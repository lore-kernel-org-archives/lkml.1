Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbZEWTX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbZEWTX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 15:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZEWTXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 15:23:20 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:36533 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZEWTXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 15:23:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=fRkAaUcV8Pbg79X0P9TcrpxeO5HbgCEdXWQn8dtp56CCMz0PawBj3plw31gZEdvG0k
         oHiXIOaM/p532OkUF1QhO4gExX7AWpeodE5qbcG0f/OFCm8V8ZbaH5I+ZPi6wxCDedRG
         xAfDbdYOkA76/FOlwSGQvnzueJMgD6vJgqN1g=
MIME-Version: 1.0
Date: Sat, 23 May 2009 14:23:20 -0500
Message-ID: <524f69650905231223t47935834x6f024d8817fc68b5@mail.gmail.com>
Subject: [CIFS] Avoid open on possible directories since Samba now rejects 
	them
From: Steve French <smfrench@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
Cc: Jeremy Allison <jra@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: multipart/mixed; boundary=000e0cd4041e5394be046a994f88
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd4041e5394be046a994f88
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The small fix below has passed testing (connectathon, dbench, and
some freelance tests so far, now running others) to at least three
server types.   Jeff has also tested it.  Fix now in the cifs-2.6.git
tree.   This or equivalent is a must fix for 2.6.30 to handle the
change to Samba that jra just made.


Small change (mostly formatting) to limit lookup based open calls to
file create only.

After discussion yesteday on samba-technical about the posix lookup
regression,  and looking at a problem with cifs posix open to one
particular Samba version, Jeff and JRA realized that Samba server's
behavior changed in this area (posix open behavior on files vs.
directories).   To make this behavior consistent, JRA just made a
fix to Samba server to alter how it handles open of directories (now
returning the equivalent of EISDIR instead of success). Since we don't
know at lookup time whether the inode is a directory or file (and
thus whether posix open will succeed with most current Samba server),
this change avoids the posix open code on lookup open (just issues
posix open on creates).    This gets the semantic benefits we want
(atomicity, posix byte range locks, improved write semantics on newly
created files) and file create still is fast, and we avoid the problem
that Jeff noticed yesterday with "openat" (and some open directory
calls) of non-cached directories to one version of Samba server, and
will work with future Samba versions (which include the fix jra just
pushed into Samba server).  I confirmed this approach with jra
yesterday and with Shirish today.

Posix open is only called (at lookup time) for file create now.
For opens (rather than creates), because we do not know if it
is a file or directory yet, and current Samba no longer allows
us to do posix open on dirs, we could end up wasting an open call
on what turns out to be a dir. For file opens, we wait to call posix
open till cifs_open.  It could be added here (lookup) in the future
but the performance tradeoff of the extra network request when EISDIR
or EACCES is returned would have to be weighed against the 50%
reduction in network traffic in the other paths.

    Reviewed-by: Shirish Pargaonkar <shirishp@us.ibm.com>
    Tested-by: Jeff Layton <jlayton@redhat.com>
    CC: Jeremy Allison <jra@samba.org>
    Signed-off-by: Steve French <sfrench@us.ibm.com>

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

-- 
Thanks,

Steve

--000e0cd4041e5394be046a994f88
Content-Type: text/x-diff; charset=US-ASCII; name="cifs-lookup-create.patch"
Content-Disposition: attachment; filename="cifs-lookup-create.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fv2phfwn0

