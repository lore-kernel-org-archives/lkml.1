Return-Path: <linux-kernel-owner+w=401wt.eu-S966816AbXJSVgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966816AbXJSVgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756161AbXJSVgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:36:33 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:54704 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754296AbXJSVgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:36:33 -0400
Message-ID: <4719235E.9030507@lwfinger.net>
Date: Fri, 19 Oct 2007 16:36:30 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: Locking problem in usbserial with 2.6.23-git 5a34417f
References: <4718D469.2080606@lwfinger.net> <Pine.LNX.4.64.0710192304590.18815@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0710192304590.18815@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Fri, 19 Oct 2007, Larry Finger wrote:
> 
>> While attempting to configure a new USB modem, the following locking 
>> problem occurred. In addition, shortly after this problem occurred, the 
>> computer froze. The log data starts at the point that usbserial was 
>> loaded and contains everything that was written to disk before the 
>> machine locked up. Some info may be missing from the end of the stack 
>> dump.
> 
> I guess this one is needed.
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> 
> USB: usbserial - fix potential deadlock between write() and irq
> 
> usb_serial_generic_write() doesn't disable interrupts when taking port->lock,
> and could therefore deadlock with usb_serial_generic_read_bulk_callback()
> being called from interrupt, taking the same lock. Fix it.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> 

As I said earlier, the lock problem went away; however, I get the following two kernel warnings:

WARNING: at kernel/sched.c:3475 sub_preempt_count()

Call Trace:
 [<ffffffff8022df50>] sub_preempt_count+0x7e/0x91
 [<ffffffff80237eb9>] local_bh_enable_ip+0x91/0xf5
 [<ffffffff803eaaa8>] _spin_unlock_bh+0x39/0x3e
 [<ffffffff88405409>] :ppp_generic:ppp_channel_push+0x72/0xad
 [<ffffffff88406528>] :ppp_generic:ppp_write+0x10f/0x121
 [<ffffffff8028f75d>] vfs_write+0xae/0x137
 [<ffffffff8028fcc6>] sys_write+0x47/0x70
 [<ffffffff8020c2fa>] tracesys+0xdc/0xe1

PPP BSD Compression module registered
PPP Deflate Compression module registered
WARNING: at kernel/softirq.c:139 local_bh_enable()

Call Trace:
 [<ffffffff80237d82>] local_bh_enable+0x8f/0x135
 [<ffffffff8038f9ec>] dev_queue_xmit+0x2a6/0x2d2
 [<ffffffff803ab2be>] ip_finish_output+0x221/0x24f
 [<ffffffff803ab5d0>] ip_output+0x53/0x55
 [<ffffffff803a9df5>] ip_push_pending_frames+0x309/0x3ed
 [<ffffffff803c5f88>] udp_push_pending_frames+0x2d7/0x33f
 [<ffffffff803c70e9>] udp_sendmsg+0x4d5/0x61d
 [<ffffffff80248c99>] lock_hrtimer_base+0x25/0x4a
 [<ffffffff803cccce>] inet_sendmsg+0x46/0x53
 [<ffffffff80381ca3>] sock_sendmsg+0xdf/0xf8
 [<ffffffff80248e8f>] hrtimer_start+0x102/0x114
 [<ffffffff8024653c>] autoremove_wake_function+0x0/0x38
 [<ffffffff8020bb85>] do_notify_resume+0x68e/0x7ac
 [<ffffffff803ea5cb>] trace_hardirqs_on_thunk+0x35/0x3a
 [<ffffffff803826b4>] move_addr_to_kernel+0x40/0x49
 [<ffffffff803827db>] sys_sendto+0x11e/0x143
 [<ffffffff8020bf5d>] sys_rt_sigreturn+0x2a6/0x389
 [<ffffffff80265072>] audit_syscall_entry+0x148/0x17e
 [<ffffffff8020c2fa>] tracesys+0xdc/0xe1

The second is complaining that interrupts are disabled, and may be related.

Larry
