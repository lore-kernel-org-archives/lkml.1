Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbZKWKLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbZKWKLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 05:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756841AbZKWKLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 05:11:17 -0500
Received: from adelie.canonical.com ([91.189.90.139]:36705 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803AbZKWKLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 05:11:15 -0500
Message-ID: <4B0A5FC4.1010902@canonical.com>
Date: Mon, 23 Nov 2009 02:11:16 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor #3 0/12] AppArmor security module
References: <1257869585-7092-1-git-send-email-john.johansen@canonical.com>	<200911210239.DCI56207.HQFOVOJOSLMFFt@I-love.SAKURA.ne.jp> <200911211428.JJH90667.LFOJFMSQVOFOtH@I-love.SAKURA.ne.jp>
In-Reply-To: <200911211428.JJH90667.LFOJFMSQVOFOtH@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> Regarding file.c ipc.c lib.c lsm.c
> 
> 
> 
> You can use container_of() inside callback functions to avoid "void *".
> 
yeah that is cleaner, will do

>> int aa_audit(int type, struct aa_profile *profile, struct aa_audit *sa,
>> 	     void (*cb) (struct audit_buffer *, void *))
> 
> int aa_audit(int type, struct aa_profile *profile, struct aa_audit *sa,
> 	     void (*cb) (struct audit_buffer *, struct aa_audit *))
> 
>> static int aa_audit_base(int type, struct aa_profile *profile,
>> 			 struct aa_audit *sa, struct audit_context *audit_cxt,
>> 			 void (*cb) (struct audit_buffer *, void *))
> 
> static int aa_audit_base(int type, struct aa_profile *profile,
> 			 struct aa_audit *sa, struct audit_context *audit_cxt,
> 			 void (*cb) (struct audit_buffer *, struct aa_audit *))
> 
>> void file_audit_cb(struct audit_buffer *ab, void *va)
>> {
>> 	struct aa_audit_file *sa = va;
> 
> void file_audit_cb(struct audit_buffer *ab, struct aa_audit *va)
> {
> 	struct aa_audit_file *sa = container_of(va, struct aa_audit_file, base);
> 
>> int aa_audit_file(struct aa_profile *profile, struct aa_audit_file *sa)
>> (...snipped...)
>> 	return aa_audit(type, profile, (struct aa_audit *)sa, file_audit_cb);
> 
> 	return aa_audit(type, profile, &sa->base, file_audit_cb);
> 
>> }
> 
>> static void audit_cb(struct audit_buffer *ab, void *va)
>> {
>> 	struct aa_audit_ptrace *sa = va;
> 
> static void audit_cb(struct audit_buffer *ab, struct aa_audit *va)
> {
> 	struct aa_audit_ptrace *sa = container_of(va, struct aa_audit_ptrace,
> 		base);
> 
>> static int aa_audit_ptrace(struct aa_profile *profile,
>> 			   struct aa_audit_ptrace *sa)
>> {
>> 	return aa_audit(AUDIT_APPARMOR_AUTO, profile, (struct aa_audit *)sa,
>> 			audit_cb);
> 
> 	return aa_audit(AUDIT_APPARMOR_AUTO, profile, &sa->base, audit_cb);
> 
> 
> 
>> int aa_path_link(struct aa_profile *profile, struct dentry *old_dentry,
>> 		 struct path *new_dir, struct dentry *new_dentry)
> (.,..snipped...)
>> 	unsigned int state;
> (.,..snipped...)
>> 	sa.perms = aa_str_perms(profile->file.dfa, DFA_START, sa.name, &cond,
>> 				&state);
> 
> "state" remains uninitialized if profile->file.dfa == NULL.
> Are you sure profile->file.dfa != NULL ?
> 
No this needs to be fixed.

> 
> 
>> char *aa_strchrnul(const char *s, int c)
>> {
>> 	for (; *s != (char)c && *s != '\0'; ++s)
>> 		;
>> 	return (char *)s;
>> }
> 
> Only fqname_subname() calls aa_strchrnul() and
> fqname_subname() returns NULL if aa_strchrnul() returns '\0'.
> You can use strchr() instead.
> 
hrmm right thanks

>> static const char *fqname_subname(const char *name)
>> {
>> 	char *split;
>> 	/* check for namespace which begins with a : and ends with : or \0 */
>> 	name = strstrip((char *)name);
>> 	if (*name == ':') {
>> 		split = aa_strchrnul(name + 1, ':');
>> 		if (*split == '\0')
>> 			return NULL;
> 
> 		split = strchr(name + 1, ':');
> 		if (!split)
> 			return NULL;
> 
yep

>> 		name = strstrip(split + 1);
>> 	}
>> 	for (split = strstr(name, "//"); split; split = strstr(name, "//"))
>> 	name = split + 2;
>>
>> 	return name;
>> }
> 
> 
> 
>> char *aa_split_name_from_ns(char *args, char **ns_name)
>> {
>> 	char *name = strstrip(args);
>>
>> 	*ns_name = NULL;
>> 	if (args[0] == ':') {
>> 		char *split = strstrip(strchr(&args[1], ':'));
>>
>> 		if (!split)
>> 			return NULL;
> 
> 
> strchr() returns NULL if not found, and strstrip(NULL) will do strlen(NULL).
> strstrip() never returns NULL. Did you mean
> 
> 		char *split = strchr(&args[1], ':');
> 
> 		if (!split)
> 			return NULL;
> 		split = strstrip(split);
> 
> ?
yes, thanks

> 
>> 		*split = 0;
>> 		*ns_name = &args[1];
>> 		name = strstrip(split + 1);
>> 	}
>> 	if (*name == 0)
>> 		name = NULL;
>>
>> 	return name;
>> }
> 
> 
> 
>> static int apparmor_sysctl(struct ctl_table *table, int op)
> This hook will be removed.
> 
>> char *sysctl_pathname(struct ctl_table *table, char *buffer, int buflen)
> This function will no longer be needed.
> 
>> int aa_pathstr_perm(struct aa_profile *profile, const char *op,
>> 		    const char *name, u16 request, struct path_cond *cond)
> This function will no longer be needed.
> 
yep

> 
> 
>> static int apparmor_file_permission(struct file *file, int mask)
>> {
>> 	/*
>> 	 * TODO: cache profiles that have revalidated?
>> 	 */
>> 	struct aa_file_cxt *fcxt = file->f_security;
>> 	struct aa_profile *profile, *fprofile = fcxt->profile;
>> 	int error = 0;
>>
>> 	if (!fprofile || !file->f_path.mnt ||
>> 	    !mediated_filesystem(file->f_path.dentry->d_inode))
>> 		return 0;
>>
>> 	profile = aa_current_profile();
>>
>> #ifdef CONFIG_SECURITY_APPARMOR_COMPAT_24
>> 	/*
>> 	 * AppArmor <= 2.4 revalidates files at access time instead
>> 	 * of at exec.
>> 	 */
>> 	if (profile && ((fprofile != profile) || (mask & ~fcxt->allowed)))
>> 	    error = aa_file_perm(profile, "file_perm", file, mask);
>> #endif
>>
>> 	return error;
>> }
> 
> Why need to call this function if CONFIG_SECURITY_APPARMOR_COMPAT_24=n ?
> I think we can do
> 
>> static struct security_operations apparmor_ops = {
> (...snipped...)
> 
> #ifdef CONFIG_SECURITY_APPARMOR_COMPAT_24
> 
>> 	.file_permission =              apparmor_file_permission,
> 
> #endif
> 
yes we can currently.  Though this will change in the future, but for now
we should got with the cleaner switch.

> (...snipped...)
>> }
> 
> 
> 
>> int aa_alloc_default_namespace(void)
> 
> This function could be declared with __init attribute.
> 
yep, thanks

> 
> 
>> static int __init apparmor_init(void)
> (...snipped...)
>> 	error = set_init_cxt();
>> 	if (error) {
>> 		AA_ERROR("Failed to set context on init task\n");
>> 		goto alloc_out;
> 
> This should be
> 
> 		goto register_security_out;
> 
> in order to call aa_free_default_namespace().
> 
>> 	}

indeed

thanks again for taking the time to review
john

