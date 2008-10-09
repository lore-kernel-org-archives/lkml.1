Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbYJIAVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbYJIAVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 20:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755718AbYJIAVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 20:21:31 -0400
Received: from ozlabs.org ([203.10.76.45]:43062 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370AbYJIAVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 20:21:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH/RFC 0/4] Add stop_machine_get/put_threads to stop_machine infrastructrue.
Date: Thu, 9 Oct 2008 11:18:27 +1100
User-Agent: KMail/1.9.9
Cc: jens.axboe@oracle.com, schwidefsky@de.ibm.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20081003105632.357231142@de.ibm.com> <200810081127.05311.rusty@rustcorp.com.au> <20081008101450.GA2954@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20081008101450.GA2954@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810091118.27464.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 08 October 2008 21:14:50 Heiko Carstens wrote:
> On Wed, Oct 08, 2008 at 10:27:04AM +1000, Rusty Russell wrote:
> > OK, idea #2.  Let's just always have a kstopmachine thread running on
> > every online cpu.  Is there a sane way to reuse the workqueue threads for
> > this?
>
> That's a very good idea and what the patch below does. It even simplifies
> the stop_machine code and it does work on an otherwise idle system.
> The only thing that needs to be addressed is that workqueue threads aka
> stop_machine threads are no real time threads now.
> We would need something like create_workqueue_prio() or
> create_workqueue_rt(). Would that be acceptable?

Hmm, I was hoping to reuse the kevent threads rather than create YA set
of threads.  But hey, everyone else is doing it.

> +static struct workqueue_struct *stop_machine_wq;
> +static struct work_struct *stop_machine_work;
> +static struct stop_machine_data active, idle;
> +static cpumask_t active_cpus;

Hmm, please make active cpus a const cpumask_t pointer.  I'm trying to
get rid of these kind of decls in another patch series :)

>  /* This is the actual thread which stops the CPU.  It exits by itself rather
>   * than waiting for kthread_stop(), because it's easier for hotplug CPU. */

This comment is no longer valid...

> +static int __init stop_machine_init(void)
> +{
> +	stop_machine_wq = create_workqueue("kstop");
> +	stop_machine_work = kcalloc(NR_CPUS, sizeof(struct work_struct),
> +				    GFP_KERNEL);

Perhaps make stop_machine_work a per-cpu array of struct work_struct
instead of initializing it here.  Or at least make it a percpu pointer and
only alloc possible cpus.

Does it break cpu hotplug BTW?  That's usually the problem.

But it looks nice!
Rusty.
