Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbZKTRjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbZKTRjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 12:39:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbZKTRju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 12:39:50 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:49188 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbZKTRjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 12:39:49 -0500
To: john.johansen@canonical.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor #3 0/12] AppArmor security module
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
In-Reply-To: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>
Message-Id: <200911210239.DCI56207.HQFOVOJOSLMFFt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 21 Nov 2009 02:39:51 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Sorry for late response.
I browsed apparmorfs-24.c apparmorfs.c audit.c capability.c context.c domain.c .
Comments are shown below.



> static int aa_audit_base(int type, struct aa_profile *profile,
> 			   struct aa_audit *sa, struct audit_context *audit_cxt,
> 			   void (*cb) (struct audit_buffer *, void *))
(...snipped...)
> if (profile && PROFILE_KILL(profile) && type == AUDIT_APPARMOR_DENIED)
> 	type = AUDIT_APPARMOR_KILL;

PROFILE_KILL(profile) includes profile != NULL checks.
Are you doing

	profile && PROFILE_KILL(profile)

in order to ignore aa_g_profile_mode == APPARMOR_KILL if profile == NULL?



> int aa_restore_previous_profile(u64 token)
> {
> 	struct aa_task_context *cxt;
> 	struct cred *new = prepare_creds();
> 	if (!new)
> 		return -ENOMEM;
> 
> 	cxt = new->security;
> 	if (cxt->sys.token != token) {
> 		abort_creds(new);

I think simply returning -EACCES when trying to escape from some profile
gives hijacked process chances to do brute force attack.
Don't you need to kill the current process?

> 		return -EACCES;
> 	}



> static struct aa_profile *x_to_profile(struct aa_namespace *ns,
> 					 struct aa_profile *profile,
> 					 const char *name, u16 xindex)
(...snipped...)
> 	case AA_X_TABLE:
> 		if (index > profile->file.trans.size) {

profile->file.trans.table[0] is not permitted if profile->file.trans.size == 0,
is it?
Did you mean index >= profile->file.trans.size ?

> 			AA_ERROR("Invalid named transition\n");
> 			return ERR_PTR(-EACCES);
> 		}
> 		name = profile->file.trans.table[index];
(...snipped...)
> 	} else if (*name == ':') {
> 		/* switching namespace */
> 		const char *ns_name = name + 1;
> 		name = xname = ns_name + strlen(ns_name) + 1;
> 		if (!*xname)

Isn't *xname undefined because it is beyond '\0'?

> 			/* no name so use profile name */
> 			xname = profile->fqname;

(...snipped...)

> 	} else if (*name == '@') {
> 		/* TODO: variable support */
> 

You want "continue;" here in order to avoid doing strstr(NULL, "//")
inside aa_find_profile().

> 	} else {



> int apparmor_bprm_set_creds(struct linux_binprm *bprm)
> {
> 	struct aa_task_context *cxt;
> 	struct aa_profile *profile, *new_profile = NULL;
> 	struct aa_namespace *ns;
> 	char *buffer = NULL;
> 	unsigned int state = DFA_START;
> 	struct path_cond cond = {
> 		bprm->file->f_path.dentry->d_inode->i_uid,
> 		bprm->file->f_path.dentry->d_inode->i_mode
> 	};
> 	struct aa_audit_file sa = {
> 		.base.operation = "exec",
> 		.base.gfp_mask = GFP_KERNEL,
> 		.request = MAY_EXEC,
> 		.cond = &cond,
> 	};
> 
> 	sa.base.error = cap_bprm_set_creds(bprm);
> 	if (sa.base.error)
> 		return sa.base.error;
> 
> 	if (bprm->cred_prepared)
> 		return 0;
> 
> 	cxt = bprm->cred->security;
> 	BUG_ON(!cxt);
> 
> 	profile = aa_confining_profile(cxt->sys.profile);
> 	ns = profile->ns;

aa_confining_profile() may return NULL.
According to apparmor-kermic tree, it is

	ns = cxt->sys.profile->ns;

> 
> 	/* buffer freed below, name is pointer inside of buffer */
> 	sa.base.error = aa_get_name(&bprm->file->f_path, 0, &buffer,
> 				    (char **)&sa.name);
> 	if (sa.base.error) {
> 		if (!profile || profile->flags & PFLAG_IX_ON_NAME_ERROR)
> 			sa.base.error = 0;
> 		sa.base.info = "Exec failed name resolution";
> 		sa.name = bprm->filename;
> 		goto audit;
> 	}
> 
> 	if (!profile) {
> 		/* unconfined task - attach profile if one matches */
> 		new_profile = aa_sys_find_attach(&ns->base, sa.name);
> 		if (!new_profile)
> 			goto cleanup;
> 		goto apply;
> 	} else if (cxt->sys.onexec) {
> 		/*
> 		 * onexec permissions are stored in a pair, rewalk the
> 		 * dfa to get start of the exec path match.
> 		 */
> 		sa.perms = change_profile_perms(profile, cxt->sys.onexec->ns,
> 						sa.name, &state);
> 		state = aa_dfa_null_transition(profile->file.dfa, state);
> 	}
> 	sa.perms = aa_str_perms(profile->file.dfa, state, sa.name, &cond, NULL);> 
> 	if (cxt->sys.onexec && sa.perms.allowed & AA_MAY_ONEXEC) {
> 		new_profile = cxt->sys.onexec;
> 		cxt->sys.onexec = NULL;
> 		sa.base.info = "change_profile onexec";
> 	} else if (sa.perms.allowed & MAY_EXEC) {
> 		new_profile = x_to_profile(ns, profile, sa.name,
> 					   sa.perms.xindex);
> 		if (IS_ERR(new_profile)) {
> 			if (sa.perms.xindex & AA_X_INHERIT) {
> 				/* (p|c|n)ix - don't change profile */
> 				sa.base.info = "ix fallback";
> 				goto x_clear;
> 			} else if (sa.perms.xindex & AA_X_UNCONFINED) {
> 				new_profile = aa_get_profile(ns->unconfined);
> 				sa.base.info = "ux fallback";

IS_ERR(new_profile) is true but new_profile == NULL is false.
What I worry is that you sometimes embed error values into pointer but you
are sometimes checking only NULL.

> 			} else {
> 				sa.base.error = PTR_ERR(new_profile);
> 				if (sa.base.error == -ENOENT)
> 					sa.base.info = "profile not found";
> 				new_profile = NULL;
> 			}
> 		}
> 	} else if (PROFILE_COMPLAIN(profile)) {
> 		new_profile = aa_alloc_null_profile(profile, 0);
> 		sa.base.error = -EACCES;
> 		if (!new_profile)
> 			sa.base.error = -ENOMEM;
> 		sa.name2 = new_profile->fqname;

This will oops if new_profile == NULL. Please fix apparmor-karmic as well.

> 		sa.perms.xindex |= AA_X_UNSAFE;
> 	} else {
> 		sa.base.error = -EACCES;
> 	}
> 
> 	if (!new_profile)
> 		goto audit;

You want to do

	if (!new_profile || IS_ERR(new_profile))

rather than

	if (!new_profile)

Please fix apparmor-karmic as well.

> 
> 	if (profile == new_profile) {
> 		aa_put_profile(new_profile);

aa_put_profile() with error pointer, which will be fixed by above change.

> 		goto audit;
> 	}
> 
> 	if (bprm->unsafe & LSM_UNSAFE_SHARE) {
> 		/* FIXME: currently don't mediate shared state */
> 		;
> 	}
> 
> 	if (bprm->unsafe & (LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP)) {
> 		sa.base.error = aa_may_change_ptraced_domain(current,
> 							     new_profile);

aa_may_change_ptraced_domain() with error pointer, which will be fixed by
above change.

> 		if (sa.base.error)
> 			goto audit;
> 	}
> 
> 	/* Determine if secure exec is needed.
> 	 * Can be at this point for the following reasons:
> 	 * 1. unconfined switching to confined
> 	 * 2. confined switching to different confinement
> 	 * 3. confined switching to unconfined
> 	 *
> 	 * Cases 2 and 3 are marked as requiring secure exec
> 	 * (unless policy specified "unsafe exec")
> 	 *
> 	 * bprm->unsafe is used to cache the AA_X_UNSAFE permission
> 	 * to avoid having to recompute in secureexec
> 	 */
> 	if (!(sa.perms.xindex & AA_X_UNSAFE))
> 		bprm->unsafe |= AA_SECURE_X_NEEDED;
> 
> apply:
> 	sa.name2 = new_profile->fqname;

error pointer, which will be fixed by above change.

> 	/* When switching namespace ensure its part of audit message */
> 	if (new_profile->ns != ns)
> 		sa.name3 = new_profile->ns->base.name;
> 
> 	/* when transitioning profiles clear unsafe personality bits */
> 	bprm->per_clear |= PER_CLEAR_ON_SETID;
> 
> 	aa_put_profile(cxt->sys.profile);
> 	/* transfer new profile reference will be released when cxt is freed */
> 	cxt->sys.profile = new_profile;
> 
> x_clear:
> 	aa_put_profile(cxt->sys.previous);
> 	aa_put_profile(cxt->sys.onexec);
> 	cxt->sys.previous = NULL;
> 	cxt->sys.onexec = NULL;
> 	cxt->sys.token = 0;
> 
> audit:
> 	sa.base.error = aa_audit_file(profile, &sa);

aa_audit_file() might return 0 if PROFILE_COMPLAIN(profile) == true even if
sa.base.error != 0 . I think regarding execve(), we should not ignore errors
like -EACCES, -ENOMEM etc. if something went wrong before auditing.
Otherwise, current process might continue execve() with unexpected profile.

> 
> cleanup:
> 	kfree(buffer);
> 
> 	return sa.base.error;
> }



> int aa_change_hat(const char *hat_name, u64 token, int permtest)
(...snipped...)
> 			/* freed below */
> 			name = new_compound_name(root->fqname, hat_name);
> 

Audit log lacks "name=%s" part if name == NULL.

> 			sa.name = name;
> 			sa.base.info = "hat not found";
> 			sa.base.error = -ENOENT;



> int aa_change_profile(const char *ns_name, const char *fqname, int onexec,
> 		      int permtest)
(...snipped...)
> 	/* released below */
> 	target = aa_find_profile(ns, fqname);
> 	if (!target) {
> 		sa.base.info = "profile not found";
> 		sa.base.error = -ENOENT;
> 		if (permtest || !PROFILE_COMPLAIN(profile))
> 			goto audit;
> 		/* release below */
> 		target = aa_alloc_null_profile(profile, 0);

aa_alloc_null_profile() will oops if profile == NULL.
