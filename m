Return-Path: <linux-kernel-owner+w=401wt.eu-S1752314AbXDLXPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbXDLXPh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 19:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbXDLXPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 19:15:37 -0400
Received: from wr-out-0506.google.com ([64.233.184.225]:47673 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbXDLXPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 19:15:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=iMz0tLBfC/JBLxtOyjPCsx+PgR08mmK/gVZWr25W/hRsZuOCZm1SLM8gdifkHt6uv8ti4zgJSENQdANeePmdkJPzUQxQfGlw9dKx/HB3E10i+CUV4jC32DN3cFOqN6qujsMGu5GmLb9DSKdwyVxOHyQWSospsebR7iK1l9YCmzA=
Message-ID: <b647ffbd0704121615t1d201096u34bc975585985b57@mail.gmail.com>
Date: Fri, 13 Apr 2007 01:15:34 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: [PATCH] [DEBUG] sd-sched: monitor dynamic priority levels of a running task
Cc: "Con Kolivas" <kernel@kolivas.org>, "ck list" <ck@vds.kolivas.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_38899_22924074.1176419734780"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_38899_22924074.1176419734780
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

[ just in case, it can be of some avail for anybody ]

target : 2.6.21-rc6-mm1

a very simplified but quite funny "toy" that

[1]  allows to monitor all the dynamic priority levels (counts a
number of hits per level) on which a given task (configured via proc)
is running;

# echo "pid" > /proc/sd_pid  - to monitor a task with a given pid";
# cat /proc/sd_slots              - to dump statistics.

[2]  triggers a message when task's *prio* and *static_prio* are out
of sync, i.e. a current prio is not allowed by
prio_matrix[USER_PRIO(static_prio)].

[ example: --- [1857] static: 35, slot: 3  -  nice ]

maybe Con has something similar.. but at least I haven't found
anything on his website.


e.g. for X all the following scenarios give different (obviously)
patterns: (1) just occasional cpu users ; (2) a cpu hog with the same
static_prio; (3) a niced cpu hog.

There are cases when [2] is triggered indeed. It's due to
set_user_nice(). Con, is it a "feature"?

-------- [ explanation ] ---------
In fact, all this "delta" calculation (delta = p->prio - old_prio)
staff is useless in set_user_prio() as effective_prio() returns just
the old p->prio and, as a result, we have got p->prio = p->prio :)  It
makes sense to use delta = p->static_prio - old_static_prio;

The p->prio will be recalculated as a result of enqueue_task ->
__enqueue_task -> recalc_task_prio ..  _but_ if the task is currently
in the "active" array and its time_slice != 0 -- the old p->prio is
not changed

So the task is queued taking into account the old_prio, although this
slot can be prohibited by a new p->static_prio. It's only for the very
first slot so one may call it err.. a feature (?)
------------------------------------------------

-- 
Best regards,
Dmitry Adamushko

------=_Part_38899_22924074.1176419734780
Content-Type: text/x-patch; name=sd-monitor_dyn_slots.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f0fdc6hw
Content-Disposition: attachment; filename="sd-monitor_dyn_slots.patch"

