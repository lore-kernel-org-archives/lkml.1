Return-Path: <linux-kernel-owner+w=401wt.eu-S1764383AbZAULWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764383AbZAULWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 06:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbZAULVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 06:21:42 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:42347 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799AbZAULVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 06:21:41 -0500
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Herbert Xu <herbert@gondor.apana.org.au>, akpm@linux-foundation.org,
       hpa@zytor.com, brgerst@gmail.com, cl@linux-foundation.org,
       travis@sgi.com, linux-kernel@vger.kernel.org, steiner@sgi.com,
       hugh@veritas.com, "David S. Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
References: <20090115183942.GA6325@elte.hu>
	<200901170827.33729.rusty@rustcorp.com.au>
	<20090116220832.GB20653@elte.hu>
	<200901201328.24605.rusty@rustcorp.com.au>
	<20090120104022.GB29346@elte.hu> <4976B82E.1080002@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 21 Jan 2009 03:21:23 -0800
In-Reply-To: <4976B82E.1080002@kernel.org> (Tejun Heo's message of "Wed\, 21 Jan 2009 14\:52\:46 +0900")
Message-ID: <m1fxjcucp8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Ingo Molnar wrote:
>> The larger point still remains: the kernel dominantly uses static percpu 
>> variables by a margin of 10 to 1, so we cannot just brush away the static 
>> percpu variables and must concentrate on optimizing that side with 
>> priority. It's nice if the dynamic percpu-alloc side improves as well, of 
>> course.
>
> Well, the infrequent usage of dynamic percpu allocation is in some
> part due to the poor implementation, so it's sort of chicken and egg
> problem.  I got into this percpu thing because I wanted a percpu
> reference count which can be dynamically allocated and it sucked.

Counters are our other special case, and counters are interesting
because they are individually very small.  I just looked and the vast
majority of the alloc_percpu users are counters.

I just did a rough count in include/linux/snmp.h  and I came
up with 171*2 counters.  At 8 bytes per counter that is roughly
2.7K.  Or about two thirds of a 4K page.

What makes this is a challenge is that those counters are per network
namespace, and there are no static limits on the number of network
namespaces.

If we push the system and allocate 1024 network namespaces we wind up
needing 2.7MB per cpu, just for the SNMP counters.  

Which nicely illustrates the principle that typically each individual
per cpu allocation is small, but with dynamic allocation we have the
challenge that number of allocations becomes unbounded and in some cases
could be large, while the typical per cpu size is likely to be very small.

I wonder if for the specific case of counters it might make sense to
simply optimize the per cpu allocator for machine word size allocations
and allocate each counter individually freeing us from the burden of
worrying about fragmentation.


The pain with the current alloc_percpu implementation when working
with counters is that it has to allocate an array with one entry
for each cpu to point at the per cpu data.  Which isn't especially efficient.


Eric



