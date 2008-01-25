Return-Path: <linux-kernel-owner+w=401wt.eu-S1757267AbYAYQAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267AbYAYQAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:00:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbYAYQAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:00:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49495 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbYAYQAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:00:41 -0500
Message-ID: <479A06D3.4020804@zytor.com>
Date: Fri, 25 Jan 2008 07:57:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, Yinghai Lu <Yinghai.Lu@Sun.COM>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v3
References: <47993F1A.5070408@goop.org> <200801241947.55223.yinghai.lu@sun.com> <4799930B.40006@goop.org> <200801250042.53074.yinghai.lu@sun.com> <20080125142150.GA27767@elte.hu> <p73ir1i7y1t.fsf@bingen.suse.de> <20080125151017.GB11846@elte.hu>
In-Reply-To: <20080125151017.GB11846@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------010205060507030000050101"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010205060507030000050101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Ingo Molnar wrote:
> 
> no, to be fully generic it would have to be able to 'split' e820 entries 
> up and punch holes into them - but we dont want to go that far i think. 
> The most common problem is mismatch at the end of a range.
> 

For what it's worth, I have a set of code to do this, written in order 
to canonicalize and modify e820 data structures for memdisk.

The key to it is the observation that the e820-delivered (address, len, 
type) tuples isn't actually the data structure you want -- what you want 
is an ordered list of (address, type) tuples, where type may includes 
undefined (the e820 default type - i.e. unused, available address space).

In addition to the attached code, to do this right, we probably want a 
function to do filtering (only clobber entries of a specfic type, in 
this case type 1) as opposed to blind clobber; with an ordered array 
this is quite trivial.

	-hpa

--------------010205060507030000050101
Content-Type: text/x-chdr;
 name="e820.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="e820.h"

/* ----------------------------------------------------------------------- *
 *
 *   Copyright 2001-2008 H. Peter Anvin - All Rights Reserved
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
 *   Boston MA 02111-1307, USA; either version 2 of the License, or
 *   (at your option) any later version; incorporated herein by reference.
 *
 * ----------------------------------------------------------------------- */

/*
 * e820.h
 *
 * Common routines for e820 memory map management
 */

#include <stdint.h>

struct e820range {
  uint64_t start;
  uint32_t type;
} __attribute__((packed));

extern struct e820range ranges[];
extern int nranges;
extern uint32_t dos_mem, low_mem, high_mem;

extern void e820map_init(void);
extern void insertrange(uint64_t, uint64_t, uint32_t);
extern void get_mem(void);
extern void parse_mem(void);

--------------010205060507030000050101
Content-Type: text/x-csrc;
 name="e820func.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="e820func.c"

/* ----------------------------------------------------------------------- *
 *
 *   Copyright 2001-2008 H. Peter Anvin - All Rights Reserved
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, Inc., 53 Temple Place Ste 330,
 *   Boston MA 02111-1307, USA; either version 2 of the License, or
 *   (at your option) any later version; incorporated herein by reference.
 *
 * ----------------------------------------------------------------------- */

/*
 * e820func.c
 *
 * E820 range database manager
 */

#include <stdint.h>
#include "memdisk.h"		/* For memset() */
#include "e820.h"

#define MAXRANGES	64
/* All of memory starts out as one range of "indeterminate" type */
struct e820range ranges[MAXRANGES];
int nranges;


void e820map_init(void)
{
  memset(ranges, 0, sizeof(ranges));
  nranges = 1;
  ranges[1].type = -1;
}

static void insertrange_at(int where, uint64_t start, uint32_t type)
{
  int i;

  for ( i = nranges ; i > where ; i-- )
    ranges[i] = ranges[i-1];

  ranges[where].start = start;
  ranges[where].type  = type;

  nranges++;
  ranges[nranges].start = 0ULL;
  ranges[nranges].type  = (uint32_t)-1;
}

void insertrange(uint64_t start, uint64_t len, uint32_t type)
{
  uint64_t last;
  uint32_t oldtype;
  int i, j;

  /* Remove this to make len == 0 mean all of memory */
  if ( len == 0 )
    return;			/* Nothing to insert */

  last = start+len-1;		/* May roll over */

  i = 0;
  oldtype = -2;
  while ( start > ranges[i].start && ranges[i].type != -1 ) {
    oldtype = ranges[i].type;
    i++;
  }

  /* Consider the replacement policy.  This current one is "overwrite." */

  if ( start < ranges[i].start || ranges[i].type == -1 )
    insertrange_at(i++, start, type);

  while ( i == 0 || last > ranges[i].start-1 ) {
    oldtype = ranges[i].type;
    ranges[i].type = type;
    i++;
  }

  if ( last < ranges[i].start-1 )
    insertrange_at(i, last+1, oldtype);

  /* Now the map is correct, but quite possibly not optimal.  Scan the
     map for ranges which are redundant and remove them. */
  i = j = 1;
  oldtype = ranges[0].type;
  while ( i < nranges ) {
    if ( ranges[i].type == oldtype ) {
      i++;
    } else {
      oldtype = ranges[i].type;
      if ( i != j )
	ranges[j] = ranges[i];
      i++; j++;
    }
  }

  if ( i != j ) {
    ranges[j] = ranges[i];	/* Termination sentinel copy */
    nranges -= (i-j);
  }
}

--------------010205060507030000050101--
