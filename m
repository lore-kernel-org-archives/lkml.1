Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbXC0LIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbXC0LIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 07:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753809AbXC0LIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 07:08:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbXC0LIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 07:08:17 -0400
Date: Tue, 27 Mar 2007 06:07:57 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Pierre.Peiffer@bull.net
Cc: akpm@linux-foundation.org, mingo@elte.hu, drepper@redhat.com,
       linux-kernel@vger.kernel.org, jean-pierre.dion@bull.net
Subject: Re: [PATCH 2.6.21-rc4-mm1 4/4] sys_futex64 : allows 64bit futexes
Message-ID: <20070327110757.GY355@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20070321095432.207136068@bull.net> <20070321100542.438317770@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070321100542.438317770@bull.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 10:54:36AM +0100, Pierre.Peiffer@bull.net wrote:
> This last patch is an adaptation of the sys_futex64 syscall provided in -rt
> patch (originally written by Ingo Molnar). It allows the use of 64-bit futex.
> 
> I have re-worked most of the code to avoid the duplication of the code.
> 
> It does not provide the functionality for all architectures (only for x64 for now).

I don't think you should blindly add all operations to sys_futex64 without
thinking what they really do.
E.g. FUTEX_{{,UN,TRY}LOCK,CMP_REQUEUE}_PI doesn't really make any sense for 64-bit
futexes, the format of PI futexes is hardcoded in the kernel and is always
32-bit, see FUTEX_TID_MASK, FUTEX_WAITERS, FUTEX_OWNER_DIED definitions.
exit_robust_list/handle_futex_death will handle 32-bit PI futexes anyway.
Similarly, sys_futex64 shouldn't support the obsolete operations that
are there solely for compatibility (e.g. FUTEX_REQUEUE or FUTEX_FD).

When you just -ENOSYS on the PI ops, there is no need to implement
futex_atomic_cmpxchg_inatomic64.

FUTEX_WAKE_OP is questionable for 64-bit, IMHO it is better to just
-ENOSYS on it and only if anyone ever finds actual uses for it, add it.

For 64-bit futexes the only needed operations are actually
FUTEX_WAIT and perhaps FUTEX_CMP_REQUEUE, so I wonder if it isn't
better to just add FUTEX_WAIT64 and FUTEX_CMP_REQUEUE64 ops to sys_futex
instead of adding a new syscall.

But the FUTEX_{{,UN,TRY}LOCK,CMP_REQUEUE}_PI removal for 64-bit futexes
is IMHO the most important part of my complain.

	Jakub
