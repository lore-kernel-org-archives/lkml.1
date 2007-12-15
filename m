Return-Path: <linux-kernel-owner+w=401wt.eu-S1760925AbXLOSoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925AbXLOSoQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 13:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbXLOSoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 13:44:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41282 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755144AbXLOSoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 13:44:01 -0500
Date: Sat, 15 Dec 2007 19:43:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Wang Chen <wangchen@cn.fujitsu.com>,
       Gerrit Renker <gerrit@erg.abdn.ac.uk>, davem@davemloft.net,
       andi@firstfloor.org, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 3/3] [UDP6]: Counter increment on BH mode
Message-ID: <20071215184327.GA21434@elte.hu>
References: <474F7EE8.2040009@cn.fujitsu.com> <474F8255.5060501@cn.fujitsu.com> <20071130111949.GB28277@gerrit.erg.abdn.ac.uk> <20071201015438.GC26895@gondor.apana.org.au> <4753AE07.1040906@cn.fujitsu.com> <20071203113935.GA25124@gondor.apana.org.au> <20071203114912.GA4425@ms2.inr.ac.ru> <20071203115435.GA4202@gondor.apana.org.au> <20071203131723.GA30312@gondor.apana.org.au> <20071215135851.GA29063@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071215135851.GA29063@gondor.apana.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Ob Tue, Dec 04, 2007 at 12:17:23AM +1100, Herbert Xu wrote:
> > 
> > Never mind, we already have that in local_t and as Alexey correctly
> > points out, USER is still going to be the expensive variant with the
> > preempt_disable (well until BH gets threaded).  So how about this patch?
> 
> I didn't hear any objections so here is the patch again.
> 
> [SNMP]: Fix SNMP counters with PREEMPT
> 
> The SNMP macros use raw_smp_processor_id() in process context which is 
> illegal because the process may be preempted and then migrated to 
> another CPU.

nit: please use 'invalid' instead of 'illegal'.

> This patch makes it use get_cpu/put_cpu to disable preemption.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

> -	(per_cpu_ptr(mib[1], raw_smp_processor_id())->mibs[field]++)
> +	do { \
> +		per_cpu_ptr(mib[1], get_cpu())->mibs[field]++; \
> +		put_cpu(); \
> +	} while (0)

> -	(per_cpu_ptr(mib[1], raw_smp_processor_id())->mibs[field] += addend)
> +	do { \
> +		per_cpu_ptr(mib[1], get_cpu())->mibs[field] += addend; \
> +		put_cpu(); \
> +	} while (0)

we could perhaps introduce stat_smp_processor_id(), which signals that 
the CPU id is used for statistical purposes and does not have to be 
exact? In any case, your patch looks good too.

	Ingo
