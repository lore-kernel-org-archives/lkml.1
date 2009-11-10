Return-Path: <linux-kernel-owner+w=401wt.eu-S1751849AbZKJGMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbZKJGMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 01:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZKJGMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 01:12:36 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:48248 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229AbZKJGMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 01:12:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=i2HtC8hedWQ+aRLHLEorjo2S+hTuh5MJLgqmgXS/BugxbQbeOZK6NsCByNzd7SqWDc
         27rDflDJabUJrHfY/Gsk515HSf68FwuFePRLlYNaEQS1lvqsosPKU+l1TX1b7S+CMHli
         /wVVcQGmsxKCg2ZXLus7XHFBq8yushIelhF38=
MIME-Version: 1.0
Date: Tue, 10 Nov 2009 14:12:41 +0800
Message-ID: <3877989d0911092212i367b9156n78d57aeee6742147@mail.gmail.com>
Subject: [RFC PATCH] use acpi_idle_enter_simple if bm_check && !.bm_control
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Len Brown <lenb@kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Content-Type: multipart/mixed; boundary=000e0cd4ce92a06f090477fe320e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd4ce92a06f090477fe320e
Content-Type: text/plain; charset=UTF-8

Hi there,

I came across acpi processor idle driver, noticed that we can cut a
bit overhead at C3 entry that can improve C3 residency a bit,
especially when it has similar kernel config as old RHEL 5 kernel
(2.6.18) on systems with as many as 64 logical CPUs. The point of this
patch is bm_sts is an optional bit. It never returns 1 on systems with
bm_check && !bm_control I tested. Instead, I have observed lower C3
residency due to accessing bm_sts and relevant code on a system with
64 logical CPUs with HZ=1000. Please review. If make sense, please
apply.

Ps. The patch is enclosed in attachment. The in-lined one is c&p of it
for reading.

Thanks,
Luming

Signed-off-by: Yu Luming <luming.yu@intel.com>

 processor_idle.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

 processor_idle.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)
[root@hp-core tmp]# cat 12.patch
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 66393d5..ee72bbb 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -895,7 +895,7 @@ static int acpi_idle_enter_simple(struct
cpuidle_device *dev,
 	 */
 	lapic_timer_state_broadcast(pr, cx, 1);

-	if (cx->type == ACPI_STATE_C3)
+	if (cx->type == ACPI_STATE_C3 && !pr->flags.bm_check)
 		ACPI_FLUSH_CPU_CACHE();

 	kt1 = ktime_get_real();
@@ -1110,6 +1110,8 @@ static int acpi_processor_setup_cpuidle(struct
acpi_processor *pr)
 			state->enter = pr->flags.bm_check ?
 					acpi_idle_enter_bm :
 					acpi_idle_enter_simple;
+			if (pr->flags.bm_check && !pr->flags.bm_control)
+				state->enter = acpi_idle_enter_simple;
 			break;
 		}

--000e0cd4ce92a06f090477fe320e
Content-Type: application/octet-stream; name="12.patch"
Content-Disposition: attachment; filename="12.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g1u9wtyk0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS9wcm9jZXNzb3JfaWRsZS5jIGIvZHJpdmVycy9hY3Bp
L3Byb2Nlc3Nvcl9pZGxlLmMKaW5kZXggNjYzOTNkNS4uZWU3MmJiYiAxMDA2NDQKLS0tIGEvZHJp
dmVycy9hY3BpL3Byb2Nlc3Nvcl9pZGxlLmMKKysrIGIvZHJpdmVycy9hY3BpL3Byb2Nlc3Nvcl9p
ZGxlLmMKQEAgLTg5NSw3ICs4OTUsNyBAQCBzdGF0aWMgaW50IGFjcGlfaWRsZV9lbnRlcl9zaW1w
bGUoc3RydWN0IGNwdWlkbGVfZGV2aWNlICpkZXYsCiAJICovCiAJbGFwaWNfdGltZXJfc3RhdGVf
YnJvYWRjYXN0KHByLCBjeCwgMSk7CiAKLQlpZiAoY3gtPnR5cGUgPT0gQUNQSV9TVEFURV9DMykK
KwlpZiAoY3gtPnR5cGUgPT0gQUNQSV9TVEFURV9DMyAmJiAhcHItPmZsYWdzLmJtX2NoZWNrKQog
CQlBQ1BJX0ZMVVNIX0NQVV9DQUNIRSgpOwogCiAJa3QxID0ga3RpbWVfZ2V0X3JlYWwoKTsKQEAg
LTExMTAsNiArMTExMCw4IEBAIHN0YXRpYyBpbnQgYWNwaV9wcm9jZXNzb3Jfc2V0dXBfY3B1aWRs
ZShzdHJ1Y3QgYWNwaV9wcm9jZXNzb3IgKnByKQogCQkJc3RhdGUtPmVudGVyID0gcHItPmZsYWdz
LmJtX2NoZWNrID8KIAkJCQkJYWNwaV9pZGxlX2VudGVyX2JtIDoKIAkJCQkJYWNwaV9pZGxlX2Vu
dGVyX3NpbXBsZTsKKwkJCWlmIChwci0+ZmxhZ3MuYm1fY2hlY2sgJiYgIXByLT5mbGFncy5ibV9j
b250cm9sKQorCQkJCXN0YXRlLT5lbnRlciA9IGFjcGlfaWRsZV9lbnRlcl9zaW1wbGU7CiAJCQli
cmVhazsKIAkJfQogCg==
--000e0cd4ce92a06f090477fe320e--
