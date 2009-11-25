Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbZKYPNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbZKYPNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 10:13:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbZKYPNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 10:13:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:33593 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbZKYPNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 10:13:12 -0500
Message-ID: <4B0D4941.5010904@kernel.org>
Date: Thu, 26 Nov 2009 00:12:01 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: percpu tree build warning
References: <20091125214219.f37935e8.sfr@canb.auug.org.au> <20091125105004.GA18163@elte.hu> <4B0D23A6.8040902@kernel.org> <20091125134058.GA9097@elte.hu>
In-Reply-To: <20091125134058.GA9097@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/25/2009 10:40 PM, Ingo Molnar wrote:
> And look at your own 'cleanup' patch - it changes the percpu name to 
> 'cpu_dr7'. That results in nonsensical repetition:
> 
>         dr7 = &__get_cpu_var(cpu_dr7);

My whole argument can be compressed into "don't name a global symbol
dr7, no matter what it is".

The key problem is the artificial difference between static and
dynamic percpu variable accessors.  The old way of prefixing from
accessors only works for symbol literals, so either we need another
identical set for dynamic ones without auto-prefixing or we end up
doing the repetition you mentioned above in much uglier way.

Option 1:

	this_cpu_static_OP(dr7, ARG);
	this_cpu_dynamic_OP(*allocated_ptr, ARG);
	this_cpu_dynamic_OP(per_cpu_var(dr7), ARG);

Options 2:

	this_cpu_OP(per_cpu_var(dr7), ARG);

BTW, option 2 is what we've been doing before the change.  It's just
ugly and the prefix no longer provides much protection because users
outside of percpu code have to use per_cpu_var() which never was
supposed to go outside of percpu internal code.  All it ends up doing
is providing false sense of address space isolation when there is
none.

DEFINE_*(NAME) defines a global symbol NAME in all other definition
macros.  DEFINE_PER_CPU() does so too.

Thanks.

-- 
tejun
