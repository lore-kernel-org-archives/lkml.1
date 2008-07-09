Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbYGIVjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbYGIVjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYGIVjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:39:44 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52747 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750881AbYGIVjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:39:43 -0400
Message-ID: <4875301D.20805@sgi.com>
Date: Wed, 09 Jul 2008 14:39:41 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <m1abgqzv3g.fsf@frodo.ebiederm.org>
In-Reply-To: <m1abgqzv3g.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> I just took a quick look at how stack_protector works on x86_64.  Unless there is
> some deep kernel magic that changes the segment register to %gs from the ABI specified
> %fs CC_STACKPROTECTOR is totally broken on x86_64.  We access our pda through %gs.
> 
> Further -fstack-protector-all only seems to detect against buffer overflows and
> thus corruption of the stack.  Not stack overflows.  So it doesn't appear especially
> useful.
> 
> So we don't we kill the broken CONFIG_CC_STACKPROTECTOR.  Stop trying to figure out
> how to use a zero based percpu area.
> 
> That should allow us to make the current pda a per cpu variable, and use %gs with
> a large offset to access the per cpu area.  And since it is only the per cpu accesses
> and the pda accesses that will change we should not need to fight toolchain issues
> and other weirdness.  The linked binary can remain the same.
> 
> Eric

Hi Eric,

There is one pda op that I was not able to remove.  Most likely it can be recoded
but it was a bit over my expertise.  Most likely the "pda_offset(field)" can be
replaced with "per_cpu_var(field)" [per_cpu__##field], but for "_proxy_pda.field"
I wasn't sure about.

include/asm-x86/pda.h:

/*
 * This is not atomic against other CPUs -- CPU preemption needs to be off
 * NOTE: This relies on the fact that the cpu_pda is the *first* field in
 *       the per cpu area.  Move it and you'll need to change this.
 */
#define test_and_clear_bit_pda(bit, field)                              \
({                                                                      \
        int old__;                                                      \
        asm volatile("btr %2,%%gs:%c3\n\tsbbl %0,%0"                    \
                     : "=r" (old__), "+m" (_proxy_pda.field)            \
                     : "dIr" (bit), "i" (pda_offset(field)) : "memory");\
        old__;                                                          \
})

And there is only one reference to it.  

arch/x86/kernel/process_64.c:

static void __exit_idle(void)
{
        if (test_and_clear_bit_pda(0, isidle) == 0)
                return;
        atomic_notifier_call_chain(&idle_notifier, IDLE_END, NULL);
}

Thanks,
Mike
