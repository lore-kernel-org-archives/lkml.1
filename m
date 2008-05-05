Return-Path: <linux-kernel-owner+w=401wt.eu-S1762806AbYEEXZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762806AbYEEXZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 19:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYEEXZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 19:25:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:16419 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbYEEXZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 19:25:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,439,1204531200"; 
   d="scan'208";a="242399025"
Date: Mon, 5 May 2008 16:25:36 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Rufus & Azrael <rufus-azrael@numericable.fr>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem error
Message-ID: <20080505232536.GA28026@linux-os.sc.intel.com>
References: <481D72A7.10901@numericable.fr> <20080504085204.GE21859@elte.hu> <481D7BF8.4080405@numericable.fr> <20080505172619.GD28173@linux-os.sc.intel.com> <481F87F2.70005@numericable.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481F87F2.70005@numericable.fr>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 03:19:30PM -0700, Rufus & Azrael wrote:
>    Suresh Siddha a ecrit :
>    > On Sun, May 04, 2008 at 11:03:52AM +0200, Rufus & Azrael wrote:
>    >  
>    >> Ingo Molnar a ecrit :
>    >>    
>    >>> * Rufus & Azrael <rufus-azrael@numericable.fr> wrote:
>    >>>      
>    >>>> When upgrading to 2.6.25-git18 and above kernel this Xorg error
>    occurs :
>    >>>>
>    >>>> xf86MapVidMem: Could not mmap framebuffer (0xf0000000,0x8000000)
>    (Invalid
>    >>>> argument)
>    >>>>
>    >>>> The latest working kernel was 25-git17 and perhaps is it related to
>    >>>> [1]http://lkml.org/lkml/2008/4/28/52
>    >>>>   
>    >>>>        
>    >>> does this X-does-not-start-up problem go away if you disable this
>    >>> option:
>    >>> 
>    >>>      
>    >>>> CONFIG_X86_PAT=y
>    >>>>   
>    >>>>        
>    >>> ?
>    >>> 
>    >>>      
>    >> Thanks for your help Ingo, all work fine when CONFIG_PAT=n :-)
>    >>    
>    >
>    > hi, Can you please send us the "dmesg" output in the failing scenario
>    > with PAT enabled, after the X crash?
>    >
>    > thanks,
>    > suresh
>    >
>    >  
>    Hi,
> 
>    Here is my dmesg with 2.6.26-rc1-git3 and CONFIG_X86_PAT=y
> 
>    Hope it can help you to fixe the crash.
> 

Did you capture dmesg after X failed to start? Only relevent msg I see is

> [    0.333352] [drm] Initialized radeon 1.28.0 20060524 on minor 0
> [    0.334110] uvesafb: (C) 1988-2005, ATI Technologies Inc. RS69001.00, RS69001.00, 01.00, OEM: ATI ATOMBIOS(C) 1988-2005, ATI Technologies Inc. RS69001.00, VBE v3.0
> [    0.351570] uvesafb: VBIOS/hardware supports DDC2 transfers
> [    0.410125] uvesafb: monitor limits: vf = 75 Hz, hf = 83 kHz, clk = 140 MHz
> [    0.410313] uvesafb: scrolling: redraw
> [    0.412579] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
> [    0.657370] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
> [    0.894472] Console: switching to colour frame buffer device 160x64
> [    0.894532] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
> [    1.128483] uvesafb: framebuffer at 0xf0000000, mapped to 0xffffc20010a80000, using 16384k, total 16384k
> [    1.128518] fb0: VESA VGA frame buffer device

Which seems to be mapping framebuffer successfully. 

Can you please try the patch below and capture the dmesg after you get the
above xf86MapVidMem error and send it. That should give us more information
on the failure.

Thanks,
Venki

Index: linux-2.6/arch/x86/mm/pat.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/pat.c	2008-05-05 14:13:16.000000000 -0700
+++ linux-2.6/arch/x86/mm/pat.c	2008-05-05 15:54:21.000000000 -0700
@@ -7,6 +7,8 @@
  * Loosely based on earlier PAT patchset from Eric Biederman and Andi Kleen.
  */
 
+#define	DEBUG
+
 #include <linux/mm.h>
 #include <linux/kernel.h>
 #include <linux/gfp.h>
