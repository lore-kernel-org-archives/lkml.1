Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbZF3Cxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbZF3Cxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 22:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755608AbZF3CxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 22:53:22 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:45692 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170AbZF3CxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 22:53:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=UzJGZ2vMD51q5QodkwVV82njMmpaNqrxSwau4rqgJbLPoBXvcQwHYD5KXFywG8t0ly
         3DUXm6hF0gr5eCsW904iSsAylIoxysNBcMt1SRwsGbAWg3aX/s+MLsbWH0HbBU1rSp9P
         S49pwiUU1zDlEJAy2Ath+m1zSI/yy+NrmYXsQ=
MIME-Version: 1.0
Date: Tue, 30 Jun 2009 10:53:23 +0800
Message-ID: <3877989d0906291953n599b7047x5fdf6033114e0eed@mail.gmail.com>
Subject: [RFC patch] disable the assumption of apic_is_clustered_box for cores 
	>= 6
From: Luming Yu <luming.yu@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: suresh.b.siddha@intel.com, venkatesh.pallipadi@intel.com
Content-Type: multipart/mixed; boundary=001636e0a774f63c70046d87e8a1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--001636e0a774f63c70046d87e8a1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

We have to disable the assumption of apic_is_clustered_box that assumes high
4bits of 8 bit APIC ID was cluster id, which is just the function's guess.
On a normal 4-socket system with >6cores Processor and HT enabled, we hit the
limitation of the guess and failed. Have to disable the guess on any
cores > 6 system.

Without this patch, we can't use good TSC on any SMP system with 48+ logical CPU

**The patch is enclosed in text attachment*
**Using web client to send the patch* *
**below is for review, please apply attached  patch*/

Thanks,
Luming

 apic/apic.c |   15 ++++++++++++++-
 cpu/intel.c |    2 +-
 2 files changed, 15 insertions(+), 2 deletions(-)

--- linux-2.6.30-rc6/arch/x86/kernel/apic/apic.c.0	2009-06-29
19:54:15.000000000 -0600
+++ linux-2.6.30-rc6/arch/x86/kernel/apic/apic.c	2009-06-29
20:14:15.000000000 -0600
@@ -2119,6 +2119,16 @@
 #endif	/* CONFIG_PM */

 #ifdef CONFIG_X86_64
+extern int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c);
+
+__cpuinit int __detect_cores(void)
+{
+	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL)
+		boot_cpu_data.x86_max_cores =
+			intel_num_cpu_cores(&boot_cpu_data);
+	return boot_cpu_data.x86_max_cores;
+}
+
 /*
  * apic_is_clustered_box() -- Check if we can expect good TSC
  *
@@ -2190,7 +2200,10 @@
 	 * May have to revisit this when multi-core + hyperthreaded CPUs come
 	 * out, but AFAIK this will work even for them.
 	 */
-	return (clusters > 2);
+	if (clusters > 2)
+		return (__detect_cores() >= 6) ? 0 : 1;
+	else
+		return 0;
 }
 #endif

--- linux-2.6.30-rc6/arch/x86/kernel/cpu/intel.c.0	2009-06-29
19:53:29.000000000 -0600
+++ linux-2.6.30-rc6/arch/x86/kernel/cpu/intel.c	2009-06-29
08:46:12.000000000 -0600
@@ -250,7 +250,7 @@
 /*
  * find out the number of processor cores on the die
  */