LS0tIGxpbnV4LTIuNi4yMS1yYzYtbW0xL2tlcm5lbC9zY2hlZC1vcmlnMy5jCTIwMDctMDQtMTEg
MTQ6NDg6MTkuMDAwMDAwMDAwICswMjAwCisrKyBsaW51eC0yLjYuMjEtcmM2LW1tMS9rZXJuZWwv
c2NoZWQuYwkyMDA3LTA0LTEyIDE2OjEzOjEyLjAwMDAwMDAwMCArMDIwMApAQCAtMjYwLDYgKzI2
MCwxNjQgQEAgc3RydWN0IHJxIHsKIHN0YXRpYyBERUZJTkVfUEVSX0NQVShzdHJ1Y3QgcnEsIHJ1
bnF1ZXVlcyk7CiBzdGF0aWMgREVGSU5FX01VVEVYKHNjaGVkX2hvdGNwdV9tdXRleCk7CiAKKyNk
ZWZpbmUgREVCVUdfU0RfU0xPVFMKKyNpZmRlZiBERUJVR19TRF9TTE9UUworCisjaW5jbHVkZSA8
bGludXgvcHJvY19mcy5oPgorCitzdGF0aWMgaW50IHNkX21vbml0b3JfcGlkLCBzZF9tb25pdG9y
X2lkeDsKK3N0YXRpYyB1bnNpZ25lZCBsb25nIHNkX3Nsb3RfaGl0c1tQUklPX1JBTkdFXTsKK3N0
YXRpYyBzdHJ1Y3QgcHJvY19kaXJfZW50cnkgKnNkX3BpZF9kaXIsICpzZF9zbG90c19kaXI7Citz
dGF0aWMgaW50IHNkX2RlYnVnX2RvbmU7CisKK3N0YXRpYyB2b2lkIGluaXRfZGVidWdfc2xvdHMo
dm9pZCk7CisKK3N0YXRpYyB2b2lkIHJlc2V0X3Nsb3RfaGl0cyh2b2lkKQoreworCWludCBpID0g
MDsKKworCWZvciAoIDsgaSA8IFBSSU9fUkFOR0U7IGkrKykKKwkJc2Rfc2xvdF9oaXRzW2ldID0g
MDsKK30KKworc3RhdGljIGlubGluZSB2b2lkIGRlYnVnX2NoZWNrX3Nsb3RfdmFsaWRpdHkoc3Ry
dWN0IHRhc2tfc3RydWN0ICpwKQoreworCWludCBzcHJpbyA9IFVTRVJfUFJJTyhwLT5zdGF0aWNf
cHJpbyksIHVwcmlvID0gVVNFUl9QUklPKHAtPnByaW8pOworCisJLyogU0NIRURfQkFUQ0ggYW5k
IHJ0IHRhc2tzIGRvbid0IHVzZSBwcmlvX21hdHJpeCBzbyBqdXN0IHNraXAgdGhlbS4gKi8KKwlp
ZiAocC0+cG9saWN5ID09IFNDSEVEX0JBVENIIHx8IHJ0X3Rhc2socCkpCisJCXJldHVybjsKKwor
CWlmICh1bmxpa2VseSghc2RfZGVidWdfZG9uZSkpCisJCWluaXRfZGVidWdfc2xvdHMoKTsKKwor
CWlmIChzZF9tb25pdG9yX3BpZCAmJiBwLT5waWQgPT0gc2RfbW9uaXRvcl9waWQpCisJCSsrc2Rf
c2xvdF9oaXRzW3VwcmlvXTsKKworCWlmICh0ZXN0X2JpdCh1cHJpbywgcHJpb19tYXRyaXhbc3By
aW9dKSkKKwkJcHJpbnRrKEtFUk5fRU1FUkcgIi0tLSBbJWRdIHN0YXRpYzogJWQsIHNsb3Q6ICVk
ICAtICAlc1xuIiwKKwkJCXAtPnBpZCwgc3ByaW8sIHVwcmlvLCBwLT5jb21tKTsKK30KKworc3Rh
dGljIGludCBzZF9waWRfcHJvY19yZWFkKGNoYXIgKnBhZ2UsIGNoYXIgKipzdGFydCwgb2ZmX3Qg
b2ZmLAorCQkJaW50IGNvdW50LCBpbnQgKmVvZiwgdm9pZCAqZGF0YSkKK3sKKwljaGFyICpwID0g
cGFnZTsKKwlpbnQgbGVuID0gMDsKKworCXAgKz0gc3ByaW50ZihwLCAicGlkOiAlZFxuIiwgc2Rf
bW9uaXRvcl9waWQpOworCisgICAgICAgIGxlbiA9IHAgLSBwYWdlIC0gb2ZmOworCisgICAgICAg
IGlmIChsZW4gPD0gb2ZmICsgY291bnQpCisgICAgICAgICAgICAgICAgKmVvZiA9IDE7CisgICAg
ICAgICpzdGFydCA9IHBhZ2UgKyBvZmY7CisgICAgICAgIGlmIChsZW4gPiBjb3VudCkKKyAgICAg
ICAgICAgICAgICBsZW4gPSBjb3VudDsKKyAgICAgICAgaWYgKGxlbiA8IDApCisgICAgICAgICAg
ICAgICAgbGVuID0gMDsKKworICAgICAgICByZXR1cm4gbGVuOworfQorCitzdGF0aWMgaW50IHNk
X3BpZF9wcm9jX3dyaXRlKHN0cnVjdCBmaWxlICpmaWxlLCBjb25zdCBjaGFyIF9fdXNlciAqYnVm
ZmVyLAorCQkJdW5zaWduZWQgbG9uZyBjb3VudCwgdm9pZCAqZGF0YSkKK3sKKwlzdHJ1Y3QgdGFz
a19zdHJ1Y3QgKnRhc2s7CisgICAgICAgIGNoYXIgKmVuZCwgYnVmWzE2XTsKKyAgICAgICAgbG9u
ZyBwaWQ7CisgICAgICAgIGludCBuOworCisgICAgICAgIG4gPSBjb3VudCA+IHNpemVvZihidWYp
IC0gMSA/IHNpemVvZihidWYpIC0gMSA6IGNvdW50OworCisgICAgICAgIGlmIChjb3B5X2Zyb21f
dXNlcihidWYsIGJ1ZmZlciwgbikpCisgICAgICAgICAgICAgICAgcmV0dXJuIC1FRkFVTFQ7CisK
KyAgICAgICAgYnVmW25dID0gJ1wwJzsKKyAgICAgICAgcGlkID0gc2ltcGxlX3N0cnRvbChidWYs
ICZlbmQsIDApOworCisJLyogU3RvcCBtb25pdG9yaW5nLiAqLworCWlmICghcGlkKSB7CisJCXNk
X21vbml0b3JfcGlkID0gMDsKKwkJZ290byBvdXRfZXhpdDsKKwl9CisKKwlyZWFkX2xvY2soJnRh
c2tsaXN0X2xvY2spOworCXRhc2sgPSBmaW5kX3Rhc2tfYnlfcGlkKHBpZCk7CisKKwlpZiAoIXRh
c2sgfHwgdGFzay0+cG9saWN5ID09IFNDSEVEX0JBVENIIHx8IHJ0X3Rhc2sodGFzaykpIHsKKwkJ
cmVhZF91bmxvY2soJnRhc2tsaXN0X2xvY2spOworCisJCXByaW50ayhLRVJOX0VNRVJHICIqKiog
ZG9uJ3QgbW9uaXRvciBTQ0hFRF9CQVRDSCBvciBSZWFsLVRpbWUgdGFza3MgKioqXG4iKTsKKwkJ
Z290byBvdXRfZXhpdDsKKwl9CisKKwlzZF9tb25pdG9yX2lkeCA9IFVTRVJfUFJJTyh0YXNrLT5z
dGF0aWNfcHJpbyk7CisJcmVhZF91bmxvY2soJnRhc2tsaXN0X2xvY2spOworCisJcmVzZXRfc2xv
dF9oaXRzKCk7CisJc2RfbW9uaXRvcl9waWQgPSBwaWQ7CisKK291dF9leGl0OgorICAgICAgICBy
ZXR1cm4gY291bnQ7Cit9CisKK3N0YXRpYyBpbnQgc2Rfc2xvdHNfcHJvY19yZWFkKGNoYXIgKnBh
Z2UsIGNoYXIgKipzdGFydCwgb2ZmX3Qgb2ZmLAorCQkJaW50IGNvdW50LCBpbnQgKmVvZiwgdm9p
ZCAqZGF0YSkKK3sKKwlpbnQgbGVuID0gMCwgaSA9IDA7CisJY2hhciAqcCA9IHBhZ2U7CisKKwlp
ZiAoIXNkX21vbml0b3JfcGlkKQorCQlnb3RvIG91dF9leGl0OworCisJcCArPSBzcHJpbnRmKHAs
ICIgc2xvdCAgYWxsb3dlZCAgICAgaGl0c1xuXG4iKTsKKworCWZvciAoIDsgaSA8IFBSSU9fUkFO
R0U7IGkrKykKKwkJcCArPSBzcHJpbnRmKHAsICJbICVkIF0gLSAlZCA6ICVsdSBcbiIsCisJCQlp
LCAhIXRlc3RfYml0KGksIHByaW9fbWF0cml4W3NkX21vbml0b3JfaWR4XSksIHNkX3Nsb3RfaGl0
c1tpXSk7CisKK291dF9leGl0OgorICAgICAgICBsZW4gPSBwIC0gcGFnZSAtIG9mZjsKKworICAg
ICAgICBpZiAobGVuIDw9IG9mZiArIGNvdW50KQorICAgICAgICAgICAgICAgICplb2YgPSAxOwor
ICAgICAgICAqc3RhcnQgPSBwYWdlICsgb2ZmOworICAgICAgICBpZiAobGVuID4gY291bnQpCisg
ICAgICAgICAgICAgICAgbGVuID0gY291bnQ7CisgICAgICAgIGlmIChsZW4gPCAwKQorICAgICAg
ICAgICAgICAgIGxlbiA9IDA7CisKKyAgICAgICAgcmV0dXJuIGxlbjsKK30KKworc3RhdGljIHZv
aWQgaW5pdF9kZWJ1Z19zbG90cyh2b2lkKQoreworCXNkX3BpZF9kaXIgPSBjcmVhdGVfcHJvY19l
bnRyeSgic2RfcGlkIiwgMDY0NCwgTlVMTCk7CisJc2Rfc2xvdHNfZGlyID0gY3JlYXRlX3Byb2Nf
cmVhZF9lbnRyeSgic2Rfc2xvdHMiLCAwNDQ0LCBOVUxMLAorCQkJCXNkX3Nsb3RzX3Byb2NfcmVh
ZCwgTlVMTCk7CisKKwlpZiAoIXNkX3BpZF9kaXIgfHwgIXNkX3Nsb3RzX2RpcikKKwkJZ290byBv
dXRfZmFpbGVkOworCisJc2RfcGlkX2Rpci0+cmVhZF9wcm9jID0gc2RfcGlkX3Byb2NfcmVhZDsK
KwlzZF9waWRfZGlyLT53cml0ZV9wcm9jID0gc2RfcGlkX3Byb2Nfd3JpdGU7CisKKwlzZF9kZWJ1
Z19kb25lID0gMTsKKwlyZXR1cm47CisKK291dF9mYWlsZWQ6CisJcHJpbnRrKEtFUk5fRVJSICJp
bml0X2RlYnVnX3Nsb3RzOiBmYWlsZWRcbiIpOworCWlmIChzZF9waWRfZGlyKQorCQlyZW1vdmVf
cHJvY19lbnRyeSgic2RfcGlkIiwgTlVMTCk7CisJaWYgKHNkX3Nsb3RzX2RpcikKKwkJcmVtb3Zl
X3Byb2NfZW50cnkoInNkX3Nsb3RzIiwgTlVMTCk7Cit9CisKKyNlbHNlCitzdGF0aWMgaW5saW5l
IHZvaWQgZGVidWdfY2hlY2tfc2xvdF92YWxpZGl0eShzdHJ1Y3QgdGFza19zdHJ1Y3QgKnApIHt9
OworI2VuZGlmCisKIHN0YXRpYyBpbmxpbmUgaW50IGNwdV9vZihzdHJ1Y3QgcnEgKnJxKQogewog
I2lmZGVmIENPTkZJR19TTVAKQEAgLTgzMiwxMiArOTkwLDE0IEBAIHN0YXRpYyBpbmxpbmUgdm9p
ZCBfX2VucXVldWVfdGFzayhzdHJ1Y3QKIHN0YXRpYyB2b2lkIGVucXVldWVfdGFzayhzdHJ1Y3Qg
dGFza19zdHJ1Y3QgKnAsIHN0cnVjdCBycSAqcnEpCiB7CiAJX19lbnF1ZXVlX3Rhc2socCwgcnEp
OworCWRlYnVnX2NoZWNrX3Nsb3RfdmFsaWRpdHkocCk7CiAJbGlzdF9hZGRfdGFpbCgmcC0+cnVu
X2xpc3QsIHAtPmFycmF5LT5xdWV1ZSArIHAtPnByaW8pOwogfQogCiBzdGF0aWMgaW5saW5lIHZv
aWQgZW5xdWV1ZV90YXNrX2hlYWQoc3RydWN0IHRhc2tfc3RydWN0ICpwLCBzdHJ1Y3QgcnEgKnJx
KQogewogCV9fZW5xdWV1ZV90YXNrKHAsIHJxKTsKKwlkZWJ1Z19jaGVja19zbG90X3ZhbGlkaXR5
KHApOwogCWxpc3RfYWRkKCZwLT5ydW5fbGlzdCwgcC0+YXJyYXktPnF1ZXVlICsgcC0+cHJpbyk7
CiB9CiAKQEAgLTg1MCw2ICsxMDEwLDcgQEAgc3RhdGljIHZvaWQgcmVxdWV1ZV90YXNrKHN0cnVj
dCB0YXNrX3N0cgogewogCWlmIChwLT5hcnJheSA9PSBycS0+ZXhwaXJlZCkKIAkJcXVldWVfZXhw
aXJlZChwLCBycSk7CisJZGVidWdfY2hlY2tfc2xvdF92YWxpZGl0eShwKTsKIAlsaXN0X21vdmVf
dGFpbCgmcC0+cnVuX2xpc3QsIHAtPmFycmF5LT5xdWV1ZSArIHAtPnByaW8pOwogCWlmICghcnRf
dGFzayhwKSkgewogCQlpZiAobGlzdF9lbXB0eShvbGRfYXJyYXktPnF1ZXVlICsgb2xkX3ByaW8p
KQo=
------=_Part_38899_22924074.1176419734780--
