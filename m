Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbZEWC26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbZEWC26 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 22:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbZEWC2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 22:28:50 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:1497 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbZEWC2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 22:28:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=jEscOLhmWZ6enSMv17iR8nbInt1F/r/rFi+TVkqlO6Hnd78XH9tBYFLLLNMvqKhaxO
         UGpxBg1PphSVg4gPowoI6pH9X7Php9GxhNCMz9LKSWWk/OvHzN5Fk83L7yj1OtaVHZ5Q
         z9Uj5b6VUZbK+dVs71iwepQ46iKB3QPRKBATU=
MIME-Version: 1.0
Date: Fri, 22 May 2009 21:28:50 -0500
Message-ID: <524f69650905221928he49410ay75000927c73bf93b@mail.gmail.com>
Subject: [CIFS] One more posix open patch on the way
From: Steve French <smfrench@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: multipart/mixed; boundary=0015175113e2305ac6046a8b23e2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0015175113e2305ac6046a8b23e2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

One small additional fix to posix open is being reviewed to address
something Jeff and JRA noticed this morning.

After discussion today on samba-technical about the posix lookup open
regression,  and looking at a problem with cifs posix open to one
particular Samba version, Jeff and JRA realized that Samba server's
behavior changed in this area (posix open behavior on files vs.
directories) too.   To make this behavior consistent, JRA just made a
fix to Samba server to alter how it handles open of directories (now
returning the equivalent of EISDIR instead of success). Since we don't
know at lookup time whether the inode is a directory or file (and thus
whether posix open will succeed with most current Samba server), I am
testing a change which avoids the posix open code on lookup open (just
issues posix open on creates).    This gets the semantic benefits we
want (posix byte range locks, improved write semantics etc. on newly
created files) and file create still is fast, and we avoid the problem
that Jeff noticed this morning with "openat" (and some open directory
calls) of non-cached directories to one version of Samba server, and
will work with future Samba versions (which include the fix jra just
pushed into Samba server).

