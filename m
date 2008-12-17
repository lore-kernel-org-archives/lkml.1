Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1756496AbYLQLXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbYLQLXW (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 06:23:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYLQLXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 06:23:12 -0500
Received: from ozlabs.org ([203.10.76.45]:48224 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbYLQLXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 06:23:11 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: local_add_return
Date: Wed, 17 Dec 2008 21:53:04 +1030
User-Agent: KMail/1.10.3 (Linux/2.6.27-9-generic; KDE/4.1.3; i686; ; )
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Christoph Lameter <christoph@lameter.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Martin Bligh <mbligh@google.com>
References: <alpine.DEB.1.10.0812150823370.18692@gandalf.stny.rr.com> <200812161703.00697.rusty@rustcorp.com.au> <20081216162532.GA7575@Krystal>
In-Reply-To: <20081216162532.GA7575@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812172153.05303.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 December 2008 02:55:32 Mathieu Desnoyers wrote:
> Specifically on this comment :
> 
> +/* There are three obvious ways to implement local_t on an arch which
> + * can't do single-instruction inc/dec etc.
> + * 1) atomic_long
> + * 2) irq_save/irq_restore
> + * 3) multiple counters.
> 
> Option 3) is not workable for tracers, because it's not safe against
> some exceptions (e.g. some hardware errors) nor NMIs.

Hmm, nor is option 2.  Now I understand where you were coming from and
I sympathize with your dilemna, but I don't think that non-x86 archs should
pay for it where local_t is used as intended, so I don't think local_t should
be (have been) hijacked for this.  nmi_safe_t?

> Also, local_t
> operations must have preemption disabled before playing on per-cpu data,
> which I don't see in your test. This has to be taken into account in the
> runtime cost.

atomic_long_t implementations don't have to.  local_irq_save does it
as a side effect.  You're right about multiple counters tho.  We can
either do it conditionally or unconditionally, but I think unconditional
makes sense (CONFIG_PREEMPT=y seems to be less popular than it was).

> the CPU_OPS work done by Christoph Lameter which use
> segments to address the per-cpu data, which effectively removes the need
> for disabling preemption around local_t operations because the CPU ID
> becomes encoded in a cpu register.

Well, we did this for 32-bit x86 some time ago, so that works today.
64-bit was delayed because of the stack protection code, which needs
a fixed offset for the canary so needs zero-based percpu, but IIRC
that's orthogonal to the CPU_OPS work itself.

Here's the timing diff when trivalue is fixed here (preempt on)
Before:
	local_inc=45 local_add=45 cpu_local_inc=6 local_read=21 local_add_return=127
After:
	local_inc=47 local_add=47 cpu_local_inc=6 local_read=41 local_add_return=127

Since sparc64 has CONFIG_PREEMPT=n in its defconfig, I think it is still
ahead with trivalue.

Thanks,
Rusty.
