Return-Path: <linux-kernel-owner+w=401wt.eu-S1758455AbYC1CcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455AbYC1CcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbYC1CcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:32:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49964 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755850AbYC1Cb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:31:59 -0400
Date: Thu, 27 Mar 2008 19:30:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pawel Staszewski <pstaszewski@artcom.pl>,
       Christoph Lameter <clameter@sgi.com>
cc: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <200803272353.51901.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>
References: <200803272353.51901.rjw@sisk.pl>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 Mar 2008, Rafael J. Wysocki wrote:
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9412
> Subject		: commit a878539ef994787c447a98c2e3ba0fe3dad984ec breaks boot on SB600 AHCI
> Submitter	: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
> Date		: 2008-03-12 17:15 (16 days old)
> Handled-By	: Jeff Garzik <jgarzik@pobox.com>
> 		  Richard Zhao <richard.zhao@amd.com>

Fixed by 4cde32fc4b32e96a99063af3183acdfd54c563f0, methinks.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9962
> Subject		: mount: could not find filesystem
> Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> Date		: 2008-02-12 14:34 (45 days old)
> References	: http://lkml.org/lkml/2008/2/12/91
> Handled-By	: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 		  Yinghai Lu <yhlu.kernel@gmail.com>

Needs more info. The original oops that opened it is fixed, but..

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9976
> Subject		: BUG: 2.6.25-rc1: iptables postrouting setup causes oops
> Submitter	: Ben Nizette <bn@niasdigital.com>
> Date		: 2008-02-12 12:46 (45 days old)
> References	: http://lkml.org/lkml/2008/2/12/148
> Handled-By	: Haavard Skinnemoen <hskinnemoen@atmel.com>

This one seems gone (and was apparently AVR-only):

http://lkml.org/lkml/2008/2/13/607:
  "What ever the problem is it isn't immediately apparent in latest git so
   I guess we'll just have to keep our eyes peeled."

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9978
> Subject		: 2.6.25-rc1: volanoMark regression
> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date		: 2008-02-13 10:30 (44 days old)
> References	: http://lkml.org/lkml/2008/2/13/128
> 		  http://lkml.org/lkml/2008/3/12/52
> 		  http://lkml.org/lkml/2008/3/18/81
> Handled-By	: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> 		  Balbir Singh <balbir@linux.vnet.ibm.com>

Hmm. It is a regression on one machine (2x quad-core stoakley), but not 
another (4x quad-core tigerton).

Interestingly, the stoakley box numbers have apparently been all over the 
map.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10318
> Subject		: WARNING: at arch/x86/mm/highmem_32.c:43 kmap_atomic_prot+0x87/0x184()
> Submitter	: Pawel Staszewski <pstaszewski@artcom.pl>
> Date		: 2008-03-25 02:50 (3 days old)

Andrew and seems to have debugged this down to a kzalloc(GFP_ATOMIC) or 
similar.

I wonder if the bug is in that commit 
3811dbf67162bd08412f1b0e02e554f353e93bdb ("SLUB: remove useless masking 
of GFP_ZERO"), because I don't think that masking was at all useless and I 
think my original 7fd272550bd43cc1d7289ef0ab2fa50de137e767 was correct.

That apparently bogus commit says "GFP_ZERO is already masked out in 
new_slab()", but gfpflags is not just used for new_slab(), but for 
kmalloc_large() too.  Which does *not* clear GFP_ZERO.

Pawel, does reverting 3811dbf67162bd08412f1b0e02e554f353e93bdb fix it for 
you?

Also, Rafael - do these reminder emails also go to the people who are 
mentioned in the regressions (especially people who are set up as being 
"hanled-by" or having patches for the problem)? 

		Linus