The small fix attached (or something like it), is a mustfix before
2.6.30 goes out, but want to give Shirish, and Jeff time to look at
it.  The main part (other than a trivial rc mapping change) is this
change to cifs_lookup

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index f49d684..c306d3f 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -660,8 +660,16 @@ cifs_lookup(struct inode *parent_dir_inode,
struct dentry *direntry,
 	if (pTcon->unix_ext) {
 		if (!(nd->flags & (LOOKUP_PARENT | LOOKUP_DIRECTORY)) &&
 		     (nd->flags & LOOKUP_OPEN) && !pTcon->broken_posix_open) {
-			if (!((nd->intent.open.flags & O_CREAT) &&
-					(nd->intent.open.flags & O_EXCL))) {
+			if (nd->intent.open.flags & O_CREAT) {
+				/* POSIX open here is only called for file
+				   create. It does not help much for file opens
+				   because we do not know if it is a file
+				   or directory, and current Samba no
+				   longer allows us to do posix open on dirs,
+				   so we could end up wasting an open
+				   call on what turns out to be a dir.
+				   For file opens, we call posix open
+				   in cifs_open */
 				rc = cifs_posix_open(full_path, &newInode,
 					parent_dir_inode->i_sb,
 					nd->intent.open.create_mode,
-- 
Thanks,

Steve

--0015175113e2305ac6046a8b23e2
Content-Type: text/x-diff; charset=US-ASCII; 
	name="posix-open-only-on-create-and-fix-isdir-error-mapping.patch"
Content-Disposition: attachment; 
	filename="posix-open-only-on-create-and-fix-isdir-error-mapping.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fv1p9yco0

ZGlmZiAtLWdpdCBhL2ZzL2NpZnMvZGlyLmMgYi9mcy9jaWZzL2Rpci5jCmluZGV4IGY0OWQ2ODQu
LmMzMDZkM2YgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvZGlyLmMKKysrIGIvZnMvY2lmcy9kaXIuYwpA
QCAtNjYwLDggKzY2MCwxNiBAQCBjaWZzX2xvb2t1cChzdHJ1Y3QgaW5vZGUgKnBhcmVudF9kaXJf
aW5vZGUsIHN0cnVjdCBkZW50cnkgKmRpcmVudHJ5LAogCWlmIChwVGNvbi0+dW5peF9leHQpIHsK
IAkJaWYgKCEobmQtPmZsYWdzICYgKExPT0tVUF9QQVJFTlQgfCBMT09LVVBfRElSRUNUT1JZKSkg
JiYKIAkJICAgICAobmQtPmZsYWdzICYgTE9PS1VQX09QRU4pICYmICFwVGNvbi0+YnJva2VuX3Bv
c2l4X29wZW4pIHsKLQkJCWlmICghKChuZC0+aW50ZW50Lm9wZW4uZmxhZ3MgJiBPX0NSRUFUKSAm
JgotCQkJCQkobmQtPmludGVudC5vcGVuLmZsYWdzICYgT19FWENMKSkpIHsKKwkJCWlmIChuZC0+
aW50ZW50Lm9wZW4uZmxhZ3MgJiBPX0NSRUFUKSB7CisJCQkJLyogUE9TSVggb3BlbiBoZXJlIGlz
IG9ubHkgY2FsbGVkIGZvciBmaWxlCisJCQkJICAgY3JlYXRlLiBJdCBkb2VzIG5vdCBoZWxwIG11
Y2ggZm9yIGZpbGUgb3BlbnMKKwkJCQkgICBiZWNhdXNlIHdlIGRvIG5vdCBrbm93IGlmIGl0IGlz
IGEgZmlsZQorCQkJCSAgIG9yIGRpcmVjdG9yeSwgYW5kIGN1cnJlbnQgU2FtYmEgbm8KKwkJCQkg
ICBsb25nZXIgYWxsb3dzIHVzIHRvIGRvIHBvc2l4IG9wZW4gb24gZGlycywKKwkJCQkgICBzbyB3
ZSBjb3VsZCBlbmQgdXAgd2FzdGluZyBhbiBvcGVuCisJCQkJICAgY2FsbCBvbiB3aGF0IHR1cm5z
IG91dCB0byBiZSBhIGRpci4gCisJCQkJICAgRm9yIGZpbGUgb3BlbnMsIHdlIGNhbGwgcG9zaXgg
b3BlbgorCQkJCSAgIGluIGNpZnNfb3BlbiAqLwogCQkJCXJjID0gY2lmc19wb3NpeF9vcGVuKGZ1
bGxfcGF0aCwgJm5ld0lub2RlLAogCQkJCQlwYXJlbnRfZGlyX2lub2RlLT5pX3NiLAogCQkJCQlu
ZC0+aW50ZW50Lm9wZW4uY3JlYXRlX21vZGUsCmRpZmYgLS1naXQgYS9mcy9jaWZzL25ldG1pc2Mu
YyBiL2ZzL2NpZnMvbmV0bWlzYy5jCmluZGV4IGUyZmU5OTguLmY0NjVhYWYgMTAwNjQ0Ci0tLSBh
L2ZzL2NpZnMvbmV0bWlzYy5jCisrKyBiL2ZzL2NpZnMvbmV0bWlzYy5jCkBAIC03OSw2ICs3OSw3
IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3Qgc21iX3RvX3Bvc2l4X2Vycm9yIG1hcHBpbmdfdGFibGVf
RVJSRE9TW10gPSB7CiAJe0VyclF1b3RhLCAtRURRVU9UfSwKIAl7RXJyTm90QUxpbmssIC1FTk9M
SU5LfSwKIAl7RVJSbmV0bG9nb25Ob3RTdGFydGVkLCAtRU5PUFJPVE9PUFR9LAorCXtFUlJpc2Rp
ciwgLUVJU0RJUn0sCiAJe0VSUnN5bWxpbmssIC1FT1BOT1RTVVBQfSwKIAl7RXJyVG9vTWFueUxp
bmtzLCAtRU1MSU5LfSwKIAl7MCwgMH0KQEAgLTM2OCw3ICszNjksNyBAQCBzdGF0aWMgY29uc3Qg
c3RydWN0IHsKIAlFUlJIUkQsIEVSUmdlbmVyYWwsIE5UX1NUQVRVU19QUk9GSUxJTkdfTk9UX1NU
QVJURUR9LCB7CiAJRVJSSFJELCBFUlJnZW5lcmFsLCBOVF9TVEFUVVNfUFJPRklMSU5HX05PVF9T
VE9QUEVEfSwgewogCUVSUkhSRCwgRVJSZ2VuZXJhbCwgTlRfU1RBVFVTX0NPVUxEX05PVF9JTlRF
UlBSRVR9LCB7Ci0JRVJSRE9TLCBFUlJub2FjY2VzcywgTlRfU1RBVFVTX0ZJTEVfSVNfQV9ESVJF
Q1RPUll9LCB7CisJRVJSRE9TLCBFUlJpc2RpciwgTlRfU1RBVFVTX0ZJTEVfSVNfQV9ESVJFQ1RP
Ull9LCB7CiAJRVJSRE9TLCBFUlJ1bnN1cCwgTlRfU1RBVFVTX05PVF9TVVBQT1JURUR9LCB7CiAJ
RVJSRE9TLCA1MSwgTlRfU1RBVFVTX1JFTU9URV9OT1RfTElTVEVOSU5HfSwgewogCUVSUkRPUywg
NTIsIE5UX1NUQVRVU19EVVBMSUNBVEVfTkFNRX0sIHsKZGlmZiAtLWdpdCBhL2ZzL2NpZnMvc21i
ZXJyLmggYi9mcy9jaWZzL3NtYmVyci5oCmluZGV4IGM1MDg0ZDIuLjU0ODE1MjUgMTAwNjQ0Ci0t
LSBhL2ZzL2NpZnMvc21iZXJyLmgKKysrIGIvZnMvY2lmcy9zbWJlcnIuaApAQCAtMTEwLDYgKzEx
MCw3IEBACiAKIC8qIEJlbG93IGVycm9ycyBhcmUgdXNlZCBpbnRlcm5hbGx5IChkbyBub3QgY29t
ZSBvdmVyIHRoZSB3aXJlKSBmb3IgcGFzc3Rocm91Z2gKICAgIGZyb20gU1RBVFVTIGNvZGVzIHRv
IFBPU0lYIG9ubHkgICovCisjZGVmaW5lIEVSUmlzZGlyCQkweEZGRkMKICNkZWZpbmUgRVJSc3lt
bGluayAgICAgICAgICAgICAgMHhGRkZECiAjZGVmaW5lIEVyclRvb01hbnlMaW5rcyAgICAgICAg
IDB4RkZGRQogCg==
--0015175113e2305ac6046a8b23e2--
