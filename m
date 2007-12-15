Return-Path: <linux-kernel-owner+w=401wt.eu-S932378AbXLORHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbXLORHp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 12:07:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbXLORHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 12:07:35 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:36673 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947AbXLORHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 12:07:34 -0500
Message-ID: <476408D7.50205@cosmosbay.com>
Date: Sat, 15 Dec 2007 18:03:19 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
       Wang Chen <wangchen@cn.fujitsu.com>,
       Gerrit Renker <gerrit@erg.abdn.ac.uk>, davem@davemloft.net,
       andi@firstfloor.org, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/3] [UDP6]: Counter increment on BH mode
References: <474F7EE8.2040009@cn.fujitsu.com> <474F8255.5060501@cn.fujitsu.com> <20071130111949.GB28277@gerrit.erg.abdn.ac.uk> <20071201015438.GC26895@gondor.apana.org.au> <4753AE07.1040906@cn.fujitsu.com> <20071203113935.GA25124@gondor.apana.org.au> <20071203114912.GA4425@ms2.inr.ac.ru> <20071203115435.GA4202@gondor.apana.org.au> <20071203131723.GA30312@gondor.apana.org.au> <20071215135851.GA29063@gondor.apana.org.au>
In-Reply-To: <20071215135851.GA29063@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 15 Dec 2007 18:03:27 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu a écrit :
> Ob Tue, Dec 04, 2007 at 12:17:23AM +1100, Herbert Xu wrote:
>> Never mind, we already have that in local_t and as Alexey correctly
>> points out, USER is still going to be the expensive variant with the
>> preempt_disable (well until BH gets threaded).  So how about this patch?
> 
> I didn't hear any objections so here is the patch again.
> 
> [SNMP]: Fix SNMP counters with PREEMPT
> 
> The SNMP macros use raw_smp_processor_id() in process context
> which is illegal because the process may be preempted and then
> migrated to another CPU.
> 
> This patch makes it use get_cpu/put_cpu to disable preemption.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> Cheers,
  #define SNMP_INC_STATS_USER(mib, field) \
-	(per_cpu_ptr(mib[1], raw_smp_processor_id())->mibs[field]++)
+	do { \
+		per_cpu_ptr(mib[1], get_cpu())->mibs[field]++; \
+		put_cpu(); \
+	} while (0)
  #define SNMP_INC_STATS(mib, field) 	\
  	(per_cpu_ptr(mib[!in_softirq()], raw_smp_processor_id())->mibs[field]++)


How come you change SNMP_INC_STATS_USER() but not SNMP_INC_STATS() ?


