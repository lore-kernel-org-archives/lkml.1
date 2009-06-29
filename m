Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbZF2Gz6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbZF2Gz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 02:55:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751807AbZF2Gzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 02:55:50 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:54078 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZF2Gzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 02:55:49 -0400
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jun 2009 02:55:49 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=UCtlVvyq9jB3D1vcAV5zJbJJAjYhlgv7rbPrFLUgAMrNGzH8oPR3OwegWvmpmITzgW
         4c9ibW7uWgc4JebWbhP8Qci01T9kbhIuZ1QnhSi1hFrHecEIIjo+girBsZk8GAv6Vh17
         3F1c7WLQVNlUMeE+l55/7JrsdHeavrLwhQGAM=
MIME-Version: 1.0
Date: Mon, 29 Jun 2009 14:47:57 +0800
Message-ID: <3877989d0906282347i311eb14bp80a7c80878219c31@mail.gmail.com>
Subject: [RFC patch] Use IPI_shortcut for lapic timer broadcast
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: suresh.b.siddha@intel.com, venkatesh.pallipadi@intel.com
Content-Type: multipart/mixed; boundary=000e0cd28fd2fd8c43046d77116f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd28fd2fd8c43046d77116f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

We need to use IPI shortcut to send lapic timer broadcast
to avoid the latency of sending IPI one bye one on systems with many
logical processors when NO_HZ is disabled.
Without this patch,I have seen upstream kernel with RHEL 5 kernel
config boot hang .

The patch also changes physflat_send_IPI_all to IPI shortcut mode.

Please review, and apply.

**The patch is enclosed in text attachment*
**Using web client to send the patch* *
**below is for review, please apply attached  patch*/

Thanks,
Luming


Signed-off-by: Yu Luming <luming.yu@intel.com>

 apic.c         |    4 +++-
 apic_flat_64.c |    7 ++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

--- linux-2.6.30-rc6/arch/x86/kernel/apic/apic.c.0	2009-06-28
20:22:55.000000000 -0600
+++ linux-2.6.30-rc6/arch/x86/kernel/apic/apic.c	2009-06-29
00:21:44.000000000 -0600
@@ -419,7 +419,9 @@
 static void lapic_timer_broadcast(const struct cpumask *mask)
 {
 #ifdef CONFIG_SMP
-	apic->send_IPI_mask(mask, LOCAL_TIMER_VECTOR);
+	if (cpus_empty(*mask))
+		return;
+	apic->send_IPI_all(LOCAL_TIMER_VECTOR);
 #endif
 }

--- linux-2.6.30-rc6/arch/x86/kernel/apic/apic_flat_64.c.0	2009-06-29
00:13:26.000000000 -0600
+++ linux-2.6.30-rc6/arch/x86/kernel/apic/apic_flat_64.c	2009-06-29
00:11:23.000000000 -0600
@@ -274,7 +274,12 @@

 static void physflat_send_IPI_all(int vector)
 {
-	physflat_send_IPI_mask(cpu_online_mask, vector);
+	if (vector == NMI_VECTOR) {
+		physflat_send_IPI_mask(cpu_online_mask, vector);
+	} else {
+		__default_send_IPI_shortcut(APIC_DEST_ALLINC,
+					    vector, apic->dest_logical);
+	}
 }

 static unsigned int physflat_cpu_mask_to_apicid(const struct cpumask *cpumask)

--000e0cd28fd2fd8c43046d77116f
Content-Type: application/octet-stream; name="1.patch"
Content-Disposition: attachment; filename="1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fwitufvt0

LS0tIGxpbnV4LTIuNi4zMC1yYzYvYXJjaC94ODYva2VybmVsL2FwaWMvYXBpYy5jLjAJMjAwOS0w
Ni0yOCAyMDoyMjo1NS4wMDAwMDAwMDAgLTA2MDAKKysrIGxpbnV4LTIuNi4zMC1yYzYvYXJjaC94
ODYva2VybmVsL2FwaWMvYXBpYy5jCTIwMDktMDYtMjkgMDA6MjE6NDQuMDAwMDAwMDAwIC0wNjAw
CkBAIC00MTksNyArNDE5LDkgQEAKIHN0YXRpYyB2b2lkIGxhcGljX3RpbWVyX2Jyb2FkY2FzdChj
b25zdCBzdHJ1Y3QgY3B1bWFzayAqbWFzaykKIHsKICNpZmRlZiBDT05GSUdfU01QCi0JYXBpYy0+
c2VuZF9JUElfbWFzayhtYXNrLCBMT0NBTF9USU1FUl9WRUNUT1IpOworCWlmIChjcHVzX2VtcHR5
KCptYXNrKSkKKwkJcmV0dXJuOworCWFwaWMtPnNlbmRfSVBJX2FsbChMT0NBTF9USU1FUl9WRUNU
T1IpOwogI2VuZGlmCiB9CiAKLS0tIGxpbnV4LTIuNi4zMC1yYzYvYXJjaC94ODYva2VybmVsL2Fw
aWMvYXBpY19mbGF0XzY0LmMuMAkyMDA5LTA2LTI5IDAwOjEzOjI2LjAwMDAwMDAwMCAtMDYwMAor
KysgbGludXgtMi42LjMwLXJjNi9hcmNoL3g4Ni9rZXJuZWwvYXBpYy9hcGljX2ZsYXRfNjQuYwky
MDA5LTA2LTI5IDAwOjExOjIzLjAwMDAwMDAwMCAtMDYwMApAQCAtMjc0LDcgKzI3NCwxMiBAQAog
CiBzdGF0aWMgdm9pZCBwaHlzZmxhdF9zZW5kX0lQSV9hbGwoaW50IHZlY3RvcikKIHsKLQlwaHlz
ZmxhdF9zZW5kX0lQSV9tYXNrKGNwdV9vbmxpbmVfbWFzaywgdmVjdG9yKTsKKwlpZiAodmVjdG9y
ID09IE5NSV9WRUNUT1IpIHsKKwkJcGh5c2ZsYXRfc2VuZF9JUElfbWFzayhjcHVfb25saW5lX21h
c2ssIHZlY3Rvcik7CisJfSBlbHNlIHsKKwkJX19kZWZhdWx0X3NlbmRfSVBJX3Nob3J0Y3V0KEFQ
SUNfREVTVF9BTExJTkMsCisJCQkJCSAgICB2ZWN0b3IsIGFwaWMtPmRlc3RfbG9naWNhbCk7CisJ
fQogfQogCiBzdGF0aWMgdW5zaWduZWQgaW50IHBoeXNmbGF0X2NwdV9tYXNrX3RvX2FwaWNpZChj
b25zdCBzdHJ1Y3QgY3B1bWFzayAqY3B1bWFzaykK
--000e0cd28fd2fd8c43046d77116f--
