Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab0BYNpo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 08:45:44 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63077 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab0BYNpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 08:45:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=EpZUQeUn6BGcBgjaR08kPGzBUaYN1bKZKrW2laq/VPcdbAV2Ijk+2zxzuYDwEYyCLC
         ieekx3DevRW6fp34ckt6kVVnlLGx5eXqXWJOkB5MRpAcHxUGGf6ipGf/zqHRzHAj6aKU
         JLLS6O0rbpHhl4z/G7fxgUXZ6lhopZP3ZYMbA=
MIME-Version: 1.0
Date: Thu, 25 Feb 2010 19:15:42 +0530
Message-ID: <f5a7b3811002250545x3d5288cfqd114d3bcd79581f2@mail.gmail.com>
Subject: [PATCH] Synchronization required before release the lock: 
	sem_post/8-1.c
From: naresh kamboju <naresh.kernel@gmail.com>
To: ltp-list <ltp-list@lists.sourceforge.net>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>,
       Garrett Cooper <yanegomi@gmail.com>,
       Masatake YAMATO <yamato@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=000e0cd116f0c695b804806cffab
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd116f0c695b804806cffab
Content-Type: text/plain; charset=ISO-8859-1

Hi,

I have found abnormal behavior of sem_post/8-1.c test case under posix.
This test case passes in some times and failed in many times :-(

After my investigation found synchronization is missing between the
child processes.
Made a patch to fix this issue.

Patch includes
1.	Reverting back changes made by mreed on Sep 25 2006. Making sure
child has been waiting for the lock (below Refs).
2.	using sleep in while loop is not a good idea, so sleep is removed
from while loop
3.	For the synchronization I have added sleep before releasing the lock.


After applying this patch I have tested this test case 1000 times continuously.
All the times test case reported as Test Pass :-)


Signed-off-by: Naresh Kamboju < naresh.kernel@gmail.com >
---
 testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c
|   15    8 +     7 -     0 !
 1 file changed, 8 insertions(+), 7 deletions(-)

Index: b/testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c
===================================================================
--- a/testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c
+++ b/testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c
@@ -161,7 +161,6 @@ int main()
        }
        fprintf(stderr, "P: child_1:%d forked\n", c_1);

-       sleep(1);
        c_2 = fork();
        if (c_2 == 0)
        {
@@ -176,13 +175,13 @@ int main()
        }
        fprintf(stderr, "P: child_2: %d forked\n", c_2);

+        /* Step 3 Implementation */
        /* Make sure the two children has been waiting */
-       /*do {
-               sleep(1);
+       do {
                sem_getvalue(sem_1, &val);
                //printf("val = %d\n", val);
        } while (val != 1);
-       */
+
        c_3 = fork();
        if (c_3 == 0)
        {
@@ -191,13 +190,15 @@ int main()
        }
        fprintf(stderr, "P: child_3: %d forked\n", c_3);

+        /* Step 3 Implementation */
        /* Make sure child 3 has been waiting for the lock */
-       /*do {
-               sleep(1);
+       do {
                sem_getvalue(sem_1, &val);
                //printf("val = %d\n", val);
        } while (val != 0);
-       */
+
+       /* Synchronization required before release the lock */
+       sleep(1);
        /* Ok, let's release the lock */
        fprintf(stderr, "P: release lock\n");
        sem_post(sem);


Test script to test 1000 times:
/*****************************************************/
#!/bin/sh

for ((  i = 0 ;  i < 1000;  i++  ))

do

./8-1.test >> /tmp/sem-post-8-1.log
done
/*****************************************************/

Refs:
http://ltp.cvs.sourceforge.net/viewvc/ltp/ltp/testcases/open_posix_testsuite/conformance/interfaces/sem_post/8-1.c?view=log

Please review this patch and let me know if you have any issues.

Best regards
Naresh Kamboju

--000e0cd116f0c695b804806cffab
Content-Type: application/octet-stream; 
	name="posix-sem-post-unstable-fix.patch"
Content-Disposition: attachment; 
	filename="posix-sem-post-unstable-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g63lfu7i0

