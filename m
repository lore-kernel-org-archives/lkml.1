Return-Path: <linux-kernel-owner+w=401wt.eu-S1759552AbZDQSOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552AbZDQSOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 14:14:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762044AbZDQSOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 14:14:16 -0400
Received: from exprod6og110.obsmtp.com ([64.18.1.25]:50367 "HELO
	exprod6og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759417AbZDQSOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 14:14:15 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C9BF88.3DEBFDA3"
Subject: RE: [PATCH] mm/page-writeback.c: fix sparse warnings
Date: Fri, 17 Apr 2009 14:13:39 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F91A0@mi8nycmail19.Mi8.com>
In-Reply-To: <20090417052730.GA2505@cmpxchg.org>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mm/page-writeback.c: fix sparse warnings
Thread-Index: Acm/HUDGtByjUv3cTY+GFZ0eojNFTQAaieUg
References: <BD79186B4FD85F4B8E60E381CAEE1909015F9049@mi8nycmail19.Mi8.com> <20090417052730.GA2505@cmpxchg.org>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Johannes Weiner" <hannes@cmpxchg.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Apr 2009 18:14:12.0652 (UTC) FILETIME=[4F786EC0:01C9BF88]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C9BF88.3DEBFDA3
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

mm: dirty limit type specifies should be unsigned long

get_dirty_limits() calls clip_bdi_dirty_limit() and task_dirty_limit()
with variable pbdi_dirty as one of the arguments. This variable is
an unsigned long * but both functions expect it to be a long *. This
causes the following sparse warnings:
=20
  warning: incorrect type in argument 3 (different signedness)
     expected long *pbdi_dirty
     got unsigned long *pbdi_dirty
  warning: incorrect type in argument 2 (different signedness)
     expected long *pdirty
     got unsigned long *pbdi_dirty
=20
Fix the warnings by changing the long * to unsigned long * in both
functions.
=20
Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

Patch is also attached due to line wrapping in email.


diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 30351f0..ad2a414 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -265,18 +265,19 @@ static void bdi_writeout_fraction(struct
backing_dev_info *bdi,
  * This avoids exceeding the total dirty_limit when the floating
averages
  * fluctuate too quickly.
  */
-static void
-clip_bdi_dirty_limit(struct backing_dev_info *bdi, long dirty, long
*pbdi_dirty)
+static void clip_bdi_dirty_limit(struct backing_dev_info *bdi,
+		unsigned long dirty, unsigned long *pbdi_dirty)
 {
-	long avail_dirty;
+	unsigned long avail_dirty;
=20
-	avail_dirty =3D dirty -
-		(global_page_state(NR_FILE_DIRTY) +
+	avail_dirty =3D global_page_state(NR_FILE_DIRTY) +
 		 global_page_state(NR_WRITEBACK) +
 		 global_page_state(NR_UNSTABLE_NFS) +
-		 global_page_state(NR_WRITEBACK_TEMP));
+		 global_page_state(NR_WRITEBACK_TEMP);
=20
-	if (avail_dirty < 0)
+	if (avail_dirty < dirty)
+		avail_dirty =3D dirty - avail_dirty;
+	else
 		avail_dirty =3D 0;
=20
 	avail_dirty +=3D bdi_stat(bdi, BDI_RECLAIMABLE) +
@@ -299,10 +300,10 @@ static inline void task_dirties_fraction(struct
task_struct *tsk,
  *
  *   dirty -=3D (dirty/8) * p_{t}
  */
-static void task_dirty_limit(struct task_struct *tsk, long *pdirty)
+static void task_dirty_limit(struct task_struct *tsk, unsigned long
*pdirty)
 {
 	long numerator, denominator;
-	long dirty =3D *pdirty;
+	unsigned long dirty =3D *pdirty;
 	u64 inv =3D dirty >> 3;
=20
 	task_dirties_fraction(tsk, &numerator, &denominator);=20

------_=_NextPart_001_01C9BF88.3DEBFDA3
Content-Type: application/octet-stream;
	name="mm_page-writeback_sparse.patch"
Content-Transfer-Encoding: base64
Content-Description: mm_page-writeback_sparse.patch
Content-Disposition: attachment;
	filename="mm_page-writeback_sparse.patch"

ZGlmZiAtLWdpdCBhL21tL3BhZ2Utd3JpdGViYWNrLmMgYi9tbS9wYWdlLXdyaXRlYmFjay5jCmlu
ZGV4IDMwMzUxZjAuLmFkMmE0MTQgMTAwNjQ0Ci0tLSBhL21tL3BhZ2Utd3JpdGViYWNrLmMKKysr
IGIvbW0vcGFnZS13cml0ZWJhY2suYwpAQCAtMjY1LDE4ICsyNjUsMTkgQEAgc3RhdGljIHZvaWQg
YmRpX3dyaXRlb3V0X2ZyYWN0aW9uKHN0cnVjdCBiYWNraW5nX2Rldl9pbmZvICpiZGksCiAgKiBU
aGlzIGF2b2lkcyBleGNlZWRpbmcgdGhlIHRvdGFsIGRpcnR5X2xpbWl0IHdoZW4gdGhlIGZsb2F0
aW5nIGF2ZXJhZ2VzCiAgKiBmbHVjdHVhdGUgdG9vIHF1aWNrbHkuCiAgKi8KLXN0YXRpYyB2b2lk
Ci1jbGlwX2JkaV9kaXJ0eV9saW1pdChzdHJ1Y3QgYmFja2luZ19kZXZfaW5mbyAqYmRpLCBsb25n
IGRpcnR5LCBsb25nICpwYmRpX2RpcnR5KQorc3RhdGljIHZvaWQgY2xpcF9iZGlfZGlydHlfbGlt
aXQoc3RydWN0IGJhY2tpbmdfZGV2X2luZm8gKmJkaSwKKwkJdW5zaWduZWQgbG9uZyBkaXJ0eSwg
dW5zaWduZWQgbG9uZyAqcGJkaV9kaXJ0eSkKIHsKLQlsb25nIGF2YWlsX2RpcnR5OworCXVuc2ln
bmVkIGxvbmcgYXZhaWxfZGlydHk7CiAKLQlhdmFpbF9kaXJ0eSA9IGRpcnR5IC0KLQkJKGdsb2Jh
bF9wYWdlX3N0YXRlKE5SX0ZJTEVfRElSVFkpICsKKwlhdmFpbF9kaXJ0eSA9IGdsb2JhbF9wYWdl
X3N0YXRlKE5SX0ZJTEVfRElSVFkpICsKIAkJIGdsb2JhbF9wYWdlX3N0YXRlKE5SX1dSSVRFQkFD
SykgKwogCQkgZ2xvYmFsX3BhZ2Vfc3RhdGUoTlJfVU5TVEFCTEVfTkZTKSArCi0JCSBnbG9iYWxf
cGFnZV9zdGF0ZShOUl9XUklURUJBQ0tfVEVNUCkpOworCQkgZ2xvYmFsX3BhZ2Vfc3RhdGUoTlJf
V1JJVEVCQUNLX1RFTVApOwogCi0JaWYgKGF2YWlsX2RpcnR5IDwgMCkKKwlpZiAoYXZhaWxfZGly
dHkgPCBkaXJ0eSkKKwkJYXZhaWxfZGlydHkgPSBkaXJ0eSAtIGF2YWlsX2RpcnR5OworCWVsc2UK
IAkJYXZhaWxfZGlydHkgPSAwOwogCiAJYXZhaWxfZGlydHkgKz0gYmRpX3N0YXQoYmRpLCBCRElf
UkVDTEFJTUFCTEUpICsKQEAgLTI5OSwxMCArMzAwLDEwIEBAIHN0YXRpYyBpbmxpbmUgdm9pZCB0
YXNrX2RpcnRpZXNfZnJhY3Rpb24oc3RydWN0IHRhc2tfc3RydWN0ICp0c2ssCiAgKgogICogICBk
aXJ0eSAtPSAoZGlydHkvOCkgKiBwX3t0fQogICovCi1zdGF0aWMgdm9pZCB0YXNrX2RpcnR5X2xp
bWl0KHN0cnVjdCB0YXNrX3N0cnVjdCAqdHNrLCBsb25nICpwZGlydHkpCitzdGF0aWMgdm9pZCB0
YXNrX2RpcnR5X2xpbWl0KHN0cnVjdCB0YXNrX3N0cnVjdCAqdHNrLCB1bnNpZ25lZCBsb25nICpw
ZGlydHkpCiB7CiAJbG9uZyBudW1lcmF0b3IsIGRlbm9taW5hdG9yOwotCWxvbmcgZGlydHkgPSAq
cGRpcnR5OworCXVuc2lnbmVkIGxvbmcgZGlydHkgPSAqcGRpcnR5OwogCXU2NCBpbnYgPSBkaXJ0
eSA+PiAzOwogCiAJdGFza19kaXJ0aWVzX2ZyYWN0aW9uKHRzaywgJm51bWVyYXRvciwgJmRlbm9t
aW5hdG9yKTsK

------_=_NextPart_001_01C9BF88.3DEBFDA3--
