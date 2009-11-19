Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbZKSRt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbZKSRt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbZKSRt2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:49:28 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:56569 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbZKSRt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:49:27 -0500
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       john.johansen@canonical.com
Subject: Re: [PATCH 00/23] Removal of binary sysctl support
References: <m1bpjch9hy.fsf@fess.ebiederm.org>
	<200911090012.nA90CF2i016994@www262.sakura.ne.jp>
	<m1zl6j65by.fsf@fess.ebiederm.org>
	<200911190704.CHI18293.VJOMHFtOLQSOFF@I-love.SAKURA.ne.jp>
	<m1k4xn8nba.fsf@fess.ebiederm.org>
	<200911192333.EHB57391.FSQOHOJtMFFLVO@I-love.SAKURA.ne.jp>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 19 Nov 2009 09:49:28 -0800
In-Reply-To: <200911192333.EHB57391.FSQOHOJtMFFLVO@I-love.SAKURA.ne.jp> (Tetsuo Handa's message of "Thu\, 19 Nov 2009 23\:33\:59 +0900")
Message-ID: <m1ocmy4d7b.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> writes:

> Acked-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>
> But please wait a bit. We need to solve the twist below.

Agreed.

> Indeed. TOMOYO and AppArmor need a hint for prepending "/proc" prefix.
> A simple implementation which adds one bit to task_struct is shown below.
> In this way, not only the file permission checks inside dentry_open()
> but also the directory permission checks inside vfs_path_lookup() can be
> prepended "/proc" prefix. AppArmor might want to prepend "/proc" inside
> vfs_path_lookup().

There don't appear to be any security hooks in vfs_path_lookup().
>
> Regards.
> ----------------------------------------
> [PATCH 1/2] sysctl: Add in_sysctl flag to task_struct.
>
> Pathname based access control prepends "/proc" prefix to the pathname obtained
> by traversing ctl_table tree when binary sysctl is requested.
>
> Now, binary sysctl code was rewritten to use internal vfs mount of /proc but
> currently there is no hint which can give pathname based access control a
> chance to prepend "/proc" prefix.

Actually there is.

> [PATCH 1/2] TOMOYO: prepend /proc prefix for binary sysctl.
>
> The pathname obtained by binary_sysctl() starts with "/sys".
> This patch prepends "/proc" prefix if the pathname was obtained inside
> binary_sysctl() so that TOMOYO checks a pathname which starts with "/proc/sys".
>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> ---
>  security/tomoyo/realpath.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
>
> --- sysctl-2.6.orig/security/tomoyo/realpath.c
> +++ sysctl-2.6/security/tomoyo/realpath.c
> @@ -108,6 +108,14 @@ int tomoyo_realpath_from_path2(struct pa
>  		spin_unlock(&dcache_lock);
>  		path_put(&root);
>  		path_put(&ns_root);
> +		/* Prepend "/proc" prefix if binary_sysctl(). */
> +		if (!IS_ERR(sp) && current->in_sysctl) {
> +			sp -= 5;
> +			if (sp >= newname)
> +				memcpy(sp, "/proc", 5);
> +			else
> +				sp = ERR_PTR(-ENOMEM);
> +		}
>  	}
>  	if (IS_ERR(sp))
>  		error = PTR_ERR(sp);

Instead of current->in_sysctl we can just look at the path and see if
it is the root of the mount chain and if the fs is proc.

Something like:

diff --git a/security/tomoyo/realpath.c b/security/tomoyo/realpath.c
index 5f2e332..0b55faa 100644
--- a/security/tomoyo/realpath.c
+++ b/security/tomoyo/realpath.c
@@ -108,6 +108,15 @@ int tomoyo_realpath_from_path2(struct path *path, char *newname,
 		spin_unlock(&dcache_lock);
 		path_put(&root);
 		path_put(&ns_root);
+		/* Prepend "/proc" prefix if using internal proc vfs mount. */
+		if (!IS_ERR(sp) && (path->mnt->mnt_parent == path->mnt) &&
+		    (strcmp(path->mnt->mnt_sb->s_type->name, "proc") == 0)) {
+			sp -= 5;
+			if (sp >= newname)
+				memcpy(sp, "/proc", 5);
+			else
+				sp = ERR_PTR(-ENOMEM);
+		}
 	}
 	if (IS_ERR(sp))
 		error = PTR_ERR(sp);

Eric
