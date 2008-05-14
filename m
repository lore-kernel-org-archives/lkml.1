Return-Path: <linux-kernel-owner+w=401wt.eu-S1758918AbYENPim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918AbYENPim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYENPie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:38:34 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:40383 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbYENPid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:38:33 -0400
Date: Wed, 14 May 2008 19:39:33 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [vfs/tty] possible circular locking dependency detected
Message-ID: <20080514153933.GA122@tv-sign.ru>
References: <20080512183235.GB6031@joi> <20080513184736.a385ffe2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080513184736.a385ffe2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Andrew Morton wrote:
>
> On Mon, 12 May 2008 20:32:59 +0200 Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > May 11 10:59:48 [kernel] [ 2494.165794] =======================================================
> > May 11 10:59:48 [kernel] [ 2494.165801] [ INFO: possible circular locking dependency detected ]
> > May 11 10:59:48 [kernel] [ 2494.165805] 2.6.26-rc1-00007-g91b3a7a #217
> > May 11 10:59:48 [kernel] [ 2494.165807] -------------------------------------------------------
> > May 11 10:59:48 [kernel] [ 2494.165809] less/7053 is trying to acquire lock:
> > May 11 10:59:48 [kernel] [ 2494.165812]  (tasklist_lock){..??}, at: [<ffffffff80232e95>] is_current_pgrp_orphaned+0x15/0x50
> > May 11 10:59:48 [kernel] [ 2494.165821] 
> > May 11 10:59:48 [kernel] [ 2494.165822] but task is already holding lock:
> > May 11 10:59:48 [kernel] [ 2494.165824]  (&tty->ctrl_lock){....}, at: [<ffffffff803d5f31>] tty_check_change+0x61/0x110
> > May 11 10:59:48 [kernel] [ 2494.165831] 
> > May 11 10:59:48 [kernel] [ 2494.165832] which lock already depends on the new lock.
> > May 11 10:59:48 [kernel] [ 2494.165833] 
> > May 11 10:59:48 [kernel] [ 2494.165835] 
> > May 11 10:59:48 [kernel] [ 2494.165836] the existing dependency chain (in reverse order) is:
> > May 11 10:59:48 [kernel] [ 2494.165838] 
> > May 11 10:59:48 [kernel] [ 2494.165839] -> #2 (&tty->ctrl_lock){....}:
> > May 11 10:59:48 [kernel] [ 2494.165843]        [<ffffffff80253796>] __lock_acquire+0xf86/0x1080
> > May 11 10:59:48 [kernel] [ 2494.165851]        [<ffffffff80253922>] lock_acquire+0x92/0xc0
> > May 11 10:59:48 [kernel] [ 2494.165858]        [<ffffffff804deee0>] _spin_lock_irqsave+0x40/0x60
> > May 11 10:59:48 [kernel] [ 2494.165866]        [<ffffffff803d31b5>] __proc_set_tty+0x35/0xe0
> > May 11 10:59:48 [kernel] [ 2494.165873]        [<ffffffff803d76d4>] tty_ioctl+0xbf4/0xfe0
> > May 11 10:59:48 [kernel] [ 2494.165880]        [<ffffffff802a05e1>] vfs_ioctl+0x31/0x90
> > May 11 10:59:48 [kernel] [ 2494.165888]        [<ffffffff802a06b3>] do_vfs_ioctl+0x73/0x2d0
> > May 11 10:59:48 [kernel] [ 2494.165895]        [<ffffffff802a095a>] sys_ioctl+0x4a/0x80
> > May 11 10:59:48 [kernel] [ 2494.165902]        [<ffffffff8020b5ab>] system_call_after_swapgs+0x7b/0x80
> > May 11 10:59:48 [kernel] [ 2494.165910]        [<ffffffffffffffff>] 0xffffffffffffffff
> > May 11 10:59:48 [kernel] [ 2494.165924] 
> > May 11 10:59:48 [kernel] [ 2494.165925] -> #1 (&sighand->siglock){++..}:
> > May 11 10:59:48 [kernel] [ 2494.165929]        [<ffffffff80253796>] __lock_acquire+0xf86/0x1080
> > May 11 10:59:48 [kernel] [ 2494.165936]        [<ffffffff80253922>] lock_acquire+0x92/0xc0
> > May 11 10:59:48 [kernel] [ 2494.165943]        [<ffffffff804dec1f>] _spin_lock+0x2f/0x40
> > May 11 10:59:48 [kernel] [ 2494.165951]        [<ffffffff8022d5a3>] copy_process+0x973/0x1210
> > May 11 10:59:48 [kernel] [ 2494.165959]        [<ffffffff8022df12>] do_fork+0x82/0x2f0
> > May 11 10:59:48 [kernel] [ 2494.165967]        [<ffffffff8020bfe1>] kernel_thread+0x81/0xde
> > May 11 10:59:48 [kernel] [ 2494.165974]        [<ffffffff8020c048>] child_rip+0xa/0x12
> > May 11 10:59:48 [kernel] [ 2494.165981]        [<ffffffffffffffff>] 0xffffffffffffffff
> > May 11 10:59:48 [kernel] [ 2494.166038] 
> > May 11 10:59:48 [kernel] [ 2494.166039] -> #0 (tasklist_lock){..??}:
> > May 11 10:59:48 [kernel] [ 2494.166043]        [<ffffffff802535ab>] __lock_acquire+0xd9b/0x1080
> > May 11 10:59:48 [kernel] [ 2494.166050]        [<ffffffff80253922>] lock_acquire+0x92/0xc0
> > May 11 10:59:48 [kernel] [ 2494.166057]        [<ffffffff804dede2>] _read_lock+0x32/0x50
> > May 11 10:59:48 [kernel] [ 2494.166063]        [<ffffffff80232e95>] is_current_pgrp_orphaned+0x15/0x50
> > May 11 10:59:48 [kernel] [ 2494.166071]        [<ffffffff803d5f80>] tty_check_change+0xb0/0x110
> > May 11 10:59:48 [kernel] [ 2494.166078]        [<ffffffff803dac5f>] set_termios+0x1f/0x4c0
> > May 11 10:59:48 [kernel] [ 2494.166085]        [<ffffffff803db379>] tty_mode_ioctl+0x279/0x3e0
> > May 11 10:59:48 [kernel] [ 2494.166092]        [<ffffffff803db51d>] n_tty_ioctl+0x3d/0x260
> > May 11 10:59:48 [kernel] [ 2494.166100]        [<ffffffff803d6c34>] tty_ioctl+0x154/0xfe0
> > May 11 10:59:48 [kernel] [ 2494.166107]        [<ffffffff802a05e1>] vfs_ioctl+0x31/0x90
> > May 11 10:59:48 [kernel] [ 2494.166114]        [<ffffffff802a06b3>] do_vfs_ioctl+0x73/0x2d0
> > May 11 10:59:48 [kernel] [ 2494.166121]        [<ffffffff802a095a>] sys_ioctl+0x4a/0x80
> > May 11 10:59:48 [kernel] [ 2494.166128]        [<ffffffff8020b5ab>] system_call_after_swapgs+0x7b/0x80
> > May 11 10:59:48 [kernel] [ 2494.166135]        [<ffffffffffffffff>] 0xffffffffffffffff

Confused. I don't understand why do lockdep reports tasklist_lock vs ctrl_lock
conflict. What we seem to have is the problem with ->ctrl_lock vs ->siglock.

tty_check_change()->kill_pgrp() takes ->siglock under ->ctrl_lock, while
usually we take them in reverse order, proc_set_tty() for example.

The patch looks correct anyway, but perhaps tty_check_change() doesn't need
->ctrl_lock at all? We don't dereference tty->pgrp.

Oleg.

