Return-Path: <linux-kernel-owner+w=401wt.eu-S1757294AbZC0MwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757294AbZC0MwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 08:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753242AbZC0Mv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 08:51:56 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55778 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803AbZC0Mvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 08:51:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=RifGmyTLmrtPMLaNdT2nNe/YZgX2vMsy/q3FkTqGpI+6e3axvtE290sKHts6KNwSM/
         OCxqtlOPFDb4kDnp3z3vP3kzS3kgYMn20IqtZvlLhyWVNtuEoasNF1R6rrZmnMGRnror
         X5SlJ731ku92VFO0yQwIR4OxWxw0tizq5djHk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Possible IRQ lock inversion from 2.6.29-Linus-03321-gbe0ea69 (2.6.29-git)
Date: Fri, 27 Mar 2009 13:54:35 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-next-20090320; KDE/4.2.1; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
       Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Li Zefan <lizf@cn.fujitsu.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Ingo Molnar <mingo@elte.hu>
References: <49CC5F15.4020404@lwfinger.net>
In-Reply-To: <49CC5F15.4020404@lwfinger.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200903271354.45480.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

I've seen this reported before against linux-next:

	http://lkml.org/lkml/2009/3/2/399

and I also experienced it myself (since at least next-20090213).

I haven't verified it but I believe that the warning is triggered by
"Move FASYNC bit handling to f_op->fasync()" change (which is commit
76398425bb06b07cc3a3b1ce169c67dc9d6874ed in Linus' tree).

I remember looking a bit more closely into the issue and not seeing
the problem with the locking (though I could have missed something):

file->f_lock is never taken in hard-irq or soft-irq context and in
the only place where file->f_lock is taken with fasync_lock hold we're
protected against IRQs by write_lock_irq().

[ Despite not being a problem now I think that changing spin_[un]lock()
  to *_irq() variants for file->f_lock could be (given that it really
  fixes the warning) more viable long-term solution than adding special
  lockdep handling (well, it could be that one day file->f_lock is used
  in soft-irq context and then the irq lock inversion issue will become
  a real one) and shouldn't incurr performance penalty since we hold it
  only for a very brief time. ]

On Friday 27 March 2009, Larry Finger wrote:
> On my x86_64 dual core system, I get the following messages logged.
> 
> 
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.29-Linus-03321-gbe0ea69 #55
> ---------------------------------------------------------
> swapper/0 just changed the state of lock:
>  (fasync_lock){..+.}, at: [<ffffffff802c7073>] kill_fasync+0x2c/0x4e
> but this lock took another, hard-irq-unsafe lock in the past:
>  (&f->f_lock){--..}
> 
> and interrupts could create inverse lock ordering between them.
> 
> 
> other info that might help us debug this:
> 4 locks held by swapper/0:
>  #0:  (&serio->lock){+...}, at: [<ffffffff803c47a4>] serio_interrupt+0x2b/0x83
>  #1:  (&dev->event_lock){+...}, at: [<ffffffff803c8bd3>] input_event+0x40/0x7d
>  #2:  (rcu_read_lock){..--}, at: [<ffffffff803c7541>] input_pass_event+0x0/0xcc
>  #3:  (rcu_read_lock){..--}, at: [<ffffffff803cbad3>] evdev_event+0x0/0xfd
> 
> the first lock's dependencies:
> -> (fasync_lock){..+.} ops: 0 {
>    initial-use  at:
>                         [<ffffffff80262870>] __lock_acquire+0x79e/0x1697
>                         [<ffffffff802637be>] lock_acquire+0x55/0x71
>                         [<ffffffff804642bf>] _write_lock_irq+0x37/0x43
>                         [<ffffffff802c6bf5>] fasync_helper+0x57/0x110
>                         [<ffffffff802ea28c>] locks_delete_lock+0x50/0x9f
>                         [<ffffffff802ea819>] __posix_lock_file+0x326/0x549
>                         [<ffffffff802eaa8c>] vfs_lock_file+0x38/0x3a
>                         [<ffffffff802eab1f>] locks_remove_posix+0x91/0xb2
>                         [<ffffffff802b9634>] filp_close+0x56/0x68
>                         [<ffffffff802b96f0>] sys_close+0xaa/0xe9
>                         [<ffffffff8020c2cb>] system_call_fastpath+0x16/0x1b
>                         [<ffffffffffffffff>] 0xffffffffffffffff
>    in-hardirq-R at:
>                         [<ffffffffffffffff>] 0xffffffffffffffff
>  }
>  ... key      at: [<ffffffff805f7db8>] fasync_lock+0x18/0x30
>  -> (&f->f_lock){--..} ops: 0 {
>     initial-use  at:
>                           [<ffffffff80262870>] __lock_acquire+0x79e/0x1697
>                           [<ffffffff802637be>] lock_acquire+0x55/0x71
>                           [<ffffffff80464126>] _spin_lock+0x31/0x3d
>                           [<ffffffff802c6c74>] fasync_helper+0xd6/0x110
>                           [<ffffffff802ea28c>] locks_delete_lock+0x50/0x9f
>                           [<ffffffff802ea819>] __posix_lock_file+0x326/0x549
>                           [<ffffffff802eaa8c>] vfs_lock_file+0x38/0x3a
>                           [<ffffffff802eab1f>] locks_remove_posix+0x91/0xb2
>                           [<ffffffff802b9634>] filp_close+0x56/0x68
>                           [<ffffffff802b96f0>] sys_close+0xaa/0xe9
>                           [<ffffffff8020c2cb>] system_call_fastpath+0x16/0x1b
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>     softirq-on-W at:
>                           [<ffffffff80262857>] __lock_acquire+0x785/0x1697
>                           [<ffffffff802637be>] lock_acquire+0x55/0x71
>                           [<ffffffff80464126>] _spin_lock+0x31/0x3d
>                           [<ffffffff802c7505>] sys_fcntl+0x2aa/0x36c
>                           [<ffffffff8020c2cb>] system_call_fastpath+0x16/0x1b
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>     hardirq-on-W at:
>                           [<ffffffff8026282e>] __lock_acquire+0x75c/0x1697
>                           [<ffffffff802637be>] lock_acquire+0x55/0x71
>                           [<ffffffff80464126>] _spin_lock+0x31/0x3d
>                           [<ffffffff802c7505>] sys_fcntl+0x2aa/0x36c
>                           [<ffffffff8020c2cb>] system_call_fastpath+0x16/0x1b
>                           [<ffffffffffffffff>] 0xffffffffffffffff
>   }
>   ... key      at: [<ffffffff81096e08>] __key.20386+0x0/0x8
>  ... acquired at:
>    [<ffffffff80263404>] __lock_acquire+0x1332/0x1697
>    [<ffffffff802637be>] lock_acquire+0x55/0x71
>    [<ffffffff80464126>] _spin_lock+0x31/0x3d
>    [<ffffffff802c6c74>] fasync_helper+0xd6/0x110
>    [<ffffffff802ea28c>] locks_delete_lock+0x50/0x9f
>    [<ffffffff802ea819>] __posix_lock_file+0x326/0x549
>    [<ffffffff802eaa8c>] vfs_lock_file+0x38/0x3a
>    [<ffffffff802eab1f>] locks_remove_posix+0x91/0xb2
>    [<ffffffff802b9634>] filp_close+0x56/0x68
>    [<ffffffff802b96f0>] sys_close+0xaa/0xe9
>    [<ffffffff8020c2cb>] system_call_fastpath+0x16/0x1b
>    [<ffffffffffffffff>] 0xffffffffffffffff
> 
> 
> the second lock's dependencies:
> -> (&f->f_lock){--..} ops: 0 {
>    initial-use  at:
>                         [<ffffffff80262870>] __lock_acquire+0x79e/0x1697
>                         [<ffffffff802637be>] lock_acquire+0x55/0x71
>                         [<ffffffff80464126>] _spin_lock+0x31/0x3d
>                         [<ffffffff802c6c74>] fasync_helper+0xd6/0x110
>                         [<ffffffff802ea28c>] locks_delete_lock+0x50/0x9f
>                         [<ffffffff802ea819>] __posix_lock_file+0x326/0x549
>                         [<ffffffff802eaa8c>] vfs_lock_file+0x38/0x3a
>                         [<ffffffff802eab1f>] locks_remove_posix+0x91/0xb2
>                         [<ffffffff802b9634>] filp_close+0x56/0x68
>                         [<ffffffff802b96f0>] sys_close+0xaa/0xe9
>                         [<ffffffff8020c2cb>] system_call_fastpath+0x16/0x1b
>                         [<ffffffffffffffff>] 0xffffffffffffffff
>    softirq-on-W at:
>                         [<ffffffff80262857>] __lock_acquire+0x785/0x1697
>                         [<ffffffff802637be>] lock_acquire+0x55/0x71
>                         [<ffffffff80464126>] _spin_lock+0x31/0x3d
>                         [<ffffffff802c7505>] sys_fcntl+0x2aa/0x36c
>                         [<ffffffff8020c2cb>] system_call_fastpath+0x16/0x1b
>                         [<ffffffffffffffff>] 0xffffffffffffffff
>    hardirq-on-W at:
>                         [<ffffffff8026282e>] __lock_acquire+0x75c/0x1697
>                         [<ffffffff802637be>] lock_acquire+0x55/0x71
>                         [<ffffffff80464126>] _spin_lock+0x31/0x3d
>                         [<ffffffff802c7505>] sys_fcntl+0x2aa/0x36c
>                         [<ffffffff8020c2cb>] system_call_fastpath+0x16/0x1b
>                         [<ffffffffffffffff>] 0xffffffffffffffff
>  }
>  ... key      at: [<ffffffff81096e08>] __key.20386+0x0/0x8
> 
> stack backtrace:
> Pid: 0, comm: swapper Not tainted 2.6.29-Linus-03321-gbe0ea69 #55
> Call Trace:
>  <IRQ>  [<ffffffff80260a11>] print_irq_inversion_bug+0x175/0x184
>  [<ffffffff80260ab8>] check_usage_forwards+0x98/0xa1
>  [<ffffffff8026113b>] mark_lock+0x5dd/0xa2b
>  [<ffffffff80262748>] __lock_acquire+0x676/0x1697
>  [<ffffffff80262870>] ? __lock_acquire+0x79e/0x1697
>  [<ffffffff802637be>] lock_acquire+0x55/0x71
>  [<ffffffff802c7073>] ? kill_fasync+0x2c/0x4e
>  [<ffffffff8046442b>] _read_lock+0x34/0x41
>  [<ffffffff802c7073>] ? kill_fasync+0x2c/0x4e
>  [<ffffffff802c7073>] kill_fasync+0x2c/0x4e
>  [<ffffffff803cb7bd>] evdev_pass_event+0x6e/0x77
>  [<ffffffff803cbb47>] evdev_event+0x74/0xfd
>  [<ffffffff803cbad3>] ? evdev_event+0x0/0xfd
>  [<ffffffff803c75a5>] input_pass_event+0x64/0xcc
>  [<ffffffff803c7541>] ? input_pass_event+0x0/0xcc
>  [<ffffffff803c7cdf>] input_handle_event+0x339/0x345
>  [<ffffffff803c8bf6>] input_event+0x63/0x7d
>  [<ffffffff803d1275>] alps_process_packet+0x3b7/0x4cc
>  [<ffffffff803d13e5>] alps_process_byte+0x5b/0x6e
>  [<ffffffff803ce797>] psmouse_handle_byte+0x17/0x10d
>  [<ffffffff803cf766>] psmouse_interrupt+0x277/0x285
>  [<ffffffff803c47a4>] ? serio_interrupt+0x2b/0x83
>  [<ffffffff803c47c0>] serio_interrupt+0x47/0x83
>  [<ffffffff803c58b7>] i8042_interrupt+0x200/0x215
>  [<ffffffff8027b277>] handle_IRQ_event+0x6b/0xa1
>  [<ffffffff8027c55c>] handle_edge_irq+0xeb/0x131
>  [<ffffffff80464a25>] __irqentry_text_start+0x6d/0xd8
>  [<ffffffff8020cd13>] ret_from_intr+0x0/0xf
>  <EOI>  [<ffffffff8025d068>] ? tick_broadcast_oneshot_control+0x1f/0x102
>  [<ffffffff802130e6>] ? default_idle+0x35/0x4f
>  [<ffffffff802130e4>] ? default_idle+0x33/0x4f
>  [<ffffffff802131ed>] ? c1e_idle+0xda/0x101
>  [<ffffffff8025713e>] ? atomic_notifier_call_chain+0xf/0x11
>  [<ffffffff8020b1f6>] ? cpu_idle+0x5c/0x9d
>  [<ffffffff80451797>] ? rest_init+0x6b/0x6d
