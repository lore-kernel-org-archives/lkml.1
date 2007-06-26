Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbXFZBqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbXFZBqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 21:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbXFZBql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 21:46:41 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:42038 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbXFZBqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 21:46:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:references:x-google-sender-auth;
        b=SJZNkMzu+Ky2dKIn8Gu1QpP5xTiznAFLK7AEfZdiBygizHwZWTtN7bct9A15THSewDX3JYJhlfdcdVwmiTrArVMaZeDmvtFlcFCs/+DwM9QhmCklXngnjC1X5txtuTeSspbz6ZqHxM+IsAuwkuip4yh0mjTmCg7t497J8jKbPCE=
Message-ID: <e9c3a7c20706251846v17347ab2n4a1d314734528c95@mail.gmail.com>
Date: Mon, 25 Jun 2007 18:46:39 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC PATCH 0/6] Convert all tasklets to workqueues
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Christoph Hellwig" <hch@infradead.org>,
       "john stultz" <johnstul@us.ibm.com>, "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Dipankar Sarma" <dipankar@in.ibm.com>,
       "David S. Miller" <davem@davemloft.net>, matthew.wilcox@hp.com,
       kuznet@ms2.inr.ac.ru
In-Reply-To: <20070622215953.GA22917@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_15972_20500424.1182822399594"
References: <20070622040014.234651401@goodmis.org>
	 <alpine.LFD.0.98.0706221010490.3593@woody.linux-foundation.org>
	 <20070622204058.GA11777@elte.hu>
	 <alpine.LFD.0.98.0706221432080.3593@woody.linux-foundation.org>
	 <20070622215953.GA22917@elte.hu>
X-Google-Sender-Auth: d4c514fd01c4582b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_15972_20500424.1182822399594
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> so how about the following, different approach: anyone who has a tasklet
> in any performance-sensitive codepath, please yell now. We'll also do a
> proactive search for such places. We can convert those places to
> softirqs, or move them back into hardirq context. Once this is done -
> and i doubt it will go beyond 1-2 places - we can just mass-convert the
> other 110 places to the lame but compatible solution of doing them in a
> global thread context.
>

I have a driver / testcase that reacts negatively to a workqueue
conversion.  This is with the iop-adma driver on an ARM based platform
re-syncing a degraded raid5 array.  The driver is currently in -mm and
it uses tasklets to run a short callback routine upon completion of an
offloaded memcpy or xor operation.  Quick tests show that
write-throughput does not go down too much, but resync speed, as
reported by /proc/mdstat, drops from ~50MB/s to ~30MB/s.

Context switches on this platform flush the L1 cache so bouncing
between a workqueue and the MD thread is painful.

The conversion patch is attached.

--
Dan

