Return-Path: <linux-kernel-owner+w=401wt.eu-S1759724AbZB0Klo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759724AbZB0Klo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 05:41:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758923AbZB0KdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 05:33:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758302AbZB0KdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 05:33:01 -0500
Date: Fri, 27 Feb 2009 02:32:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: airlied@linux.ie, eric@anholt.net, keithp@keithp.com,
       dri-devel@lists.sourceforge.net,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: i915 X lockup
Message-Id: <20090227023231.76e7c65f.akpm@linux-foundation.org>
In-Reply-To: <49A7B253.906@gmail.com>
References: <49A7B253.906@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Feb 2009 10:28:51 +0100 Jiri Slaby <jirislaby@gmail.com> wrote:

> everytime I run X, it gets stuck. Currently running on mmotm 
> 2009-02-26-16-58, but I think this is wider problem. I had i915 disabled 
> for a long time (until I noticed today).
> 
> SysRq : Show Locks Held
> 
> Showing all locks held in the system:
> 3 locks held by events/0/10:
>   #0:  (events){+.+.+.}, at: [<ffffffff8025223d>] worker_thread+0x19d/0x340
>   #1:  (&(&dev_priv->mm.retire_work)->work){+.+...}, at: 
> [<ffffffff8025223d>] worker_thread+0x19d/0x340
>   #2:  (&dev->struct_mutex){+.+.+.}, at: [<ffffffff804057ba>] 
> i915_gem_retire_work_handler+0x3a/0x90
> 1 lock held by mingetty/3899:
>   #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff803cb5de>] 
> n_tty_read+0x48e/0x8e0
> 1 lock held by mingetty/3900:
>   #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff803cb5de>] 
> n_tty_read+0x48e/0x8e0
> 1 lock held by mingetty/3901:
>   #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff803cb5de>] 
> n_tty_read+0x48e/0x8e0
> 1 lock held by X/4007:
>   #0:  (&dev->struct_mutex){+.+.+.}, at: [<ffffffff8040563c>] 
> i915_gem_throttle_ioctl+0x2c/0x60
> 2 locks held by bash/4105:
>   #0:  (sysrq_key_table_lock){......}, at: [<ffffffff803de366>] 
> __handle_sysrq+0x26/0x190
>   #1:  (tasklist_lock){.+.+..}, at: [<ffffffff80266c1f>] 
> debug_show_all_locks+0x3f/0x1c0

I assume that i915_gem_throttle_ioctl->i915_gem_ring_throttle is stuck
in i915_wait_request(), holding struct_mutex.  That of course makes
keventd block.

Perhaps i915_wait_request() is waiting for keventd to do something,
which is the deadlock.  That "something" could be to simply finish its
current call to i915_gem_retire_work_handler().

But worse, it could be some completely other keventd handler which
isn't getting run, because that keventd instance is stuck over in
i915_gem_retire_work_handler().

IOW, the usual keventd problem.
