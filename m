Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbZG0UgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbZG0UgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 16:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbZG0UgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 16:36:14 -0400
Received: from mail-fx0-f205.google.com ([209.85.220.205]:59175 "EHLO
	mail-fx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbZG0UgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 16:36:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=hqAB1/TXPgImKLhnXAR++W+Jfm4GuLCHewsZ2Ay7dtxV93AR1jPRFZkuo67juffWci
         5B8prIw2cq1ymlYK8ANYt5KBK+WOU/PfnE6t17V58+V8nyC4wSg5kd1yJVjmnC9bAPPw
         ifPOCrm9YBu5wayAN35wGptbaXmQjKCD2A0wg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: Tree for July 27 (tty locking)
Date: Mon, 27 Jul 2009 22:35:08 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090727-04601-g24690ff; KDE/4.2.4; i686; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20090727180552.eb32515b.sfr@canb.auug.org.au>
In-Reply-To: <20090727180552.eb32515b.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907272235.08319.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 27 July 2009 10:05:52 Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090724:

Alan, it seems that tty still needs some polishing,
I'm getting the following warning on boot:

INFO: task hald-probe-seri:1779 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
hald-probe-se D 0000000b     0  1779   1734 0x00000004
 daf8cde0 00000046 b829e804 0000000b daf95a04 00000000 c054832c c054bec0
 daf95a04 00000000 c054bec0 c054bec0 00000001 00000000 00000000 00094e71
 00000000 b8209993 0000000b daf95780 00000246 00000000 00000002 00000000
Call Trace:
 [<c029b327>] ? tty_port_block_til_ready+0x1f/0x3c
 [<c0397be3>] mutex_lock_nested+0x167/0x28e
 [<c029b327>] tty_port_block_til_ready+0x1f/0x3c
 [<c02bdcdc>] uart_open+0x12a/0x1e9
 [<c0296742>] tty_open+0x291/0x38f
 [<c018b8bf>] chrdev_open+0x156/0x16d
 [<c0187f02>] __dentry_open+0x131/0x21b
 [<c019b5a5>] ? mntput_no_expire+0x19/0xb4
 [<c018808a>] nameidata_to_filp+0x2d/0x42
 [<c018b769>] ? chrdev_open+0x0/0x16d
 [<c01928d7>] do_filp_open+0x3dc/0x6dc
 [<c019a161>] ? alloc_fd+0xbd/0xca
 [<c0187cd6>] do_sys_open+0x48/0xe4
 [<c01191fb>] ? do_page_fault+0x262/0x290
 [<c0187db4>] sys_open+0x1e/0x26
 [<c0102948>] sysenter_do_call+0x12/0x36
INFO: lockdep is turned off.

with LOCKDEP=y:

=============================================
[ INFO: possible recursive locking detected ]
2.6.31-rc4-next-20090727-04601-g24690ff #43
---------------------------------------------
hald-probe-seri/1580 is trying to acquire lock:
 (&port->mutex){+.+.+.}, at: [<c029b327>] tty_port_block_til_ready+0x1f/0x3c

but task is already holding lock:
 (&port->mutex){+.+.+.}, at: [<c02bdc03>] uart_open+0x51/0x1e9

other info that might help us debug this:
1 lock held by hald-probe-seri/1580:
 #0:  (&port->mutex){+.+.+.}, at: [<c02bdc03>] uart_open+0x51/0x1e9

stack backtrace:
Pid: 1580, comm: hald-probe-seri Not tainted 2.6.31-rc4-next-20090727-04601-g24690ff #43
Call Trace:
 [<c0396406>] ? printk+0xf/0x11
 [<c014b29b>] __lock_acquire+0xc21/0x12b5
 [<c029b327>] ? tty_port_block_til_ready+0x1f/0x3c
 [<c014b975>] lock_acquire+0x46/0x62
 [<c029b327>] ? tty_port_block_til_ready+0x1f/0x3c
 [<c0397abf>] mutex_lock_nested+0x43/0x28e
 [<c029b327>] ? tty_port_block_til_ready+0x1f/0x3c
 [<c0149c14>] ? trace_hardirqs_on_caller+0x100/0x121
 [<c0149c40>] ? trace_hardirqs_on+0xb/0xd
 [<c029b327>] tty_port_block_til_ready+0x1f/0x3c
 [<c02bdcdc>] uart_open+0x12a/0x1e9
 [<c0296742>] tty_open+0x291/0x38f
 [<c018b8bf>] chrdev_open+0x156/0x16d
 [<c0187f02>] __dentry_open+0x131/0x21b
 [<c019b5a5>] ? mntput_no_expire+0x19/0xb4
 [<c018808a>] nameidata_to_filp+0x2d/0x42
 [<c018b769>] ? chrdev_open+0x0/0x16d
 [<c01928d7>] do_filp_open+0x3dc/0x6dc
 [<c019a161>] ? alloc_fd+0xbd/0xca
 [<c0187cd6>] do_sys_open+0x48/0xe4
 [<c01029fc>] ? restore_all_notrace+0x0/0x18
 [<c0187db4>] sys_open+0x1e/0x26
 [<c0102948>] sysenter_do_call+0x12/0x36
