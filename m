Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbYDNOsQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbYDNOsQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 10:48:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYDNOsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 10:48:01 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:38711 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbYDNOsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 10:48:00 -0400
Date: Mon, 14 Apr 2008 20:18:01 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-rc9 -- INFO: possible circular locking dependency
	detected
Message-ID: <20080414144801.GC20671@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <a44ae5cd0804132004v2bef54fek6e9634f8bce087ab@mail.gmail.com> <1208156045.7427.16.camel@twins> <1208174767.7427.60.camel@twins> <20080414122741.GB7416@in.ibm.com> <1208176947.7427.68.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208176947.7427.68.camel@twins>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 02:42:27PM +0200, Peter Zijlstra wrote:
> 
>  void __init cpu_hotplug_init(void)
>  {
> +#ifdef CONFIG_DEBUG_LOCK_ALLOC
> +	static struct lockdep_class_key __key;
		      ^^^^^^^^^^^^^^^^^
		      should be lock_class_key.

> +
> +	lockdep_init_map(&cpu_hotplug.dep_map, "cpu_hotplug", &__key, 0);
> +#endif
>  	cpu_hotplug.active_writer = NULL;
>  	spin_lock_init(&cpu_hotplug.lock);
>  	cpu_hotplug.refcount = 0;
> @@ -54,6 +62,8 @@ void get_online_cpus(void)
>  {
>  	might_sleep();
> 
> +	cpu_hotplug_acquire_read(&cpu_hotplug.dep_map, 0, 0, _THIS_IP_);
> +
>  	spin_lock(&cpu_hotplug.lock);
>  	if (cpu_hotplug.active_writer == current)
>  		goto unlock;
> @@ -80,6 +90,8 @@ EXPORT_SYMBOL_GPL(get_online_cpus);
> 
>  void put_online_cpus(void)
>  {
> +	cpu_hotplug_release(&cpu_hotplug.lock, 1, _THIS_IP_);
> +
>  	spin_lock(&cpu_hotplug.lock);
>  	if (cpu_hotplug.active_writer == current)
>  		goto unlock;
> @@ -119,6 +131,8 @@ static void cpu_hotplug_begin(void)
>  {
>  	might_sleep();
> 
> +	cpu_hotplug_acquire(&cpu_hotplug.dep_map, 0, 0, _THIS_IP_);
> +
>  	spin_lock(&cpu_hotplug.lock);
>  	if (cpu_hotplug.refcount || cpu_hotplug.active_writer) {
>  		DEFINE_WAIT(wait);
> @@ -140,6 +154,8 @@ static void cpu_hotplug_begin(void)
> 
>  static void cpu_hotplug_done(void)
>  {
> +	cpu_hotplug_release(&cpu_hotplug.lock, 1, _THIS_IP_);
> +
>  	spin_lock(&cpu_hotplug.lock);
>  	cpu_hotplug.active_writer = NULL;
>  	if (!list_empty(&cpu_hotplug.writer_queue.task_list))
> 

-- 
Thanks and Regards
gautham
