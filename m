Return-Path: <linux-kernel-owner+w=401wt.eu-S965820AbXDBUSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965820AbXDBUSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 16:18:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965813AbXDBUSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 16:18:07 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:60501 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965820AbXDBUSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 16:18:05 -0400
Message-ID: <001f01c77564$86416300$eeeea8c0@aldipc>
From: "roland" <devzero@web.de>
To: "Jeff Dike" <jdike@addtoit.com>, "Andrew Morton" <akpm@osdl.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "uml-devel" <user-mode-linux-devel@lists.sourceforge.net>
References: <20070402165012.GA7626@c2.user-mode-linux.org>
Subject: Re: [PATCH 4/4] UML - kernel_thread shouldn't panic
Date: Mon, 2 Apr 2007 22:21:38 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 8bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.2869
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.2869
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i´d like to acknowledge that this fixes the problem i had when creating 
loop-devices inside uml.

instead of crashing the whole uml, losetup now tells:

ioctl: LOOP_SET_FD: Resource temporarily unavailable

and dmesg:

Apr  2 20:17:53 localhost udevd[641]: udev_event_run: fork of child failed: 
Resource temporarily unavailable
Apr  2 20:17:54 localhost last message repeated 4 times
Apr  2 20:17:54 localhost udevd-event[3014]: run_program: fork of 
'/lib/udev/udev_run_hotplugd' failed:Resource temporarily unavailable
Apr  2 20:17:54 localhost udevd-event[3014]: run_program: fork of 
'/lib/udev/udev_run_devd' failed: Resource temporarily unavailable
Apr  2 20:17:54 localhost udevd-event[3014]: run_program: fork of 
'/sbin/pam_console_apply' failed: Resource temporarily unavailable
Apr  2 20:17:54 localhost udevd[641]: udev_event_run: fork of child failed: 
Resource temporarily unavailable

so, this should be right behaviour now when running out of memory.

regards
roland

----- Original Message ----- 
From: "Jeff Dike" <jdike@addtoit.com>
To: "Andrew Morton" <akpm@osdl.org>; <devzero@web.de>
Cc: "LKML" <linux-kernel@vger.kernel.org>; "uml-devel" 
<user-mode-linux-devel@lists.sourceforge.net>
Sent: Monday, April 02, 2007 6:50 PM
Subject: [PATCH 4/4] UML - kernel_thread shouldn't panic


> kernel_thread should just return an error value on do_fork failure, not 
> panic.
>
> Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> --
> arch/um/kernel/process.c |    2 --
> 1 file changed, 2 deletions(-)
>
> Index: linux-2.6.21-mm/arch/um/kernel/process.c
> ===================================================================
> --- linux-2.6.21-mm.orig/arch/um/kernel/process.c 2007-04-02 
> 11:51:43.000000000 -0400
> +++ linux-2.6.21-mm/arch/um/kernel/process.c 2007-04-02 
> 12:01:00.000000000 -0400
> @@ -97,8 +97,6 @@ int kernel_thread(int (*fn)(void *), voi
>  current->thread.request.u.thread.arg = arg;
>  pid = do_fork(CLONE_VM | CLONE_UNTRACED | flags, 0,
>        &current->thread.regs, 0, NULL, NULL);
> - if(pid < 0)
> - panic("do_fork failed in kernel_thread, errno = %d", pid);
>  return pid;
> }
> 

