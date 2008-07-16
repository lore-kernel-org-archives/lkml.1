Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbYGPShI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbYGPShI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 14:37:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753611AbYGPSg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 14:36:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:57163 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbYGPSgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 14:36:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type
         :x-google-sender-auth;
        b=BnUL2M+KCtUKg6C+zghzEGeABGSTtjAr5GFTRM3EaOAJeBnAx5jLFAICU9cbi7ajMd
         E+NhKJ9p3jIg4wgBMszs3nxHlwUdZHstropfHmogoV1M51j76H18zgDb5y/x9EUBCYOP
         T2ky69yEPldMLixki/G9dUOLK39Ng1MCB07k8=
Message-ID: <3efb10970807161136q39622d8frb74221ca1726bb24@mail.gmail.com>
Date: Wed, 16 Jul 2008 20:36:53 +0200
From: "Remy Bohmer" <linux@bohmer.net>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: 2.6.25.X-rtX compile errors on ARM due to cmpxchg() problems.
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       lvcargnini@gmail.com, "Thomas Gleixner" <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_29414_8264355.1216233413881"
X-Google-Sender-Auth: 1eec99b854627865
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_29414_8264355.1216233413881
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello Steven,

A while ago I already mentioned that 2.6.25 did not compile on ARM.
(e.g. AT91SAM9261-EK)
Today I looked at it again with the latest 2.6.25 kernel with latest RT-patch.

Several errors are gone, but I still I get these warnings on every
file that is being compiled:
-----------------------------------------------------------------
  CC      arch/arm/kernel/asm-offsets.s
In file included from include/linux/rt_lock.h:14,
                 from include/linux/spinlock.h:117,
                 from include/linux/seqlock.h:29,
                 from include/linux/time.h:8,
                 from include/linux/timex.h:57,
                 from include/linux/sched.h:54,
                 from arch/arm/kernel/asm-offsets.c:13:
include/asm/atomic.h:241:1: warning: "cmpxchg" redefined
In file included from include/asm/system.h:378,
                 from include/asm/bitops.h:27,
                 from include/linux/bitops.h:17,
                 from include/linux/kernel.h:15,
                 from include/linux/sched.h:52,
                 from arch/arm/kernel/asm-offsets.c:13:
include/asm-generic/cmpxchg.h:19:1: warning: this is the location of
the previous definition
...
and many more...
...
-----------------------------------------------------------------

I looked at the broken-out series which patches are causing these
warnings and these are the offending patches:
* arm-fix-atomic-cmpxchg.patch
* arm-cmpxchg.patch

When these patches are removed from the Preempt-RT patchset everything
compiles again, without warnings.

But these patches are probably there for a reason, and leaving them
out could break some things. (Although I believe that these patches
are just there because they apply on 2.6.25-RT)

But, Here I need some (RT-mutex-expert) review help.

Because this ARM architecture (ARM <= V5) does not have a real
cmpxchg() assembler
instruction, and the implementation is almost the same as the generic
definition, the generic definition can be used instead.
However, The generic implementation does NOT define __HAVE_ARCH_CMPXCHG.

My questions are:
* What are the results of NOT defining  __HAVE_ARCH_CMPXCHG in
kernel/rtmutex.c ?
* Does the RT-mutex still behave correctly?
* Why is this check in rtmutex.c ? Is it really needed, because there
is always a generic implementation of cmpxchg() these days?

FURTHER: The patch arm-fix-atomic-cmpxchg.patch made the
local_irq_save() a raw_local_irq_save().
Looking at the generic implementation I believe that this code should
also use the raw_* types. I attached a new patch for this to this
mail.

So, attached 3 patches:
* revert-arm-fix-atomic-cmpxchg.patch (reverts the same named patch in
preempt-RT set)
* revert-arm-cmpxchg.patch (reverts the same named patch in preempt-RT set)
* make-generic-cmpxchg-use-raw-intlock-types.patch

Can you clear some things up here? And also repair the RT-patch for
ARM and 2.6.25 ;-) (and newer)


Kind regards,

Remy

------=_Part_29414_8264355.1216233413881
Content-Type: text/x-patch;
 name=make-generic-cmpxchg-use-raw-intlock-types.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fiq9qutm0
Content-Disposition: attachment;
 filename=make-generic-cmpxchg-use-raw-intlock-types.patch

