Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbZIWRsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbZIWRsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 13:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbZIWRsT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 13:48:19 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:52742 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751377AbZIWRsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 13:48:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArsFAH/3uUpMROOX/2dsb2JhbACBUtY/hBsF
Date: Wed, 23 Sep 2009 13:48:20 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC] Userspace RCU: (ab)using futexes to save cpu cycles and
	energy
Message-ID: <20090923174820.GA12827@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:39:32 up 36 days,  4:29,  3 users,  load average: 0.07, 0.06,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When implementing the call_rcu() "worker thread" in userspace, I ran
into the problem that it had to be woken up periodically to check if
there are any callbacks to execute. However, I easily imagine that this
does not fit well with the "green computing" definition.

Therefore, I've looked at ways to have the call_rcu() callers waking up
this worker thread when callbacks are enqueued. However, I don't want to
take any lock and the fast path (when no wake up is required) should not
cause any cache-line exchange.

Here are the primitives I've created. I'd like to have feedback on my
futex use, just to make sure I did not do any incorrect assumptions.

This could also be eventually used in the QSBR Userspace RCU quiescent
state and in mb/signal userspace RCU when exiting RCU read-side C.S. to
ensure synchronize_rcu() does not busy-wait for too long.

/*
 * Wake-up any waiting defer thread. Called from many concurrent threads.
 */
static void wake_up_defer(void)
{
        if (unlikely(atomic_read(&defer_thread_futex) == -1))
                atomic_set(&defer_thread_futex, 0);
                futex(&defer_thread_futex, FUTEX_WAKE,
                      0, NULL, NULL, 0);
}

/*
 * Defer thread waiting. Single thread.
 */
static void wait_defer(void)
{
        atomic_dec(&defer_thread_futex);
        if (atomic_read(&defer_thread_futex) == -1)
                futex(&defer_thread_futex, FUTEX_WAIT, -1,
                      NULL, NULL, 0);
}

Thanks,

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
