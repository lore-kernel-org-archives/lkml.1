Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab0BRF27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 00:28:59 -0500
Received: from ozlabs.org ([203.10.76.45]:48699 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392Ab0BRF26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 00:28:58 -0500
Date: Thu, 18 Feb 2010 16:28:20 +1100
From: Anton Blanchard <anton@samba.org>
To: arun@linux.vnet.ibm.com, tglx@linutronix.de
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: NO_HZ migration of TCP ack timers
Message-ID: <20100218052820.GD24270@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

We have a networking workload on a large ppc64 box that is spending a lot
of its time in mod_timer(). One backtrace looks like:

83.25%  [k] ._spin_lock_irqsave
            |          
            |--99.62%-- .lock_timer_base
            |          .mod_timer
            |          .sk_reset_timer
            |          |          
            |          |--84.77%-- .tcp_send_delayed_ack
            |          |          .__tcp_ack_snd_check
            |          |          .tcp_rcv_established
            |          |          .tcp_v4_do_rcv

            |          |--12.72%-- .tcp_ack
            |          |          .tcp_rcv_established
            |          |          .tcp_v4_do_rcv

So it's mod_timer being called from the TCP ack timer code. It looks like
commit eea08f32adb3f97553d49a4f79a119833036000a (timers: Logic to move non
pinned timers) is causing it, in particular:

#if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
        if (!pinned && get_sysctl_timer_migration() && idle_cpu(cpu)) {
                int preferred_cpu = get_nohz_load_balancer();

                if (preferred_cpu >= 0)
                        cpu = preferred_cpu;
        }
#endif

and:

echo 0 > /proc/sys/kernel/timer_migration

makes the problem go away.

I think the problem is the CPU is most likely to be idle when an rx networking
interrupt comes in. It seems the wrong thing to do to migrate any ack timers
off the current cpu taking the interrupt, and with enough networks we train
wreck transferring everyones ack timers to the nohz load balancer cpu. 

What should we do? Should we use mod_timer_pinned here? Or is this an issue
other areas might see (eg the block layer) and we should instead avoid
migrating timers created out of interrupts.

Anton
