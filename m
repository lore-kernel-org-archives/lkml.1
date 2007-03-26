Return-Path: <linux-kernel-owner+w=401wt.eu-S1751661AbXCZLnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751661AbXCZLnU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbXCZLnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:43:20 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60008 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbXCZLnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:43:19 -0400
Date: Mon, 26 Mar 2007 17:20:46 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Balbir Singh <balbir@in.ibm.com>
Cc: pj@sgi.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix race between attach_task and cpuset_exit
Message-ID: <20070326115046.GK11794@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070325164746.GI11794@in.ibm.com> <4606B6CF.6040306@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4606B6CF.6040306@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 11:22:15PM +0530, Balbir Singh wrote:
> >+	struct cpuset *oldcs_tobe_released = NULL;
> 
> How about oldcs_to_be_released?

Yes, I wanted to use that, but my typo I guess.

> >@@ -2242,19 +2241,20 @@ void cpuset_exit(struct task_struct *tsk
> > {
> > 	struct cpuset *cs;
> >
> >+	task_lock(tsk);
> > 	cs = tsk->cpuset;
> > 	tsk->cpuset = &top_cpuset;	/* the_top_cpuset_hack - see above */
> >+	atomic_dec(&cs->count);
> 
> How about using a local variable like ref_count and using
> 
> ref_count = atomic_dec_and_test(&cs->count); This will avoid the two
> atomic operations, atomic_dec() and atomic_read() below.

Well, someone may have attached to this cpuset while we were waiting on the 
mutex_lock(). So we need to do a atomic_read again to ensure it is still
unused. But I notice that check_for_release() has that
atomic_read-and-check-for-zero-refcount inbuilt into it, which means we can 
blindly call it. Modified patch in another mail.

-- 
Regards,
vatsa
