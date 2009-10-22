Return-Path: <linux-kernel-owner+w=401wt.eu-S1756558AbZJVPgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558AbZJVPgh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 11:36:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756507AbZJVPgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 11:36:36 -0400
Received: from mail-qy0-f194.google.com ([209.85.221.194]:34015 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261AbZJVPge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 11:36:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=N/qi/RYssPvYyFRjIhJJF2vGOW6eTmIdogZVGlQ1kLQN/+afV+M5uusrFk1f7ZVATp
         oEm8O+kxAzwReWXkNSqj/nS3C2ZE9c9lpeLVbq+CokPN3IRnI6SWumz0OK8qbLeLDUTi
         WeWmh4PQAaCOIh1ytu7e+yR0pl5LHpX9cNv9U=
MIME-Version: 1.0
In-Reply-To: <5e93dcec0910220512x50788f59u56e6493778093c7@mail.gmail.com>
References: <5e93dcec0910200800q2e156fd3v324632efcf136f5e@mail.gmail.com>
	 <4AE02A1B.6020700@redhat.com>
	 <5e93dcec0910220512x50788f59u56e6493778093c7@mail.gmail.com>
Date: Fri, 23 Oct 2009 00:36:38 +0900
Message-ID: <5e93dcec0910220836x7f798d45w299129e0c80ed5d1@mail.gmail.com>
Subject: [PATCH -tip] sched, cpuacct: fix niced guest time accounting
From: Ryota Ozaki <ozaki.ryota@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
       KVM ML <kvm@vger.kernel.org>, Ryota OZAKI <ozaki.ryota@gmail.com>
Content-Type: multipart/mixed; boundary=0016e6db2ae77c0410047687dc81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6db2ae77c0410047687dc81
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi list,
(CC: Ingo and Avi)

CPU time of a guest is always accounted in 'user' time
without concern for the nice value of its counterpart
process although the guest is scheduled under the nice
value.

This patch fixes the defect and accounts cpu time of
a niced guest in 'nice' time as same as a niced process.

And also the patch adds 'guest_nice' to cpuacct. The
value provides niced guest cpu time which is like 'nice'
to 'user'.

This patch has already reviewed and acked by Avi on KVM ML.

The original discussions can be found here.
http://www.mail-archive.com/kvm@vger.kernel.org/msg23982.html
http://www.mail-archive.com/kvm@vger.kernel.org/msg23860.html

Thanks,
  ozaki-r


>From 2be4eb881b35a879b15f4ac58f117455d10535fa Mon Sep 17 00:00:00 2001
From: Ryota Ozaki <ozaki.ryota@gmail.com>
Date: Tue, 20 Oct 2009 22:41:12 +0900
Subject: [PATCH] sched, cpuacct: fix niced guest time accounting

CPU time of a guest is always accounted in 'user' time
without concern for the nice value of its counterpart
process although the guest is scheduled under the nice
value.

This patch fixes the defect and accounts cpu time of
a niced guest in 'nice' time as same as a niced process.

And also the patch adds 'guest_nice' to cpuacct. The
value provides niced guest cpu time which is like 'nice'
to 'user'.

Signed-off-by: Ryota Ozaki <ozaki.ryota@gmail.com>
Acked-by: Avi Kivity <avi@redhat.com>
---
 Documentation/filesystems/proc.txt |    3 ++-
 fs/proc/stat.c                     |   17 +++++++++++------
 include/linux/kernel_stat.h        |    1 +
 kernel/sched.c                     |    9 +++++++--
 4 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/proc.txt
b/Documentation/filesystems/proc.txt
index 2c48f94..4af0018 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1072,7 +1072,8 @@ second).  The meanings of the columns are as
follows, from left to right:
 - irq: servicing interrupts
 - softirq: servicing softirqs
 - steal: involuntary wait
-- guest: running a guest
+- guest: running a normal guest
+- guest_nice: running a niced guest

 The "intr" line gives counts of interrupts  serviced since boot time, for =
