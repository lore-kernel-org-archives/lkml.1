Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbYCCLy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbYCCLy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 06:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbYCCLyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 06:54:49 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:59152 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbYCCLys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 06:54:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=Z2DHJDlqkowCidR4gc/vYmQZA7hh5GXRi2ePiIkntveybhiybaQpaKr2S/h4roHU4FkjWD0aYN3bhDgDIBIVIbF8QPfs+QTNkn87Mlpuf0p2NVZCGsgCwLE3o51YKdc8AUwtUBIZKIM+YdQPu7zxsrB5hyd/1e+kPgWaD++S3/k=
Message-ID: <b647ffbd0803030354s268089fo8e5b8f647ada0aae@mail.gmail.com>
Date: Mon, 3 Mar 2008 12:54:47 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: yi.y.yang@intel.com
Subject: Re: [BUG 2.6.25-rc3] scheduler/hotplug: some processes are dealocked when cpu is set to offline
Cc: "Ingo Molnar" <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_1985_31506725.1204545287718"
References: <1204483329.3607.8.camel@yangyi-dev.bj.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_1985_31506725.1204545287718
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 02/03/2008, Yi Yang <yi.y.yang@intel.com> wrote:
> [ ... ]
>
>  Why isn't the kernel thread [watchdog/1] reaped by its parent?
> its state
>  is TASK_RUNNING with high priority (R< means this), why it isn't done?
>
>  Anyone ever met such a problem? Your thought?
>

iirc, Andrew had the same issue.

'watchdog's are supposed to be stopped with kthread_stop() from
softlockup.c :: cpu_callback() :: case CPU_DEAD.

The 'R' state of 'watchdog' is strange indeed.

would you please conduct a test with the patch [1] below and provide
me with additional output it generates?

(non-white-space-damaged versions are enclosed)

with your current set-up and also with
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs"

Then please try also the patch [2] (on top of [1]). With this 'magic'
patch applied, the issue 'seemed' to disappear on Andrew's set-up...

Thanks in advacne,


[1]

--- softlockup-prev.c   2008-03-03 12:35:01.000000000 +0100
+++ softlockup.c        2008-03-03 12:38:01.000000000 +0100
@@ -237,6 +237,8 @@ static int watchdog(void *__bind_cpu)

        }

+       printk(KERN_WARN "-> watchdog(cpu: %d) is done\n", this_cpu);
+
        return 0;
 }

@@ -249,6 +251,9 @@ cpu_callback(struct notifier_block *nfb,
        int hotcpu = (unsigned long)hcpu;
        struct task_struct *p;

+       printk(KERN_WARN "-> cpu_callback(cpu: %d, action: %lu,
check_cpu: %d)\n",
+               hotcpu, action, check_cpu);
+
        switch (action) {
        case CPU_UP_PREPARE:
        case CPU_UP_PREPARE_FROZEN:


[2]

--- softlockup-prev-2.c 2008-03-03 12:38:36.000000000 +0100
+++ softlockup.c        2008-03-03 12:39:02.000000000 +0100
@@ -294,6 +294,7 @@ cpu_callback(struct notifier_block *nfb,
        case CPU_DEAD_FROZEN:
                p = per_cpu(watchdog_task, hotcpu);
                per_cpu(watchdog_task, hotcpu) = NULL;
+               mlseep(1);
                kthread_stop(p);
                break;
 #endif /* CONFIG_HOTPLUG_CPU */


-- 
Best regards,
Dmitry Adamushko

------=_Part_1985_31506725.1204545287718
Content-Type: text/x-patch; name=softlockup-debug-1.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdcz58uz
Content-Disposition: attachment; filename=softlockup-debug-1.patch

LS0tIHNvZnRsb2NrdXAtcHJldi5jCTIwMDgtMDMtMDMgMTI6MzU6MDEuMDAwMDAwMDAwICswMTAw
CisrKyBzb2Z0bG9ja3VwLmMJMjAwOC0wMy0wMyAxMjozODowMS4wMDAwMDAwMDAgKzAxMDAKQEAg
LTIzNyw2ICsyMzcsOCBAQCBzdGF0aWMgaW50IHdhdGNoZG9nKHZvaWQgKl9fYmluZF9jcHUpCiAK
IAl9CiAKKwlwcmludGsoS0VSTl9XQVJOICItPiB3YXRjaGRvZyhjcHU6ICVkKSBpcyBkb25lXG4i
LCB0aGlzX2NwdSk7CisKIAlyZXR1cm4gMDsKIH0KIApAQCAtMjQ5LDYgKzI1MSw5IEBAIGNwdV9j
YWxsYmFjayhzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5mYiwKIAlpbnQgaG90Y3B1ID0gKHVuc2ln
bmVkIGxvbmcpaGNwdTsKIAlzdHJ1Y3QgdGFza19zdHJ1Y3QgKnA7CiAKKwlwcmludGsoS0VSTl9X
QVJOICItPiBjcHVfY2FsbGJhY2soY3B1OiAlZCwgYWN0aW9uOiAlbHUsIGNoZWNrX2NwdTogJWQp
XG4iLAorCQlob3RjcHUsIGFjdGlvbiwgY2hlY2tfY3B1KTsKKwogCXN3aXRjaCAoYWN0aW9uKSB7
CiAJY2FzZSBDUFVfVVBfUFJFUEFSRToKIAljYXNlIENQVV9VUF9QUkVQQVJFX0ZST1pFTjoK
------=_Part_1985_31506725.1204545287718
Content-Type: text/x-patch; name=softlockup-debug-2.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdcz5fk9
Content-Disposition: attachment; filename=softlockup-debug-2.patch

LS0tIHNvZnRsb2NrdXAtcHJldi0yLmMJMjAwOC0wMy0wMyAxMjozODozNi4wMDAwMDAwMDAgKzAx
MDAKKysrIHNvZnRsb2NrdXAuYwkyMDA4LTAzLTAzIDEyOjM5OjAyLjAwMDAwMDAwMCArMDEwMApA
QCAtMjk0LDYgKzI5NCw3IEBAIGNwdV9jYWxsYmFjayhzdHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5m
YiwKIAljYXNlIENQVV9ERUFEX0ZST1pFTjoKIAkJcCA9IHBlcl9jcHUod2F0Y2hkb2dfdGFzaywg
aG90Y3B1KTsKIAkJcGVyX2NwdSh3YXRjaGRvZ190YXNrLCBob3RjcHUpID0gTlVMTDsKKwkJbWxz
ZWVwKDEpOwogCQlrdGhyZWFkX3N0b3AocCk7CiAJCWJyZWFrOwogI2VuZGlmIC8qIENPTkZJR19I
T1RQTFVHX0NQVSAqLwo=
------=_Part_1985_31506725.1204545287718--