-static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
+int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
 {
 	unsigned int eax, ebx, ecx, edx;

--001636e0a774f63c70046d87e8a1
Content-Type: application/octet-stream; name="1.patch"
Content-Disposition: attachment; filename="1.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fwk0z3b70

LS0tIGxpbnV4LTIuNi4zMC1yYzYvYXJjaC94ODYva2VybmVsL2FwaWMvYXBpYy5jLjAJMjAwOS0w
Ni0yOSAxOTo1NDoxNS4wMDAwMDAwMDAgLTA2MDAKKysrIGxpbnV4LTIuNi4zMC1yYzYvYXJjaC94
ODYva2VybmVsL2FwaWMvYXBpYy5jCTIwMDktMDYtMjkgMjA6MTQ6MTUuMDAwMDAwMDAwIC0wNjAw
CkBAIC0yMTE5LDYgKzIxMTksMTYgQEAKICNlbmRpZgkvKiBDT05GSUdfUE0gKi8KIAogI2lmZGVm
IENPTkZJR19YODZfNjQKK2V4dGVybiBpbnQgX19jcHVpbml0IGludGVsX251bV9jcHVfY29yZXMo
c3RydWN0IGNwdWluZm9feDg2ICpjKTsKKworX19jcHVpbml0IGludCBfX2RldGVjdF9jb3Jlcyh2
b2lkKQoreworCWlmIChib290X2NwdV9kYXRhLng4Nl92ZW5kb3IgPT0gWDg2X1ZFTkRPUl9JTlRF
TCkKKwkJYm9vdF9jcHVfZGF0YS54ODZfbWF4X2NvcmVzID0gCisJCQlpbnRlbF9udW1fY3B1X2Nv
cmVzKCZib290X2NwdV9kYXRhKTsKKwlyZXR1cm4gYm9vdF9jcHVfZGF0YS54ODZfbWF4X2NvcmVz
OworfQorCiAvKgogICogYXBpY19pc19jbHVzdGVyZWRfYm94KCkgLS0gQ2hlY2sgaWYgd2UgY2Fu
IGV4cGVjdCBnb29kIFRTQwogICoKQEAgLTIxOTAsNyArMjIwMCwxMCBAQAogCSAqIE1heSBoYXZl
IHRvIHJldmlzaXQgdGhpcyB3aGVuIG11bHRpLWNvcmUgKyBoeXBlcnRocmVhZGVkIENQVXMgY29t
ZQogCSAqIG91dCwgYnV0IEFGQUlLIHRoaXMgd2lsbCB3b3JrIGV2ZW4gZm9yIHRoZW0uCiAJICov
Ci0JcmV0dXJuIChjbHVzdGVycyA+IDIpOworCWlmIChjbHVzdGVycyA+IDIpCisJCXJldHVybiAo
X19kZXRlY3RfY29yZXMoKSA+PSA2KSA/IDAgOiAxOworCWVsc2UKKwkJcmV0dXJuIDA7CiB9CiAj
ZW5kaWYKIAotLS0gbGludXgtMi42LjMwLXJjNi9hcmNoL3g4Ni9rZXJuZWwvY3B1L2ludGVsLmMu
MAkyMDA5LTA2LTI5IDE5OjUzOjI5LjAwMDAwMDAwMCAtMDYwMAorKysgbGludXgtMi42LjMwLXJj
Ni9hcmNoL3g4Ni9rZXJuZWwvY3B1L2ludGVsLmMJMjAwOS0wNi0yOSAwODo0NjoxMi4wMDAwMDAw
MDAgLTA2MDAKQEAgLTI1MCw3ICsyNTAsNyBAQAogLyoKICAqIGZpbmQgb3V0IHRoZSBudW1iZXIg
b2YgcHJvY2Vzc29yIGNvcmVzIG9uIHRoZSBkaWUKICAqLwotc3RhdGljIGludCBfX2NwdWluaXQg
aW50ZWxfbnVtX2NwdV9jb3JlcyhzdHJ1Y3QgY3B1aW5mb194ODYgKmMpCitpbnQgX19jcHVpbml0
IGludGVsX251bV9jcHVfY29yZXMoc3RydWN0IGNwdWluZm9feDg2ICpjKQogewogCXVuc2lnbmVk
IGludCBlYXgsIGVieCwgZWN4LCBlZHg7CiAK
--001636e0a774f63c70046d87e8a1--