each
 of the  possible system interrupts.   The first  column  is the  total of =
 all
diff --git a/fs/proc/stat.c b/fs/proc/stat.c
index 7cc726c..67c30a7 100644
--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -27,7 +27,7 @@ static int show_stat(struct seq_file *p, void *v)
 	int i, j;
 	unsigned long jif;
 	cputime64_t user, nice, system, idle, iowait, irq, softirq, steal;
-	cputime64_t guest;
+	cputime64_t guest, guest_nice;
 	u64 sum =3D 0;
 	u64 sum_softirq =3D 0;
 	unsigned int per_softirq_sums[NR_SOFTIRQS] =3D {0};
@@ -36,7 +36,7 @@ static int show_stat(struct seq_file *p, void *v)

 	user =3D nice =3D system =3D idle =3D iowait =3D
 		irq =3D softirq =3D steal =3D cputime64_zero;
-	guest =3D cputime64_zero;
+	guest =3D guest_nice =3D cputime64_zero;
 	getboottime(&boottime);
 	jif =3D boottime.tv_sec;

@@ -51,6 +51,8 @@ static int show_stat(struct seq_file *p, void *v)
 		softirq =3D cputime64_add(softirq, kstat_cpu(i).cpustat.softirq);
 		steal =3D cputime64_add(steal, kstat_cpu(i).cpustat.steal);
 		guest =3D cputime64_add(guest, kstat_cpu(i).cpustat.guest);
+		guest_nice =3D cputime64_add(guest_nice,
+			kstat_cpu(i).cpustat.guest_nice);
 		for_each_irq_nr(j) {
 			sum +=3D kstat_irqs_cpu(j, i);
 		}
@@ -65,7 +67,7 @@ static int show_stat(struct seq_file *p, void *v)
 	}
 	sum +=3D arch_irq_stat();

