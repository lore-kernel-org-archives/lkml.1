Return-Path: <linux-kernel-owner+w=401wt.eu-S1760400AbZAWKXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760400AbZAWKXy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 05:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZAWKXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 05:23:46 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41486 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbZAWKXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 05:23:45 -0500
Date: Fri, 23 Jan 2009 11:22:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Menage <menage@google.com>
Cc: akpm@linux-foundation.org, serue@us.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] cgroup: Fix root_count when mount fails due to busy
	subsystem
Message-ID: <20090123102253.GF15188@elte.hu>
References: <20090123004703.25103.29754.stgit@menage.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090123004703.25103.29754.stgit@menage.corp.google.com>
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


* Paul Menage <menage@google.com> wrote:

> cgroup: Fix root_count when mount fails due to busy subsystem
> 
> root_count was being incremented in cgroup_get_sb() after all error 
> checking was complete, but decremented in cgroup_kill_sb(), which can be 
> called on a superblock that we gave up on due to an error.  This patch 
> changes cgroup_kill_sb() to only decrement root_count if the root was 
> previously linked into the list of roots.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 
> ---
> 
> I was actually surprised to find that list_del() doesn't crash when
> run on an unattached list_head structure.
> 
>  kernel/cgroup.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index adcd0bb..9ce27e8 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1115,8 +1115,10 @@ static void cgroup_kill_sb(struct super_block *sb) {
>  	}
>  	write_unlock(&css_set_lock);
>  
> -	list_del(&root->root_list);
> -	root_count--;
> +	if (!list_empty(&root->root_list)) {
> +		list_del(&root->root_list);
> +		root_count--;
> +	}

That's ugly. It is _much_ cleaner to always keep the link head consistent 
- i.e. initialize it with INIT_LIST_HEAD() and then remove from it via 
list_del_init().

That way the error path will do the right thing automatically, and there's 
no need for that ugly "if !list_empty" construct either.

	Ingo