TWFrZSBnZW5lcmljIGNtcHhjaGcoKSB1c2UgcmF3X2xvY2FsX2lycV9zYXZlKCkKClRoZSBnZW5l
cmljIHJvdXRpbmVzIGZvciB0aGUgY21weGNoZygpIGNvZGUgcGF0aCBzaG91bGQgdXNlIHRoZSBy
YXdfKiAKdHlwZXMgb24gcHJlZW1wdC1SVC4KClNpZ25lZC1vZmYtYnk6IFJlbXkgQm9obWVyIDxs
aW51eEBib2htZXIubmV0PgotLS0KIGluY2x1ZGUvYXNtLWdlbmVyaWMvY21weGNoZy1sb2NhbC5o
IHwgICAgOCArKysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxl
dGlvbnMoLSkKCkluZGV4OiBsaW51eC0yLjYuMjUuMTEvaW5jbHVkZS9hc20tZ2VuZXJpYy9jbXB4
Y2hnLWxvY2FsLmgKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42LjI1LjExLm9yaWcvaW5jbHVkZS9h
c20tZ2VuZXJpYy9jbXB4Y2hnLWxvY2FsLmgJMjAwOC0wNy0xMyAyMDowMDoyNS4wMDAwMDAwMDAg
KzAyMDAKKysrIGxpbnV4LTIuNi4yNS4xMS9pbmNsdWRlL2FzbS1nZW5lcmljL2NtcHhjaGctbG9j
YWwuaAkyMDA4LTA3LTE2IDE5OjM4OjM0LjAwMDAwMDAwMCArMDIwMApAQCAtMjAsNyArMjAsNyBA
QCBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgX19jbXB4Y2hnX2xvCiAJaWYgKHNpemUgPT0g
OCAmJiBzaXplb2YodW5zaWduZWQgbG9uZykgIT0gOCkKIAkJd3Jvbmdfc2l6ZV9jbXB4Y2hnKHB0
cik7CiAKLQlsb2NhbF9pcnFfc2F2ZShmbGFncyk7CisJcmF3X2xvY2FsX2lycV9zYXZlKGZsYWdz
KTsKIAlzd2l0Y2ggKHNpemUpIHsKIAljYXNlIDE6IHByZXYgPSAqKHU4ICopcHRyOwogCQlpZiAo
cHJldiA9PSBvbGQpCkBAIC00MSw3ICs0MSw3IEBAIHN0YXRpYyBpbmxpbmUgdW5zaWduZWQgbG9u
ZyBfX2NtcHhjaGdfbG8KIAlkZWZhdWx0OgogCQl3cm9uZ19zaXplX2NtcHhjaGcocHRyKTsKIAl9
Ci0JbG9jYWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOworCXJhd19sb2NhbF9pcnFfcmVzdG9yZShmbGFn
cyk7CiAJcmV0dXJuIHByZXY7CiB9CiAKQEAgLTU0LDExICs1NCwxMSBAQCBzdGF0aWMgaW5saW5l
IHU2NCBfX2NtcHhjaGc2NF9sb2NhbF9nZW5lCiAJdTY0IHByZXY7CiAJdW5zaWduZWQgbG9uZyBm
bGFnczsKIAotCWxvY2FsX2lycV9zYXZlKGZsYWdzKTsKKwlyYXdfbG9jYWxfaXJxX3NhdmUoZmxh
Z3MpOwogCXByZXYgPSAqKHU2NCAqKXB0cjsKIAlpZiAocHJldiA9PSBvbGQpCiAJCSoodTY0ICop
cHRyID0gbmV3OwotCWxvY2FsX2lycV9yZXN0b3JlKGZsYWdzKTsKKwlyYXdfbG9jYWxfaXJxX3Jl
c3RvcmUoZmxhZ3MpOwogCXJldHVybiBwcmV2OwogfQogCg==
------=_Part_29414_8264355.1216233413881
Content-Type: text/x-patch; name=revert-arm-cmpxchg.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fiq9r5ty1
Content-Disposition: attachment; filename=revert-arm-cmpxchg.patch

