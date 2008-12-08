Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbYLHVPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbYLHVPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 16:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYLHVP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 16:15:26 -0500
Received: from tundra.namei.org ([65.99.196.166]:4886 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbYLHVPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 16:15:25 -0500
Date: Tue, 9 Dec 2008 08:15:03 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
cc: lkml <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       David Howells <dhowells@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] user namespaces: let user_ns be cloned with
 fairsched
In-Reply-To: <20081208160429.GA18268@us.ibm.com>
Message-ID: <alpine.LRH.1.10.0812090814360.6220@tundra.namei.org>
References: <20081203191706.GA16433@us.ibm.com> <alpine.LRH.1.10.0812080946360.23851@tundra.namei.org> <20081208160429.GA18268@us.ibm.com>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Dec 2008, Serge E. Hallyn wrote:

> > Applied to 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
> 
> Thanks, James.  I talked about patch 1 with Dhaval, and while he's ok
> with the patch he (rightfully) thought there should be some extra
> documentation.  If it's not too much trouble would you mind swapping
> out patch 1 for the following?  (Otherwise I can send a new patch on
> top of the original)

It was applied to a public tree, so an update patch is needed.

> 
> thanks,
> -serge
> 
> >From 047b66fff5e014ac0eb995b8a60ff396abe2e8b2 Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Mon, 8 Dec 2008 07:24:33 -0800
> Subject: [PATCH 1/1] user namespaces: let user_ns be cloned with fairsched
> 
> fairsched creates a per-uid directory under /sys/kernel/uids/.
> So when you clone(CLONE_NEWUSER), it tries to create
> /sys/kernel/uids/0, which already exists, and you get back
> -ENOMEM.
> 
> This was supposed to be fixed by sysfs tagging, but that
> was postponed (ok, rejected until sysfs locking is fixed).
> So, just as with network namespaces, we just don't create
> those directories for user namespaces other than the init.
> 
> Changelog:
> 	Dec 8 2008: Documented the currently bogus state of
> 	 support for user groups with user namespaces.  In
> 	 particular, all users in a user namespace should be
> 	 children of the user which created the user namespace.
> 	 This is yet to be unimplemented.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> ---
>  Documentation/scheduler/sched-design-CFS.txt |   21 +++++++++++++++++++++
>  kernel/user.c                                |   12 +++++++++++-
>  2 files changed, 32 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/scheduler/sched-design-CFS.txt b/Documentation/scheduler/sched-design-CFS.txt
> index eb471c7..8398ca4 100644
> --- a/Documentation/scheduler/sched-design-CFS.txt
> +++ b/Documentation/scheduler/sched-design-CFS.txt
> @@ -273,3 +273,24 @@ task groups and modify their CPU share using the "cgroups" pseudo filesystem.
>  
>  	# #Launch gmplayer (or your favourite movie player)
>  	# echo <movie_player_pid> > multimedia/tasks
> +
> +8. Implementation note: user namespaces
> +
> +User namespaces are intended to be hierarchical.  But they are currently
> +only partially implemented.  Each of those has ramifications for CFS.
> +
> +First, since user namespaces are hierarchical, the /sys/kernel/uids
> +presentation is inadequate.  Eventually we will likely want to use sysfs
> +tagging to provide private views of /sys/kernel/uids within each user
> +namespace.
> +
> +Second, the hierarchical nature is intended to support completely
> +unprivileged use of user namespaces.  So if using user groups, then
> +we want the users in a user namespace to be children of the user
> +who created it.
> +
> +That is currently unimplemented.  So instead, every user in a new
> +user namespace will receive 1024 shares just like any user in the
> +initial user namespace.  Note that at the moment creation of a new
> +user namespace requires each of CAP_SYS_ADMIN, CAP_SETUID, and
> +CAP_SETGID.
> diff --git a/kernel/user.c b/kernel/user.c
> index 97202cb..6608a3d 100644
> --- a/kernel/user.c
> +++ b/kernel/user.c
> @@ -239,13 +239,21 @@ static struct kobj_type uids_ktype = {
>  	.release = uids_release,
>  };
>  
> -/* create /sys/kernel/uids/<uid>/cpu_share file for this user */
> +/*
> + * Create /sys/kernel/uids/<uid>/cpu_share file for this user
> + * We do not create this file for users in a user namespace (until
> + * sysfs tagging is implemented).
> + *
> + * See Documentation/scheduler/sched-design-CFS.txt for ramifications.
> + */
>  static int uids_user_create(struct user_struct *up)
>  {
>  	struct kobject *kobj = &up->kobj;
>  	int error;
>  
>  	memset(kobj, 0, sizeof(struct kobject));
> +	if (up->user_ns != &init_user_ns)
> +		return 0;
>  	kobj->kset = uids_kset;
>  	error = kobject_init_and_add(kobj, &uids_ktype, NULL, "%d", up->uid);
>  	if (error) {
> @@ -281,6 +289,8 @@ static void remove_user_sysfs_dir(struct work_struct *w)
>  	unsigned long flags;
>  	int remove_user = 0;
>  
> +	if (up->user_ns != &init_user_ns)
> +		return;
>  	/* Make uid_hash_remove() + sysfs_remove_file() + kobject_del()
>  	 * atomic.
>  	 */
> -- 
> 1.5.4.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris@namei.org>
