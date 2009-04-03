Return-Path: <linux-kernel-owner+w=401wt.eu-S1755071AbZDCHua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071AbZDCHua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 03:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbZDCHuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 03:50:18 -0400
Received: from viefep16-int.chello.at ([62.179.121.36]:19268 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbZDCHuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 03:50:17 -0400
X-SourceIP: 213.93.53.227
Subject: Re: perf_counter: request for three more sample data options
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <49D5B9E7.1020400@linux.vnet.ibm.com>
References: <49D56A7E.80908@linux.vnet.ibm.com>
	 <1238742064.798.8.camel@twins>  <49D5B9E7.1020400@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 03 Apr 2009 09:51:17 +0200
Message-Id: <1238745077.798.17.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 00:25 -0700, Corey Ashford wrote:

> >> I am guessing the only difficult thing here would be obtaining the 
> >> current time from an IRQ, especially NMI handler.  Is this difficult?
> > 
> > Yes, quite :-) I'll have to see what we can do there -- we could do a
> > best effort thing with little to no guarantees I think.
> > 
> 
> Best effort would be fine, I think.  I would assume that means that 
> 99.9% of the time, you'll get a correct timestamp, and the rest are 
> rubbish?  Or would there be a way to detect when you're not able to give 
> a correct timestamp and in that case replace the timestamp field with a 
> special sentinel, like all hex f's?

What I was thinking of was re-using some of the cpu_clock()
infrastructure. That provides us with a jiffy based GTOD sample,
cpu_clock() then uses TSC and a few filters to compute a current
timestamp.

I was thinking about cutting back those filters and thus trusting the
TSC more -- which on x86 can do any random odd thing. So provided the
TSC is not doing funny the results will be ok-ish.

This does mean however, that its not possible to know when its gone bad.

Also, cpu_clock() can only provide monotonicity per-cpu, if a value read
on one cpu is compared to a value read on another cpu, there can be a
drift of at most 1-2 jiffies.

Anyway, I'll prod some at this and see how much of cpu_clock() we can
get working in NMI context -- currently it just bails and returns the
last value computed.

The question to Paul is, does the powerpc sched_clock() call work in NMI
-- or hard irq disable -- context?

