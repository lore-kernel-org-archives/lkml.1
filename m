Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab0BOCi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 21:38:59 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51025 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422Ab0BOCi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 21:38:58 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Michael Neuling <mikey@neuling.org>
Subject: Re: 2.6.33-rc8 breaks UML with Restrict initial stack space expansion to rlimit
Cc: kosaki.motohiro@jp.fujitsu.com, Jouni Malinen <j@w1.fi>,
       linux-kernel@vger.kernel.org
In-Reply-To: <9296.1266185019@neuling.org>
References: <20100214164023.GA2726@jm.kir.nu> <9296.1266185019@neuling.org>
Message-Id: <20100215113751.7275.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 15 Feb 2010 11:38:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 
> In message <20100214164023.GA2726@jm.kir.nu> you wrote:
> > It looks like the commit 803bf5ec259941936262d10ecc84511b76a20921
> > (fs/exec.c: restrict initial stack space expansion to rlimit) broke my
> > user mode Linux setup by somehow preventing system setup from running
> > properly (or killing some processes that try to mount things, etc.).
> > This commit turned up as the reason based on git bisect and reverting it
> > fixes my UML test setup (Ubuntu 9.10 on both host and in UML and AMD64
> > arch for both). I have no idea what exactly would be the main cause for
> > this issue, but this looks like a somewhat unfortunately timed
> > regression in 2.6.33-rc8.
> > 
> > The failed run shows like this (with current linux-2.6.git):
> > 
> > ...
> > EXT3-fs (ubda): mounted filesystem with writeback data mode
> > VFS: Mounted root (ext3 filesystem) readonly on device 98:0.
> > IRQ 3/console-write: IRQF_DISABLED is not guaranteed on shared IRQs
> > IRQ 2/console: IRQF_DISABLED is not guaranteed on shared IRQs
> > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> > mountall: mount /sys/kernel/debug [218] killed by KILL signal
> > mountall: Filesystem could not be mounted: /sys/kernel/debug
> > mountall: mount /dev [219] killed by KILL signal
> > mountall: Filesystem could not be mounted: /dev
> > mountall: mount /tmp [220] killed by KILL signal
> > mountall: Filesystem could not be mounted: /tmp
> > mountall: mount /var/lock [222] killed by KILL signal
> > mountall: Filesystem could not be mounted: /var/lock
> > ...

Wow. It seems very strange. Usually stack overflow makes SIGSEGV, not SIGKILL.
plus, In my environment (x86_64 non-uml), mount command doesn't use
the stack so much.


% /usr/bin/time --format="mem %M" ls
/usr/bin/time --format="mem %M" ls
GPATH      INSTALL  README       configure    fdisk          lib      misc-utils   schedutils
mem 3232

% sudo /usr/bin/time --format="mem %M"  mount -a
sudo /usr/bin/time --format="mem %M"  mount -a
mem 2992


Hmmm...
I have no idea.



> > 
> > 
> > With 803bf5ec reverted, UML comes up and the output looks like this:
> > 
> > ...
> > EXT3-fs (ubda): mounted filesystem with writeback data mode
> > VFS: Mounted root (ext3 filesystem) readonly on device 98:0.
> > IRQ 3/console-write: IRQF_DISABLED is not guaranteed on shared IRQs
> > IRQ 2/console: IRQF_DISABLED is not guaranteed on shared IRQs
> > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> > IRQ 10/winch: IRQF_DISABLED is not guaranteed on shared IRQs
> > init: procps main process (226) terminated with status 255
> > fsck from util-linux-ng 2.16
> > ...
> 
> Crud, the "killed" is definitely something this patch could cause.
> 
> I'm not familiar with UML.  Is this the guest and the host booting rc8,
> or just the host?  Does UML use stack protection at all?
> 
> Can you try booting the guest to init=/bin/sh and try running some tests
> to see what you can set 'ulimit -s' to and still be able to run a simple
> command like '/bin/ls'?
> 
> Mikey
> 
> > 
> > -- 
> > Jouni Malinen                                            PGP id EFC895FA
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



