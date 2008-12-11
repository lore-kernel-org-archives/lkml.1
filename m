Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbYLKCZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbYLKCZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 21:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755911AbYLKCZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 21:25:18 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64800 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754156AbYLKCZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 21:25:16 -0500
Message-ID: <494079AF.3040704@cn.fujitsu.com>
Date: Thu, 11 Dec 2008 10:23:43 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CGroups: Fix a race between rmdir and remount
References: <6599ad830812101533r6cb007eeu5ef19499e278f6b7@mail.gmail.com>
In-Reply-To: <6599ad830812101533r6cb007eeu5ef19499e278f6b7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Fix a race between rmdir and remount
> 
> When a cgroup is removed, it's unlinked from its parent's children
> list, but not actually freed until the last dentry on it is released
> (at which point cgrp->root->number_of_cgroups is decremented).
> 
> Currently rebind_subsystems checks for the top cgroup's child list
> being empty in order to rebind subsystems into or out of a hierarchy -
> this can result in the set of subsystems bound to a hierarchy being
> different than the set of subsystems with state in the
> removed-but-not-freed cgroup.
> 
> The simplest fix for this is to forbid remounts that change the set of
> subsystems on a hierarchy that has removed-but-not-freed cgroups.
> 
> This bug can be reproduced via:
> 

Seems this bug is revealed by my patch:

cgroups-remove-some-redundant-null-checks.patch
(http://marc.info/?l=linux-mm-commits&m=122730918427045&w=2)

@@ -611,10 +611,8 @@ static void cgroup_diput(struct dentry *
...
-		for_each_subsys(cgrp->root, ss) {
-			if (cgrp->subsys[ss->subsys_id])
-				ss->destroy(ss, cgrp);
-		}
+		for_each_subsys(cgrp->root, ss)
+			ss->destroy(ss, cgrp);

But this patch is not guilty. :)

The original code leaked memory silently due to this race, if the remount
removes some subsystems from the hierarchy.

> mkdir /mnt/cg
> mount -t cgroup -o ns,freezer cgroup /mnt/cg
> mkdir /mnt/cg/foo
> sleep 1h < /mnt/cg/foo &
> rmdir /mnt/cg/foo
> mount -t cgroup -o remount,ns,devices,freezer cgroup /mnt/cg
> kill $!
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> ---
>  kernel/cgroup.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: hierarchy_lock-mmotm-2008-12-09/kernel/cgroup.c
> ===================================================================
> --- hierarchy_lock-mmotm-2008-12-09.orig/kernel/cgroup.c
> +++ hierarchy_lock-mmotm-2008-12-09/kernel/cgroup.c
> @@ -702,7 +702,7 @@ static int rebind_subsystems(struct cgro
>  	 * any child cgroups exist. This is theoretically supportable
>  	 * but involves complex error handling, so it's being left until
>  	 * later */
> -	if (!list_empty(&cgrp->children))
> +	if (root->number_of_cgroups > 1)
>  		return -EBUSY;
> 
>  	/* Process each subsystem */

