Return-Path: <linux-kernel-owner+w=401wt.eu-S932267AbZARJL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbZARJL1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 04:11:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760359AbZARJLA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 04:11:00 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55777 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758356AbZARJK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 04:10:58 -0500
Date: Sun, 18 Jan 2009 10:10:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, menage@google.com,
       miaox@cn.fujitsu.com, maxk@qualcomm.com, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/3] cgroup: convert open-coded
	mutex_lock(&cgroup_mutex) calls into cgroup_lock() calls
Message-ID: <20090118091038.GC27144@elte.hu>
References: <496FEFCA.9050908@cn.fujitsu.com> <4970000E.7040902@cn.fujitsu.com> <20090116125738.22c21bf2.akpm@linux-foundation.org> <4972E2FD.1010902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4972E2FD.1010902@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Convert open-coded mutex_lock(&cgroup_mutex) calls into cgroup_lock()
> calls and convert mutex_unlock(&cgroup_mutex) calls into cgroup_unlock()
> calls.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Max Krasnyansky <maxk@qualcomm.com>
> Cc: Miao Xie <miaox@cn.fujitsu.com>
> ---

(please include diffstat output in patches, so that the general source 
code impact can be seen at a glance.)

> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index c298310..75a352b 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -616,7 +688,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
>  		 * agent */
>  		synchronize_rcu();
>  
> -		mutex_lock(&cgroup_mutex);
> +		cgroup_lock();

this just changes over a clean mutex call to a wrapped lock/unlock 
sequence that has higher overhead in the common case.

We should do the exact opposite, we should change this opaque API:

 void cgroup_lock(void)
 {
         mutex_lock(&cgroup_mutex);
 }

To something more explicit (and more maintainable) like:

  cgroup_mutex_lock(&cgroup_mutex);
  cgroup_mutex_unlock(&cgroup_mutex);

Which is a NOP in the !CGROUPS case and maps to mutex_lock/unlock in the 
CGROUPS=y case.

	Ingo
