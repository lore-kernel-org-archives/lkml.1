Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbZCTGgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbZCTGgD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 02:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbZCTGfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 02:35:51 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:42296 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbZCTGfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 02:35:50 -0400
Message-ID: <49C33928.1050806@cosmosbay.com>
Date: Fri, 20 Mar 2009 07:35:20 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: dipankar@in.ibm.com
CC: paulmck@linux.vnet.ibm.com, Arjan van de Ven <arjan@infradead.org>,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Question about usage of RCU in the input layer
References: <20090318215812.15496a86@infradead.org> <20090319085628.GA6167@in.ibm.com> <20090319071841.63334eff@infradead.org> <20090320020750.GA6807@linux.vnet.ibm.com> <20090319202032.4c971d92@infradead.org> <20090320044541.GE6807@linux.vnet.ibm.com> <49C3296B.1020209@cosmosbay.com> <20090320060128.GC6167@in.ibm.com>
In-Reply-To: <20090320060128.GC6167@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 20 Mar 2009 07:35:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dipankar Sarma a écrit :
> On Fri, Mar 20, 2009 at 06:28:11AM +0100, Eric Dumazet wrote:
>> Paul E. McKenney a écrit :
>> Hmm... point is to make linux boot as fast as possible, so ...
>>
>> Use a special variant of udelay() in offending drivers that make appropriate
>> RCU call to increment quiescent state ?
> 
> It may not be safe to do this it is in a RCU read-side critical section.

Yes, this is why I suggested a variant of udelay, not udelay() itself,
used by selected drivers (probably not so many drivers hog cpu so long)

void udelay_rcu_quiescent(unsigned long usecs)
{
	preempt_disable();
	rcu_qsctr_inc(smp_processor_id());
	preempt_enable();

	udelay(usecs);
}


Or maybe we have a way to detect we are in a RCU-side critical section at runtime ?

void __udelay(unsigned long usecs)
{
	if (!in_rcu_critical_section()) {
		preempt_disable();
		rcu_qsctr_inc(smp_processor_id());
		preempt_enable();
	}
	...
}


Thank you

