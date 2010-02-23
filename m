Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab0BWJRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 04:17:15 -0500
Received: from adelie.canonical.com ([91.189.90.139]:47036 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab0BWJRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 04:17:12 -0500
Message-ID: <4B839D0D.203@canonical.com>
Date: Tue, 23 Feb 2010 01:17:01 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: john.johansen@canonical.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [AppArmor #4 0/12] AppArmor security module
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com> <201002230831.o1N8V3Iv071911@www262.sakura.ne.jp>
In-Reply-To: <201002230831.o1N8V3Iv071911@www262.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Regarding audit.c
> 
>  53 static int aa_audit_base(int type, struct aa_profile *profile,
>  54                          struct aa_audit *sa, struct audit_context *audit_cxt,
>  55                          void (*cb) (struct audit_buffer *, struct aa_audit *))
> (...snipped...)
>  93                 pid_t pid = task->real_parent->pid;
> I think you need to protect this dereference with RCU
> (see SYSCALL_DEFINE0(getppid)).
> 
yep

> 
> 
> 
> 
> Regarding domain.c
> 
>  54 static int aa_may_change_ptraced_domain(struct task_struct *task,
>  55                                         struct aa_profile *to_profile)
> (...snipped...)
>  71         /* not ptraced */
>  72         if (!tracer || unconfined(tracerp))
>  73                 goto out;
> unconfined() does not accept NULL.
> What guarantees that tracer's profile != NULL?
> 
every context needs to have a valid profile now.  That change happened when
AppArmor made the switch to creds, but internally the change wasn't originally rolled into all the code so NULL was used in a lot of places
for the unconfined profile.  That should be finally cleaned up in this
submission.

> 
> 
> 
> 
> 197 static const char *separate_fqname(const char *fqname, const char **ns_name)(...snipped...)
> 201         if (fqname[0] == ':') {
> 202                 *ns_name = fqname + 1;          /* skip : */
> 203                 name = *ns_name + strlen(*ns_name) + 1;
> 204                 if (!*name)
> This will go beyond \0 if fqname was ":" . Is fqname checked somewhere else?
> 205                         name = NULL;
> 
yes. unpack_trans_table in policy_unpack.c verifies the transition table
strings.  But thanks for asking because its check isn't quite right.

> 
> 
> 
> 
> 229 static struct aa_profile *x_to_profile(struct aa_profile *profile,
> 230                                        const char *name, u16 xindex)
> (...snipped...)
> 297 out:
> This label seems unused.
> 298         /* released by caller */
> 299         return new_profile;
> 
well it is used by
	case AA_X_NAME:
		if (xindex & AA_X_CHILD)
			/* released by caller */
			new_profile = aa_find_attach(ns,
						     &profile->base.profiles,
						     name);
		else
			/* released by caller */
			new_profile = aa_find_attach(ns, &ns->base.profiles,
						     name);

		goto out;

but that goto could be replaced by a return

> 
> 
> 
> 
> 308 int apparmor_bprm_set_creds(struct linux_binprm *bprm)
> (...snipped...)
> 336         profile = aa_newest_version(cxt->profile);
> profile == NULL if cxt->profile == NULL.
> What guarantees that cxt->profile != NULL?
> 
Well every cxt is supposed to point to a valid profile and fn's should fail
if they violate this.  That being said there really should be some BUG_ONs
in the code for this, just like there is for the cxt.

> 
> 
> 
> 
> 534 int aa_change_hat(const char *hats[], int count, u64 token, bool permtest)
> (...snipped...)
> 565                 /* find first matching hat */
> 566                 for (i = 0; i < count && !hat; i++)
> 567                         /* released below */
> 568                         hat = aa_find_child(root, hats[i]);
> 569                 if (!hat) {
> 570                         if (!COMPLAIN_MODE(root) || permtest) {
> 571                                 sa.base.info = "hat not found";
> 572                                 if (list_empty(&root->base.profiles))
> 573                                         sa.base.error = -ECHILD;
> 574                                 else
> 575                                         sa.base.error = -ENOENT;
> 576                                 goto out;
> 577                         }
> 578                         /* freed below */
> 579                         name = new_compound_name(root->base.hname, hats[0]);
> Is this hats[0] and not hats[i - 1]?
> 
Yep, I know it seems strange and deserves a comment.  This is an artifact
of what userspace is expecting as logging output.  The traditional
behavior of learning mode is the first hat request to fail cause switching
into a learning profile and the failure is logged.  If the requests succeeds
then the transition is made.  At this point all requests have failed so
we log the first as expected.

There is a planned improvement here where we log more information but this
is sufficient for the moment.

> 
> You have a lot of
> 
>    sa.base.info = ...;
>    sa.base.error = -E...;
> 
> Passing sa.base to functions might simplify the code.
> 
Hrmm, yeah I have played around with this some and haven't hit on the right
combination yet.

> 
> 
> 
> 
> Regarding file.c
> 
>  61 static void file_audit_cb(struct audit_buffer *ab, struct aa_audit *va)
>  62 {
>  63         struct aa_audit_file *sa = container_of(va, struct aa_audit_file, base);
>  64         u16 denied = sa->request & ~sa->perms.allowed;
>  65         uid_t fsuid;
>  66 
>  67         if (sa->base.task)
>  68                 fsuid = task_uid(sa->base.task);
> Is task_struct pointed by sa->base.task guaranteed to exist until now?
> 
well yes but only because sa->base.task isn't used :),


> 
> 
> 
> 
> Regarding lsm.c
> 
> 135 static int apparmor_capable(struct task_struct *task, const struct cred *cred,
> 136                             int cap, int audit)
> 137 {
> 138         struct aa_profile *profile;
> 139         /* cap_capable returns 0 on success, else -EPERM */
> 140         int error = cap_capable(task, cred, cap, audit);
> 141 
> 142         profile = aa_cred_profile(cred);
> aa_cred_profile() returns NULL but unconfined() and aa_capable() don't accept
> profile == NULL case.
> 143         if (!error  && !unconfined(profile))
> 144                 error = aa_capable(task, profile, cap, audit);
> 
> For me, it is difficult to check "whether parameter may be NULL or not"
> "whether function may return NULL or not".
> Adding "Maybe NULL." / "Never NULL." to function parameter's comment line and
> "May return NULL" / "Never returns NULL" for function's return value would be
> helpful.
okay, will do
