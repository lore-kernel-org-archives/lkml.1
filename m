Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbXJBBeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbXJBBeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 21:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbXJBBen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 21:34:43 -0400
Received: from ozlabs.org ([203.10.76.45]:34302 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbXJBBem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 21:34:42 -0400
Subject: Re: [PATCH RFC] paravirt: cleanup lazy mode handling
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>,
       Avi Kivity <avi@qumranet.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>
In-Reply-To: <470186C4.5080208@goop.org>
References: <470186C4.5080208@goop.org>
Content-Type: text/plain
Date: Tue, 02 Oct 2007 11:34:17 +1000
Message-Id: <1191288858.6979.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-01 at 16:46 -0700, Jeremy Fitzhardinge wrote:
> This patch removes the set_lazy_mode operation, and adds "enter" and
> "leave" lazy mode operations on mmu_ops and cpu_ops.  All the logic
> associated with enter and leaving lazy states is now in common code
> (basically BUG_ONs to make sure that no mode is current when entering
> a lazy mode, and make sure that the mode is current when leaving).
> Also, flush is handled in a common way, by simply leaving and
> re-entering the lazy mode.

That's good, but this code does lose on native because we no longer
simply replace the entire thing with noops.

Perhaps inverting this and having (inline) helpers is the way to go?
I'm thinking something like:

static inline void paravirt_enter_lazy(enum paravirt_lazy_mode mode)
{
	BUG_ON(x86_read_percpu(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
	BUG_ON(preemptible());

	x86_write_percpu(paravirt_lazy_mode, mode);
}

static inline void paravirt_exit_lazy(enum paravirt_lazy_mode mode)
{
	BUG_ON(x86_read_percpu(paravirt_lazy_mode) != mode);
	BUG_ON(preemptible());

	x86_write_percpu(paravirt_lazy_mode, PARAVIRT_LAZY_NONE);
}

The only trick would be that the flushes are so rarely required it's
probably worth putting the unlikely() in the top level:

static void arch_flush_lazy_cpu_mode(void)
{
	if (unlikely(x86_read_percpu(paravirt_lazy_mode)) {
		PVOP_VCALL0(cpu_ops.enter_lazy);
		PVOP_VCALL0(cpu_ops.exit_lazy);
	}
}

static void arch_flush_lazy_mmy_mode(void)
{
	if (unlikely(x86_read_percpu(paravirt_lazy_mode)) {
		PVOP_VCALL0(mmu_ops.enter_lazy);
		PVOP_VCALL0(mmu_ops.exit_lazy);
	}
}

Thoughts?
Rusty.

