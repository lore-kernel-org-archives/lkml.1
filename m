Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbZEWP4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbZEWP4v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 11:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbZEWP4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 11:56:44 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:1139 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbZEWP4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 11:56:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N8S7eeKNlmSmc4O9paozLowV5RPIwH6ly6zs0J8LJZYe57LAUXDyQjcwI7DARYu5a3
         O3p7XbqxmDAghUCw94ku8j8UuUMGiJnNF+6wmfEqLtC7HqJv7N72ESRCMrN01I5baP1c
         7i1Wm6RQVb3UXP9A6v5c3CHj29/53sVX+UTSo=
MIME-Version: 1.0
In-Reply-To: <20090523044330.5715d607@tlielax.poochiereds.net>
References: <524f69650905221853l625afaa2s39d0470db8ef56b1@mail.gmail.com>
	 <20090523044330.5715d607@tlielax.poochiereds.net>
Date: Sat, 23 May 2009 10:56:44 -0500
Message-ID: <524f69650905230856r24b49f47yb5a3ea53e77a0f1@mail.gmail.com>
Subject: Re: Fix lookup so we don't try to open, just create
From: Steve French <smfrench@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Shirish Pargaonkar <shirishpargaonkar@gmail.com>,
       Jeremy Allison <jra@samba.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=001e680f15587a2f96046a966c1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001e680f15587a2f96046a966c1d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On Sat, May 23, 2009 at 3:43 AM, Jeff Layton <jlayton@redhat.com> wrote:
> It's also preferable not to break up an if block like that. That is, the
> comment should be moved up outside of the if block and to the left.
>
> --
> Jeff Layton <jlayton@redhat.com>

