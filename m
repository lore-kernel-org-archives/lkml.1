Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbYGaKNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbYGaKNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbYGaKNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:13:30 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:51862 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113AbYGaKN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:13:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=WLqnJ0po7nknyMzRBLRt6RDJ2KooyuXHEZINbAa3s5I0R5SnHaUBZsw5yk6ehg99GM
         t9lNXk4LQz3CWqevO8AGR/ot++ZBzX9ySFUaw7OwUPB1Q/2Z8PEkX/MSnbdSIAUCAgm4
         GKiXGAaFrHtSJXN9LJozYUdKZHcNFg64KFmRI=
Message-ID: <520f0cf10807310313q45599221q3db1b6fd7e7c722f@mail.gmail.com>
Date: Thu, 31 Jul 2008 12:13:24 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Sebastien Dugue" <sebastien.dugue@bull.net>
Subject: Re: [PATCH] Fix Bug messages
Cc: "Chirag Jog" <chirag@linux.vnet.ibm.com>,
       "J?rgen Mell" <j.mell@t-online.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Clark Williams" <williams@redhat.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Josh Triplett" <josht@linux.vnet.ibm.com>,
       "Timothy R. Chavez" <tim.chavez@linux.vnet.ibm.com>
In-Reply-To: <20080731100023.0221ec2b@bull.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_3146_33459054.1217499204794"
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0807291440240.14925@apollo.tec.linutronix.de>
	 <alpine.LFD.1.10.0807300006180.14925@apollo.tec.linutronix.de>
	 <200807301101.32417.j.mell@t-online.de>
	 <20080730171842.GB3420@linux.vnet.ibm.com>
	 <20080731100023.0221ec2b@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_3146_33459054.1217499204794
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thu, Jul 31, 2008 at 10:00 AM, Sebastien Dugue
<sebastien.dugue@bull.net> wrote:
> On Wed, 30 Jul 2008 22:48:42 +0530 Chirag Jog <chirag@linux.vnet.ibm.com>=
 wrote:
>
>> * J?rgen Mell <j.mell@t-online.de> [2008-07-30 11:01:32]:
>>
>> > Hello Thomas,
>> >
>> > On Wednesday, 30. July 2008, Thomas Gleixner wrote:
>> > > We are pleased to announce the 2.6.26-rt1 tree, which can be
>> > > downloaded from the location:
>> >
>> > I have tried the new kernel and have some good news and some bad news:
>> >
>> > The good news: The machine boots and seems to run without major proble=
ms.
>> >
>> > The bad news: It produces continuously lots of bug messages in the err=
or
>> > logs (cf. attached dmesg.tgz). The error at rtmutex.c:743 was already
>> > present in 2.6.25-rt* when ACPI was enabled. The 'using smp_processor_=
id
>> > ()  in preemptible code' is new here with 2.6.26.
>> >
>> > Machine is an old Athlon XP (single core) on an EPOX mainboard with VI=
A
>> > chipset.
>> >
>> > If I can help with testing, please let me know.
>> >
>> > Bye,
>> >          J=FCrgen
>> >
>> >
>> This patch should solve some of the bug messages.
>> It does two things:
>> 1. Change rt_runtime_lock to be a raw spinlock as the comment above it
>> says: it is nested inside the rq lock.
>>
>> 2. Change mnt_writers to be a per_cpu locked variable.
>> This eliminates the need for the codepath to disable preemption and
>> then potentially sleep, leading to the BUG messages
>>
>> Signed-Off-By: Chirag <chirag@linux.vnet.ibm.com>
>
>  Neat, the only remaining BUGs I see are from sock_prot_inuse_add()
>
> BUG: using smp_processor_id() in preemptible [00000000] code: arping/1916
> caller is .sock_prot_inuse_add+0x30/0x80
> Call Trace:
> [c0000000eed2f910] [c000000000010304] .show_stack+0x70/0x1bc (unreliable)
> [c0000000eed2f9c0] [c0000000001a2340] .debug_smp_processor_id+0x138/0x168
> [c0000000eed2fa70] [c0000000002181f4] .sock_prot_inuse_add+0x30/0x80
> [c0000000eed2fb10] [c00000000026d96c] .udp_lib_get_port+0x2a8/0x320
> [c0000000eed2fbc0] [c000000000275b30] .inet_bind+0x168/0x248
> [c0000000eed2fc60] [c000000000215024] .sys_bind+0x98/0xdc
> [c0000000eed2fd90] [c0000000002370bc] .compat_sys_socketcall+0xcc/0x214
> [c0000000eed2fe30] [c0000000000086ac] syscall_exit+0x0/0x40
> BUG: arping:1916 task might have lost a preemption check!
> Call Trace:
> [c0000000eed2f890] [c000000000010304] .show_stack+0x70/0x1bc (unreliable)
> [c0000000eed2f940] [c00000000004e298] .preempt_enable_no_resched+0x60/0x7=
8
> [c0000000eed2f9c0] [c0000000001a2348] .debug_smp_processor_id+0x140/0x168
> [c0000000eed2fa70] [c0000000002181f4] .sock_prot_inuse_add+0x30/0x80
> [c0000000eed2fb10] [c00000000026d96c] .udp_lib_get_port+0x2a8/0x320
> [c0000000eed2fbc0] [c000000000275b30] .inet_bind+0x168/0x248
> [c0000000eed2fc60] [c000000000215024] .sys_bind+0x98/0xdc
> [c0000000eed2fd90] [c0000000002370bc] .compat_sys_socketcall+0xcc/0x214
> [c0000000eed2fe30] [c0000000000086ac] syscall_exit+0x0/0x40
>

Does this simple fix do the trick for you?

------=_Part_3146_33459054.1217499204794
Content-Type: text/x-patch; name=sock_prot_inuse_add-fix.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjb7ja1q0
Content-Disposition: attachment; filename=sock_prot_inuse_add-fix.patch

U2lnbmVkLW9mZi1ieTogSm9obiBLYWN1ciA8amthY3VyQGdtYWlsLmNvbT4KCkluZGV4OiBsaW51
eC0yLjYuMjYtcnQxL25ldC9jb3JlL3NvY2suYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYuMjYt
cnQxLm9yaWcvbmV0L2NvcmUvc29jay5jCisrKyBsaW51eC0yLjYuMjYtcnQxL25ldC9jb3JlL3Nv
Y2suYwpAQCAtMTk0Myw3ICsxOTQzLDcgQEAgc3RhdGljIERFQ0xBUkVfQklUTUFQKHByb3RvX2lu
dXNlX2lkeCwgUAogI2lmZGVmIENPTkZJR19ORVRfTlMKIHZvaWQgc29ja19wcm90X2ludXNlX2Fk
ZChzdHJ1Y3QgbmV0ICpuZXQsIHN0cnVjdCBwcm90byAqcHJvdCwgaW50IHZhbCkKIHsKLQlpbnQg
Y3B1ID0gc21wX3Byb2Nlc3Nvcl9pZCgpOworCWludCBjcHUgPSByYXdfc21wX3Byb2Nlc3Nvcl9p
ZCgpOwogCXBlcl9jcHVfcHRyKG5ldC0+Y29yZS5pbnVzZSwgY3B1KS0+dmFsW3Byb3QtPmludXNl
X2lkeF0gKz0gdmFsOwogfQogRVhQT1JUX1NZTUJPTF9HUEwoc29ja19wcm90X2ludXNlX2FkZCk7
Cg==
------=_Part_3146_33459054.1217499204794--
