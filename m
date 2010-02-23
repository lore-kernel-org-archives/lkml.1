Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab0BWIbM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 03:31:12 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:54427 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab0BWIbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 03:31:09 -0500
Message-Id: <201002230831.o1N8V3Iv071911@www262.sakura.ne.jp>
Subject: Re: [AppArmor #4 0/12] AppArmor security module
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: john.johansen@canonical.com
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 23 Feb 2010 17:31:03 +0900
References: <1266572188-26529-1-git-send-email-john.johansen@canonical.com> 
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 23022010 #3408306, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regarding audit.c

 53 static int aa_audit_base(int type, struct aa_profile *profile,
 54                          struct aa_audit *sa, struct audit_context *audit_cxt,
 55                          void (*cb) (struct audit_buffer *, struct aa_audit *))
(...snipped...)
 93                 pid_t pid = task->real_parent->pid;
I think you need to protect this dereference with RCU
(see SYSCALL_DEFINE0(getppid)).





Regarding domain.c

 54 static int aa_may_change_ptraced_domain(struct task_struct *task,
 55                                         struct aa_profile *to_profile)
(...snipped...)
 71         /* not ptraced */
 72         if (!tracer || unconfined(tracerp))
 73                 goto out;
unconfined() does not accept NULL.
What guarantees that tracer's profile != NULL?





197 static const char *separate_fqname(const char *fqname, const char **ns_name)(...snipped...)
201         if (fqname[0] == ':') {
202                 *ns_name = fqname + 1;          /* skip : */
203                 name = *ns_name + strlen(*ns_name) + 1;
204                 if (!*name)
This will go beyond \0 if fqname was ":" . Is fqname checked somewhere else?
205                         name = NULL;





229 static struct aa_profile *x_to_profile(struct aa_profile *profile,
230                                        const char *name, u16 xindex)
(...snipped...)
297 out:
This label seems unused.
298         /* released by caller */
299         return new_profile;





308 int apparmor_bprm_set_creds(struct linux_binprm *bprm)
(...snipped...)
336         profile = aa_newest_version(cxt->profile);
profile == NULL if cxt->profile == NULL.
What guarantees that cxt->profile != NULL?





534 int aa_change_hat(const char *hats[], int count, u64 token, bool permtest)
(...snipped...)
565                 /* find first matching hat */
566                 for (i = 0; i < count && !hat; i++)
567                         /* released below */
568                         hat = aa_find_child(root, hats[i]);
569                 if (!hat) {
570                         if (!COMPLAIN_MODE(root) || permtest) {
571                                 sa.base.info = "hat not found";
572                                 if (list_empty(&root->base.profiles))
573                                         sa.base.error = -ECHILD;
574                                 else
575                                         sa.base.error = -ENOENT;
576                                 goto out;
577                         }
578                         /* freed below */
579                         name = new_compound_name(root->base.hname, hats[0]);
Is this hats[0] and not hats[i - 1]?


You have a lot of

   sa.base.info = ...;
   sa.base.error = -E...;

Passing sa.base to functions might simplify the code.





Regarding file.c

 61 static void file_audit_cb(struct audit_buffer *ab, struct aa_audit *va)
 62 {
 63         struct aa_audit_file *sa = container_of(va, struct aa_audit_file, base);
 64         u16 denied = sa->request & ~sa->perms.allowed;
 65         uid_t fsuid;
 66 
 67         if (sa->base.task)
 68                 fsuid = task_uid(sa->base.task);
Is task_struct pointed by sa->base.task guaranteed to exist until now?





Regarding lsm.c

135 static int apparmor_capable(struct task_struct *task, const struct cred *cred,
136                             int cap, int audit)
137 {
138         struct aa_profile *profile;
139         /* cap_capable returns 0 on success, else -EPERM */
140         int error = cap_capable(task, cred, cap, audit);
141 
142         profile = aa_cred_profile(cred);
aa_cred_profile() returns NULL but unconfined() and aa_capable() don't accept
profile == NULL case.
143         if (!error  && !unconfined(profile))
144                 error = aa_capable(task, profile, cap, audit);

For me, it is difficult to check "whether parameter may be NULL or not"
"whether function may return NULL or not".
Adding "Maybe NULL." / "Never NULL." to function parameter's comment line and
"May return NULL" / "Never returns NULL" for function's return value would be
helpful.