OK - simplified per Jeff's suggestions, and also simplified the error
check so it falls through to old unix query path on everything but rc
== 0 or rc == -ENOENT  (which avoids having to worry about future
EISDIR vs. EACCES anyway).  Will begin testing, but with a change this
small, looks lower risk to not map the errors (per Jeff's suggestion).
 Most of the change size is reformatting the comments and the one
level of now superfluous indentation.

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index f49d684..3758965 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -657,31 +657,36 @@ cifs_lookup(struct inode *parent_dir_inode,
struct dentry *direntry,
 	}
 	cFYI(1, ("Full path: %s inode = 0x%p", full_path, direntry->d_inode));

+	/* Posix open is only called (at lookup time) for file create now.
+	 * For opens (rather than creates), because we do not know if it
+	 * is a file or directory yet, and current Samba no longer allows
+	 * us to do posix open on dirs, we could end up wasting an open call
+	 * on what turns out to be a dir. For file opens, we wait to call posix
+	 * open till cifs_open.  It could be added here (lookup) in the future
+	 * but the performance tradeoff of the extra network request when EISDIR
+	 * or EACCES is returned would have to be weighed against the 50%
+	 * reduction in network traffic in the other paths.
+	 */
 	if (pTcon->unix_ext) {
 		if (!(nd->flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY)) &&
-		     (nd->flags & LOOKUP_OPEN) && !pTcon->broken_posix_open) {
-			if (!((nd->intent.open.flags & O_CREAT) &&
-					(nd->intent.open.flags & O_EXCL))) {
-				rc = cifs_posix_open(full_path, &newInode,
+		     (nd->flags & LOOKUP_OPEN) && !pTcon->broken_posix_open &&
+		     (nd->intent.open.flags & O_CREAT)) {
+			rc = cifs_posix_open(full_path, &newInode,
 					parent_dir_inode->i_sb,
 					nd->intent.open.create_mode,
 					nd->intent.open.flags, &oplock,
 					&fileHandle, xid);
-				/*
-				 * This code works around a bug in
-				 * samba posix open in samba versions 3.3.1
-				 * and earlier where create works
-				 * but open fails with invalid parameter.
-				 * If either of these error codes are
-				 * returned, follow the normal lookup.
-				 * Otherwise, the error during posix open
-				 * is handled.
-				 */
-				if ((rc != -EINVAL) && (rc != -EOPNOTSUPP))
-					posix_open = true;
-				else
-					pTcon->broken_posix_open = true;
-			}
+			/*
+			 * The check below works around a bug in POSIX
+			 * open in samba versions 3.3.1 and earlier where
+			 * open could incorrectly fail with invalid parameter.
+			 * If either that or op not supported returned, follow
+			 * the normal lookup.
+			 */
+			if ((rc == 0) || (rc == -ENOENT))
+				posix_open = true;
+			else if ((rc == -EINVAL) || (rc != -EOPNOTSUPP))
+				pTcon->broken_posix_open = true;
 		}
 		if (!posix_open)
 			rc = cifs_get_inode_info_unix(&newInode, full_path,



See attached:




-- 
Thanks,

Steve

--001e680f15587a2f96046a966c1d
Content-Type: text/x-diff; charset=US-ASCII; 
	name="posix-open-only-on-create-and-fix-isdir-error-mapping-ver2.patch"
Content-Disposition: attachment; 
	filename="posix-open-only-on-create-and-fix-isdir-error-mapping-ver2.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fv2i3fbf0

ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZGlyLmMgYi9mcy9jaWZzL2Rpci5jCmluZGV4IGY0OWQ2ODQu
LjM3NTg5NjUgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZGlyLmMKKysrIGIvZnMvY2lmcy9kaXIuYwpA
QCAtNjU3LDMxICs2NTcsMzYgQEAgY2lmc19sb29rdXAoc3RydWN0IGlub2RlICpwYXJlbnRfZGly
X2lub2RlLCBzdHJ1Y3QgZGVudHJ5ICpkaXJlbnRyeSwKIAl9CiAJY0ZZSSgxLCAoIkZ1bGwgcGF0
aDogJXMgaW5vZGUgPSAweCVwIiwgZnVsbF9wYXRoLCBkaXJlbnRyeS0+ZF9pbm9kZSkpOwogCisJ
LyogUG9zaXggb3BlbiBpcyBvbmx5IGNhbGxlZCAoYXQgbG9va3VwIHRpbWUpIGZvciBmaWxlIGNy
ZWF0ZSBub3cuCisJICogRm9yIG9wZW5zIChyYXRoZXIgdGhhbiBjcmVhdGVzKSwgYmVjYXVzZSB3
ZSBkbyBub3Qga25vdyBpZiBpdAorCSAqIGlzIGEgZmlsZSBvciBkaXJlY3RvcnkgeWV0LCBhbmQg
Y3VycmVudCBTYW1iYSBubyBsb25nZXIgYWxsb3dzCisJICogdXMgdG8gZG8gcG9zaXggb3BlbiBv
biBkaXJzLCB3ZSBjb3VsZCBlbmQgdXAgd2FzdGluZyBhbiBvcGVuIGNhbGwKKwkgKiBvbiB3aGF0
IHR1cm5zIG91dCB0byBiZSBhIGRpci4gRm9yIGZpbGUgb3BlbnMsIHdlIHdhaXQgdG8gY2FsbCBw
b3NpeAorCSAqIG9wZW4gdGlsbCBjaWZzX29wZW4uICBJdCBjb3VsZCBiZSBhZGRlZCBoZXJlIChs
b29rdXApIGluIHRoZSBmdXR1cmUKKwkgKiBidXQgdGhlIHBlcmZvcm1hbmNlIHRyYWRlb2ZmIG9m
IHRoZSBleHRyYSBuZXR3b3JrIHJlcXVlc3Qgd2hlbiBFSVNESVIKKwkgKiBvciBFQUNDRVMgaXMg
cmV0dXJuZWQgd291bGQgaGF2ZSB0byBiZSB3ZWlnaGVkIGFnYWluc3QgdGhlIDUwJQorCSAqIHJl
ZHVjdGlvbiBpbiBuZXR3b3JrIHRyYWZmaWMgaW4gdGhlIG90aGVyIHBhdGhzLgorCSAqLwogCWlm
IChwVGNvbi0+dW5peF9leHQpIHsKIAkJaWYgKCEobmQtPmZsYWdzICYgKExPT0tVUF9QQVJFTlQg
fCBMT09LVVBfRElSRUNUT1JZKSkgJiYKLQkJICAgICAobmQtPmZsYWdzICYgTE9PS1VQX09QRU4p
ICYmICFwVGNvbi0+YnJva2VuX3Bvc2l4X29wZW4pIHsKLQkJCWlmICghKChuZC0+aW50ZW50Lm9w
ZW4uZmxhZ3MgJiBPX0NSRUFUKSAmJgotCQkJCQkobmQtPmludGVudC5vcGVuLmZsYWdzICYgT19F
WENMKSkpIHsKLQkJCQlyYyA9IGNpZnNfcG9zaXhfb3BlbihmdWxsX3BhdGgsICZuZXdJbm9kZSwK
KwkJICAgICAobmQtPmZsYWdzICYgTE9PS1VQX09QRU4pICYmICFwVGNvbi0+YnJva2VuX3Bvc2l4
X29wZW4gJiYKKwkJICAgICAobmQtPmludGVudC5vcGVuLmZsYWdzICYgT19DUkVBVCkpIHsKKwkJ
CXJjID0gY2lmc19wb3NpeF9vcGVuKGZ1bGxfcGF0aCwgJm5ld0lub2RlLAogCQkJCQlwYXJlbnRf
ZGlyX2lub2RlLT5pX3NiLAogCQkJCQluZC0+aW50ZW50Lm9wZW4uY3JlYXRlX21vZGUsCiAJCQkJ
CW5kLT5pbnRlbnQub3Blbi5mbGFncywgJm9wbG9jaywKIAkJCQkJJmZpbGVIYW5kbGUsIHhpZCk7
Ci0JCQkJLyoKLQkJCQkgKiBUaGlzIGNvZGUgd29ya3MgYXJvdW5kIGEgYnVnIGluCi0JCQkJICog
c2FtYmEgcG9zaXggb3BlbiBpbiBzYW1iYSB2ZXJzaW9ucyAzLjMuMQotCQkJCSAqIGFuZCBlYXJs
aWVyIHdoZXJlIGNyZWF0ZSB3b3JrcwotCQkJCSAqIGJ1dCBvcGVuIGZhaWxzIHdpdGggaW52YWxp
ZCBwYXJhbWV0ZXIuCi0JCQkJICogSWYgZWl0aGVyIG9mIHRoZXNlIGVycm9yIGNvZGVzIGFyZQot
CQkJCSAqIHJldHVybmVkLCBmb2xsb3cgdGhlIG5vcm1hbCBsb29rdXAuCi0JCQkJICogT3RoZXJ3
aXNlLCB0aGUgZXJyb3IgZHVyaW5nIHBvc2l4IG9wZW4KLQkJCQkgKiBpcyBoYW5kbGVkLgotCQkJ
CSAqLwotCQkJCWlmICgocmMgIT0gLUVJTlZBTCkgJiYgKHJjICE9IC1FT1BOT1RTVVBQKSkKLQkJ
CQkJcG9zaXhfb3BlbiA9IHRydWU7Ci0JCQkJZWxzZQotCQkJCQlwVGNvbi0+YnJva2VuX3Bvc2l4
X29wZW4gPSB0cnVlOwotCQkJfQorCQkJLyoKKwkJCSAqIFRoZSBjaGVjayBiZWxvdyB3b3JrcyBh
cm91bmQgYSBidWcgaW4gUE9TSVgKKwkJCSAqIG9wZW4gaW4gc2FtYmEgdmVyc2lvbnMgMy4zLjEg
YW5kIGVhcmxpZXIgd2hlcmUKKwkJCSAqIG9wZW4gY291bGQgaW5jb3JyZWN0bHkgZmFpbCB3aXRo
IGludmFsaWQgcGFyYW1ldGVyLgorCQkJICogSWYgZWl0aGVyIHRoYXQgb3Igb3Agbm90IHN1cHBv
cnRlZCByZXR1cm5lZCwgZm9sbG93CisJCQkgKiB0aGUgbm9ybWFsIGxvb2t1cC4KKwkJCSAqLwor
CQkJaWYgKChyYyA9PSAwKSB8fCAocmMgPT0gLUVOT0VOVCkpCisJCQkJcG9zaXhfb3BlbiA9IHRy
dWU7CisJCQllbHNlIGlmICgocmMgPT0gLUVJTlZBTCkgfHwgKHJjICE9IC1FT1BOT1RTVVBQKSkK
KwkJCQlwVGNvbi0+YnJva2VuX3Bvc2l4X29wZW4gPSB0cnVlOwogCQl9CiAJCWlmICghcG9zaXhf
b3BlbikKIAkJCXJjID0gY2lmc19nZXRfaW5vZGVfaW5mb191bml4KCZuZXdJbm9kZSwgZnVsbF9w
YXRoLAogCg==
--001e680f15587a2f96046a966c1d--