Y29tbWl0IDhkYjE0Y2ExMjU2OWZlODg1Njk0YmQzZDVmZjg0YzJkOTczZDNjYjAKQXV0aG9yOiBT
dGV2ZSBGcmVuY2ggPHNmcmVuY2hAdXMuaWJtLmNvbT4KRGF0ZTogICBTYXQgTWF5IDIzIDE4OjU3
OjI1IDIwMDkgKzAwMDAKCiAgICBbQ0lGU10gQXZvaWQgb3BlbiBvbiBwb3NzaWJsZSBkaXJlY3Rv
cmllcyBzaW5jZSBTYW1iYSBub3cgcmVqZWN0cyB0aGVtCiAgICAKICAgIFNtYWxsIGNoYW5nZSAo
bW9zdGx5IGZvcm1hdHRpbmcpIHRvIGxpbWl0IGxvb2t1cCBiYXNlZCBvcGVuIGNhbGxzIHRvCiAg
ICBmaWxlIGNyZWF0ZSBvbmx5LgogICAgCiAgICBBZnRlciBkaXNjdXNzaW9uIHllc3RlZGF5IG9u
IHNhbWJhLXRlY2huaWNhbCBhYm91dCB0aGUgcG9zaXggbG9va3VwCiAgICByZWdyZXNzaW9uLCAg
YW5kIGxvb2tpbmcgYXQgYSBwcm9ibGVtIHdpdGggY2lmcyBwb3NpeCBvcGVuIHRvIG9uZQogICAg
cGFydGljdWxhciBTYW1iYSB2ZXJzaW9uLCBKZWZmIGFuZCBKUkEgcmVhbGl6ZWQgdGhhdCBTYW1i
YSBzZXJ2ZXIncwogICAgYmVoYXZpb3IgY2hhbmdlZCBpbiB0aGlzIGFyZWEgKHBvc2l4IG9wZW4g
YmVoYXZpb3Igb24gZmlsZXMgdnMuCiAgICBkaXJlY3RvcmllcykuICAgVG8gbWFrZSB0aGlzIGJl
aGF2aW9yIGNvbnNpc3RlbnQsIEpSQSBqdXN0IG1hZGUgYQogICAgZml4IHRvIFNhbWJhIHNlcnZl
ciB0byBhbHRlciBob3cgaXQgaGFuZGxlcyBvcGVuIG9mIGRpcmVjdG9yaWVzIChub3cKICAgIHJl
dHVybmluZyB0aGUgZXF1aXZhbGVudCBvZiBFSVNESVIgaW5zdGVhZCBvZiBzdWNjZXNzKS4gU2lu
Y2Ugd2UgZG9uJ3QKICAgIGtub3cgYXQgbG9va3VwIHRpbWUgd2hldGhlciB0aGUgaW5vZGUgaXMg
YSBkaXJlY3Rvcnkgb3IgZmlsZSAoYW5kCiAgICB0aHVzIHdoZXRoZXIgcG9zaXggb3BlbiB3aWxs
IHN1Y2NlZWQgd2l0aCBtb3N0IGN1cnJlbnQgU2FtYmEgc2VydmVyKSwKICAgIHRoaXMgY2hhbmdl
IGF2b2lkcyB0aGUgcG9zaXggb3BlbiBjb2RlIG9uIGxvb2t1cCBvcGVuIChqdXN0IGlzc3Vlcwog
ICAgcG9zaXggb3BlbiBvbiBjcmVhdGVzKS4gICAgVGhpcyBnZXRzIHRoZSBzZW1hbnRpYyBiZW5l
Zml0cyB3ZSB3YW50CiAgICAoYXRvbWljaXR5LCBwb3NpeCBieXRlIHJhbmdlIGxvY2tzLCBpbXBy
b3ZlZCB3cml0ZSBzZW1hbnRpY3Mgb24gbmV3bHkKICAgIGNyZWF0ZWQgZmlsZXMpIGFuZCBmaWxl
IGNyZWF0ZSBzdGlsbCBpcyBmYXN0LCBhbmQgd2UgYXZvaWQgdGhlIHByb2JsZW0KICAgIHRoYXQg
SmVmZiBub3RpY2VkIHllc3RlcmRheSB3aXRoICJvcGVuYXQiIChhbmQgc29tZSBvcGVuIGRpcmVj
dG9yeQogICAgY2FsbHMpIG9mIG5vbi1jYWNoZWQgZGlyZWN0b3JpZXMgdG8gb25lIHZlcnNpb24g
b2YgU2FtYmEgc2VydmVyLCBhbmQKICAgIHdpbGwgd29yayB3aXRoIGZ1dHVyZSBTYW1iYSB2ZXJz
aW9ucyAod2hpY2ggaW5jbHVkZSB0aGUgZml4IGpyYSBqdXN0CiAgICBwdXNoZWQgaW50byBTYW1i
YSBzZXJ2ZXIpLiAgSSBjb25maXJtZWQgdGhpcyBhcHByb2FjaCB3aXRoIGpyYQogICAgeWVzdGVy
ZGF5IGFuZCB3aXRoIFNoaXJpc2ggdG9kYXkuCiAgICAKICAgIFBvc2l4IG9wZW4gaXMgb25seSBj
YWxsZWQgKGF0IGxvb2t1cCB0aW1lKSBmb3IgZmlsZSBjcmVhdGUgbm93LgogICAgRm9yIG9wZW5z
IChyYXRoZXIgdGhhbiBjcmVhdGVzKSwgYmVjYXVzZSB3ZSBkbyBub3Qga25vdyBpZiBpdAogICAg
aXMgYSBmaWxlIG9yIGRpcmVjdG9yeSB5ZXQsIGFuZCBjdXJyZW50IFNhbWJhIG5vIGxvbmdlciBh
bGxvd3MKICAgIHVzIHRvIGRvIHBvc2l4IG9wZW4gb24gZGlycywgd2UgY291bGQgZW5kIHVwIHdh
c3RpbmcgYW4gb3BlbiBjYWxsCiAgICBvbiB3aGF0IHR1cm5zIG91dCB0byBiZSBhIGRpci4gRm9y
IGZpbGUgb3BlbnMsIHdlIHdhaXQgdG8gY2FsbCBwb3NpeAogICAgb3BlbiB0aWxsIGNpZnNfb3Bl
bi4gIEl0IGNvdWxkIGJlIGFkZGVkIGhlcmUgKGxvb2t1cCkgaW4gdGhlIGZ1dHVyZQogICAgYnV0
IHRoZSBwZXJmb3JtYW5jZSB0cmFkZW9mZiBvZiB0aGUgZXh0cmEgbmV0d29yayByZXF1ZXN0IHdo
ZW4gRUlTRElSCiAgICBvciBFQUNDRVMgaXMgcmV0dXJuZWQgd291bGQgaGF2ZSB0byBiZSB3ZWln
aGVkIGFnYWluc3QgdGhlIDUwJQogICAgcmVkdWN0aW9uIGluIG5ldHdvcmsgdHJhZmZpYyBpbiB0
aGUgb3RoZXIgcGF0aHMuCiAgICAKICAgIFJldmlld2VkLWJ5OiBTaGlyaXNoIFBhcmdhb25rYXIg
PHNoaXJpc2hwQHVzLmlibS5jb20+CiAgICBUZXN0ZWQtYnk6IEplZmYgTGF5dG9uIDxqbGF5dG9u
QHJlZGhhdC5jb20+CiAgICBDQzogSmVyZW15IEFsbGlzb24gPGpyYUBzYW1iYS5vcmc+CiAgICBT
aWduZWQtb2ZmLWJ5OiBTdGV2ZSBGcmVuY2ggPHNmcmVuY2hAdXMuaWJtLmNvbT4KCmRpZmYgLS1n
aXQgYS9mcy9jaWZzL2Rpci5jIGIvZnMvY2lmcy9kaXIuYwppbmRleCBmNDlkNjg0Li4zNzU4OTY1
IDEwMDY0NAotLS0gYS9mcy9jaWZzL2Rpci5jCisrKyBiL2ZzL2NpZnMvZGlyLmMKQEAgLTY1Nywz
MSArNjU3LDM2IEBAIGNpZnNfbG9va3VwKHN0cnVjdCBpbm9kZSAqcGFyZW50X2Rpcl9pbm9kZSwg
c3RydWN0IGRlbnRyeSAqZGlyZW50cnksCiAJfQogCWNGWUkoMSwgKCJGdWxsIHBhdGg6ICVzIGlu
b2RlID0gMHglcCIsIGZ1bGxfcGF0aCwgZGlyZW50cnktPmRfaW5vZGUpKTsKIAorCS8qIFBvc2l4
IG9wZW4gaXMgb25seSBjYWxsZWQgKGF0IGxvb2t1cCB0aW1lKSBmb3IgZmlsZSBjcmVhdGUgbm93
LgorCSAqIEZvciBvcGVucyAocmF0aGVyIHRoYW4gY3JlYXRlcyksIGJlY2F1c2Ugd2UgZG8gbm90
IGtub3cgaWYgaXQKKwkgKiBpcyBhIGZpbGUgb3IgZGlyZWN0b3J5IHlldCwgYW5kIGN1cnJlbnQg
U2FtYmEgbm8gbG9uZ2VyIGFsbG93cworCSAqIHVzIHRvIGRvIHBvc2l4IG9wZW4gb24gZGlycywg
d2UgY291bGQgZW5kIHVwIHdhc3RpbmcgYW4gb3BlbiBjYWxsCisJICogb24gd2hhdCB0dXJucyBv
dXQgdG8gYmUgYSBkaXIuIEZvciBmaWxlIG9wZW5zLCB3ZSB3YWl0IHRvIGNhbGwgcG9zaXgKKwkg
KiBvcGVuIHRpbGwgY2lmc19vcGVuLiAgSXQgY291bGQgYmUgYWRkZWQgaGVyZSAobG9va3VwKSBp
biB0aGUgZnV0dXJlCisJICogYnV0IHRoZSBwZXJmb3JtYW5jZSB0cmFkZW9mZiBvZiB0aGUgZXh0
cmEgbmV0d29yayByZXF1ZXN0IHdoZW4gRUlTRElSCisJICogb3IgRUFDQ0VTIGlzIHJldHVybmVk
IHdvdWxkIGhhdmUgdG8gYmUgd2VpZ2hlZCBhZ2FpbnN0IHRoZSA1MCUKKwkgKiByZWR1Y3Rpb24g
aW4gbmV0d29yayB0cmFmZmljIGluIHRoZSBvdGhlciBwYXRocy4KKwkgKi8KIAlpZiAocFRjb24t
PnVuaXhfZXh0KSB7CiAJCWlmICghKG5kLT5mbGFncyAmIChMT09LVVBfUEFSRU5UIHwgTE9PS1VQ
X0RJUkVDVE9SWSkpICYmCi0JCSAgICAgKG5kLT5mbGFncyAmIExPT0tVUF9PUEVOKSAmJiAhcFRj
b24tPmJyb2tlbl9wb3NpeF9vcGVuKSB7Ci0JCQlpZiAoISgobmQtPmludGVudC5vcGVuLmZsYWdz
ICYgT19DUkVBVCkgJiYKLQkJCQkJKG5kLT5pbnRlbnQub3Blbi5mbGFncyAmIE9fRVhDTCkpKSB7
Ci0JCQkJcmMgPSBjaWZzX3Bvc2l4X29wZW4oZnVsbF9wYXRoLCAmbmV3SW5vZGUsCisJCSAgICAg
KG5kLT5mbGFncyAmIExPT0tVUF9PUEVOKSAmJiAhcFRjb24tPmJyb2tlbl9wb3NpeF9vcGVuICYm
CisJCSAgICAgKG5kLT5pbnRlbnQub3Blbi5mbGFncyAmIE9fQ1JFQVQpKSB7CisJCQlyYyA9IGNp
ZnNfcG9zaXhfb3BlbihmdWxsX3BhdGgsICZuZXdJbm9kZSwKIAkJCQkJcGFyZW50X2Rpcl9pbm9k
ZS0+aV9zYiwKIAkJCQkJbmQtPmludGVudC5vcGVuLmNyZWF0ZV9tb2RlLAogCQkJCQluZC0+aW50
ZW50Lm9wZW4uZmxhZ3MsICZvcGxvY2ssCiAJCQkJCSZmaWxlSGFuZGxlLCB4aWQpOwotCQkJCS8q
Ci0JCQkJICogVGhpcyBjb2RlIHdvcmtzIGFyb3VuZCBhIGJ1ZyBpbgotCQkJCSAqIHNhbWJhIHBv
c2l4IG9wZW4gaW4gc2FtYmEgdmVyc2lvbnMgMy4zLjEKLQkJCQkgKiBhbmQgZWFybGllciB3aGVy
ZSBjcmVhdGUgd29ya3MKLQkJCQkgKiBidXQgb3BlbiBmYWlscyB3aXRoIGludmFsaWQgcGFyYW1l
dGVyLgotCQkJCSAqIElmIGVpdGhlciBvZiB0aGVzZSBlcnJvciBjb2RlcyBhcmUKLQkJCQkgKiBy
ZXR1cm5lZCwgZm9sbG93IHRoZSBub3JtYWwgbG9va3VwLgotCQkJCSAqIE90aGVyd2lzZSwgdGhl
IGVycm9yIGR1cmluZyBwb3NpeCBvcGVuCi0JCQkJICogaXMgaGFuZGxlZC4KLQkJCQkgKi8KLQkJ
CQlpZiAoKHJjICE9IC1FSU5WQUwpICYmIChyYyAhPSAtRU9QTk9UU1VQUCkpCi0JCQkJCXBvc2l4
X29wZW4gPSB0cnVlOwotCQkJCWVsc2UKLQkJCQkJcFRjb24tPmJyb2tlbl9wb3NpeF9vcGVuID0g
dHJ1ZTsKLQkJCX0KKwkJCS8qCisJCQkgKiBUaGUgY2hlY2sgYmVsb3cgd29ya3MgYXJvdW5kIGEg
YnVnIGluIFBPU0lYCisJCQkgKiBvcGVuIGluIHNhbWJhIHZlcnNpb25zIDMuMy4xIGFuZCBlYXJs
aWVyIHdoZXJlCisJCQkgKiBvcGVuIGNvdWxkIGluY29ycmVjdGx5IGZhaWwgd2l0aCBpbnZhbGlk
IHBhcmFtZXRlci4KKwkJCSAqIElmIGVpdGhlciB0aGF0IG9yIG9wIG5vdCBzdXBwb3J0ZWQgcmV0
dXJuZWQsIGZvbGxvdworCQkJICogdGhlIG5vcm1hbCBsb29rdXAuCisJCQkgKi8KKwkJCWlmICgo
cmMgPT0gMCkgfHwgKHJjID09IC1FTk9FTlQpKQorCQkJCXBvc2l4X29wZW4gPSB0cnVlOworCQkJ
ZWxzZSBpZiAoKHJjID09IC1FSU5WQUwpIHx8IChyYyAhPSAtRU9QTk9UU1VQUCkpCisJCQkJcFRj
b24tPmJyb2tlbl9wb3NpeF9vcGVuID0gdHJ1ZTsKIAkJfQogCQlpZiAoIXBvc2l4X29wZW4pCiAJ
CQlyYyA9IGNpZnNfZ2V0X2lub2RlX2luZm9fdW5peCgmbmV3SW5vZGUsIGZ1bGxfcGF0aCwK
--000e0cd4041e5394be046a994f88--
