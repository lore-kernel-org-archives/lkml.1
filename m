Return-Path: <linux-kernel-owner+w=401wt.eu-S1760603AbYG2Wrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603AbYG2Wrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 18:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbYG2WrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 18:47:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:47050 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbYG2WrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 18:47:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MxiIejcvdlGkcpWJ/bY0i13MCv5qE7KTOT0FZmIo4rFhP/AzrZJF7wK6MmCCpbvVw3
         fLgAWyuPvB0xQ5jQPRO0+7CzQorNxrHiGVvO/jUBNxxtF8rki3Z83FxuLPGOIULnaOHb
         espkzGfTUJAUL97bcS3Wqt3M3WylBKRfj/0/4=
Message-ID: <48f7fe350807291547g2d67eabcka5dc63c9c0e62239@mail.gmail.com>
Date: Tue, 29 Jul 2008 18:47:15 -0400
From: "Ryan Hope" <rmh3093@gmail.com>
To: "Norbert Preining" <preining@logic.at>
Subject: Re: kernel bug (null pointer) in 2.6.27-rc1
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080729215456.GE30307@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080729215456.GE30307@gamma.logic.tuwien.ac.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes this issue, it fixed it for me:

diff --git a/kernel/sched.c b/kernel/sched.c
index 3ba1199..d757da7 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7713,35 +7713,34 @@ static ssize_t sched_power_savings_store(const
char *buf, size_t count, int smt)
 }

 #ifdef CONFIG_SCHED_MC
-static ssize_t sched_mc_power_savings_show(struct sys_device *dev,
-				struct sysdev_attribute *attr, char *page)
+static ssize_t sched_mc_power_savings_show(struct sysdev_class *class,
+                                            char *page)
 {
 	return sprintf(page, "%u\n", sched_mc_power_savings);
 }
-static ssize_t sched_mc_power_savings_store(struct sys_device *dev,
-					    struct sysdev_attribute *attr,
+static ssize_t sched_mc_power_savings_store(struct sysdev_class *class,
 					    const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 0);
 }
-static SYSDEV_ATTR(sched_mc_power_savings, 0644, sched_mc_power_savings_show,
-		   sched_mc_power_savings_store);
+static SYSDEV_CLASS_ATTR(sched_mc_power_savings, 0644,
+                          sched_mc_power_savings_show,
+                          sched_mc_power_savings_store);
 #endif

 #ifdef CONFIG_SCHED_SMT
-static ssize_t sched_smt_power_savings_show(struct sys_device *dev,
-				struct sysdev_attribute *attr, char *page)
+static ssize_t sched_smt_power_savings_show(struct sysdev_class *dev,
+                                             char *page)
 {
 	return sprintf(page, "%u\n", sched_smt_power_savings);
 }
-static ssize_t sched_smt_power_savings_store(struct sys_device *dev,
-					     struct sysdev_attribute *attr,
+static ssize_t sched_smt_power_savings_store(struct sysdev_class *dev,
 					     const char *buf, size_t count)
 {
 	return sched_power_savings_store(buf, count, 1);
 }
-static SYSDEV_ATTR(sched_smt_power_savings, 0644, sched_smt_power_savings_show,
-		   sched_smt_power_savings_store);
+static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644,
+                    sched_smt_power_savings_show,
 #endif

 int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)

On Tue, Jul 29, 2008 at 5:54 PM, Norbert Preining <preining@logic.at> wrote:
> Hi all,
>
> (pleace Cc)
>
> Got that just now ...
>
> BUG: unable to handle kernel NULL pointer dereference at 00000002
> IP: [<c011bad5>] sched_mc_power_savings_store+0x0/0x2c
> *pde = 00000000
> Oops: 0000 [#1] PREEMPT SMP
> Modules linked in: binfmt_misc nls_utf8 fuse dm_crypt dm_mod kvm_intel kvm coretemp tifm_7xx1 gspca_vc032x tifm_core gspca_main nsc_ircc joydev iwl3945 videodev v4l1_compat rfkill mac80211 irda crc_ccitt firewire_ohci firewire_core crc_itu_t
>
> Pid: 4144, comm: sched-powersave Not tainted (2.6.27-rc1 #1)
> EIP: 0060:[<c011bad5>] EFLAGS: 00010282 CPU: 0
> EIP is at sched_mc_power_savings_store+0x0/0x2c
> EAX: c0434498 EBX: c011bad5 ECX: 00000002 EDX: e9135000
> ESI: c04344bc EDI: e9135000 EBP: c04344bc ESP: e9133f48
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process sched-powersave (pid: 4144, ti=e9132000 task=f7934810 task.ti=e9132000)
> Stack: c02300db c04341f8 f781fd1c f7e25400 c0195442 00000002 0849e408 e90784c0
>       f7e25414 c04341f8 00000002 e90784c0 c0195392 0849e408 c016433a e9133fa0
>       e90784c0 fffffff7 0849e408 e9132000 c016442a e9133fa0 00000000 00000000
> Call Trace:
>  [<c02300db>] sysdev_class_store+0x1e/0x22
>  [<c0195442>] sysfs_write_file+0xb0/0xdd
>  [<c0195392>] sysfs_write_file+0x0/0xdd
>  [<c016433a>] vfs_write+0x7e/0xd6
>  [<c016442a>] sys_write+0x3c/0x63
>  [<c0102dfe>] syscall_call+0x7/0xb
>  [<c0350000>] tg3_init_one+0xaf2/0x1010
>  =======================
> Code: c0 c3 31 c0 31 c9 31 d2 e8 bb fd ff ff b8 01 00 00 00 c3 e8 ce 4d 00 00 31 c0 31 c9 31 d2 e8 a5 fd ff ff e8 22 4f 00 00 31 c0 c3 <8a> 09 ba ea ff ff ff 8d 41 d0 3c 01 77 1b 31 c0 80 f9 31 0f 94
> EIP: [<c011bad5>] sched_mc_power_savings_store+0x0/0x2c SS:ESP 0068:e9133f48
> ---[ end trace f43d02115764e57e ]---
>
>
> kernel config and all other if one needs it.
>
> Best wishes
>
> Norbert
>
> -------------------------------------------------------------------------------
> Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
> Debian Developer <preining@debian.org>                         Debian TeX Group
> gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> -------------------------------------------------------------------------------
> `That young girl is one of the least benightedly
> unintelligent organic life forms it has been my profound
> lack of pleasure not to be able to avoid meeting.'
>                 --- Marvin's first ever compliment about anybody.
>                 --- Douglas Adams, The Hitchhikers Guide to the Galaxy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
