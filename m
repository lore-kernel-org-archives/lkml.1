Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbYHLVp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbYHLVp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 17:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751858AbYHLVpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 17:45:18 -0400
Received: from saeurebad.de ([85.214.36.134]:38299 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbYHLVpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 17:45:17 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Nageswara R Sastry <rnsastry@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
       svaidy@linux.vnet.ibm.com, davej@codemonkey.org.uk,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [BUG] While changing the cpufreq governor, kernel hits a bug in workqueue.c
References: <485F8028.1070302@linux.vnet.ibm.com>
	<87y74w41fp.fsf@skyscraper.fehenstaub.lan>
	<4860BB8E.2070505@linux.vnet.ibm.com>
	<87tzfh2t5l.fsf@skyscraper.fehenstaub.lan>
	<48638906.4090308@linux.vnet.ibm.com>
	<87y74l4scd.fsf@skyscraper.fehenstaub.lan>
	<87fxqp7nye.fsf@skyscraper.fehenstaub.lan>
	<4871E657.3040403@linux.vnet.ibm.com> <87d4lqq7ec.fsf@saeurebad.de>
	<487300B1.4040300@linux.vnet.ibm.com> <877ibukn8k.fsf@saeurebad.de>
	<1216215897.1652.24.camel@lappy.programming.kicks-ass.net>
	<48A145FA.2030803@linux.vnet.ibm.com>
	<8763q53ot0.fsf@skyscraper.fehenstaub.lan>
Date: Tue, 12 Aug 2008 23:44:51 +0200
In-Reply-To: <8763q53ot0.fsf@skyscraper.fehenstaub.lan> (Johannes Weiner's
	message of "Tue, 12 Aug 2008 23:29:15 +0200")
Message-ID: <87y73129ik.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner <hannes@saeurebad.de> writes:

> Hi Nageswara,
>
> Nageswara R Sastry <rnsastry@linux.vnet.ibm.com> writes:
>
>> Any updates on this bug.
>
> Sorry.  I was just looking into it again and still see no resolution.
> Added Venkatesh and Alexey to CC.

Sorry, wrong address for Alexey.  Hope this one works.

> To summarize again:
>
> The problem we have is that cpufreq_ondemand has a self-rearming worker
> function which we should but can not cancel synchroneously with the
> current code.  The locking order is like this:
>
> store()
>   policy_rwsem write
>     cpufreq_governor_dbs()
>     dbs_mutex
>
> work lock
>   do_dbs_timer()
>     policy_rwsem write
>
> which gives a locking hierarchy of:
>
> work lock
>   policy_rwsem
>     dbs_mutex
>
> Now, we _should_ cancel the worker synchroneously, but that won't fly
> since when cpufreq_governor_dbs() is called, we already hold
> policy_rwsem and grabbing the work lock is illegal.
>
> I will continue to read code and see if I can come up with a solution,
> but any help is really appreciated.
>
> I have not yet looked at cpufreq_conservative...
>
>> Thanks and Regards
>> R.Nageswara Sastry
>
> Thanks for your patience and insistence,
>
> 	Hannes