-	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu=A5n",
+	seq_printf(p, "cpu  %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu=A5n=
",
 		(unsigned long long)cputime64_to_clock_t(user),
 		(unsigned long long)cputime64_to_clock_t(nice),
 		(unsigned long long)cputime64_to_clock_t(system),
@@ -74,7 +76,8 @@ static int show_stat(struct seq_file *p, void *v)
 		(unsigned long long)cputime64_to_clock_t(irq),
 		(unsigned long long)cputime64_to_clock_t(softirq),
 		(unsigned long long)cputime64_to_clock_t(steal),
-		(unsigned long long)cputime64_to_clock_t(guest));
+		(unsigned long long)cputime64_to_clock_t(guest),
+		(unsigned long long)cputime64_to_clock_t(guest_nice));
 	for_each_online_cpu(i) {

 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
@@ -88,8 +91,9 @@ static int show_stat(struct seq_file *p, void *v)
 		softirq =3D kstat_cpu(i).cpustat.softirq;
 		steal =3D kstat_cpu(i).cpustat.steal;
 		guest =3D kstat_cpu(i).cpustat.guest;
+		guest_nice =3D kstat_cpu(i).cpustat.guest_nice;
 		seq_printf(p,
-			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu=A5n",
+			"cpu%d %llu %llu %llu %llu %llu %llu %llu %llu %llu %llu=A5n",
 			i,
 			(unsigned long long)cputime64_to_clock_t(user),
 			(unsigned long long)cputime64_to_clock_t(nice),
@@ -99,7 +103,8 @@ static int show_stat(struct seq_file *p, void *v)
 			(unsigned long long)cputime64_to_clock_t(irq),
 			(unsigned long long)cputime64_to_clock_t(softirq),
 			(unsigned long long)cputime64_to_clock_t(steal),
-			(unsigned long long)cputime64_to_clock_t(guest));
+			(unsigned long long)cputime64_to_clock_t(guest),
+			(unsigned long long)cputime64_to_clock_t(guest_nice));
 	}
 	seq_printf(p, "intr %llu", (unsigned long long)sum);

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 348fa88..c059044 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -25,6 +25,7 @@ struct cpu_usage_stat {
 	cputime64_t iowait;
 	cputime64_t steal;
 	cputime64_t guest;
+	cputime64_t guest_nice;
 };

 struct kernel_stat {
diff --git a/kernel/sched.c b/kernel/sched.c
index 00f9e71..8dd285e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5017,8 +5017,13 @@ static void account_guest_time(struct
task_struct *p, cputime_t cputime,
 	p->gtime =3D cputime_add(p->gtime, cputime);

 	/* Add guest time to cpustat. */
-	cpustat->user =3D cputime64_add(cpustat->user, tmp);
-	cpustat->guest =3D cputime64_add(cpustat->guest, tmp);
+	if (TASK_NICE(p) > 0) {
+		cpustat->nice =3D cputime64_add(cpustat->nice, tmp);
+		cpustat->guest_nice =3D cputime64_add(cpustat->guest_nice, tmp);
+	} else {
+		cpustat->user =3D cputime64_add(cpustat->user, tmp);
+		cpustat->guest =3D cputime64_add(cpustat->guest, tmp);
+	}
 }

 /*
--=20
1.6.2.5

--0016e6db2ae77c0410047687dc81
Content-Type: application/octet-stream; 
	name="0001-sched-cpuacct-fix-niced-guest-time-accounting.patch"
Content-Disposition: attachment; 
	filename="0001-sched-cpuacct-fix-niced-guest-time-accounting.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g13nzkmu0

RnJvbSAyYmU0ZWI4ODFiMzVhODc5YjE1ZjRhYzU4ZjExNzQ1NWQxMDUzNWZhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSeW90YSBPemFraSA8b3pha2kucnlvdGFAZ21haWwuY29tPgpE
YXRlOiBUdWUsIDIwIE9jdCAyMDA5IDIyOjQxOjEyICswOTAwClN1YmplY3Q6IFtQQVRDSF0gc2No
ZWQsIGNwdWFjY3Q6IGZpeCBuaWNlZCBndWVzdCB0aW1lIGFjY291bnRpbmcKCkNQVSB0aW1lIG9m
IGEgZ3Vlc3QgaXMgYWx3YXlzIGFjY291bnRlZCBpbiAndXNlcicgdGltZQp3aXRob3V0IGNvbmNl
cm4gZm9yIHRoZSBuaWNlIHZhbHVlIG9mIGl0cyBjb3VudGVycGFydApwcm9jZXNzIGFsdGhvdWdo
IHRoZSBndWVzdCBpcyBzY2hlZHVsZWQgdW5kZXIgdGhlIG5pY2UKdmFsdWUuCgpUaGlzIHBhdGNo
IGZpeGVzIHRoZSBkZWZlY3QgYW5kIGFjY291bnRzIGNwdSB0aW1lIG9mCmEgbmljZWQgZ3Vlc3Qg
aW4gJ25pY2UnIHRpbWUgYXMgc2FtZSBhcyBhIG5pY2VkIHByb2Nlc3MuCgpBbmQgYWxzbyB0aGUg
cGF0Y2ggYWRkcyAnZ3Vlc3RfbmljZScgdG8gY3B1YWNjdC4gVGhlCnZhbHVlIHByb3ZpZGVzIG5p
Y2VkIGd1ZXN0IGNwdSB0aW1lIHdoaWNoIGlzIGxpa2UgJ25pY2UnCnRvICd1c2VyJy4KClNpZ25l
ZC1vZmYtYnk6IFJ5b3RhIE96YWtpIDxvemFraS5yeW90YUBnbWFpbC5jb20+CkFja2VkLWJ5OiBB
dmkgS2l2aXR5IDxhdmlAcmVkaGF0LmNvbT4KLS0tCiBEb2N1bWVudGF0aW9uL2ZpbGVzeXN0ZW1z
L3Byb2MudHh0IHwgICAgMyArKy0KIGZzL3Byb2Mvc3RhdC5jICAgICAgICAgICAgICAgICAgICAg
fCAgIDE3ICsrKysrKysrKysrLS0tLS0tCiBpbmNsdWRlL2xpbnV4L2tlcm5lbF9zdGF0LmggICAg
ICAgIHwgICAgMSArCiBrZXJuZWwvc2NoZWQuYyAgICAgICAgICAgICAgICAgICAgIHwgICAgOSAr
KysrKysrLS0KIDQgZmlsZXMgY2hhbmdlZCwgMjEgaW5zZXJ0aW9ucygrKSwgOSBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2ZpbGVzeXN0ZW1zL3Byb2MudHh0IGIvRG9j
dW1lbnRhdGlvbi9maWxlc3lzdGVtcy9wcm9jLnR4dAppbmRleCAyYzQ4Zjk0Li40YWYwMDE4IDEw
MDY0NAotLS0gYS9Eb2N1bWVudGF0aW9uL2ZpbGVzeXN0ZW1zL3Byb2MudHh0CisrKyBiL0RvY3Vt
ZW50YXRpb24vZmlsZXN5c3RlbXMvcHJvYy50eHQKQEAgLTEwNzIsNyArMTA3Miw4IEBAIHNlY29u
ZCkuICBUaGUgbWVhbmluZ3Mgb2YgdGhlIGNvbHVtbnMgYXJlIGFzIGZvbGxvd3MsIGZyb20gbGVm
dCB0byByaWdodDoKIC0gaXJxOiBzZXJ2aWNpbmcgaW50ZXJydXB0cwogLSBzb2Z0aXJxOiBzZXJ2
aWNpbmcgc29mdGlycXMKIC0gc3RlYWw6IGludm9sdW50YXJ5IHdhaXQKLS0gZ3Vlc3Q6IHJ1bm5p
bmcgYSBndWVzdAorLSBndWVzdDogcnVubmluZyBhIG5vcm1hbCBndWVzdAorLSBndWVzdF9uaWNl
OiBydW5uaW5nIGEgbmljZWQgZ3Vlc3QKIAogVGhlICJpbnRyIiBsaW5lIGdpdmVzIGNvdW50cyBv
ZiBpbnRlcnJ1cHRzICBzZXJ2aWNlZCBzaW5jZSBib290IHRpbWUsIGZvciBlYWNoCiBvZiB0aGUg
IHBvc3NpYmxlIHN5c3RlbSBpbnRlcnJ1cHRzLiAgIFRoZSBmaXJzdCAgY29sdW1uICBpcyB0aGUg
IHRvdGFsIG9mICBhbGwKZGlmZiAtLWdpdCBhL2ZzL3Byb2Mvc3RhdC5jIGIvZnMvcHJvYy9zdGF0
LmMKaW5kZXggN2NjNzI2Yy4uNjdjMzBhNyAxMDA2NDQKLS0tIGEvZnMvcHJvYy9zdGF0LmMKKysr
IGIvZnMvcHJvYy9zdGF0LmMKQEAgLTI3LDcgKzI3LDcgQEAgc3RhdGljIGludCBzaG93X3N0YXQo
c3RydWN0IHNlcV9maWxlICpwLCB2b2lkICp2KQogCWludCBpLCBqOwogCXVuc2lnbmVkIGxvbmcg
amlmOwogCWNwdXRpbWU2NF90IHVzZXIsIG5pY2UsIHN5c3RlbSwgaWRsZSwgaW93YWl0LCBpcnEs
IHNvZnRpcnEsIHN0ZWFsOwotCWNwdXRpbWU2NF90IGd1ZXN0OworCWNwdXRpbWU2NF90IGd1ZXN0
LCBndWVzdF9uaWNlOwogCXU2NCBzdW0gPSAwOwogCXU2NCBzdW1fc29mdGlycSA9IDA7CiAJdW5z
aWduZWQgaW50IHBlcl9zb2Z0aXJxX3N1bXNbTlJfU09GVElSUVNdID0gezB9OwpAQCAtMzYsNyAr
MzYsNyBAQCBzdGF0aWMgaW50IHNob3dfc3RhdChzdHJ1Y3Qgc2VxX2ZpbGUgKnAsIHZvaWQgKnYp
CiAKIAl1c2VyID0gbmljZSA9IHN5c3RlbSA9IGlkbGUgPSBpb3dhaXQgPQogCQlpcnEgPSBzb2Z0
aXJxID0gc3RlYWwgPSBjcHV0aW1lNjRfemVybzsKLQlndWVzdCA9IGNwdXRpbWU2NF96ZXJvOwor
CWd1ZXN0ID0gZ3Vlc3RfbmljZSA9IGNwdXRpbWU2NF96ZXJvOwogCWdldGJvb3R0aW1lKCZib290
dGltZSk7CiAJamlmID0gYm9vdHRpbWUudHZfc2VjOwogCkBAIC01MSw2ICs1MSw4IEBAIHN0YXRp
YyBpbnQgc2hvd19zdGF0KHN0cnVjdCBzZXFfZmlsZSAqcCwgdm9pZCAqdikKIAkJc29mdGlycSA9
IGNwdXRpbWU2NF9hZGQoc29mdGlycSwga3N0YXRfY3B1KGkpLmNwdXN0YXQuc29mdGlycSk7CiAJ
CXN0ZWFsID0gY3B1dGltZTY0X2FkZChzdGVhbCwga3N0YXRfY3B1KGkpLmNwdXN0YXQuc3RlYWwp
OwogCQlndWVzdCA9IGNwdXRpbWU2NF9hZGQoZ3Vlc3QsIGtzdGF0X2NwdShpKS5jcHVzdGF0Lmd1
ZXN0KTsKKwkJZ3Vlc3RfbmljZSA9IGNwdXRpbWU2NF9hZGQoZ3Vlc3RfbmljZSwKKwkJCWtzdGF0
X2NwdShpKS5jcHVzdGF0Lmd1ZXN0X25pY2UpOwogCQlmb3JfZWFjaF9pcnFfbnIoaikgewogCQkJ
c3VtICs9IGtzdGF0X2lycXNfY3B1KGosIGkpOwogCQl9CkBAIC02NSw3ICs2Nyw3IEBAIHN0YXRp
YyBpbnQgc2hvd19zdGF0KHN0cnVjdCBzZXFfZmlsZSAqcCwgdm9pZCAqdikKIAl9CiAJc3VtICs9
IGFyY2hfaXJxX3N0YXQoKTsKIAotCXNlcV9wcmludGYocCwgImNwdSAgJWxsdSAlbGx1ICVsbHUg
JWxsdSAlbGx1ICVsbHUgJWxsdSAlbGx1ICVsbHVcbiIsCisJc2VxX3ByaW50ZihwLCAiY3B1ICAl
bGx1ICVsbHUgJWxsdSAlbGx1ICVsbHUgJWxsdSAlbGx1ICVsbHUgJWxsdSAlbGx1XG4iLAogCQko
dW5zaWduZWQgbG9uZyBsb25nKWNwdXRpbWU2NF90b19jbG9ja190KHVzZXIpLAogCQkodW5zaWdu
ZWQgbG9uZyBsb25nKWNwdXRpbWU2NF90b19jbG9ja190KG5pY2UpLAogCQkodW5zaWduZWQgbG9u
ZyBsb25nKWNwdXRpbWU2NF90b19jbG9ja190KHN5c3RlbSksCkBAIC03NCw3ICs3Niw4IEBAIHN0
YXRpYyBpbnQgc2hvd19zdGF0KHN0cnVjdCBzZXFfZmlsZSAqcCwgdm9pZCAqdikKIAkJKHVuc2ln
bmVkIGxvbmcgbG9uZyljcHV0aW1lNjRfdG9fY2xvY2tfdChpcnEpLAogCQkodW5zaWduZWQgbG9u
ZyBsb25nKWNwdXRpbWU2NF90b19jbG9ja190KHNvZnRpcnEpLAogCQkodW5zaWduZWQgbG9uZyBs
b25nKWNwdXRpbWU2NF90b19jbG9ja190KHN0ZWFsKSwKLQkJKHVuc2lnbmVkIGxvbmcgbG9uZylj
cHV0aW1lNjRfdG9fY2xvY2tfdChndWVzdCkpOworCQkodW5zaWduZWQgbG9uZyBsb25nKWNwdXRp
bWU2NF90b19jbG9ja190KGd1ZXN0KSwKKwkJKHVuc2lnbmVkIGxvbmcgbG9uZyljcHV0aW1lNjRf
dG9fY2xvY2tfdChndWVzdF9uaWNlKSk7CiAJZm9yX2VhY2hfb25saW5lX2NwdShpKSB7CiAKIAkJ
LyogQ29weSB2YWx1ZXMgaGVyZSB0byB3b3JrIGFyb3VuZCBnY2MtMi45NS4zLCBnY2MtMi45NiAq
LwpAQCAtODgsOCArOTEsOSBAQCBzdGF0aWMgaW50IHNob3dfc3RhdChzdHJ1Y3Qgc2VxX2ZpbGUg
KnAsIHZvaWQgKnYpCiAJCXNvZnRpcnEgPSBrc3RhdF9jcHUoaSkuY3B1c3RhdC5zb2Z0aXJxOwog
CQlzdGVhbCA9IGtzdGF0X2NwdShpKS5jcHVzdGF0LnN0ZWFsOwogCQlndWVzdCA9IGtzdGF0X2Nw
dShpKS5jcHVzdGF0Lmd1ZXN0OworCQlndWVzdF9uaWNlID0ga3N0YXRfY3B1KGkpLmNwdXN0YXQu
Z3Vlc3RfbmljZTsKIAkJc2VxX3ByaW50ZihwLAotCQkJImNwdSVkICVsbHUgJWxsdSAlbGx1ICVs
bHUgJWxsdSAlbGx1ICVsbHUgJWxsdSAlbGx1XG4iLAorCQkJImNwdSVkICVsbHUgJWxsdSAlbGx1
ICVsbHUgJWxsdSAlbGx1ICVsbHUgJWxsdSAlbGx1ICVsbHVcbiIsCiAJCQlpLAogCQkJKHVuc2ln
bmVkIGxvbmcgbG9uZyljcHV0aW1lNjRfdG9fY2xvY2tfdCh1c2VyKSwKIAkJCSh1bnNpZ25lZCBs
b25nIGxvbmcpY3B1dGltZTY0X3RvX2Nsb2NrX3QobmljZSksCkBAIC05OSw3ICsxMDMsOCBAQCBz
dGF0aWMgaW50IHNob3dfc3RhdChzdHJ1Y3Qgc2VxX2ZpbGUgKnAsIHZvaWQgKnYpCiAJCQkodW5z
aWduZWQgbG9uZyBsb25nKWNwdXRpbWU2NF90b19jbG9ja190KGlycSksCiAJCQkodW5zaWduZWQg
bG9uZyBsb25nKWNwdXRpbWU2NF90b19jbG9ja190KHNvZnRpcnEpLAogCQkJKHVuc2lnbmVkIGxv
bmcgbG9uZyljcHV0aW1lNjRfdG9fY2xvY2tfdChzdGVhbCksCi0JCQkodW5zaWduZWQgbG9uZyBs
b25nKWNwdXRpbWU2NF90b19jbG9ja190KGd1ZXN0KSk7CisJCQkodW5zaWduZWQgbG9uZyBsb25n
KWNwdXRpbWU2NF90b19jbG9ja190KGd1ZXN0KSwKKwkJCSh1bnNpZ25lZCBsb25nIGxvbmcpY3B1
dGltZTY0X3RvX2Nsb2NrX3QoZ3Vlc3RfbmljZSkpOwogCX0KIAlzZXFfcHJpbnRmKHAsICJpbnRy
ICVsbHUiLCAodW5zaWduZWQgbG9uZyBsb25nKXN1bSk7CiAKZGlmZiAtLWdpdCBhL2luY2x1ZGUv
bGludXgva2VybmVsX3N0YXQuaCBiL2luY2x1ZGUvbGludXgva2VybmVsX3N0YXQuaAppbmRleCAz
NDhmYTg4Li5jMDU5MDQ0IDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2tlcm5lbF9zdGF0LmgK
KysrIGIvaW5jbHVkZS9saW51eC9rZXJuZWxfc3RhdC5oCkBAIC0yNSw2ICsyNSw3IEBAIHN0cnVj
dCBjcHVfdXNhZ2Vfc3RhdCB7CiAJY3B1dGltZTY0X3QgaW93YWl0OwogCWNwdXRpbWU2NF90IHN0
ZWFsOwogCWNwdXRpbWU2NF90IGd1ZXN0OworCWNwdXRpbWU2NF90IGd1ZXN0X25pY2U7CiB9Owog
CiBzdHJ1Y3Qga2VybmVsX3N0YXQgewpkaWZmIC0tZ2l0IGEva2VybmVsL3NjaGVkLmMgYi9rZXJu
ZWwvc2NoZWQuYwppbmRleCAwMGY5ZTcxLi44ZGQyODVlIDEwMDY0NAotLS0gYS9rZXJuZWwvc2No
ZWQuYworKysgYi9rZXJuZWwvc2NoZWQuYwpAQCAtNTAxNyw4ICs1MDE3LDEzIEBAIHN0YXRpYyB2
b2lkIGFjY291bnRfZ3Vlc3RfdGltZShzdHJ1Y3QgdGFza19zdHJ1Y3QgKnAsIGNwdXRpbWVfdCBj
cHV0aW1lLAogCXAtPmd0aW1lID0gY3B1dGltZV9hZGQocC0+Z3RpbWUsIGNwdXRpbWUpOwogCiAJ
LyogQWRkIGd1ZXN0IHRpbWUgdG8gY3B1c3RhdC4gKi8KLQljcHVzdGF0LT51c2VyID0gY3B1dGlt
ZTY0X2FkZChjcHVzdGF0LT51c2VyLCB0bXApOwotCWNwdXN0YXQtPmd1ZXN0ID0gY3B1dGltZTY0
X2FkZChjcHVzdGF0LT5ndWVzdCwgdG1wKTsKKwlpZiAoVEFTS19OSUNFKHApID4gMCkgeworCQlj
cHVzdGF0LT5uaWNlID0gY3B1dGltZTY0X2FkZChjcHVzdGF0LT5uaWNlLCB0bXApOworCQljcHVz
dGF0LT5ndWVzdF9uaWNlID0gY3B1dGltZTY0X2FkZChjcHVzdGF0LT5ndWVzdF9uaWNlLCB0bXAp
OworCX0gZWxzZSB7CisJCWNwdXN0YXQtPnVzZXIgPSBjcHV0aW1lNjRfYWRkKGNwdXN0YXQtPnVz
ZXIsIHRtcCk7CisJCWNwdXN0YXQtPmd1ZXN0ID0gY3B1dGltZTY0X2FkZChjcHVzdGF0LT5ndWVz
dCwgdG1wKTsKKwl9CiB9CiAKIC8qCi0tIAoxLjYuMi41Cgo=
--0016e6db2ae77c0410047687dc81--
