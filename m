Return-Path: <linux-kernel-owner+w=401wt.eu-S1763289AbYBLU2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763289AbYBLU2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755247AbYBLU2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:28:16 -0500
Received: from ns2.suse.de ([195.135.220.15]:39215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbYBLU2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:28:15 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] [8/8] RFC: Fix some EFI problems
Date: Tue, 12 Feb 2008 21:23:08 +0100
User-Agent: KMail/1.9.6
Cc: ying.huang@intel.com, mingo@elte.hu, linux-kernel@vger.kernel.org
References: <200802111034.764275766@suse.de> <20080211093436.EAFB11B41CE@basil.firstfloor.org> <alpine.LFD.1.00.0802122043460.12988@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.00.0802122043460.12988@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802122123.08732.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008 21:04:06 Thomas Gleixner wrote:

> 
> And you just copied the real bug in that logic as well:
> 
>           set_memory_uc(md->virt_addr, size);

Oops you're right. I wanted to fix that, but didn't. Ok I'll put up
my brown paper back tonight when I go out.
 
> ------------------------^^^^^^^^
> 
> which is initialized a couple of lines down.
> 
> 	md->virt_addr = (u64) (unsigned long) va;
> 
> The reordering/optimizing needs to be a separate patch.

What optimizing? It wasn't intended to be an optimization.
It fixes a bug.

Not doing set_memory_uc on efi_ioremap output is needed because 
set_memory_uc doesn't work on fixmap which is what efi_ioremap
returns. 

(see previous mails on that topic -- i fixed the 'x' case,
but fixing "uc" is too hard imho) 

So I fixed efi_ioremap instead to set the correct caching
mode directly. That is ok because there can be no overlap 
with the direct mapping, so no aliases to fix up.


> Please keep bugfixes and other changes separate.
>  
> > +		/* RED-PEN does not handle overlapped areas */
> 
> Can you please use CHECKME/FIXME which is used everywhere else. No need to
> invent an extra marker.

I've always used RED-PEN

% grep -r RED-PEN arch/x86/* | wc -l
12
%

It comes originally from network code I hacked a long time ago, although
most of those got lost over time (only 2 left, sniff) 

Sorry I don't want to change this now and I doubt that will really cause
a problem for anybody.

I'll send an updated patch with the va thing fixed.

-Andi

