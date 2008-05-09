Return-Path: <linux-kernel-owner+w=401wt.eu-S934664AbYEIAue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934664AbYEIAue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 20:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760327AbYEIAuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 20:50:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46387 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071AbYEIAuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 20:50:17 -0400
Message-ID: <48239FAC.8070707@zytor.com>
Date: Thu, 08 May 2008 17:49:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: Rufus & Azrael <rufus-azrael@numericable.fr>, Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem
 error
References: <924EFEDD5F540B4284297C4DC59F3DEE010057B4@orsmsx423.amr.corp.intel.com> <4822A6F7.7010704@numericable.fr> <B5B0CFF685D7DF46A05CF1678CFB42ED20E04609@orsmsx423.amr.corp.intel.com> <20080508192555.GA8643@linux-os.sc.intel.com> <48235DA1.5060809@numericable.fr> <20080508213722.GA28372@linux-os.sc.intel.com> <482373C5.1060202@zytor.com> <20080508215931.GA5035@jamoon.sc.intel.com> <20080508234016.GA14169@linux-os.sc.intel.com> <482392C4.7080901@zytor.com> <20080509003424.GA19710@linux-os.sc.intel.com>
In-Reply-To: <20080509003424.GA19710@linux-os.sc.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venki Pallipadi wrote:
> 
> What I meant was:
> MTRRs are not really base and size. They are defined as base and mask.
> Any addr is affected by mtrr if addr & mask == base & mask.
> So, MTRR entry like
> base = 0xf00000, mask = 0xff00000 with 36 bit physical address covers
> 0xf00000-0xffffff, 0x10f00000-0x10ffffff, 0x20f00000-0x20ffffff, ....
> 
> In this case if user is trying to mmap 0x1a000000-0x2a000000, we cannot really
> cover this case with single parsing of variable address ranges. We will have
> to go through the sub-ranges withing single variable range, which can be page
> by page in worst case.
>  

In practice, though, such MTRRs are never seen.  Even in the presence of 
such pathological MTRRs, I'm sure one can figure out a *much* smarter 
overlap algorithm.  I'd have to sit down and think about it, but I'm 
pretty sure one could; the basic observation, though, is that any set 
mask bit that are in a position <= floor(log2(range_len))-1 don't matter 
at all, since the range WILL end up covering both the 0 and the 1 case 
in this bit position.  At this point, you can test only a limited number 
of points (I *believe* you can reduce it down to only the beginning and 
the end, but I haven't proven that, so don't count on it yet.)

The key, of course, is to look for the case of multiple MTRRs matching 
the range.

	-hpa
