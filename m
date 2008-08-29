Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbYH2KT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbYH2KT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYH2KTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:19:48 -0400
Received: from burp.tkv.asdf.org ([212.16.99.49]:45875 "EHLO
	cs181073102.pp.htv.fi" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751469AbYH2KTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:19:47 -0400
Date: Fri, 29 Aug 2008 13:18:38 +0300
From: Markku Savela <msa@moth.iki.fi>
Message-Id: <200808291018.m7TAIcqJ030105@burp.tkv.asdf.org>
To: Theodore Tso <tytso@mit.edu>
CC: tytso@mit.edu, pavel@suse.cz, linux-kernel@vger.kernel.org
In-reply-to: <20080828174854.GM26987@mit.edu> (message from Theodore Tso on
	Thu, 28 Aug 2008 13:48:54 -0400)
Subject: Re: Frustrated with capabilities..
References: <87hc96by8x.fsf@burp.tkv.asdf.org> <20080828141826.GA6797@ucw.cz> <200808281445.m7SEjYsB007502@burp.tkv.asdf.org> <20080828174854.GM26987@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Theodore Tso <tytso@mit.edu>

> The reason for that was to avoid bugs where a program that wasn't
> expecting to be setuid (or just written by a stupid progammer) exec's
> some program which wasn't expecting to have root privileges then bad
> things happen.  The classic example of this was running the mail
> program, which was setuid or setgid to the mail user/group, and then
> typing "!/bin/sh" which would exec a shell running with those
> privileges (because the mail program didn't know to drop its
> privileges).

Considering the current case, without the file capabilites, I note

- if the caller of /bin/sh is ROOT, the capabities are inherited. Thus
  my request has no relevance in that case.

- if the caller does first setuid to non-root, the capabilities are
  cleared, unless KEEP_CAPS is explicitly set. Thus, my requested
  change would not cause problems with your buggy mail program.

- if the caller goes through all the trouble of setting KEEP_CAPS and
  changing to non-root, I would expect it to be sensible that the
  caller also intends the execve code to inherit capabilities.

As an experiment and example, I made a small patch to Ubuntu 2.6.24
kernel, to make it work like I think it should: if KEEP_CAPS is set,
they are inherited (see at end).

I'm ok with the current kernel code, which seems to clear the
KEEP_CAPS on execve. Thus, each executable must again re-enable it, if
it needs capabilities inherited further...


> So in the capabilities model, the capabilities do *not* inherit unless
> the a particular file explicitly states that it should inherit the
> capabilities.  It's the principle of least privilege taken to its
> logical conclusion.

I'm looking at network oriented devices, where executables or
interpreted content from network sources is executed by helper
applications or directly as executables. Depending on the source of
the "code", the helper application or the downloaded exectuable may be
allowed to run with different permissions (capabilities, uid/gid
etc). [For example, look at android security model with manifests of
requested and declared permissions, but applied to everything
downloaded or installed].

File capabilities (nor selinux) won't work, because the "helper
applications" need to be executed with different capabilities and
permissions, depending on the "manifests" of the downloaded
"code". Obviously, serious permissions are granted only to properly
verified "code" (signed).

  [Any ideas how selinux would help to enforce a permission which is
  dynamically defined by installing application?]

I'm using "code" in quotes, because in my mind, it can include HTML,
word documents, spreadsheets, images. Data formats are getting so
complex, that they start to look more like interpreted code, than
plain passive data.

File capabilities (and setuid/setgid bits, selinux attributes) have
another problem: they only work properly on internal disk. No sane
person would allow them to be effective from removable media or NFS.

-------------------
This only handles the case where file capabilities are not enabled. If
enabled, I would need to remove the bprm_clear_caps call from the
branch that gets executed when the file does not have any special
capabilities defined.
-------------------

--- fs/exec.c.orig	2008-08-21 00:51:46.000000000 +0300
+++ fs/exec.c	2008-08-28 11:18:13.000000000 +0300
@@ -1072,6 +1072,12 @@
 	bprm->e_uid = current->euid;
 	bprm->e_gid = current->egid;
 
+	if (current->keep_capabilities) {
+		bprm->cap_inheritable = current->cap_inheritable;
+		bprm->cap_permitted = current->cap_permitted;
+		bprm->cap_effective = 1;
+	}
+
 	if(!(bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)) {
 		/* Set-uid? */
 		if (mode & S_ISUID) {
--- security/commoncap.c.orig	2008-08-21 00:51:47.000000000 +0300
+++ security/commoncap.c	2008-08-28 16:20:34.000000000 +0300
@@ -282,7 +282,7 @@
 
 static inline int get_file_caps(struct linux_binprm *bprm)
 {
-	bprm_clear_caps(bprm);
+	/*bprm_clear_caps(bprm); */
 	return 0;
 }
 #endif

