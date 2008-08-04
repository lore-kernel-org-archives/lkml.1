Return-Path: <linux-kernel-owner+w=401wt.eu-S1763624AbYHDUwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763624AbYHDUwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbYHDUwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:52:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:65062 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698AbYHDUwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:52:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=q76xr2OEbDGcVFTmWYfKmsPNRALEzf4YE0xaqakbd5Niu2DtiznxCXtPrSeb3JkkvP
         W3gLVAKfQdJ6iUcNJO/ctmZbQGBTtYg/pa9qIvAhiUg9IJatLgB9F3jIzdnvPRf+h9jK
         /zJzOFxv4r8QVNcq93Pq32FzdBgGokeU6DZZs=
Message-ID: <520f0cf10808041352h78bd4319x1802f018aeffe6dc@mail.gmail.com>
Date: Mon, 4 Aug 2008 22:52:19 +0200
From: "John Kacur" <jkacur@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: [PATCH RFC] pm_qos_requirement might sleep
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Zijlstra" <peterz@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_35101_28729097.1217883139712"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_35101_28729097.1217883139712
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Even after applying some fixes posted by Chirag and Peter Z, I'm still
getting some messages in my log like this
BUG: sleeping function called from invalid context swapper(0) at
kernel/rtmutex.c:743
in_atomic():1 [00000001], irqs_disabled():1
Pid: 0, comm: swapper Tainted: G        W 2.6.26.1-rt1.jk #2

Call Trace:
 [<ffffffff802305d3>] __might_sleep+0x12d/0x132
 [<ffffffff8046cdbe>] __rt_spin_lock+0x34/0x7d
 [<ffffffff8046ce15>] rt_spin_lock+0xe/0x10
 [<ffffffff802532e5>] pm_qos_requirement+0x1f/0x3c
 [<ffffffff803e1b7f>] menu_select+0x7b/0x9c
 [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
 [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
 [<ffffffff803e0b4b>] cpuidle_idle_call+0x68/0xd8
 [<ffffffff803e0ae3>] ? cpuidle_idle_call+0x0/0xd8
 [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
 [<ffffffff8020b333>] cpu_idle+0xb2/0x12d
 [<ffffffff80466af0>] start_secondary+0x186/0x18b

---------------------------
| preempt count: 00000001 ]
| 1-level deep critical section nesting:
----------------------------------------
.. [<ffffffff8020b39c>] .... cpu_idle+0x11b/0x12d
.....[<ffffffff80466af0>] ..   ( <= start_secondary+0x186/0x18b)

The following simple patch makes the messages disappear - however,
there may be a better more fine grained solution, but the problem is
also that all the functions are designed to use the same lock.

------=_Part_35101_28729097.1217883139712
Content-Type: text/x-patch; name=pm_qos_requirement.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjhk3o5e0
Content-Disposition: attachment; filename=pm_qos_requirement.patch

cG1fcW9zX3JlcXVpcmVtZW50LWZpeApTaWduZWQtb2ZmLWJ5OiBKb2huIEthY3VyIDxqa2FjdXIg
YXQgZ21haWwgZG90IGNvbT4KCkluZGV4OiBsaW51eC0yLjYuMjYuMS1qay1ydDEva2VybmVsL3Bt
X3Fvc19wYXJhbXMuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYuMjYuMS1qay1ydDEub3JpZy9r
ZXJuZWwvcG1fcW9zX3BhcmFtcy5jCisrKyBsaW51eC0yLjYuMjYuMS1qay1ydDEva2VybmVsL3Bt
X3Fvc19wYXJhbXMuYwpAQCAtMTEwLDcgKzExMCw3IEBAIHN0YXRpYyBzdHJ1Y3QgcG1fcW9zX29i
amVjdCAqcG1fcW9zX2FycmEKIAkmbmV0d29ya190aHJvdWdocHV0X3BtX3FvcwogfTsKIAotc3Rh
dGljIERFRklORV9TUElOTE9DSyhwbV9xb3NfbG9jayk7CitzdGF0aWMgREVGSU5FX1JBV19TUElO
TE9DSyhwbV9xb3NfbG9jayk7CiAKIHN0YXRpYyBzc2l6ZV90IHBtX3Fvc19wb3dlcl93cml0ZShz
dHJ1Y3QgZmlsZSAqZmlscCwgY29uc3QgY2hhciBfX3VzZXIgKmJ1ZiwKIAkJc2l6ZV90IGNvdW50
LCBsb2ZmX3QgKmZfcG9zKTsK
------=_Part_35101_28729097.1217883139712--