LS0tCiB0ZXN0Y2FzZXMvb3Blbl9wb3NpeF90ZXN0c3VpdGUvY29uZm9ybWFuY2UvaW50ZXJmYWNl
cy9zZW1fcG9zdC84LTEuYyB8ICAgMTUgCTggKwk3IC0JMCAhCiAxIGZpbGUgY2hhbmdlZCwgOCBp
bnNlcnRpb25zKCspLCA3IGRlbGV0aW9ucygtKQoKSW5kZXg6IGIvdGVzdGNhc2VzL29wZW5fcG9z
aXhfdGVzdHN1aXRlL2NvbmZvcm1hbmNlL2ludGVyZmFjZXMvc2VtX3Bvc3QvOC0xLmMKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PQotLS0gYS90ZXN0Y2FzZXMvb3Blbl9wb3NpeF90ZXN0c3VpdGUvY29uZm9ybWFuY2UvaW50
ZXJmYWNlcy9zZW1fcG9zdC84LTEuYworKysgYi90ZXN0Y2FzZXMvb3Blbl9wb3NpeF90ZXN0c3Vp
dGUvY29uZm9ybWFuY2UvaW50ZXJmYWNlcy9zZW1fcG9zdC84LTEuYwpAQCAtMTYxLDcgKzE2MSw2
IEBAIGludCBtYWluKCkgCiAJfQogCWZwcmludGYoc3RkZXJyLCAiUDogY2hpbGRfMTolZCBmb3Jr
ZWRcbiIsIGNfMSk7CiAJCi0Jc2xlZXAoMSk7CiAJY18yID0gZm9yaygpOwogCWlmIChjXzIgPT0g
MCkKIAl7CkBAIC0xNzYsMTMgKzE3NSwxMyBAQCBpbnQgbWFpbigpIAogCX0KIAlmcHJpbnRmKHN0
ZGVyciwgIlA6IGNoaWxkXzI6ICVkIGZvcmtlZFxuIiwgY18yKTsKIAorICAgICAgICAvKiBTdGVw
IDMgSW1wbGVtZW50YXRpb24gKi8KIAkvKiBNYWtlIHN1cmUgdGhlIHR3byBjaGlsZHJlbiBoYXMg
YmVlbiB3YWl0aW5nICovCQotCS8qZG8geyAKLQkJc2xlZXAoMSk7CisJZG8gewogCQlzZW1fZ2V0
dmFsdWUoc2VtXzEsICZ2YWwpOwogCQkvL3ByaW50ZigidmFsID0gJWRcbiIsIHZhbCk7CiAJfSB3
aGlsZSAodmFsICE9IDEpOwotCSovCisKIAljXzMgPSBmb3JrKCk7CiAJaWYgKGNfMyA9PSAwKQog
CXsKQEAgLTE5MSwxMyArMTkwLDE1IEBAIGludCBtYWluKCkgCiAJfQogCWZwcmludGYoc3RkZXJy
LCAiUDogY2hpbGRfMzogJWQgZm9ya2VkXG4iLCBjXzMpOwogCQorICAgICAgICAvKiBTdGVwIDMg
SW1wbGVtZW50YXRpb24gKi8KIAkvKiBNYWtlIHN1cmUgY2hpbGQgMyBoYXMgYmVlbiB3YWl0aW5n
IGZvciB0aGUgbG9jayAqLwkKLQkvKmRvIHsgCi0JCXNsZWVwKDEpOworCWRvIHsKIAkJc2VtX2dl
dHZhbHVlKHNlbV8xLCAmdmFsKTsKIAkJLy9wcmludGYoInZhbCA9ICVkXG4iLCB2YWwpOwogCX0g
d2hpbGUgKHZhbCAhPSAwKTsKLQkqLworCisJLyogU3luY2hyb25pemF0aW9uIHJlcXVpcmVkIGJl
Zm9yZSByZWxlYXNlIHRoZSBsb2NrICovCisJc2xlZXAoMSk7CiAJLyogT2ssIGxldCdzIHJlbGVh
c2UgdGhlIGxvY2sgKi8KIAlmcHJpbnRmKHN0ZGVyciwgIlA6IHJlbGVhc2UgbG9ja1xuIik7CiAJ
c2VtX3Bvc3Qoc2VtKTsK
--000e0cd116f0c695b804806cffab--