UmV2ZXJ0IHRoZSBwYXRjaCBuYW1lZCBhcm0tY21weGNoZy5wYXRjaCBpbiB0aGUgcHJlZW1wdC1y
dCBwYXRjaHNldAoKQ3VycmVudGx5IHRoZSBwYXRjaCBhcm0tY21weGNoZy5wYXRjaCBpcyBwYXJ0
IG9mIHRoZSBwcmVlbXB0LXJ0CnBhdGNoc2V0LiBBbHRob3VnaCBpdCBhcHBsaWVzIGNvcnJlY3Rs
eSwgaXQgaW50cm9kdWNlcyBub3cgYSAybmQKaW1wbGVtZW50YXRpb24gb2YgdGhlIGNtcHhjaGco
KSBtYWNybywgYW5kIHRodXMgYSBjb21waWxlIGVycm9yLgoKQmVjYXVzZSB0aGlzIGFyY2hpdGVj
dHVyZSBkb2VzIG5vdCBoYXZlIGEgcmVhbCBjbXB4Y2hnKCkgYXNzZW1ibGVyCmluc3RydWN0aW9u
LCBhbmQgdGhlIGltcGxlbWVudGF0aW9uIGlzIGFsbW9zdCB0aGUgc2FtZSBhcyB0aGUgZ2VuZXJp
YwpkZWZpbml0aW9uLCB0aGUgZ2VuZXJpYyBkZWZpbml0aW9uIGlzIG5vdyB1c2VkIGluc3RlYWQu
CgpCVVQ6IHRoZSBfX0hBVkVfQVJDSF9DTVBYQ0hHIGlzIG5vdCBzZXQgYW55IGxvbmdlciwgYmVj
YXVzZSBpdCBpcyBub3QKc2V0IGluIHRoZSBnZW5lcmljIGltcGxlbWVudGF0aW9uLiBTb21lIHJl
dmlldyBpcyByZXF1aXJlZCAKZm9yIHRoZSBrZXJuZWwvcnRtdXRleC5jIGNvZGUgdG8gbWFrZSBz
dXJlIHRoZSBjb2RlIHN0aWxsCmJlaGF2ZXMgd2VsbCB3aXRob3V0IHRoaXMgZmxhZyBzZXQuCgpJ
IGhhdmUgb25seSBjb21waWxlIHRlc3RlZCB0aGlzIHBhdGNoIQpJIGhhdmUgbm90IGNvbmZyb250
ZWQgYW55IGhhcmR3YXJlIHdpdGggdGhpcyBwYXRjaCB5ZXQuCioqKiogUkVWSUVXIFJFUVVJUkVE
IG9uIHJ0bXV0ZXggY29kZSEgKioqKgoKTk9URTogSW5zdGVhZCBvZiBhcHBseWluZyB0aGlzIHBh
dGNoLCBpdCBpcyBldmVuIGJldHRlciB0byByZW1vdmUKdGhlIGFybS1jbXB4Y2hnLnBhdGNoIGZy
b20gdGhlIHByZWVtcHQtcnQgc2V0IGJlY2F1c2UgdGhpcyBwYXRjaApvbmx5IHJldmVydHMgdGhh
dCBwYXRjaC4KClNpZ25lZC1vZmYtYnk6IFJlbXkgQm9obWVyIDxsaW51eEBib2htZXIubmV0Pgot
LS0KIGluY2x1ZGUvYXNtLWFybS9hdG9taWMuaCB8ICAgMzUgLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAzNSBkZWxldGlvbnMoLSkKCkluZGV4OiBs
aW51eC0yLjYuMjUuMTEvaW5jbHVkZS9hc20tYXJtL2F0b21pYy5oCj09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIGxp
bnV4LTIuNi4yNS4xMS5vcmlnL2luY2x1ZGUvYXNtLWFybS9hdG9taWMuaAkyMDA4LTA3LTE2IDE3
OjE0OjAxLjAwMDAwMDAwMCArMDIwMAorKysgbGludXgtMi42LjI1LjExL2luY2x1ZGUvYXNtLWFy
bS9hdG9taWMuaAkyMDA4LTA3LTE2IDE3OjE1OjE1LjAwMDAwMDAwMCArMDIwMApAQCAtMjEzLDQx
ICsyMTMsNiBAQCBzdGF0aWMgaW5saW5lIHZvaWQgYXRvbWljX2NsZWFyX21hc2sodW5zCiAJcmF3
X2xvY2FsX2lycV9yZXN0b3JlKGZsYWdzKTsKIH0KIAotI2lmbmRlZiBDT05GSUdfU01QCi0vKgot
ICogQXRvbWljIGNvbXBhcmUgYW5kIGV4Y2hhbmdlLgotICovCi0jZGVmaW5lIF9fSEFWRV9BUkNI
X0NNUFhDSEcJMQotCi1leHRlcm4gdW5zaWduZWQgbG9uZyB3cm9uZ19zaXplX2NtcHhjaGcodm9s
YXRpbGUgdm9pZCAqcHRyKTsKLQotc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nIF9fY21weGNo
Zyh2b2xhdGlsZSB2b2lkICpwdHIsCi0JCQkJICAgIHVuc2lnbmVkIGxvbmcgb2xkLAotCQkJCSAg
ICB1bnNpZ25lZCBsb25nIG5ldywgaW50IHNpemUpCi17Ci0JdW5zaWduZWQgbG9uZyBmbGFncywg
cHJldjsKLQl2b2xhdGlsZSB1bnNpZ25lZCBsb25nICpwID0gcHRyOwotCi0JaWYgKHNpemUgPT0g
NCkgewotCQlsb2NhbF9pcnFfc2F2ZShmbGFncyk7Ci0JCWlmICgocHJldiA9ICpwKSA9PSBvbGQp
Ci0JCQkqcCA9IG5ldzsKLQkJbG9jYWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOwotCQlyZXR1cm4ocHJl
dik7Ci0JfSBlbHNlCi0JCXJldHVybiB3cm9uZ19zaXplX2NtcHhjaGcocHRyKTsKLX0KLQotI2Rl
ZmluZSBjbXB4Y2hnKHB0cixvLG4pCQkJCQkgIAlcCi0oewkJCQkJCQkJCVwKLSAgICAgX190eXBl
b2ZfXygqKHB0cikpIF9vXyA9IChvKTsJCQkJCVwKLSAgICAgX190eXBlb2ZfXygqKHB0cikpIF9u
XyA9IChuKTsJCQkJCVwKLSAgICAgKF9fdHlwZW9mX18oKihwdHIpKSkgX19jbXB4Y2hnKChwdHIp
LCAodW5zaWduZWQgbG9uZylfb18sCQlcCi0JCQkJKHVuc2lnbmVkIGxvbmcpX25fLCBzaXplb2Yo
KihwdHIpKSk7CVwKLX0pCi0KLSNlbmRpZgotCiAjZW5kaWYgLyogX19MSU5VWF9BUk1fQVJDSF9f
ICovCiAKICNkZWZpbmUgYXRvbWljX3hjaGcodiwgbmV3KSAoeGNoZygmKCh2KS0+Y291bnRlciks
IG5ldykpCg==
------=_Part_29414_8264355.1216233413881
Content-Type: text/x-patch; name=revert-arm-fix-atomic-cmpxchg.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fiq9r9602
Content-Disposition: attachment;
 filename=revert-arm-fix-atomic-cmpxchg.patch

