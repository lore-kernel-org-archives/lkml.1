Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbZIKODq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbZIKODq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 10:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZIKODq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 10:03:46 -0400
Received: from mail-yx0-f176.google.com ([209.85.210.176]:48083 "EHLO
	mail-yx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbZIKODp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 10:03:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KyIBOGVSClPFwU/iltF6zjCeiaNHBlLfwO4dto5i8U+daqBYygxf1PCOgD6XDHFROa
         9U/JKupMEkPllCJXG+tCSU18c4EPOTSZlqHgiHAEDe65MPgM3/PK5596LKHT7B2gvMd3
         E/sbfX1DvNmvwZRYbkhN/rRyXf/qYS564P65A=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0908241532470.9322@sister.anvils>
References: <alpine.LRH.2.00.0908241110420.21562@tundra.namei.org> 
	<Pine.LNX.4.64.0908241258070.27704@sister.anvils> <4A929BF5.2050105@gmail.com> 
	<Pine.LNX.4.64.0908241532470.9322@sister.anvils>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 11 Sep 2009 10:03:28 -0400
Message-ID: <8bd0f97a0909110703o4d496a45jddc0d7d6fd8674b4@mail.gmail.com>
Subject: Re: [PATCH] mm: fix hugetlb bug due to user_shm_unlock call
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stefan Huber <shuber2@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Meerwald <pmeerw@cosy.sbg.ac.at>,
       James Morris <jmorris@namei.org>, William Irwin <wli@movementarian.org>,
       Mel Gorman <mel@csn.ul.ie>, Ravikiran G Thirumalai <kiran@scalex86.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 11:30, Hugh Dickins wrote:
> --- 2.6.31-rc7/ipc/shm.c        2009-06-25 05:18:09.000000000 +0100
> +++ linux/ipc/shm.c     2009-08-24 16:06:30.000000000 +0100
> @@ -174,7 +174,7 @@ static void shm_destroy(struct ipc_names
>        shm_unlock(shp);
>        if (!is_file_hugepages(shp->shm_file))
>                shmem_lock(shp->shm_file, 0, shp->mlock_user);
> -       else
> +       else if (shp->mlock_user)
>                user_shm_unlock(shp->shm_file->f_path.dentry->d_inode->i_size,
>                                                shp->mlock_user);
>        fput (shp->shm_file);
> @@ -369,8 +369,8 @@ static int newseg(struct ipc_namespace *
>                /* hugetlb_file_setup applies strict accounting */
>                if (shmflg & SHM_NORESERVE)
>                        acctflag = VM_NORESERVE;
> -               file = hugetlb_file_setup(name, size, acctflag);
> -               shp->mlock_user = current_user();
> +               file = hugetlb_file_setup(name, size, acctflag,
> +                                                       &shp->mlock_user);
>        } else {
>                /*
>                 * Do not allow no accounting for OVERCOMMIT_NEVER, even
> @@ -410,6 +410,8 @@ static int newseg(struct ipc_namespace *
>        return error;
>
>  no_id:
> +       if (shp->mlock_user)    /* shmflg & SHM_HUGETLB case */
> +               user_shm_unlock(size, shp->mlock_user);
>        fput(file);
>  no_file:
>        security_shm_free(shp);

this breaks on no-mmu systems due to user_shm_unlock() being
mmu-specific.  normally gcc is smart enough to do dead code culling so
it hasnt caused problems, but not here.  hugetlb support is not
available on no-mmu systems, so the stubbed hugepage functions prevent
calls to user_shm_unlock() and such, but here gcc cant figure it out:

static int newseg(struct ipc_namespace *ns, struct ipc_params *params)
{
...
    shp->mlock_user = NULL;
...
    if (shmflg & SHM_HUGETLB) {
        /* hugetlb_file_setup applies strict accounting */
        if (shmflg & SHM_NORESERVE)
            acctflag = VM_NORESERVE;
        file = hugetlb_file_setup(name, size, acctflag,
                            &shp->mlock_user);
...
    id = ipc_addid(&shm_ids(ns), &shp->shm_perm, ns->shm_ctlmni);
    if (id < 0) {
        error = id;
        goto no_id;
    }
...
no_id:
    if (shp->mlock_user)    /* shmflg & SHM_HUGETLB case */
        user_shm_unlock(size, shp->mlock_user);
...

hugetlb_file_setup() expands to nothing and so mlock_user will never
come back from NULL, but gcc still emits a reference to
user_shm_unlock() in the error path.  perhaps the best thing here is
to just add an #ifdef ?
 no_id:
+#ifdef CONFIG_HUGETLB_PAGE
+    /* gcc isn't smart enough to see that mlock_user goes non-NULL
only by hugetlb */
    if (shp->mlock_user)    /* shmflg & SHM_HUGETLB case */
        user_shm_unlock(size, shp->mlock_user);
+#endif
-mike
