Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab0BOHZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 02:25:18 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:41750 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab0BOHZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 02:25:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v7dGsN7A7/cvw4YZz7+32Up20HtLWs2FJcbdp79/4pg1kysqH7X/QdKehij8gUKTHZ
         0n8u9otk8GvtkfMjQYdGV0WMZQQI5L95YaEy16BnDHfKIWYSao6G+B5aRJQQu+jjtFgo
         nh8HlODrEmCsXueg7tNbNZ3ZoppsRVG2S3WWU=
Date: Mon, 15 Feb 2010 15:27:45 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       "Tejun Heo <tj@kernel.org> Neil Brown" <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] sysfs: Only take active references on attributes.
Message-ID: <20100215072745.GC12076@hack.private>
References: <4B7217CF.2080702@kernel.org> <m1vde57c11.fsf@fess.ebiederm.org> <4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org> <20100210230544.GA678@suse.de> <m1ocjwwob1.fsf@fess.ebiederm.org> <4B73671E.2050105@kernel.org> <m1bpfvxt67.fsf_-_@fess.ebiederm.org> <m14olnxt3s.fsf_-_@fess.ebiederm.org> <m1ljezwean.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ljezwean.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 03:20:00PM -0800, Eric W. Biederman wrote:
>
>If we exclude directories and symlinks from the set of sysfs
>dirents where we need active references we are left with
>sysfs attributes (binary or not).
>
>- Tweak sysfs_deactivate to only do something on attributes
>- Move lockdep initialization into sysfs_file_add_mode to
>  limit it to just attributes.

Why?

If I read your patch correctly, s_active will be useless
for non-attributes sysfs entries? For sysfs dir, maybe,
since it can only be removed by sysfs_remove_dir(),
but not sure about sysfs symlinks...


>
>Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>---
> fs/sysfs/dir.c   |    5 ++++-
> fs/sysfs/file.c  |    1 +
> fs/sysfs/sysfs.h |    1 +
> 3 files changed, 6 insertions(+), 1 deletions(-)
>
>diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
>index 1bdc42f..481fdec 100644
>--- a/fs/sysfs/dir.c
>+++ b/fs/sysfs/dir.c
>@@ -156,6 +156,10 @@ static void sysfs_deactivate(struct sysfs_dirent *sd)
> 	int v;
> 
> 	BUG_ON(sd->s_sibling || !(sd->s_flags & SYSFS_FLAG_REMOVED));
>+
>+	if (!(sysfs_type(sd) & SYSFS_ACTIVE_REF))
>+		return;
>+
> 	sd->s_sibling = (void *)&wait;
> 
> 	rwsem_acquire(&sd->dep_map, 0, 0, _RET_IP_);
>@@ -315,7 +319,6 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
> 
> 	atomic_set(&sd->s_count, 1);
> 	atomic_set(&sd->s_active, 0);
>-	sysfs_dirent_init_lockdep(sd);
> 
> 	sd->s_name = name;
> 	sd->s_mode = mode;
>diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
>index 8d6bd65..8eaae5d 100644
>--- a/fs/sysfs/file.c
>+++ b/fs/sysfs/file.c
>@@ -509,6 +509,7 @@ int sysfs_add_file_mode(struct sysfs_dirent *dir_sd,
> 	if (!sd)
> 		return -ENOMEM;
> 	sd->s_attr.attr = (void *)attr;
>+	sysfs_dirent_init_lockdep(sd);
> 
> 	sysfs_addrm_start(&acxt, dir_sd);
> 	rc = sysfs_add_one(&acxt, sd);
>diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
>index bb7723c..7db6884 100644
>--- a/fs/sysfs/sysfs.h
>+++ b/fs/sysfs/sysfs.h
>@@ -79,6 +79,7 @@ struct sysfs_dirent {
> #define SYSFS_KOBJ_BIN_ATTR		0x0004
> #define SYSFS_KOBJ_LINK			0x0008
> #define SYSFS_COPY_NAME			(SYSFS_DIR | SYSFS_KOBJ_LINK)
>+#define SYSFS_ACTIVE_REF		(SYSFS_KOBJ_ATTR | SYSFS_KOBJ_BIN_ATTR)
> 
> #define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
> #define SYSFS_FLAG_REMOVED		0x0200
>-- 
>1.6.5.2.143.g8cc62
>

-- 
Live like a child, think like the god.
 
