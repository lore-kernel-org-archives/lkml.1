Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbZCLU5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbZCLU5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 16:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753245AbZCLU5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 16:57:01 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:39290 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714AbZCLU47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 16:56:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wk1kF1nUTGvS88aX/UoAP5byC4b2XQ92OrZetCnrsiXopTrg801sdpaRKMJy6BC/K8
         6j9QgfGCapQv2NysFrUwGNi7e+K1HOEzvKy7b4vJto0MXk9c0ZG44unnztLMNlP4Epvz
         B4nB9NYAV+FQGK0b58jQFN3pzpWwD4u2l6Hok=
MIME-Version: 1.0
In-Reply-To: <20090312190039.GA6901@fieldses.org>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com>
	 <20090311232356.GP13540@fieldses.org>
	 <20090312161047.GA15209@us.ibm.com>
	 <20090312190039.GA6901@fieldses.org>
Date: Thu, 12 Mar 2009 23:56:55 +0300
Message-ID: <f44001920903121356m3f742684mec1adebc9a2e37dd@mail.gmail.com>
Subject: Re: VFS, NFS security bug? Should CAP_MKNOD and CAP_LINUX_IMMUTABLE 
	be added to CAP_FS_MASK?
From: Igor Zhbanov <izh1979@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, neilb@suse.de, Trond.Myklebust@netapp.com,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/12 J. Bruce Fields <bfields@fieldses.org>:
>
> For nfsd at least we should be droppping anything that concerns the
> filesystem and would normally require root privileges.
>
> We need to trace up through the users of CAP_FS_SET and figure out what
> other users need.

2009/3/12 J. Bruce Fields <bfields@fieldses.org>:

> For nfsd at least we should be droppping anything that concerns the
> filesystem and would normally require root privileges.
>
> We need to trace up through the users of CAP_FS_SET and figure out what
> other users need.

CAP_FS_SET used unly in functions cap_is_fs_cap(...),
cap_drop_fs_set(...), cap_raise_fs_set(...).
And it is used as a base for CAP_NFSD_SET.

CAP_NFSD_SET is used in cap_drop_nfsd_set(...) and
cap_raise_nfsd_set(...) functions.

All above you can find in include/linux/capability.h

cap_is_fs_cap(...) is not used in mainstream kernel.

As for cap_drop_fs_set(...) and cap_raise_fs_set(...), they are used in function
cap_task_post_setuid(...) in file security/commoncap.c:
------------------------------------------------------------------------------
int cap_task_post_setuid (uid_t old_ruid, uid_t old_euid, uid_t old_suid,
			  int flags)
{
	switch (flags) {
...
	case LSM_SETID_FS:
		{
			uid_t old_fsuid = old_ruid;

			/* Copied from kernel/sys.c:setfsuid. */

			/*
			 * FIXME - is fsuser used for all CAP_FS_MASK capabilities?
			 *          if not, we might be a bit too harsh here.
			 */

			if (!issecure (SECURE_NO_SETUID_FIXUP)) {
				if (old_fsuid == 0 && current->fsuid != 0) {
					current->cap_effective =
						cap_drop_fs_set(
						    current->cap_effective);
				}
				if (old_fsuid != 0 && current->fsuid == 0) {
					current->cap_effective =
						cap_raise_fs_set(
						    current->cap_effective,
						    current->cap_permitted);
				}
			}
			break;
		}
	default:
		return -EINVAL;
	}

	return 0;
}
------------------------------------------------------------------------------

So, it raises or drops filesystem capabilities when (old_ruid !=
current->fsuid), i.e. when fsuid changes.

And cap_task_post_setuid(...) indirectly called from setfsuid(...)
syscall function in file kernel/sys.c:
------------------------------------------------------------------------------
/*
 * "setfsuid()" sets the fsuid - the uid used for filesystem checks. This
 * is used for "access()" and for the NFS daemon (letting nfsd stay at
 * whatever uid it wants to). It normally shadows "euid", except when
 * explicitly set by setfsuid() or for access..
 */
SYSCALL_DEFINE1(setfsuid, uid_t, uid)
{
	int old_fsuid;

	old_fsuid = current->fsuid;
	if (security_task_setuid(uid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS))
		return old_fsuid;

	if (uid == current->uid || uid == current->euid ||
	    uid == current->suid || uid == current->fsuid ||
	    capable(CAP_SETUID)) {
		if (uid != old_fsuid) {
			set_dumpable(current->mm, suid_dumpable);
			smp_wmb();
		}
		current->fsuid = uid;
	}

	key_fsuid_changed(current);
	proc_id_connector(current, PROC_EVENT_UID);

	/* !!! HERE !!! */
	security_task_post_setuid(old_fsuid, (uid_t)-1, (uid_t)-1, LSM_SETID_FS);

	return old_fsuid;
}
------------------------------------------------------------------------------

And here is example of using setfsuid(...) syscall. I have found it in
linux-PAM package
in pam_xauth module in file modules/pam_xauth.c. This module reads
file in home directory
of authenticating user. Look at this:
------------------------------------------------------------------------------
	euid = geteuid();
	setfsuid(pwd->pw_uid);
	fp = fopen(path, "r");
	setfsuid(euid);
------------------------------------------------------------------------------

Module runs as root, but needs to temporarily drop filesystem
capabilities, so module
will not read files that user couldn't read according to permissions.

And I think that when some process running as root decides to temporarily drop
filesystem capabilities, CAP_MKNOD and CAP_LINUX_IMMUTABLE
(and probably some selinux related capablities) must be dropped too,
as ordinary users couldn't create devices, etc.
