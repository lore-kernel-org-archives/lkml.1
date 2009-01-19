Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbZASSyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbZASSyw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZASSym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:54:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41314 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbZASSyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:54:41 -0500
Message-ID: <4974CC8B.1030403@zytor.com>
Date: Mon, 19 Jan 2009 10:55:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Avuton Olrich <avuton@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2 due
 to 	dc1e35c
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com>
In-Reply-To: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040006080706020402060606"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040006080706020402060606
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

> 
> bisected to:
> commit dc1e35c6e95e8923cf1d3510438b63c600fee1e2
> Author: Suresh Siddha <suresh.b.siddha@intel.com>
> Date:   Tue Jul 29 10:29:19 2008 -0700
> 

Avuton, could you please compile the attached program and send us the 
output?

	-hpa

--------------040006080706020402060606
Content-Type: text/x-csrc;
 name="cpuid.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="cpuid.c"

#include <stdio.h>
#include <ctype.h>
#include <stdint.h>

char *make_string(uint32_t val)
{
  static char string[5] = "xxxx";
  int i, ch;

  for ( i = 0 ; i < 4 ; i++ ) {
    ch = val & 0xff;
    string[i] = isprint(ch) ? ch : '.';
    val >>= 8;
  }

  return string;
}

void dump_cpuid_level(uint32_t level)
{
  uint32_t eax, ebx, ecx, edx;

  asm("cpuid" : "=a" (eax), "=b" (ebx), "=c" (ecx), "=d" (edx)
      : "a" (level));

  printf("%08X:  %08X %s  ", level, eax, make_string(eax));
  printf("%08X %s  ", ebx, make_string(ebx));
  printf("%08X %s  ", ecx, make_string(ecx));
  printf("%08X %s\n", edx, make_string(edx));
}

void dump_levels(uint32_t region)
{
  uint32_t max, n;

  asm("cpuid" : "=a" (max) : "a" (region) : "ebx","ecx","edx");
  if ( (max & 0xffff0000) == region ) {
    for ( n = region ; n <= max ; n++ ) {
      dump_cpuid_level(n);
    }
  }
}

int main(int argc, char *argv[])
{
  uint32_t n;

  printf("Level      EAX            EBX            ECX            EDX            \n");

  for ( n = 0 ; n <= 0xffff ; n++ ) {
    dump_levels(n << 16);
  }

  return 0;
}

--------------040006080706020402060606--