------=_Part_15972_20500424.1182822399594
Content-Type: text/x-patch; name=iop-adma-workq-conv.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f3dpuj5t
Content-Disposition: attachment; filename="iop-adma-workq-conv.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZG1hL2lvcC1hZG1hLmMgYi9kcml2ZXJzL2RtYS9pb3AtYWRt
YS5jCmluZGV4IDVkOGE2Y2YuLjdlODkwMDMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZG1hL2lvcC1h
ZG1hLmMKKysrIGIvZHJpdmVycy9kbWEvaW9wLWFkbWEuYwpAQCAtNDEsNiArNDEsOCBAQAogI2Rl
ZmluZSB0eF90b19pb3BfYWRtYV9zbG90KHR4KSBcCiAJY29udGFpbmVyX29mKHR4LCBzdHJ1Y3Qg
aW9wX2FkbWFfZGVzY19zbG90LCBhc3luY190eCkKIAorc3RhdGljIHN0cnVjdCB3b3JrcXVldWVf
c3RydWN0ICppb3BfYWRtYV93b3JrcXVldWU7CisKIC8qKgogICogaW9wX2FkbWFfZnJlZV9zbG90
cyAtIGZsYWdzIGRlc2NyaXB0b3Igc2xvdHMgZm9yIHJldXNlCiAgKiBAc2xvdDogU2xvdCB0byBm
cmVlCkBAIC0yNzMsOSArMjc1LDExIEBAIGlvcF9hZG1hX3Nsb3RfY2xlYW51cChzdHJ1Y3QgaW9w
X2FkbWFfY2hhbiAqaW9wX2NoYW4pCiAJc3Bpbl91bmxvY2tfYmgoJmlvcF9jaGFuLT5sb2NrKTsK
IH0KIAotc3RhdGljIHZvaWQgaW9wX2FkbWFfdGFza2xldCh1bnNpZ25lZCBsb25nIGRhdGEpCitz
dGF0aWMgdm9pZCBpb3BfYWRtYV93b3JrX3JvdXRpbmUoc3RydWN0IHdvcmtfc3RydWN0ICp3b3Jr
KQogewotCXN0cnVjdCBpb3BfYWRtYV9jaGFuICpjaGFuID0gKHN0cnVjdCBpb3BfYWRtYV9jaGFu
ICopIGRhdGE7CisJc3RydWN0IGlvcF9hZG1hX2NoYW4gKmNoYW4gPQorCQljb250YWluZXJfb2Yo
d29yaywgc3RydWN0IGlvcF9hZG1hX2NoYW4sIHdvcmspOworCiAJX19pb3BfYWRtYV9zbG90X2Ns
ZWFudXAoY2hhbik7CiB9CiAKQEAgLTM3MCw3ICszNzQsNyBAQCByZXRyeToKIAkJZ290byByZXRy
eTsKIAogCS8qIHRyeSB0byBmcmVlIHNvbWUgc2xvdHMgaWYgdGhlIGFsbG9jYXRpb24gZmFpbHMg
Ki8KLQl0YXNrbGV0X3NjaGVkdWxlKCZpb3BfY2hhbi0+aXJxX3Rhc2tsZXQpOworCXF1ZXVlX3dv
cmsoaW9wX2FkbWFfd29ya3F1ZXVlLCAmaW9wX2NoYW4tPndvcmspOwogCiAJcmV0dXJuIE5VTEw7
CiB9CkBAIC03MDQsNyArNzA4LDcgQEAgaW9wX2FkbWFfcHJlcF9kbWFfemVyb19zdW0oc3RydWN0
IGRtYV9jaGFuICpjaGFuLCB1bnNpZ25lZCBpbnQgc3JjX2NudCwKIHN0YXRpYyB2b2lkIGlvcF9h
ZG1hX2RlcGVuZGVuY3lfYWRkZWQoc3RydWN0IGRtYV9jaGFuICpjaGFuKQogewogCXN0cnVjdCBp
b3BfYWRtYV9jaGFuICppb3BfY2hhbiA9IHRvX2lvcF9hZG1hX2NoYW4oY2hhbik7Ci0JdGFza2xl
dF9zY2hlZHVsZSgmaW9wX2NoYW4tPmlycV90YXNrbGV0KTsKKwlxdWV1ZV93b3JrKGlvcF9hZG1h
X3dvcmtxdWV1ZSwgJmlvcF9jaGFuLT53b3JrKTsKIH0KIAogc3RhdGljIHZvaWQgaW9wX2FkbWFf
ZnJlZV9jaGFuX3Jlc291cmNlcyhzdHJ1Y3QgZG1hX2NoYW4gKmNoYW4pCkBAIC03ODUsNyArNzg5
LDcgQEAgc3RhdGljIGlycXJldHVybl90IGlvcF9hZG1hX2VvdF9oYW5kbGVyKGludCBpcnEsIHZv
aWQgKmRhdGEpCiAKIAlkZXZfZGJnKGNoYW4tPmRldmljZS0+Y29tbW9uLmRldiwgIiVzXG4iLCBf
X0ZVTkNUSU9OX18pOwogCi0JdGFza2xldF9zY2hlZHVsZSgmY2hhbi0+aXJxX3Rhc2tsZXQpOwor
CXF1ZXVlX3dvcmsoaW9wX2FkbWFfd29ya3F1ZXVlLCAmY2hhbi0+d29yayk7CiAKIAlpb3BfYWRt
YV9kZXZpY2VfY2xlYXJfZW90X3N0YXR1cyhjaGFuKTsKIApAQCAtNzk4LDcgKzgwMiw3IEBAIHN0
YXRpYyBpcnFyZXR1cm5fdCBpb3BfYWRtYV9lb2NfaGFuZGxlcihpbnQgaXJxLCB2b2lkICpkYXRh
KQogCiAJZGV2X2RiZyhjaGFuLT5kZXZpY2UtPmNvbW1vbi5kZXYsICIlc1xuIiwgX19GVU5DVElP
Tl9fKTsKIAotCXRhc2tsZXRfc2NoZWR1bGUoJmNoYW4tPmlycV90YXNrbGV0KTsKKwlxdWV1ZV93
b3JrKGlvcF9hZG1hX3dvcmtxdWV1ZSwgJmNoYW4tPndvcmspOwogCiAJaW9wX2FkbWFfZGV2aWNl
X2NsZWFyX2VvY19zdGF0dXMoY2hhbik7CiAKQEAgLTEyNDQsOCArMTI0OCw2IEBAIHN0YXRpYyBp
bnQgX19kZXZpbml0IGlvcF9hZG1hX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYp
CiAJCXJldCA9IC1FTk9NRU07CiAJCWdvdG8gZXJyX2ZyZWVfaW9wX2NoYW47CiAJfQotCXRhc2ts
ZXRfaW5pdCgmaW9wX2NoYW4tPmlycV90YXNrbGV0LCBpb3BfYWRtYV90YXNrbGV0LCAodW5zaWdu
ZWQgbG9uZykKLQkJaW9wX2NoYW4pOwogCiAJLyogY2xlYXIgZXJyb3JzIGJlZm9yZSBlbmFibGlu
ZyBpbnRlcnJ1cHRzICovCiAJaW9wX2FkbWFfZGV2aWNlX2NsZWFyX2Vycl9zdGF0dXMoaW9wX2No
YW4pOwpAQCAtMTI2OCwxMSArMTI3MCwxMyBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBpb3BfYWRt
YV9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCiAJc3Bpbl9sb2NrX2luaXQo
JmlvcF9jaGFuLT5sb2NrKTsKIAlpbml0X3RpbWVyKCZpb3BfY2hhbi0+Y2xlYW51cF93YXRjaGRv
Zyk7Ci0JaW9wX2NoYW4tPmNsZWFudXBfd2F0Y2hkb2cuZGF0YSA9ICh1bnNpZ25lZCBsb25nKSBp
b3BfY2hhbjsKLQlpb3BfY2hhbi0+Y2xlYW51cF93YXRjaGRvZy5mdW5jdGlvbiA9IGlvcF9hZG1h
X3Rhc2tsZXQ7CisJaW9wX2NoYW4tPmNsZWFudXBfd2F0Y2hkb2cuZGF0YSA9ICh1bnNpZ25lZCBs
b25nKSAmaW9wX2NoYW4tPndvcms7CisJaW9wX2NoYW4tPmNsZWFudXBfd2F0Y2hkb2cuZnVuY3Rp
b24gPSBpb3BfYWRtYV93b3JrX3JvdXRpbmU7CiAJSU5JVF9MSVNUX0hFQUQoJmlvcF9jaGFuLT5j
aGFpbik7CiAJSU5JVF9MSVNUX0hFQUQoJmlvcF9jaGFuLT5hbGxfc2xvdHMpOwogCUlOSVRfUkNV
X0hFQUQoJmlvcF9jaGFuLT5jb21tb24ucmN1KTsKKwlJTklUX1dPUksoJmlvcF9jaGFuLT53b3Jr
LCBpb3BfYWRtYV93b3JrX3JvdXRpbmUpOworCiAJaW9wX2NoYW4tPmNvbW1vbi5kZXZpY2UgPSBk
bWFfZGV2OwogCWxpc3RfYWRkX3RhaWwoJmlvcF9jaGFuLT5jb21tb24uZGV2aWNlX25vZGUsICZk
bWFfZGV2LT5jaGFubmVscyk7CiAKQEAgLTE0NDMsNiArMTQ0NywxMCBAQCBzdGF0aWMgc3RydWN0
IHBsYXRmb3JtX2RyaXZlciBpb3BfYWRtYV9kcml2ZXIgPSB7CiAKIHN0YXRpYyBpbnQgX19pbml0
IGlvcF9hZG1hX2luaXQgKHZvaWQpCiB7CisJaW9wX2FkbWFfd29ya3F1ZXVlID0gY3JlYXRlX3dv
cmtxdWV1ZSgiaW9wLWFkbWEiKTsKKwlpZiAoIWlvcF9hZG1hX3dvcmtxdWV1ZSkKKwkJcmV0dXJu
IC1FTk9ERVY7CisKIAkvKiBpdCdzIGN1cnJlbnRseSB1bnNhZmUgdG8gdW5sb2FkIHRoaXMgbW9k
dWxlICovCiAJLyogaWYgZm9yY2VkLCB3b3JzdCBjYXNlIGlzIHRoYXQgcm1tb2QgaGFuZ3MgKi8K
IAlfX3Vuc2FmZShUSElTX01PRFVMRSk7CmRpZmYgLS1naXQgYS9pbmNsdWRlL2FzbS1hcm0vaGFy
ZHdhcmUvaW9wX2FkbWEuaCBiL2luY2x1ZGUvYXNtLWFybS9oYXJkd2FyZS9pb3BfYWRtYS5oCmlu
ZGV4IDhlYjU5OTAuLjdkODc0MmIgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvYXNtLWFybS9oYXJkd2Fy
ZS9pb3BfYWRtYS5oCisrKyBiL2luY2x1ZGUvYXNtLWFybS9oYXJkd2FyZS9pb3BfYWRtYS5oCkBA
IC02Nyw3ICs2Nyw3IEBAIHN0cnVjdCBpb3BfYWRtYV9jaGFuIHsKIAlzdHJ1Y3QgbGlzdF9oZWFk
IGFsbF9zbG90czsKIAlzdHJ1Y3QgdGltZXJfbGlzdCBjbGVhbnVwX3dhdGNoZG9nOwogCWludCBz
bG90c19hbGxvY2F0ZWQ7Ci0Jc3RydWN0IHRhc2tsZXRfc3RydWN0IGlycV90YXNrbGV0OworCXN0
cnVjdCB3b3JrX3N0cnVjdCB3b3JrOwogfTsKIAogLyoqCg==
------=_Part_15972_20500424.1182822399594--
