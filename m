Return-Path: <linux-kernel-owner+w=401wt.eu-S1754232AbYE2IRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbYE2IRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 04:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbYE2IRF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 04:17:05 -0400
Received: from relay2.sgi.com ([192.48.171.30]:60828 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751384AbYE2IRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 04:17:02 -0400
Date: Thu, 29 May 2008 03:16:56 -0500
From: Paul Jackson <pj@sgi.com>
To: miaox@cn.fujitsu.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, menage@google.com
Subject: Re: [RFC] [PATCH 1/2] cpusets: restructure the function
 update_cpumask() and update_nodemask()
Message-Id: <20080529031656.cdc38001.pj@sgi.com>
In-Reply-To: <483E564A.5050807@cn.fujitsu.com>
References: <483E564A.5050807@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nice work.

As usual, I have a few minor items to note.

 1) No need to initialize 'retval = 0' since retval is set
    unconditionally in the next line of update_tasks_cpumask():

	+static int update_tasks_cpumask(struct cpuset *cs)
	+{
	+	struct cgroup_scanner scan;
	+	struct ptr_heap heap;
	+	int retval = 0;
	+
	+	retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, &started_after);

 2) Same thing in update_tasks_nodemask - no need to initialize
    retval = 0.
    
    These initializations use an extra instruction or two, so we
    avoid them, if it is really clear from the code that the
    variable is set before used anyway.
    

 3) The special style for documenting functions, starting with the
    "/**" comment, which is documented in:
        Documentation/kernel-doc-nano-HOWTO.txt
    results in adding that functions documentation to various man pages
    and documents that are generated from these comment blocks.
    Typically, we do not document file static routines this way,
    because such routines cannot be called from outside that file,
    so are of little use to others.  Best not to clutter the more
    widely distributed documentation with details of functions that
    others can't call anyway.

    So I would suggest -removing- the special commenting convention
    for the routines update_tasks_cpumask() and update_tasks_nodemask().
    
    For example, in the update_tasks_nodemask() case, this means
    changing from:

    > /**
    >  * update_tasks_nodemask - Scan tasks in cpuset cs, and update the nodemasks of
    >  * any that need an update.
    >  * @cs: the cpuset in which each task's mems_allowed mask needs to be changed
    >  * @oldmem: old mems_allowed of cpuset cs
    >  *
    >  * Called with cgroup_mutex held
    >  * Return 0 if successful, -errno if not.
    >  */
    > static int update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem)

    to:


    > /*
    >  * update_tasks_nodemask - Scan tasks in cpuset cs, and update the nodemasks of
    >  * any that need an update.
    >  *  cs: the cpuset in which each task's mems_allowed mask needs to be changed
    >  *  oldmem: old mems_allowed of cpuset cs
    >  *
    >  * Called with cgroup_mutex held
    >  * Return 0 if successful, -errno if not.
    >  */
    > static int update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem)


    Similarly for update_tasks_cpumask().

 4) Could you do me a little favor, and include the two minor fixes in
    the following patch in your patch?  These two fixes aren't worth
    making their own separate submission for.  I noticed them when I
    was running the scripts/kernel-doc tool to check the comments for
    my comment (3) above.  You can either just add the minor fixes to
    your patch 1 of 2, or you can make the following a third patch in
    your patch set, under your "Signed-off-by" line.  It does not matter
    at all to me which way you do it.  Take the easy way, which is
    probably just making these three minor changes as part of your
    first patch, just as if they were your code all the time.  Thanks!


====================== Begin Patch ======================
--- 2.6.26-rc2-mm1-pj_efi_patches.orig/kernel/cpuset.c	2008-05-29 00:20:35.000000000 -0700
+++ 2.6.26-rc2-mm1-pj_efi_patches/kernel/cpuset.c	2008-05-29 00:53:42.478128805 -0700
@@ -1938,7 +1938,6 @@ void __init cpuset_init_smp(void)
 }
 
 /**
-
  * cpuset_cpus_allowed - return cpus_allowed mask from a tasks cpuset.
  * @tsk: pointer to task_struct from which to obtain cpuset->cpus_allowed.
  * @pmask: pointer to cpumask_t variable to receive cpus_allowed set.
@@ -1956,10 +1955,10 @@ void cpuset_cpus_allowed(struct task_str
 	mutex_unlock(&callback_mutex);
 }
 
-/**
+/*
  * cpuset_cpus_allowed_locked - return cpus_allowed mask from a tasks cpuset.
  * Must be called with callback_mutex held.
- **/
+ */
 void cpuset_cpus_allowed_locked(struct task_struct *tsk, cpumask_t *pmask)
 {
 	task_lock(tsk);
======================= End Patch =======================


 5) You wrote:
	This patch fixes this bug expect for root cpuset.
    Then you analyze the root cpuset problem that remains.  I will try
    to think more about that perhaps tomorrow; that won't impede progress
    on this current patch set.



These patches look very good to me.  Please add my Acked-by line
in your next and I expect final version:

Acked-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
