Return-Path: <linux-kernel-owner+w=401wt.eu-S1751878AbZIBLoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878AbZIBLoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 07:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751764AbZIBLoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 07:44:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbZIBLoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 07:44:10 -0400
Message-ID: <4A9E5A8B.4060804@redhat.com>
Date: Wed, 02 Sep 2009 14:44:11 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] keep guest wallclock in sync with host clock
References: <1251805848-17451-1-git-send-email-glommer@redhat.com> <1251805848-17451-2-git-send-email-glommer@redhat.com>
In-Reply-To: <1251805848-17451-2-git-send-email-glommer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2009 02:50 PM, Glauber Costa wrote:
> KVM clock is great to avoid drifting in guest VMs running ontop of kvm.
> However, the current mechanism will not propagate changes in wallclock value
> upwards. This effectively means that in a large pool of VMs that need accurate timing,
> all of them has to run NTP, instead of just the host doing it.
>
> Since the host updates information in the shared memory area upon msr writes,
> this patch introduces a worker that writes to that msr, and calls do_settimeofday
> at fixed intervals, with second resolution. A interval of 0 determines that we
> are not interested in this behaviour. A later patch will make this optional at
> runtime
>
> +
> +static void kvm_sync_wall_clock(struct work_struct *work)
> +{
> +	struct timespec now;
> +
> +	kvm_get_wall_ts(&now);
>    

What happens if we schedule here?

> +
> +	do_settimeofday(&now);
> +	schedule_next_update();
> +}
> +
> +static __init int init_updates(void)
> +{
> +	schedule_next_update();
> +	return 0;
> +}
> +/*
> + * It has to be run after workqueues are initialized, since we call
> + * schedule_delayed_work. Other than that, we have no specific requirements
> + */
> +late_initcall(init_updates);
>    

Should this run on bare metal too?

-- 
error compiling committee.c: too many arguments to function

