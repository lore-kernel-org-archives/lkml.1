Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbYBQUVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbYBQUVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 15:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYBQUVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 15:21:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:18962 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbYBQUVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 15:21:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=u866fvKgT6GEQf2ZaXs8eex87dBK4XRzkEF6/ZNhjJLVLwJOQ129WlZAY8bL+wnpeXlUsGdboyX+KPAh6dGCGJpN8Gy6GXgYsyAxQ8wNCVgs3Bvt2qLlI2YgfG/ywzzO+eGOWNLtO7vk3hw1e7sKIJLN82TUe6uMn7/nJLA44Nk=
Date: Sun, 17 Feb 2008 21:27:39 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Jarek Poplawski <jarkao2@o2.pl>, Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] workqueues: shrink cpu_populated_map when CPU dies
Message-ID: <20080217202739.GA2994@ami.dom.local>
References: <20080216172259.GA18524@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080216172259.GA18524@tv-sign.ru>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

This patch looks OK to me. But while reading this I got some doubts
in nearby places, so BTW 2 small questions:

1) ... workqueue_cpu_callback(...)
{
	...
        list_for_each_entry(wq, &workqueues, list) {
                cwq = per_cpu_ptr(wq->cpu_wq, cpu);

                switch (action) {
                case CPU_UP_PREPARE:
		...

It looks like not all CPU_ cases are served here: shouldn't
list_for_each_entry() be omitted for them?

2) ... __create_workqueue_key(...)
{
	...
        if (singlethread) {
		...
        } else {
                get_online_cpus();
                spin_lock(&workqueue_lock);
                list_add(&wq->list, &workqueues);

Shouldn't this list_add() be done after all these inits below?

                spin_unlock(&workqueue_lock);

                for_each_possible_cpu(cpu) {
                        cwq = init_cpu_workqueue(wq, cpu);
			...
                }
		...
Thanks,
Jarek P.
 

On Sat, Feb 16, 2008 at 08:22:59PM +0300, Oleg Nesterov wrote:
> When cpu_populated_map was introduced, it was supposed that cwq->thread can
> survive after CPU_DEAD, that is why we never shrink cpu_populated_map.
> 
> This is not very nice, we can safely remove the already dead CPU from the map.
> The only required change is that destroy_workqueue() must hold the hotplug lock
> until it destroys all cwq->thread's, to protect the cpu_populated_map. We could
> make the local copy of cpu mask and drop the lock, but sizeof(cpumask_t) may be
> very large.
> 
> Also, fix the comment near queue_work(). Unless _cpu_down() happens we do
> guarantee the cpu-affinity of the work_struct, and we have users which rely on
> this.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
