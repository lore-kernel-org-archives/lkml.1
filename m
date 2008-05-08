Return-Path: <linux-kernel-owner+w=401wt.eu-S1761025AbYEHXe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761025AbYEHXe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbYEHXeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:34:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33252 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043AbYEHXeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:34:12 -0400
Date: Thu, 8 May 2008 16:33:40 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch] speed up / fix the new generic semaphore code (fix AIM7
 40% regression with 2.6.26-rc1)
In-Reply-To: <20080509001647.244393bc@core>
Message-ID: <alpine.LFD.1.10.0805081631440.2940@woody.linux-foundation.org>
References: <1210214696.3453.87.camel@ymzhang> <alpine.LFD.1.10.0805072014330.3024@woody.linux-foundation.org> <1210219729.3453.97.camel@ymzhang> <alpine.LFD.1.10.0805072115190.3024@woody.linux-foundation.org> <20080508120130.GA2860@elte.hu>
 <20080508122802.GA4880@elte.hu> <alpine.LFD.1.10.0805080859140.3024@woody.linux-foundation.org> <alpine.LFD.1.10.0805081128550.3024@woody.linux-foundation.org> <20080508201956.GA2547@elte.hu> <alpine.LFD.1.10.0805081326130.2940@woody.linux-foundation.org>
 <20080508214557.GA13311@elte.hu> <alpine.LFD.1.10.0805081535130.2940@woody.linux-foundation.org> <20080509001647.244393bc@core>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 9 May 2008, Alan Cox wrote:
> 
> I don't think fixing n_tty is now a big job if someone wants to take a
> swing at it. The driver write/throttle/etc routines below the n_tty ldisc
> layer are now BKL clean so it should just be the internal locking of the
> buffers, window and the like to tackle.

Well, it turns out that Ingo's fixed statistics actually put the real cost 
in fcntl/ioctl/open/release:

    310  down <= lock_kernel <= sys_fcntl <= system_call_after_swapgs <
    332  down <= lock_kernel <= vfs_ioctl <= do_vfs_ioctl <
    380  down <= lock_kernel <= tty_release <= __fput <
    422  down <= lock_kernel <= chrdev_open <= __dentry_open <

rather than the write routines. But it may be that Ingo was just profiling 
two different sections, and it's really all of them.

			Linus
