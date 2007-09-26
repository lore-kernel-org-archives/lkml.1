Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbXIZPmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbXIZPmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbXIZPl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:41:56 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:12144 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754743AbXIZPlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:41:55 -0400
X-BigFish: VP
X-FB-SS: 0,
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
Date: Wed, 26 Sep 2007 09:41:06 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Joerg Pommnitz" <pommnitz@yahoo.com>, cebbert@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Regression in 2.6.23-pre Was: Problems with 2.6.23-rc6 on
 AMD Geode LX800
Message-ID: <20070926154106.GG7582@cosmic.amd.com>
References: <637040.99806.qm@web51411.mail.re2.yahoo.com>
 <46FA6858.5060908@zytor.com>
MIME-Version: 1.0
In-Reply-To: <46FA6858.5060908@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 26 Sep 2007 15:40:48.0969 (UTC)
 FILETIME=[9C9A1B90:01C80053]
X-WSS-ID: 6AE4A20B2ZC352695-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/09/07 07:10 -0700, H. Peter Anvin wrote:
> Joerg Pommnitz wrote:
> > Hello all,
> > this is what git bisect told me about the problem:
> > 
> > jpo@jpo-laptop:~/linux-2.6$ git bisect good
> > 4fd06960f120e02e9abc802a09f9511c400042a5 is first bad commit
> > commit 4fd06960f120e02e9abc802a09f9511c400042a5
> > Author: H. Peter Anvin <hpa@zytor.com>
> > Date:   Wed Jul 11 12:18:56 2007 -0700
> > 
> >     Use the new x86 setup code for i386
> > 
> >     This patch hooks the new x86 setup code into the Makefile machinery.  It
> >     also adapts boot/tools/build.c to a two-file (as opposed to three-file)
> >     universe, and simplifies it substantially.
> > 
> >     Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > 
> > :040000 040000 6560eb5b7e40d93813276544bced8c478f9067f5 fe5f90d9ca08e526559815789175602ba2c51743 M      arch
> > 
> 
> There is something very fishy.
> 
> The only documentation you've given us so far is a screen shot which
> contained a message ("BIOS data check successful") which doesn't occur
> in the kernel.
> 
> The loader string doesn't look all that familiar either; it looks like
> an extremely old version of SYSLINUX, but that doesn't contain that
> message either.
> 
> INT 6 is #UD, the undefined instruction exception.  This is consistent with:
> 
> > Its hitting a bug - specifically (from bootmem.c:125):
> > BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);
> 
> However, all that tells us is that reserve_bootmem_core() was either
> called with a bad address or bdata->node_low_pfn is garbage.  In
> particular, without knowing how it got there it's hard to know for sure.

/me swings a +5 JTAG debugger

Its the latter - max_pfn as read by find_max_pfn() in arch/i386/e820.c
is being set to 9F (640k) in the broken case, this due to the
the e820 map looking something like this:

Address   Size      Type
00000000  0009FC00  1
0009FC00  00000400  2
000E0000  00002000  2

(Yep, thats it - thats the list.  e820.nr_map is indeed 3). 

Long story short, bdata->node_low_pfn gets set to 9F, and When we 
try to allocate the bootmem bitmap (at _pa_symbol(_text), which is 
page 0x100), then the system gets appropriately angry.

As background, I'm using syslinux 3.36 as my loader here - I've used this
exact same version for a very long time, so I don't blame it in the least.
Something is getting confused in the early kernel, and whatever that
something is, a still unknown change in a newer version of the BIOS
fixed it.  The search goes on.

Jordan
-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.


