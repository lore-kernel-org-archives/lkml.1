Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab0BNWDl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 17:03:41 -0500
Received: from ozlabs.org ([203.10.76.45]:41580 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417Ab0BNWDk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 17:03:40 -0500
From: Michael Neuling <mikey@neuling.org>
To: Jouni Malinen <j@w1.fi>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.33-rc8 breaks UML with Restrict initial stack space expansion to rlimit
In-reply-to: <20100214164023.GA2726@jm.kir.nu>
References: <20100214164023.GA2726@jm.kir.nu>
Comments: In-reply-to Jouni Malinen <j@w1.fi>
   message dated "Sun, 14 Feb 2010 18:40:23 +0200."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Mon, 15 Feb 2010 09:03:39 +1100
Message-ID: <9296.1266185019@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



In message <20100214164023.GA2726@jm.kir.nu> you wrote:
> It looks like the commit 803bf5ec259941936262d10ecc84511b76a20921
> (fs/exec.c: restrict initial stack space expansion to rlimit) broke my
> user mode Linux setup by somehow preventing system setup from running
> properly (or killing some processes that try to mount things, etc.).
> This commit turned up as the reason based on git bisect and reverting it
> fixes my UML test setup (Ubuntu 9.10 on both host and in UML and AMD64
> arch for both). I have no idea what exactly would be the main cause for
> this issue, but this looks like a somewhat unfortunately timed
> regression in 2.6.33-rc8.
> 
> The failed run shows like this (with current linux-2.6.git):
> 
> ...
> EXT3-fs (ubda): mounted filesystem with writeback data mode
> VFS: Mounted root (ext3 filesystem) readonly on device 98:0.
> IRQ 3/console-write: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 2/console: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> mountall: mount /sys/kernel/debug [218] killed by KILL signal
> mountall: Filesystem could not be mounted: /sys/kernel/debug
> mountall: mount /dev [219] killed by KILL signal
> mountall: Filesystem could not be mounted: /dev
> mountall: mount /tmp [220] killed by KILL signal
> mountall: Filesystem could not be mounted: /tmp
> mountall: mount /var/lock [222] killed by KILL signal
> mountall: Filesystem could not be mounted: /var/lock
> ...
> 
> 
> With 803bf5ec reverted, UML comes up and the output looks like this:
> 
> ...
> EXT3-fs (ubda): mounted filesystem with writeback data mode
> VFS: Mounted root (ext3 filesystem) readonly on device 98:0.
> IRQ 3/console-write: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 2/console: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> init: procps main process (226) terminated with status 255
> fsck from util-linux-ng 2.16
> ...

Crud, the "killed" is definitely something this patch could cause.

I'm not familiar with UML.  Is this the guest and the host booting rc8,
or just the host?  Does UML use stack protection at all?

Can you try booting the guest to init=/bin/sh and try running some tests
to see what you can set 'ulimit -s' to and still be able to run a simple
command like '/bin/ls'?

Mikey

> 
> -- 
> Jouni Malinen                                            PGP id EFC895FA
> 
