Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755970Ab0CHXQ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 18:16:57 -0500
Received: from hera.kernel.org ([140.211.167.34]:34465 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab0CHXQx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 18:16:53 -0500
Message-ID: <4B9585DF.8020308@kernel.org>
Date: Tue, 09 Mar 2010 08:18:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-3.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, sivanich@sgi.com,
       heiko.carstens@de.ibm.com, torvalds@linux-foundation.org, mingo@elte.hu,
       peterz@infradead.org, dipankar@in.ibm.com, josh@freedesktop.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org
Subject: Re: [PATCH 1/4] cpuhog: implement cpuhog
References: <1268063603-7425-1-git-send-email-tj@kernel.org> <1268063603-7425-2-git-send-email-tj@kernel.org> <20100308190142.GA9149@redhat.com>
In-Reply-To: <20100308190142.GA9149@redhat.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 08 Mar 2010 23:15:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On 03/09/2010 04:01 AM, Oleg Nesterov wrote:
> On 03/09, Tejun Heo wrote:
>> +struct cpuhog_done {
>> +	atomic_t		nr_todo;	/* nr left to execute */
>> +	bool			executed;	/* actually executed? */
>> +	int			ret;		/* collected return value */
>> +	struct completion	completion;	/* fired if nr_todo reaches 0 */
>> +};
>> +
>> +static void cpuhog_signal_done(struct cpuhog_done *done, bool executed)
>> +{
>> +	if (done) {
>> +		if (executed)
>> +			done->executed = true;
>> +		if (atomic_dec_and_test(&done->nr_todo))
>> +			complete(&done->completion);
>> +	}
>> +}
> 
> So, ->executed becomes T if at least one cpuhog_thread() thread calls ->fn(),
> 
>> +int __hog_cpus(const struct cpumask *cpumask, cpuhog_fn_t fn, void *arg)
>> +{
>> ...
>> +
>> +	wait_for_completion(&done.completion);
>> +	return done.executed ? done.ret : -ENOENT;
>> +}
> 
> Is this really right?
> 
> I mean, perhaps it makes more sense if ->executed was set only if _all_
> CPUs from cpumask "ack" this call?
> 
> I guess, currently this doesn't matter, stop_machine() uses cpu_online_mask
> and we can't race with hotplug.

cpuhog itself doesn't care whether the cpus go on or offline and
ensuring cpus stay online is the caller's responsibility.  The return
value check is mostly added for hog_one_cpu() users which is much more
light weight than hog_cpus() and thus is much more likely to be used
w/o disabling cpu hotplugging.  For hog_cpus(), I wanted it not to
care about cpu onliness itself.  Requests will be executed for online
ones while ignored for others, so the only exceptional one is the case
where none gets executed.

Thanks.

-- 
tejun
