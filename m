Return-Path: <linux-kernel-owner+w=401wt.eu-S1751983AbZIBMWE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbZIBMWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 08:22:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751923AbZIBMWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 08:22:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbZIBMWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 08:22:01 -0400
Date: Wed, 2 Sep 2009 09:21:44 -0300
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] keep guest wallclock in sync with host clock
Message-ID: <20090902122144.GL30340@mothafucka.localdomain>
References: <1251805848-17451-1-git-send-email-glommer@redhat.com> <1251805848-17451-2-git-send-email-glommer@redhat.com> <4A9E5A8B.4060804@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9E5A8B.4060804@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 02:44:11PM +0300, Avi Kivity wrote:
> On 09/01/2009 02:50 PM, Glauber Costa wrote:
>> KVM clock is great to avoid drifting in guest VMs running ontop of kvm.
>> However, the current mechanism will not propagate changes in wallclock value
>> upwards. This effectively means that in a large pool of VMs that need accurate timing,
>> all of them has to run NTP, instead of just the host doing it.
>>
>> Since the host updates information in the shared memory area upon msr writes,
>> this patch introduces a worker that writes to that msr, and calls do_settimeofday
>> at fixed intervals, with second resolution. A interval of 0 determines that we
>> are not interested in this behaviour. A later patch will make this optional at
>> runtime
>>
>> +
>> +static void kvm_sync_wall_clock(struct work_struct *work)
>> +{
>> +	struct timespec now;
>> +
>> +	kvm_get_wall_ts(&now);
>>    
>
> What happens if we schedule here?
hummm, I guess disabling preemption would be enough to make us safe here?

>
>> +
>> +	do_settimeofday(&now);
>> +	schedule_next_update();
>> +}
>> +
>> +static __init int init_updates(void)
>> +{
>> +	schedule_next_update();
>> +	return 0;
>> +}
>> +/*
>> + * It has to be run after workqueues are initialized, since we call
>> + * schedule_delayed_work. Other than that, we have no specific requirements
>> + */
>> +late_initcall(init_updates);
>>    
>
> Should this run on bare metal too?
>
> -- 
> error compiling committee.c: too many arguments to function
>
