Return-Path: <linux-kernel-owner+w=401wt.eu-S1751485AbZKEFKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbZKEFKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 00:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbZKEFKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 00:10:45 -0500
Received: from adelie.canonical.com ([91.189.90.139]:59248 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbZKEFKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 00:10:43 -0500
Message-ID: <4AF25E51.1010609@canonical.com>
Date: Wed, 04 Nov 2009 21:10:41 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch 0/12] AppArmor security module
References: <1257292099-15802-1-git-send-email-john.johansen@canonical.com> <200911040441.nA44fxms062617@www262.sakura.ne.jp>
In-Reply-To: <200911040441.nA44fxms062617@www262.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Hello.
> 
> Some random topics I noticed. I need to use lxr for further review.
> 
> John Johansen wrote:
> [01/12]
> +static int d_namespace_path(struct path *path, char *buf, int buflen,
> +                           char **name, int flags)
> +{
> +       struct path root, tmp, ns_root = { };
> +       char *res;
> +       int error = 0;
> +
> +       read_lock(&current->fs->lock);
> +       root = current->fs->root;
> +       path_get(&current->fs->root);
> +       read_unlock(&current->fs->lock);
> +       spin_lock(&vfsmount_lock);
> +       if (root.mnt && root.mnt->mnt_ns)
> +               ns_root.mnt = mntget(root.mnt->mnt_ns->root);
> +       if (ns_root.mnt)
> +               ns_root.dentry = dget(ns_root.mnt->mnt_root);
> +       spin_unlock(&vfsmount_lock);
> +       spin_lock(&dcache_lock);
> +       tmp = ns_root;
> +       res = __d_path(path, &tmp, buf, buflen);
> +
> +       *name = res;
> +       /* handle error conditions - and still allow a partial path to
> +        * be returned.
> +        */
> +       if (IS_ERR(res)) {
> +               error = PTR_ERR(res);
> +               *name = buf;
> +       } else if (d_unlinked(path->dentry)) {
> +               /* The stripping of (deleted) is a hack that could be removed
> +                * with an updated __d_path
> +                */
> +
> 
> Yes, we know. But .... isn't there a race window that the file is unlink()ed
> between __d_path() and d_unlinked(path->dentry) ? Holding dcache_lock prevents
> this race?
> 
bleah, no not in general.  For the creation case (it was showing up in mknod on
nfs) I think it is okay but I need to go back and double check that.  The other
case however needs fixed as we currently can't avoid mediating deleted paths in
some cases.  In general I would like to work towards eliminating this case.

> 
> 
> [02/12]
> +static int aa_audit_base(int type, struct aa_profile *profile,
> +			 struct aa_audit *sa, struct audit_context *audit_cxt,
> +			 void (*cb) (struct audit_buffer *, void *))
> +{
> +	struct audit_buffer *ab = NULL;
> 
> You can add
> 
> 	struct task_struct *task = sa->task ? sa->task : current;
> 
> and replace subsequent "sa->task ? ... : ...".
> 
yep, that is a nice little cleanup


> +
> +	if (profile && PROFILE_KILL(profile) && type == AUDIT_APPARMOR_DENIED)
> +		type = AUDIT_APPARMOR_KILL;
> +
> +	ab = audit_log_start(audit_cxt, sa->gfp_mask, type);
> +
> +	if (!ab) {
> +		AA_ERROR("(%d) Unable to log event of type (%d)\n",
> +			 -ENOMEM, type);
> 
> Don't you want
> 
> 	if (type == AUDIT_APPARMOR_KILL)
> 		(void)send_sig_info(SIGKILL, NULL,
> 				sa->task ? sa->task : current);
> 
> so that process is killed when audit_log_start() failed?
> 
yep another good catch


> +	audit_log_format(ab, " pid=%d",
> +			 sa->task ? sa->task->pid : current->pid);
> +
> +	if (profile) {
> +		pid_t pid = sa->task ? sa->task->real_parent->pid :
> +				       current->real_parent->pid;
> +		audit_log_format(ab, " parent=%d", pid);
> +		audit_log_format(ab, " profile=");
> +		audit_log_untrustedstring(ab, profile->fqname);
> +
> +		if (profile->ns != default_namespace) {
> +			audit_log_format(ab, " namespace=");
> +			audit_log_untrustedstring(ab, profile->ns->base.name);
> +		}
> +	}
> +
> +	if (cb)
> +		cb(ab, sa);
> +
> +	audit_log_end(ab);
> 
> Not checking -ENOMEM failures for audit_log_format() etc. might cause
> partial audit logs. Is it OK?
>
That would be dependent on the situation, currently we have been tolerant
of partial logs, but the plan has been to add flags to specify if audit
failures should be tolerated or not.

So this definitely needs updated.

> 
> [03/12]
> +static inline void aa_free_file_context(struct aa_file_cxt *cxt)
> +{
> +       aa_put_profile(cxt->profile);
> +       memset(cxt, 0, sizeof(struct aa_file_cxt));
> +       kfree(cxt);
> +}
> 
> Why not kzfree(cxt); instead of memset() + kfree() ?
> 
I missed it somehow, must have been temporary blindness ;)

> 
> [04/12]
> +void aa_free_default_namespace(void)
> +{
> +       write_lock(&ns_list_lock);
> +       list_del_init(&default_namespace->base.list);
> +       aa_put_namespace(default_namespace);
> +       write_unlock(&ns_list_lock);
> +       aa_put_namespace(default_namespace);
> +       default_namespace = NULL;
> +}
> 
> Any reason to call aa_put_namespace(default_namespace); with a lock and
> without a lock?
> 
> 
hehe, no.  That does look confusing doesn't it, basically the list holds a
reference and the variable holds a reference.  The put inside the locks
was dropping the list ref, I think I actually had that in a macro at one point.

the put_namespace can certainly be pulled out of the lock

> 
> [06/12]
> +static int unpack_dynstring(struct aa_ext *e, char **string, const char *name)
> +{
> +       char *tmp;
> +       void *pos = e->pos;
> +       int res = unpack_string(e, &tmp, name);
> +       *string = NULL;
> +
> +       if (!res)
> +               return res;
> 
> 	return 0; ?
>
smae thing but yeah that would be better


> +static int aa_unpack_trans_table(struct aa_ext *e, struct aa_profile *profile)
> +{
> +       void *pos = e->pos;
> +
> +       /* exec table is optional */
> +       if (unpack_nameX(e, AA_STRUCT, "xtable")) {
> +               int i, size;
> +
> +               size = unpack_array(e, NULL);
> +               /* currently 4 exec bits and entries 0-3 are reserved iupcx */
> +               if (size > 16 - 4)
> +                       goto fail;
> +               profile->file.trans.table = kzalloc(sizeof(char *) * size,
> +                                                   GFP_KERNEL);
> +               if (!profile->file.trans.table)
> +                       goto fail;
> +
> 
> 		profile->file.trans.size = size;
> 
> +               for (i = 0; i < size; i++) {
> +                       char *tmp;
> +                       if (!unpack_dynstring(e, &tmp, NULL))
> +                               goto fail;
> +                       /*
> +                        * note: strings beginning with a : have an embedded
> +                        * \0 seperating the profile ns name from the profile
> +                        * name
> +                        */
> +                       profile->file.trans.table[i] = tmp;
> +               }
> +               if (!unpack_nameX(e, AA_ARRAYEND, NULL))
> +                       goto fail;
> +               if (!unpack_nameX(e, AA_STRUCTEND, NULL))
> +                       goto fail;
> +               profile->file.trans.size = size;
> 
> This assignment is too late to pass the size to aa_free_domain_entries().
> 
yikes, yep thanks for catching that.

> 
> +ssize_t aa_interface_add_profiles(void *data, size_t size)
> +{
> +       struct aa_profile *profile;
> +       struct aa_namespace *ns = NULL;
> +       struct aa_policy_common *common;
> +       struct aa_ext e = {
> +               .start = data,
> +               .end = data + size,
> +               .pos = data,
> +               .ns_name = NULL
> +       };
> +       ssize_t error;
> +       struct aa_audit_iface sa;
> +       aa_audit_init(&sa, "profile_load", &e);
> +
> +       error = aa_verify_header(&e, &sa);
> +       if (error)
> +               return error;
> +
> +       profile = aa_unpack_profile(&e, &sa);
> +       if (IS_ERR(profile))
> +               return PTR_ERR(profile);
> +
> +       sa.name2 = e.ns_name;
> +       ns = aa_prepare_namespace(e.ns_name);
> +       if (IS_ERR(ns)) {
> +               sa.base.info = "failed to prepare namespace";
> +               sa.base.error = PTR_ERR(ns);
> +               goto fail;
> +       }
> +       /* profiles are currently loaded flat with fqnames */
> +       sa.name = profile->fqname;
> +
> +       write_lock(&ns->base.lock);
> +
> +       common = __aa_find_parent_by_fqname(ns, sa.name);
> +       if (!common) {
> +               sa.base.info = "parent does not exist";
> +               sa.base.error = -ENOENT;
> +               goto fail2;
> +       }
> +
> +       if (common != &ns->base)
> +               profile->parent = aa_get_profile((struct aa_profile *)common);
> +
> +       if (__aa_find_profile(&common->profiles, profile->base.name)) {
> +               /* A profile with this name exists already. */
> +               sa.base.info = "profile already exists";
> +               sa.base.error = -EEXIST;
> 
> Don't you need to call aa_put_profile(common) if common != &ns->base ?
> 
no,
__aa_find_parent_by_fqname doesn't increment the ref count so
the reference for common is actually held by profile->parent.  When
the profile is put it will put the reference to common.

However not taking a reference on common could be considered playing fast and
lose with the ref count.

> 
> [07/12]
> +static struct aa_profile *next_profile(struct aa_profile *profile)
> +{
> +       struct aa_profile *parent;
> +       struct aa_namespace *ns = profile->ns;
> +
> +       if (!list_empty(&profile->base.profiles))
> +               return list_first_entry(&profile->base.profiles,
> +                                       struct aa_profile, base.list);
> +
> +       parent = profile->parent;
> +       while (parent) {
> +               list_for_each_entry_continue(profile, &parent->base.profiles,
> +                                            base.list)
> +                       return profile;
> +               profile = parent;
> +               parent = parent->parent;
> +       }
> +
> +       list_for_each_entry_continue(profile, &ns->base.profiles, base.list)
> +               return profile;
> +
> +       read_unlock(&ns->base.lock);
> +       list_for_each_entry_continue(ns, &ns_list, base.list) {
> +               read_lock(&ns->base.lock);
> +               return list_first_entry(&ns->base.profiles, struct aa_profile,
> +                                       base.list);
> +               read_unlock(&ns->base.lock);
> 
> This read_unlock() unreachable?
> 
yep so it is, will drop it.


> +       }
> +       return NULL;
> +}
> 
> +int aa_getprocattr(struct aa_namespace *ns, struct aa_profile *profile,
> +                  char **string)
> +{
> +       char *str;
> +       int len = 0;
> +
> +       if (profile) {
> +               int mode_len, name_len, ns_len = 0;
> +               const char *mode_str = profile_mode_names[profile->mode];
> +               char *s;
> +
> +               mode_len = strlen(mode_str) + 3;        /* _(mode_str)\n */
> +               name_len = strlen(profile->fqname);
> +               if (ns != default_namespace)
> +                       ns_len = strlen(ns->base.name) + 3;
> +               len = mode_len + ns_len + name_len + 1;
> +               s = str = kmalloc(len + 1, GFP_ATOMIC);
> +               if (!str)
> +                       return -ENOMEM;
> +
> +               if (ns_len) {
> +                       sprintf(s, "%s://", ns->base.name);
> +                       s += ns_len;
> +               }
> +               memcpy(s, profile->fqname, name_len);
> +               s += name_len;
> +               sprintf(s, " (%s)\n", mode_str);
> +       } else {
> +               const char unconfined_str[] = "unconfined\n";
> +
> +               len = sizeof(unconfined_str) - 1;
> +               if (ns != default_namespace)
> +                       len += strlen(ns->base.name) + 3;
> +
> +               str = kmalloc(len + 1, GFP_ATOMIC);
> +               if (!str)
> +                       return -ENOMEM;
> +
> +               if (ns != default_namespace)
> +                       sprintf(str, "%s://%s", ns->base.name, unconfined_str);
> +               else
> +                       memcpy(str, unconfined_str, len);
> 
> You need to copy one more byte to make str \0-terminated.
> 
interesting, looking back through some log not null terminating it was
actually deliberate, as it is treating the value as file contents not a
string.  But it is not what we are doing above any more, thanks for point it
out.


> [10/12]
> +static int aa_may_change_ptraced_domain(struct task_struct *task,
> +                                       struct aa_profile *to_profile)
> +{
> +       struct task_struct *tracer;
> +       struct cred *cred = NULL;
> +       struct aa_profile *tracerp = NULL;
> +       int error = 0;
> +
> +       rcu_read_lock();
> +       tracer = tracehook_tracer_task(task);
> +       if (tracer)
> +               cred = aa_get_task_policy(tracer, &tracerp);
> +       rcu_read_unlock();
> +
> +       if (!tracerp)
> 
> Don't you need to call put_cred(cred); because aa_get_task_policy() calls
> get_task_cred() but aa_cred_policy() may set tracerp to NULL ?
> 
indeed.



> +
> +       .cred_free = apparmor_cred_free,
> +       .cred_prepare = apparmor_cred_prepare,
> +
> 
> Don't you need to define ".cred_alloc_blank" and ".cred_transfer" ?
> 
hrmm, yes it seems I managed to drop that patch.

> +static int set_init_cxt(void)
> +{
> +       struct cred *cred = (struct cred *)current->real_cred;
> +       struct aa_task_context *cxt;
> +
> +       cxt = aa_alloc_task_context(GFP_KERNEL);
> +       if (!cxt)
> +               return -ENOMEM;
> +
> +       cxt->sys.profile = aa_get_profile(default_namespace->unconfined);
> +       cred->security = cxt;
> +
> +       return 0;
> +}
> 
> You can add __init to this function.
yep

thanks again Tetsuo



