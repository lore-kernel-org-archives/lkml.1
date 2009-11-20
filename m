Return-Path: <linux-kernel-owner+w=401wt.eu-S1753058AbZKTFL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753058AbZKTFL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 00:11:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbZKTFL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 00:11:27 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45388 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751174AbZKTFL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 00:11:27 -0500
Date: Thu, 19 Nov 2009 21:09:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, avi@redhat.com,
       peterz@infradead.org, johannes@sipsolutions.net
Subject: Re: [PATCH 07/19] acpi: use queue_work_on() instead of binding
 workqueue worker to cpu0
Message-Id: <20091119210909.b112bc77.akpm@linux-foundation.org>
In-Reply-To: <1258692407-8985-8-git-send-email-tj@kernel.org>
References: <1258692407-8985-1-git-send-email-tj@kernel.org>
	<1258692407-8985-8-git-send-email-tj@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 13:46:35 +0900 Tejun Heo <tj@kernel.org> wrote:

> ACPI works need to be executed on cpu0 and acpi/osl.c achieves this by
> creating singlethread workqueue and then binding it to cpu0 from a
> work which is quite unorthodox.  Make it create regular workqueues and
> use queue_work_on() instead.  This is in preparation of concurrency
> managed workqueue and the extra workers won't be a problem after it's
> implemented.
> 
> ...
>
>  acpi_status acpi_os_initialize1(void)
>  {
> -	/*
> -	 * On some machines, a software-initiated SMI causes corruption unless
> -	 * the SMI runs on CPU 0.  An SMI can be initiated by any AML, but
> -	 * typically it's done in GPE-related methods that are run via
> -	 * workqueues, so we can avoid the known corruption cases by binding
> -	 * the workqueues to CPU 0.
> -	 */
> -	kacpid_wq = create_singlethread_workqueue("kacpid");
> -	bind_workqueue(kacpid_wq);
> -	kacpi_notify_wq = create_singlethread_workqueue("kacpi_notify");
> -	bind_workqueue(kacpi_notify_wq);
> -	kacpi_hotplug_wq = create_singlethread_workqueue("kacpi_hotplug");
> -	bind_workqueue(kacpi_hotplug_wq);
> +	kacpid_wq = create_workqueue("kacpid");
> +	kacpi_notify_wq = create_workqueue("kacpi_notify");
> +	kacpi_hotplug_wq = create_workqueue("kacpi_hotplug");

Well that sucks.  We create an additional ((num_possible_cpus()-1)*3)
kernel threads just because the previous code was "unorthodox"?

I guess that problem goes away with concurrency-managed workqueues. 
But please let's not merge this patch without also merging
concurrency-managed workqueues!
