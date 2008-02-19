Return-Path: <linux-kernel-owner+w=401wt.eu-S1761302AbYBSWkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761302AbYBSWkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbYBSWki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:40:38 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:64076 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbYBSWkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:40:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=wA/gIqRxo/i2reQukG2PJqsFGwS9vB1jo/dvWCeS3zOlNY5nVsw2t4c3pLPdO7cLS+zcmaQGEYrbfTXMQclBYkbLHGhQ2NyJtPcR4M9PjyqruBLyzRPt5sr7h62bLkcpS9uKGg42YPsZvoKwpwKe+hOqFNlgFBqpeNvJo2peVIE=
Message-ID: <12c511ca0802191440q6a2f5604xe6b563c32c3a90b2@mail.gmail.com>
Date: Tue, 19 Feb 2008 14:40:35 -0800
From: "Tony Luck" <tony.luck@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: Strange hang on ia64 with CONFIG_PRINTK_TIME=y
Cc: "David Miller" <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
In-Reply-To: <12c511ca0802141817i3295e83cxd7c05e07f2c54fea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_11673_8312711.1203460835389"
References: <20080213125725.GC6344@elte.hu>
	 <20080213.050340.64342037.davem@davemloft.net>
	 <12c511ca0802131659u6e4407d9w96148fe72d6e11d7@mail.gmail.com>
	 <20080213.170452.68851396.davem@davemloft.net>
	 <12c511ca0802131933g6aaaec9cidbfbfcac6f394c63@mail.gmail.com>
	 <adaprv0rygh.fsf@cisco.com>
	 <12c511ca0802141327j6e31e8c2tee1d679053b604fc@mail.gmail.com>
	 <ada7ih7qjoq.fsf@cisco.com>
	 <1FE6DD409037234FAB833C420AA843EC97C8B0@orsmsx424.amr.corp.intel.com>
	 <12c511ca0802141817i3295e83cxd7c05e07f2c54fea@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_11673_8312711.1203460835389
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> Perhaps what is happening is that cpu0 comes online ... safely skips
> over the early printk calls.  Calls cpu_init() which sets up the resources
> *it* needs (ar.k3 points to per-cpu space), and then executes
> sched_init() which marks it safe for all printk's. Then cpu1 comes
> up and does a printk before it gets to cpu_init().

I just tried Ingo's patch[1] on a 2.6.25-rc2 kernel with printk timestamps
turned on ... and it booted just fine on my tiger4.  The default path
for non-boot cpus is from head.S to start_secondary(), and that
calls cpu_init() pretty quickly.  There shouldn't normally[2] be any
printk() calls on the non-boot cpu before it is safe to do so.

-Tony

[1] Attached
[2] If you set #define SMP_DEBUG in arch/ia64/kernel/smpboot.c
that enables at least one printk() that will cause problems if you have
also configured timestamps.

------=_Part_11673_8312711.1203460835389
Content-Type: text/x-patch; name=ingo.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fcv1hlqr0
Content-Disposition: attachment; filename=ingo.patch

IGtlcm5lbC9zY2hlZC5jIHwgICAxNCArKysrKysrKysrLS0tLQogMSBmaWxlIGNoYW5nZWQsIDEw
IGluc2VydGlvbnMoKyksIDQgZGVsZXRpb25zKC0pCgpJbmRleDogbGludXgteDg2LnEva2VybmVs
L3NjaGVkLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgteDg2LnEub3JpZy9rZXJuZWwvc2NoZWQuYwor
KysgbGludXgteDg2LnEva2VybmVsL3NjaGVkLmMKQEAgLTY2Niw2ICs2NjYsOCBAQCBjb25zdF9k
ZWJ1ZyB1bnNpZ25lZCBpbnQgc3lzY3RsX3NjaGVkX3J0CiAgKi8KIGNvbnN0X2RlYnVnIHVuc2ln
bmVkIGludCBzeXNjdGxfc2NoZWRfcnRfcmF0aW8gPSA2MjI1OTsKIAorc3RhdGljIF9fcmVhZF9t
b3N0bHkgaW50IHNjaGVkdWxlcl9ydW5uaW5nOworCiAvKgogICogRm9yIGtlcm5lbC1pbnRlcm5h
bCB1c2U6IGhpZ2gtc3BlZWQgKGJ1dCBzbGlnaHRseSBpbmNvcnJlY3QpIHBlci1jcHUKICAqIGNs
b2NrIGNvbnN0cnVjdGVkIGZyb20gc2NoZWRfY2xvY2soKToKQEAgLTY3NiwxNCArNjc4LDE2IEBA
IHVuc2lnbmVkIGxvbmcgbG9uZyBjcHVfY2xvY2soaW50IGNwdSkKIAl1bnNpZ25lZCBsb25nIGZs
YWdzOwogCXN0cnVjdCBycSAqcnE7CiAKLQlsb2NhbF9pcnFfc2F2ZShmbGFncyk7Ci0JcnEgPSBj
cHVfcnEoY3B1KTsKIAkvKgogCSAqIE9ubHkgY2FsbCBzY2hlZF9jbG9jaygpIGlmIHRoZSBzY2hl
ZHVsZXIgaGFzIGFscmVhZHkgYmVlbgogCSAqIGluaXRpYWxpemVkIChzb21lIGNvZGUgbWlnaHQg
Y2FsbCBjcHVfY2xvY2soKSB2ZXJ5IGVhcmx5KToKIAkgKi8KLQlpZiAocnEtPmlkbGUpCi0JCXVw
ZGF0ZV9ycV9jbG9jayhycSk7CisJaWYgKHVubGlrZWx5KCFzY2hlZHVsZXJfcnVubmluZykpCisJ
CXJldHVybiAwOworCisJbG9jYWxfaXJxX3NhdmUoZmxhZ3MpOworCXJxID0gY3B1X3JxKGNwdSk7
CisJdXBkYXRlX3JxX2Nsb2NrKHJxKTsKIAlub3cgPSBycS0+Y2xvY2s7CiAJbG9jYWxfaXJxX3Jl
c3RvcmUoZmxhZ3MpOwogCkBAIC03MjU1LDYgKzcyNTksOCBAQCB2b2lkIF9faW5pdCBzY2hlZF9p
bml0KHZvaWQpCiAJICogRHVyaW5nIGVhcmx5IGJvb3R1cCB3ZSBwcmV0ZW5kIHRvIGJlIGEgbm9y
bWFsIHRhc2s6CiAJICovCiAJY3VycmVudC0+c2NoZWRfY2xhc3MgPSAmZmFpcl9zY2hlZF9jbGFz
czsKKworCXNjaGVkdWxlcl9ydW5uaW5nID0gMTsKIH0KIAogI2lmZGVmIENPTkZJR19ERUJVR19T
UElOTE9DS19TTEVFUAotLQo=
------=_Part_11673_8312711.1203460835389--
