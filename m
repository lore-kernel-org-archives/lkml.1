Return-Path: <linux-kernel-owner+w=401wt.eu-S1761120AbXFGOHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761120AbXFGOHW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757283AbXFGOHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:07:10 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:11321 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbXFGOHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:07:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KBlWsqRAlGWQv7S1Aoz7OkgfVQs41A8keuN6FEHNh0VzxhYn6BbcLeB5QZDyFArgXmc/18cvr/F9jg+m0jOj9VPTC4fB8JP5pA/3ZXdljoKRhk1gGT7vGPcpMCJlk3qkLOjmmkHtLenfM9cpz9OoD6nt7RoRYrn0tU1X/2euslA=
Message-ID: <a781481a0706070707j301ba886h10f4607fd6a6e8de@mail.gmail.com>
Date: Thu, 7 Jun 2007 19:37:04 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Jan Glauber" <jan.glauber@de.ibm.com>
Subject: Re: [patch] i386/x86_64: smp_call_function locking inconsistency
Cc: "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "David Miller" <davem@davemloft.net>, akpm@osdl.org, mingo@elte.hu,
       ak@suse.de, schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@redhat.com>
In-Reply-To: <1171025838.5349.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070208203210.GB9798@osiris.ibm.com>
	 <20070208.124328.88477956.davem@davemloft.net>
	 <20070209084221.GA8259@osiris.boeblingen.de.ibm.com>
	 <1171025838.5349.14.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm about six months late here(!), but I noticed this bug in
arch/x86_64/kernel/smp.c while preparing another related
patch today and then found this thread during Googling ...

On 2/9/07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> On i386/x86_64 smp_call_function_single() takes call_lock with
> spin_lock_bh(). To me this would imply that it is legal to call
> smp_call_function_single() from softirq context.
> It's not since smp_call_function() takes call_lock with just
> spin_lock(). We can easily deadlock:
>
> -> [process context]
> -> smp_call_function()
> -> spin_lock(&call_lock)
> -> IRQ -> do_softirq -> tasklet
> -> [softirq context]
> -> smp_call_function_single()
> -> spin_lock_bh(&call_lock)
> -> dead

You're absolutely right, and this bug still exists in the latest -git.

> So either all spin_lock_bh's should be converted to spin_lock,
> which would limit smp_call_function()/smp_call_function_single()
> to process context & irqs enabled.
> Or the spin_lock's could be converted to spin_lock_bh which would
> make it possible to call these two functions even if in softirq
> context. AFAICS this should be safe.

Actually, I agree with David and Andi here:

On 2/9/07, David Miller <davem@davemloft.net> wrote:
> I think it's logically simpler if we disallow smp_call_function*()
> from any kind of asynchronous context.  But I'm sure your driver
> has a true need for this for some reason.

and

On 2/9/07, Andi Kleen <ak@suse.de> wrote:
> I'm not so sure. Perhaps drop _bh in both and stick a WARN_ON_ONCE in
> to catch the cases?

Replacing the _bh variants and making smp_call_function{_single}
illegal from all contexts but process is fine for x86_64, as we
don't really have any driver that needs to use this from softirq
context in the x86_64 tree. This means it becomes dissimilar to
s390, but similar to powerpc, mips, alpha, sparc64 semantics.
I'll prepare and submit a patch for the same, shortly.

As for:

On 2/9/07, Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> Another thing that comes into my mind is smp_call_function together
> with cpu hotplug. Who is responsible that preemption and with that
> cpu hotplug is disabled?
> Is it the caller or smp_call_function itself?
> If it's smp_call_function then s390 would be broken, since
> then we would have
> int cpus = num_online_cpus()-1;
> in preemptible context... I agree: what a mess :)

and

On 2/9/07, Jan Glauber <jan.glauber@de.ibm.com> wrote:
> If preemption must be disabled before smp_call_function() we should have
> the same semantics for all smp_call_function_* variants.

I don't see any CPU hotplug / preemption disabling issues here.
Note that both smp_call_function() and smp_call_function_single()
on x86_64 acquire the call_lock spinlock before using cpu_online_map
via num_online_cpus(). And spin_lock() does preempt_disable() on both
SMP and !SMP, so we're safe. [ But we're not explicitly disabling
preemption and depending on spin_lock() instead, so a comment would
be in order? ]

Satyam
