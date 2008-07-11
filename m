Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYGKXD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYGKXD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 19:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752819AbYGKXDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 19:03:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:8480 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbYGKXDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 19:03:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=cjHuRJvOGmeuHLmk+IRNbd6SOH4SHWnkkLA+4yLi/PbTZ/eJuk0+QF5HdyT8bhUSb8
         um/qRHr5/e/hNKPk6mLrSuA0deMYT7OaWavwGgyK0qrRlgjOXbFUqo+qyAGGhcnYNAry
         vN3xTHESAm3GeExGsGzP4DKsgptjEkAgncbic=
Message-ID: <b647ffbd0807111603m45b65f73q90399891fb8795f1@mail.gmail.com>
Date: Sat, 12 Jul 2008 01:03:18 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: current linux-2.6.git: cpusets completely broken
Cc: "Paul Menage" <menage@google.com>, "Max Krasnyansky" <maxk@qualcomm.com>,
       "Paul Jackson" <pj@sgi.com>, "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       miaox@cn.fujitsu.com, rostedt@goodmis.org,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0807111243s549b0facvbd0a650358463231@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_32131_12938469.1215817398836"
References: <19f34abd0807111207q2ad2011csdb46c6f451fe0f6d@mail.gmail.com>
	 <6599ad830807111236t2bc9aa02ned59dcc58f14b1bf@mail.gmail.com>
	 <19f34abd0807111243s549b0facvbd0a650358463231@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_32131_12938469.1215817398836
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

2008/7/11 Vegard Nossum <vegard.nossum@gmail.com>:
> On Fri, Jul 11, 2008 at 9:36 PM, Paul Menage <menage@google.com> wrote:
>> On Fri, Jul 11, 2008 at 12:07 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>>
>>> The result of having CPUSETS enabled as above is a 100% reproducible
>>> BUG on the very first cpu hot-unplug:
>>>
>>> ------------[ cut here ]------------
>>> kernel BUG at xxx/linux-2.6/kernel/sched.c:5859!
>>
>> That doesn't quite match up with any BUG in 2.6.26-rc9 - what tree is
>> this last crash based on?
>
> latest mainline. Commit e5a5816f7875207cb0a0a7032e39a4686c5e10a4.
>
> Is this one:
>
> /* called under rq->lock with disabled interrupts */
> static void migrate_dead(unsigned int dead_cpu, struct task_struct *p)
> {
>        struct rq *rq = cpu_rq(dead_cpu);
>
>        /* Must be exiting, otherwise would be on tasklist. */
>        BUG_ON(!p->exit_state);
>
>>> Also, this is on the latest linux-2.6.git! Since we're so close to
>>> release, maybe cpusets should simply be marked BROKEN for now? (Unless
>>> we can fix it, of course. The alternative is to apply Miao Xie's
>>> workaround patch temporarily.)
>>
>> If we were going to mark anything as broken, wouldn't cpu-hotplug be
>> the more appropriate victim? I suspect that there are more systems
>> using cpusets in production environments than using cpu hotplug. But
>> as you say, fixing it sounds better.
>
> I'm sorry for the harsh characterization and suggestion; please accept
> my apology. It was purely a result of my excitement at having made
> some progress in this case.
>
> But I have more good news; reverting this:
>
> commit f18f982abf183e91f435990d337164c7a43d1e6d
> Author: Max Krasnyansky <maxk@qualcomm.com>
> Date:   Thu May 29 11:17:01 2008 -0700
>
>    sched: CPU hotplug events must not destroy scheduler domains created by the
> cpusets

Does the patch below help?

(non-white-space-damaged version is attached)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 9fceb97..ae61dc9 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1912,11 +1912,21 @@ static void common_cpu_mem_hotplug_unplug(void)
 static int cpuset_handle_cpuhp(struct notifier_block *unused_nb,
                                unsigned long phase, void *unused_cpu)
 {
-       if (phase == CPU_DYING || phase == CPU_DYING_FROZEN)
+       swicth (phase) {
+       case CPU_UP_CANCELED:
+       case CPU_UP_CANCELED_FROZEN:
+       case CPU_DOWN_FAILED:
+       case CPU_DOWN_FAILED_FROZEN:
+       case CPU_ONLINE:
+       case CPU_ONLINE_FROZEN:
+       case CPU_DEAD:
+       case CPU_DEAD_FROZEN:
+               common_cpu_mem_hotplug_unplug();
+               break;
+       default:
                return NOTIFY_DONE;

-       common_cpu_mem_hotplug_unplug();
-       return 0;
+       return NOTIFY_OK;
 }

 #ifdef CONFIG_MEMORY_HOTPLU



-- 
Best regards,
Dmitry Adamushko

------=_Part_32131_12938469.1215817398836
Content-Type: text/x-diff; name=003-fix-cpuset.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fije9rch0
Content-Disposition: attachment; filename=003-fix-cpuset.patch

ZGlmZiAtLWdpdCBhL2tlcm5lbC9jcHVzZXQuYyBiL2tlcm5lbC9jcHVzZXQuYwppbmRleCA5ZmNl
Yjk3Li5hZTYxZGM5IDEwMDY0NAotLS0gYS9rZXJuZWwvY3B1c2V0LmMKKysrIGIva2VybmVsL2Nw
dXNldC5jCkBAIC0xOTEyLDExICsxOTEyLDIxIEBAIHN0YXRpYyB2b2lkIGNvbW1vbl9jcHVfbWVt
X2hvdHBsdWdfdW5wbHVnKHZvaWQpCiBzdGF0aWMgaW50IGNwdXNldF9oYW5kbGVfY3B1aHAoc3Ry
dWN0IG5vdGlmaWVyX2Jsb2NrICp1bnVzZWRfbmIsCiAJCQkJdW5zaWduZWQgbG9uZyBwaGFzZSwg
dm9pZCAqdW51c2VkX2NwdSkKIHsKLQlpZiAocGhhc2UgPT0gQ1BVX0RZSU5HIHx8IHBoYXNlID09
IENQVV9EWUlOR19GUk9aRU4pCisJc3dpY3RoIChwaGFzZSkgeworCWNhc2UgQ1BVX1VQX0NBTkNF
TEVEOgorCWNhc2UgQ1BVX1VQX0NBTkNFTEVEX0ZST1pFTjoKKwljYXNlIENQVV9ET1dOX0ZBSUxF
RDoKKwljYXNlIENQVV9ET1dOX0ZBSUxFRF9GUk9aRU46CisJY2FzZSBDUFVfT05MSU5FOgorCWNh
c2UgQ1BVX09OTElORV9GUk9aRU46CisJY2FzZSBDUFVfREVBRDoKKwljYXNlIENQVV9ERUFEX0ZS
T1pFTjoKKwkJY29tbW9uX2NwdV9tZW1faG90cGx1Z191bnBsdWcoKTsKKwkJYnJlYWs7CisJZGVm
YXVsdDoKIAkJcmV0dXJuIE5PVElGWV9ET05FOwogCi0JY29tbW9uX2NwdV9tZW1faG90cGx1Z191
bnBsdWcoKTsKLQlyZXR1cm4gMDsKKwlyZXR1cm4gTk9USUZZX09LOwogfQogCiAjaWZkZWYgQ09O
RklHX01FTU9SWV9IT1RQTFVHCg==
------=_Part_32131_12938469.1215817398836--
