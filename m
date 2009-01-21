Return-Path: <linux-kernel-owner+w=401wt.eu-S1756107AbZAUOOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107AbZAUOOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 09:14:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbZAUONw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 09:13:52 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:35698 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZAUONv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 09:13:51 -0500
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
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
	<m1fxjcucp8.fsf@fess.ebiederm.org> <20090121234502.66acbcf9@s6510>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 21 Jan 2009 06:13:41 -0800
In-Reply-To: <20090121234502.66acbcf9@s6510> (Stephen Hemminger's message of "Wed\, 21 Jan 2009 23\:45\:01 +1100")
Message-ID: <m11vuwn3vu.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Hemminger <shemminger@vyatta.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] percpu: add optimized generic percpu accessors
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger <shemminger@vyatta.com> writes:

> This is crap. only a small fraction of these SNMP counters are
> close enough to the hot path to deserve per-cpu treatment.

Interesting.  I was just reading af_inet.c:ipv4_mib_init_net()
to get a feel for what a large consumer of percpu counters looks
like.

I expect the patterns I saw will hold even if the base size is much
smaller.


Your statement reinforces my point that our allocations in a per cpu
area are small and our dynamic per cpu allocator is not really
optimized for small allocations.

In most places what we want are 1-5 counters, which is max 40 bytes.
And our minimum allocation is a full cache line (64-128 bytes) per
allocation.



I'm wondering if dynamic per cpu allocations should work more like
slab.  Have a set of percpu base pointers for an area, and return an
area + offset in some convenient form.

Ideally we would just have one area (allowing us to keep the base
pointer in a register), but I'm not convinced that doesn't fall down
in the face of dynamic allocation.

Eric
 