UmV2ZXJ0IHBhdGNoIGFybS1maXgtYXRvbWljLWNtcHhjaGcucGF0Y2ggaW4gcHJlZW1wdC1ydCBw
YXRjaHNldAoKVG8gYmUgYWJsZSB0byByZXZlcnQgdGhlIHBhdGNoIGFybS1jbXB4Y2hnLnBhdGNo
IHRoaXMgcGF0Y2ggaGFzIHRvIGJlCnJldmVydGVkIGFsc28uCihBY3R1YWxseSB0aGlzIGNoYW5n
ZSBoYXMgYmVlbiBtb3ZlZCB0byB0aGUgaW5jbHVkZS9hc20tZ2VuZXJpYy9jbXB4Y2hnLWxvY2Fs
LmgKdGhyb3VnaCBhbm90aGVyIHBhdGNoKQoKU2lnbmVkLW9mZi1ieTogUmVteSBCb2htZXIgPGxp
bnV4QGJvaG1lci5uZXQ+Ci0tLQogaW5jbHVkZS9hc20tYXJtL2F0b21pYy5oIHwgICAgNCArKy0t
CiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQoKSW5kZXg6
IGxpbnV4LTIuNi4yNS4xMS9pbmNsdWRlL2FzbS1hcm0vYXRvbWljLmgKPT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0g
bGludXgtMi42LjI1LjExLm9yaWcvaW5jbHVkZS9hc20tYXJtL2F0b21pYy5oCTIwMDgtMDctMTYg
MTc6MDg6NDIuMDAwMDAwMDAwICswMjAwCisrKyBsaW51eC0yLjYuMjUuMTEvaW5jbHVkZS9hc20t
YXJtL2F0b21pYy5oCTIwMDgtMDctMTYgMTc6MTQ6MDEuMDAwMDAwMDAwICswMjAwCkBAIC0yMjks
MTAgKzIyOSwxMCBAQCBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgX19jbXB4Y2hnKHZvCiAJ
dm9sYXRpbGUgdW5zaWduZWQgbG9uZyAqcCA9IHB0cjsKIAogCWlmIChzaXplID09IDQpIHsKLQkJ
cmF3X2xvY2FsX2lycV9zYXZlKGZsYWdzKTsKKwkJbG9jYWxfaXJxX3NhdmUoZmxhZ3MpOwogCQlp
ZiAoKHByZXYgPSAqcCkgPT0gb2xkKQogCQkJKnAgPSBuZXc7Ci0JCXJhd19sb2NhbF9pcnFfcmVz
dG9yZShmbGFncyk7CisJCWxvY2FsX2lycV9yZXN0b3JlKGZsYWdzKTsKIAkJcmV0dXJuKHByZXYp
OwogCX0gZWxzZQogCQlyZXR1cm4gd3Jvbmdfc2l6ZV9jbXB4Y2hnKHB0cik7Cg==
------=_Part_29414_8264355.1216233413881--
