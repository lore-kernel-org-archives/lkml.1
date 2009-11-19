Return-Path: <linux-kernel-owner+w=401wt.eu-S1751386AbZKSOd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbZKSOd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 09:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751598AbZKSOd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 09:33:58 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:52255 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbZKSOd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 09:33:56 -0500
To: ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       john.johansen@canonical.com
Subject: Re: [PATCH 00/23] Removal of binary sysctl support
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <m1bpjch9hy.fsf@fess.ebiederm.org>
	<200911090012.nA90CF2i016994@www262.sakura.ne.jp>
	<m1zl6j65by.fsf@fess.ebiederm.org>
	<200911190704.CHI18293.VJOMHFtOLQSOFF@I-love.SAKURA.ne.jp>
	<m1k4xn8nba.fsf@fess.ebiederm.org>
In-Reply-To: <m1k4xn8nba.fsf@fess.ebiederm.org>
Message-Id: <200911192333.EHB57391.FSQOHOJtMFFLVO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Thu, 19 Nov 2009 23:33:59 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Eric W. Biederman wrote:
> Tetsuo Handa writes:
> 
> > Hello.
> >
> > Eric W. Biederman wrote:
> >> Tetsuo Handa writes:
> >> 
> >> > Eric W. Biederman wrote:
> >> >> There has been a gradual transition from the assumption that the table ends with
> >> >> !ctl_name to the assumption that procname == NULL.  There is no sysctl entry
> >> >> with a valid ctl_name without a valid procname.
> >> >
> >> > I see. Then, please add below one to your patchset.
> >> 
> >> I have been looking at this and in the sysctl tree I am now going through
> >> the vfs for all of the the operations on /proc/sys.  I believe that means
> >> we can completely remove the sysctl special case in tomoyo.  Like I have
> >> in the patch below.
> >> 
> >> Will that work?
> >> 
> >> Eric
> >
> > If you remove sysctl(2) from kernel and let userland libraries emulate
> >
> > 	static int name[] = { CTL_NET, NET_IPV4, NET_IPV4_LOCAL_PORT_RANGE };
> > 	int buffer[2] = { 0, 0 };
> > 	int size = sizeof(buffer);
> > 	sysctl(name, 3, buffer, &size, 0, 0);
> >
> > like
> >
> > 	FILE *fp = fopen("/proc/sys/net/ipv4/ip_local_port_range", "r");
> > 	int buffer[2] = { 0, 0 };
> > 	fscanf(fp, "%u %u", &buffer[0], &buffer[1]);
> > 	fclose(fp);
> >
> > or you modify sysctl(2) to call security_dentry_open() rather than
> > security_sysctl(), we can completely remove the sysctl special case in tomoyo.
> 
> I have done something very close, the emulation is in the kernel not
> user space, but the idea is the same.
> 
> The relevant bits of binary_sysctl() (from my sysctl tree) are:
> 	mnt = current->nsproxy->pid_ns->proc_mnt;
> 	result = vfs_path_lookup(mnt->mnt_root, mnt, pathname, 0, &nd);
> 	if (result)
> 		goto out_putname;
> 
> 	result = may_open(&nd.path, acc_mode, fmode);
> 	if (result)
> 		goto out_putpath;
> 
> 	file = dentry_open(nd.path.dentry, nd.path.mnt, flags, current_cred());
> 	result = PTR_ERR(file);
> 	if (IS_ERR(file))
> 		goto out_putname;
> 
>  dentry_open calls __dentry_open which calls security_dentry_open.
> 

I see. We can remove the sysctl special case in tomoyo.

> diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
> index 3f93bb9..8a00ade 100644
> --- a/security/tomoyo/tomoyo.c
> +++ b/security/tomoyo/tomoyo.c
> @@ -85,75 +85,6 @@ static int tomoyo_bprm_check_security(struct linux_binprm *bprm)
>  	return tomoyo_check_open_permission(domain, &bprm->file->f_path, 1);
>  }
>  
> -#ifdef CONFIG_SYSCTL
> -
> -static int tomoyo_prepend(char **buffer, int *buflen, const char *str)
> -{
> -	int namelen = strlen(str);
> -
> -	if (*buflen < namelen)
> -		return -ENOMEM;
> -	*buflen -= namelen;
> -	*buffer -= namelen;
> -	memcpy(*buffer, str, namelen);
> -	return 0;
> -}
> -
> -/**
> - * tomoyo_sysctl_path - return the realpath of a ctl_table.
> - * @table: pointer to "struct ctl_table".
> - *
> - * Returns realpath(3) of the @table on success.
> - * Returns NULL on failure.
> - *
> - * This function uses tomoyo_alloc(), so the caller must call tomoyo_free()
> - * if this function didn't return NULL.
> - */
> -static char *tomoyo_sysctl_path(struct ctl_table *table)
> -{
> -	int buflen = TOMOYO_MAX_PATHNAME_LEN;
> -	char *buf = tomoyo_alloc(buflen);
> -	char *end = buf + buflen;
> -	int error = -ENOMEM;
> -
> -	if (!buf)
> -		return NULL;
> -
> -	*--end = '\0';
> -	buflen--;
> -	while (table) {
> -		if (tomoyo_prepend(&end, &buflen, table->procname) ||
> -		    tomoyo_prepend(&end, &buflen, "/"))
> -			goto out;
> -		table = table->parent;
> -	}
> -	if (tomoyo_prepend(&end, &buflen, "/proc/sys"))
> -		goto out;
> -	error = tomoyo_encode(buf, end - buf, end);
> - out:
> -	if (!error)
> -		return buf;
> -	tomoyo_free(buf);
> -	return NULL;
> -}
> -
> -static int tomoyo_sysctl(struct ctl_table *table, int op)
> -{
> -	int error;
> -	char *name;
> -
> -	op &= MAY_READ | MAY_WRITE;
> -	if (!op)
> -		return 0;
> -	name = tomoyo_sysctl_path(table);
> -	if (!name)
> -		return -ENOMEM;
> -	error = tomoyo_check_file_perm(tomoyo_domain(), name, op);
> -	tomoyo_free(name);
> -	return error;
> -}
> -#endif
> -
>  static int tomoyo_path_truncate(struct path *path, loff_t length,
>  				unsigned int time_attrs)
>  {
> @@ -274,9 +205,6 @@ static struct security_operations tomoyo_security_ops = {
>  	.cred_transfer	     = tomoyo_cred_transfer,
>  	.bprm_set_creds      = tomoyo_bprm_set_creds,
>  	.bprm_check_security = tomoyo_bprm_check_security,
> -#ifdef CONFIG_SYSCTL
> -	.sysctl              = tomoyo_sysctl,
> -#endif
>  	.file_fcntl          = tomoyo_file_fcntl,
>  	.dentry_open         = tomoyo_dentry_open,
>  	.path_truncate       = tomoyo_path_truncate,
> 

Acked-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

But please wait a bit. We need to solve the twist below.

> The twist that may get this into trouble is that I am going through
> the internal vfs mount of /proc instead of the normal mount of proc.
> So you will see paths like "/sys/net/ipv4/ip_local_port_range" instead
> of "/proc/sys/net/ipv4/ip_local_port_range".  I don't know how the
> choice of mount points affects you.
> 
> Eric
> 

Indeed. TOMOYO and AppArmor need a hint for prepending "/proc" prefix.
A simple implementation which adds one bit to task_struct is shown below.
In this way, not only the file permission checks inside dentry_open()
but also the directory permission checks inside vfs_path_lookup() can be
prepended "/proc" prefix. AppArmor might want to prepend "/proc" inside
vfs_path_lookup().

Regards.
----------------------------------------
[PATCH 1/2] sysctl: Add in_sysctl flag to task_struct.

Pathname based access control prepends "/proc" prefix to the pathname obtained
by traversing ctl_table tree when binary sysctl is requested.

Now, binary sysctl code was rewritten to use internal vfs mount of /proc but
currently there is no hint which can give pathname based access control a
chance to prepend "/proc" prefix.

We want a hint which gives TOMOYO a chance to prepend "/proc" prefix.
There are two ways to implement this hint. One is to add 1 bit to task_struct
which remembers whether the current process is doing binary_sysctl() or not.
The other is to pass that bit to dentry_open(), security_dentry_open(),
tomoyo_dentry_open(), tomoyo_check_open_permission(), tomoyo_get_path(),
tomoyo_get_path() and tomoyo_realpath_from_path2().

This patch implements the former, for different LSM modules might want to

(a) prepend "/proc" prefix for checking directory permission inside
    vfs_path_lookup() 

or

(b) omit checking directory permission inside vfs_path_lookup()

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 include/linux/sched.h  |    2 ++
 kernel/sysctl_binary.c |    2 ++
 2 files changed, 4 insertions(+)

--- sysctl-2.6.orig/include/linux/sched.h
+++ sysctl-2.6/include/linux/sched.h
@@ -1279,6 +1279,8 @@ struct task_struct {
 	unsigned did_exec:1;
 	unsigned in_execve:1;	/* Tell the LSMs that the process is doing an
 				 * execve */
+	unsigned in_sysctl:1;	/* Tell the LSMs that the process is doing a
+				 * binary sysctl */
 	unsigned in_iowait:1;
 
 
--- sysctl-2.6.orig/kernel/sysctl_binary.c
+++ sysctl-2.6/kernel/sysctl_binary.c
@@ -1356,6 +1356,7 @@ static ssize_t binary_sysctl(const int *
 		goto out_putname;
 	}
 
+	current->in_sysctl = 1;
 	mnt = current->nsproxy->pid_ns->proc_mnt;
 	result = vfs_path_lookup(mnt->mnt_root, mnt, pathname, 0, &nd);
 	if (result)
@@ -1374,6 +1375,7 @@ static ssize_t binary_sysctl(const int *
 
 	fput(file);
 out_putname:
+	current->in_sysctl = 0;
 	putname(pathname);
 out:
 	return result;

----------------------------------------
[PATCH 1/2] TOMOYO: prepend /proc prefix for binary sysctl.

The pathname obtained by binary_sysctl() starts with "/sys".
This patch prepends "/proc" prefix if the pathname was obtained inside
binary_sysctl() so that TOMOYO checks a pathname which starts with "/proc/sys".

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/tomoyo/realpath.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- sysctl-2.6.orig/security/tomoyo/realpath.c
+++ sysctl-2.6/security/tomoyo/realpath.c
@@ -108,6 +108,14 @@ int tomoyo_realpath_from_path2(struct pa
 		spin_unlock(&dcache_lock);
 		path_put(&root);
 		path_put(&ns_root);
+		/* Prepend "/proc" prefix if binary_sysctl(). */
+		if (!IS_ERR(sp) && current->in_sysctl) {
+			sp -= 5;
+			if (sp >= newname)
+				memcpy(sp, "/proc", 5);
+			else
+				sp = ERR_PTR(-ENOMEM);
+		}
 	}
 	if (IS_ERR(sp))
 		error = PTR_ERR(sp);
