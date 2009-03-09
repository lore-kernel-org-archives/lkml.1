Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZCIWho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZCIWho (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 18:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753643AbZCIWh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 18:37:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753380AbZCIWh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 18:37:26 -0400
Date: Mon, 9 Mar 2009 15:36:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-aio@kvack.org, zach.brown@oracle.com, bcrl@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] aio: remove aio-max-nr and instead use the memlock
 rlimit to limit the number of pages pinned for the aio completion ring
Message-Id: <20090309153630.912d36a0.akpm@linux-foundation.org>
In-Reply-To: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 09 Mar 2009 11:49:57 -0400
Jeff Moyer <jmoyer@redhat.com> wrote:

> Hi,
> 
> Believe it or not, I get numerous questions from customers about the
> suggested tuning value of aio-max-nr.  aio-max-nr limits the total
> number of io events that can be reserved, system wide, for aio
> completions.  Each time io_setup is called, a ring buffer is allocated
> that can hold nr_events I/O completions.  That ring buffer is then
> mapped into the process' address space, and the pages are pinned in
> memory.  So, the reason for this upper limit (I believe) is to keep a
> malicious user from pinning all of kernel memory.  Now, this sounds like
> a much better job for the memlock rlimit to me, hence the following
> patch.
> 
> It's worth noting that, by default, aio-max-nr was set to 65536
> requests.  By default, the memlock rlimit is set to 64kb per process.
> With this patch in place, a single process can specify 2045 for the
> nr_events parameter of io_setup.  Or, for the worst case scenario, a
> process can only create 16 io contexts, each with a single event (since
> the minimum ring size is a page).
> 
> I created a simple program that sets the process' memlock rlimit and
> then drops the CAP_IPC_LOCK capability (the memlock rlimit is a command
> line parameter, so you can see how the nr_events allowable changes with
> different limits in place).  Then, it calls io_setup/io_destroy in a
> loop, increasing nr_events until it fails.  Finally, it calls io_setup
> in a loop with a single event to see how many iterations it can perform
> before receiving -EAGAIN.  I ran the test on a patched kernel and the
> results are in line with expectations.
> 
> I also ran the aio-dio-regress regression tests, and all passed but
> one.  The one that failed only failed due to an expected return code of
> -ENOMEM, and instead got -EAGAIN.  Part of the patch below returns a
> proper error code from aio_setup_ring.  So, I'm calling this a test
> issue, but we can debate this nuance if it is deemed important.
> 
> Further, as a result of this exercise, I noticed that there are numerous
> places in the kernel that test to see if locking memory will exceed the
> maximum amount of allowed locked memory.  I've factored out that bit of
> code in a follow-on patch that I will post.
> 
> Finally, I updated the aio man pages to reflect this change (and fix
> references to aio_context_t that should be io_context_t).
> 
> You can find a copy of the test program I used at:
>   http://people.redhat.com/jmoyer/aio/ioctx_alloc.c
> I'll apologize in advance for the crudity of the test code.
> 
> For those reviewing the below patch, it may be worth looking at:
> 
> commit d55b5fdaf40846221d543937b786956e27837fda
> Author: Zach Brown <zach.brown@oracle.com>
> Date:   Mon Nov 7 00:59:31 2005 -0800
> 
>     [PATCH] aio: remove aio_max_nr accounting race
> 
> The below patch basically reverts the above commit.  There is no
> accounting race now, because we are charging per-process rlimits instead
> of a system-wide maximum number of aio requests.  This has the added
> benefit of reducing some code complexity.

It's risky to simply remove an existing tunable.  What if someone's
mission-critical startup script which is provided by a super-slow or
even no-longer-in-business vendor does 

	if (write(aoi-max-nr, something) == error)
		crash_and_burn()

?

It would be prudent to have a more cautious update scheme.  Leave the
existing tunable in place.  Keep it working if possible.  If someone
uses it, blurt out a loud printk telling them that they're using a
deprecated interface and informing them how to update.

Then at some later time we can remove the old interface.

>  /*------ sysctl variables----*/
> -static DEFINE_SPINLOCK(aio_nr_lock);
> -unsigned long aio_nr;		/* current system wide number of aio requests */
> -unsigned long aio_max_nr = 0x10000; /* system wide maximum number of aio requests */
> +/* current system wide number of aio requests */
> +atomic_t aio_nr = ATOMIC_INIT(0);

Was it a conscious decision to downgrade this from a `long' type to an
`int' type?  It _could_ have used atomic_long_t.


