Return-Path: <linux-kernel-owner+w=401wt.eu-S1760272AbZCPOQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760272AbZCPOQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 10:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756991AbZCPOQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 10:16:39 -0400
Received: from mail-bw0-f175.google.com ([209.85.218.175]:53313 "EHLO
	mail-bw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755725AbZCPOQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:16:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aad98RKLazpoufmfAXb5i2Ggbl38d7SLeGO7ADBtIFH/Vc7rqFHQ8My4Nzalmq3g/a
         ZfCMfYIDMMAmxfzzwPItyzPLFuyvPbWSi4SHQ0tF71sfypGuzsb/E2Xew6yQQf/gIlZG
         Gf+87vUH4NnJ2S/JhNBW3hux0ZBobIGewoA68=
MIME-Version: 1.0
In-Reply-To: <cfd18e0f0903141220u66230ceer22ef0cc6aed1d046@mail.gmail.com>
References: <f44001920903110553t52ce0ba7l4ba97213e1c51873@mail.gmail.com>
	 <20090311232356.GP13540@fieldses.org>
	 <20090312161047.GA15209@us.ibm.com>
	 <517f3f820903121321sf6d2014q8165b925d5d44db7@mail.gmail.com>
	 <20090313175848.GB27891@fieldses.org>
	 <cfd18e0f0903141220u66230ceer22ef0cc6aed1d046@mail.gmail.com>
Date: Mon, 16 Mar 2009 17:16:34 +0300
Message-ID: <f44001920903160716i488e3642o869f626a5c3327d0@mail.gmail.com>
Subject: Re: VFS, NFS security bug? Should CAP_MKNOD and CAP_LINUX_IMMUTABLE 
	be added to CAP_FS_MASK?
From: Igor Zhbanov <izh1979@gmail.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk, neilb@suse.de, Trond.Myklebust@netapp.com,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, everybody!

I look again at kernel sources and will tell you what I think of.

CAP_FS_MASK is used currently in two places: in setfsuid(...) system call
and as a base for CAP_NFSD_MASK which used in nfsd_setuser(...) function.

First, setfsuid(...). As I understand, this system call is a subset
of seteuid(...). And it is used when some privileged process want to do
some filesystem operations as some ordinary user could do. That privileged
process don't want to completely drop all privileges and become that ordinary
user. But it wants temporarily lower it's privileges and set fsuid, so process
don't bother itself with checking permissions on files and can rely on kernel.
Here is typical usage from linux-PAM package, file modules/pam_xauth.c:

	euid = geteuid();
	setfsuid(pwd->pw_uid);
	fp = fopen(path, "r");
	setfsuid(euid);
	if (fp != NULL) {...}

So, privileged PAM authentication process sets fsuid and tries to read file
from user's home, and after attempt to open file, it sets fsuid back.
So, if user cannot read that file, PAM module cannot read it too.

And I think that CAP_MKNOD and CAP_LINUX_IMMUTABLE privileges should
be included in CAP_FS_MASK. As for CAP_SYS_ADMIN and CAP_SETFCAP,
they could be also included in CAP_FS_MASK. Perhaps with CAP_MAC_ADMIN,
so mandatory access control labels couldn't be changed too.

Although it is strange to me if someone write a code that drops filesystem
capabilities and later tries e.g. to set SElinux label. Tries just to fail? ;-)
IMHO setfsuid(...) in ordinary privileged processes should be used only
for short times just around filesystem operations, that should be checked
against another user's permission.

As for NFSD, the story is quite different. Before attempting to access
file system NFSD calls nfsd_setuser(...) function. But NFSD is unaware
of capabilities of client's process. It knows just fsuid, fsgid and additional
groups of calling process (as it is done in AUTH_UNIX authorisation method).
So decision of NFSD is simple: if uid is zero, then raises filesystem
capabilities, else drop them.

And the problem is that not all filesystem operations that client can ask NFSD
to perform are covered by CAP_NFSD_SET. So if some ordinary user (because
of broken client or by given capability) will ask NFSD to create a device,
NFSD will do it because nfsd_setuser(...) doesn't drop that capability.

As for SElinux and extended attributes, it seems that extended attributes
other that ACL are not supported by NFS by bow. So, NFSD is unaffected
with CAP_SYS_ADMIN and CAP_SETFCAP not included in CAP_NFSD_SET - you just
can't ask NFSD to set SElinux label. It's not implemented. ;-)

And my conclusion is that CAP_MKNOD, CAP_LINUX_IMMUTABLE, CAP_SYS_ADMIN,
CAP_SETFCAP and CAP_MAC_ADMIN should be included
in CAP_FS_MASK.

I'm sure about CAP_MKNOD and CAP_LINUX_IMMUTABLE, and not so sure
of CAP_SYS_ADMIN, CAP_SETFCAP and CAP_MAC_ADMIN.
(NFS doesn't support SElinux, as I know. And dropping filesystem capabilities
before manipulating SElinux labels seems to be useless. And if someone exploits
vulnerability in process with dropped filesystem capabilities, it's
easy to bring them back.)

Please tell what you think.

And there are patches:

For linux-2.6:
------------------------------------------------------------------------------
diff -purN linux-2.6.28.7/include/linux/capability.h
linux/include/linux/capability.h
--- linux-2.6.28.7/include/linux/capability.h	2009-02-21
01:41:27.000000000 +0300
+++ linux/include/linux/capability.h	2009-03-16 17:09:23.588420300 +0300
@@ -370,9 +370,14 @@ typedef struct kernel_cap_struct {
 			    | CAP_TO_MASK(CAP_DAC_OVERRIDE)	\
 			    | CAP_TO_MASK(CAP_DAC_READ_SEARCH)	\
 			    | CAP_TO_MASK(CAP_FOWNER)		\
+			    | CAP_TO_MASK(CAP_MKNOD)		\
+			    | CAP_TO_MASK(CAP_LINUX_IMMUTABLE)	\
+			    | CAP_TO_MASK(CAP_SYS_ADMIN)	\
+			    | CAP_TO_MASK(CAP_SETFCAP)		\
 			    | CAP_TO_MASK(CAP_FSETID))

-# define CAP_FS_MASK_B1     (CAP_TO_MASK(CAP_MAC_OVERRIDE))
+# define CAP_FS_MASK_B1     (CAP_TO_MASK(CAP_MAC_OVERRIDE)	\
+			    | CAP_TO_MASK(CAP_MAC_ADMIN))

 #if _KERNEL_CAPABILITY_U32S != 2
 # error Fix up hand-coded capability macro initializers
------------------------------------------------------------------------------

And for linux-2.4:
------------------------------------------------------------------------------
diff -purN linux-2.4.37/include/linux/capability.h
linux/include/linux/capability.h
--- linux-2.4.37/include/linux/capability.h	2008-12-02 11:01:34.000000000 +0300
+++ linux/include/linux/capability.h	2009-03-16 17:14:16.308635400 +0300
@@ -101,7 +101,7 @@ typedef __u32 kernel_cap_t;

 /* Used to decide between falling back on the old suser() or fsuser(). */

-#define CAP_FS_MASK          0x1f
+#define CAP_FS_MASK          0x0820021f

 /* Overrides the restriction that the real or effective user ID of a
    process sending a signal must match the real or effective user ID
------------------------------------------------------------------------------

Anyway, I haven't write access to git repository, so if you agree,
please commit.

P.S. CAP_SYS_ADMIN is bad - too many actions are bounded to this capability.
Perhaps it should be broken down to a set of independent capabilities.
Especially, SElinux related could be separated.
