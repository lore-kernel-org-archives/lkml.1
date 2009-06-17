Return-Path: <linux-kernel-owner+w=401wt.eu-S1761054AbZFQSl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761054AbZFQSl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 14:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755578AbZFQSlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 14:41:22 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:48177 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755106AbZFQSlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 14:41:21 -0400
Date: Wed, 17 Jun 2009 14:41:17 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>, davem@davemloft.net
Subject: Re: [this_cpu_xx 01/11] Introduce this_cpu_ptr() and generic this_cpu_*
 operations
In-Reply-To: <4A38A719.2030709@kernel.org>
Message-ID: <alpine.DEB.1.10.0906171343370.30060@gentwo.org>
References: <20090605191819.376530498@gentwo.org> <20090605191850.441840884@gentwo.org> <4A38A719.2030709@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009, Tejun Heo wrote:

> cl@linux-foundation.org wrote:
> > +#ifndef this_cpu_write
> > +# define this_cpu_write(pcp, val)	__this_cpu_write((pcp), (val))
> > +#endif
>
> Is this safe?  Write itself would always be atomic but this means that
> a percpu variable may change its value while a thread is holding the
> processor by disabling preemption.  ie,
>
> 0. v contains A for cpu0
>
> 1. task0 on cpu0 does this_cpu_write(v, B), looks up cpu but gets
>    preemted out.
>
> 2. task1 gets scheduled on cpu1, disables preemption and does
>    __this_cpu_read(v) and gets A and goes on with preemtion disabled.
>
> 3. task0 gets scheduled on cpu1 and executes the assignment.
>
> 4. task1 does __this_cpu_read(v) again and oops gets B this time.
>
> Please note that this can also happen between addition or other
> modifying ops and cause incorrect result.

Per cpu operations are only safe for the current processor. One issue
there may be that the store after rescheduling may not occur to the
current processors per cpu instance but the prior cpu. At that point
another thread may be running on the prior cpu and be disturbed like you
point out. So it needs a preempt disable there too.

> Also, these macros depricate percpu_OP() macros, right?

They are different. percpu_OP() macros require a percpu variable name
to be passed.

this_cpu_* macros require a reference to a variable in a
structure allocated with the new per cpu allocator.

It is possible to simply pass the full variable name of a percpu variable
to this_cpu_* macros. See the patch of the vm statistics handling.

It uses

	per_cpu_var(per_cpu_name_without_prefix)

to generate the full name.

