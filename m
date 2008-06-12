Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbYFLGb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbYFLGb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751509AbYFLGbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:31:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:46064 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbYFLGbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:31:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JDgMu57JTaWsEC51dB3yUeqfJn8NfasV9K7okQprzQpRuvGBTxtNbgsXAIy78lrwOz
         BxuloyqVwa0yQz4p+JKnhJAzem3jGMRSvafqw4ujZMymbH7CuXdoIDK9ukc6dgd1E1Hp
         skFZtDBXE9jI/0P60ZVMTaE64KyjPeegUiqRY=
Message-ID: <ca992f110806112331v3d4d73abhaa46167f494e8d9b@mail.gmail.com>
Date: Thu, 12 Jun 2008 15:31:04 +0900
From: "junjie cai" <junjiec@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: [rt] __reacquire_lock_kernel bug?
In-Reply-To: <a5530a0e-7f34-4ddf-862e-83771a9c78e3@a32g2000prf.googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a5530a0e-7f34-4ddf-862e-83771a9c78e3@a32g2000prf.googlegroups.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, List

We get a BUG_ON during some tests on a 2.6.22.19-rt9,
the message is pasted at the end of this mail.

It seems that preemption happened in __reacquire_kernel_lock()
that kernel_lock in released twice.

 int __lockfunc __reacquire_kernel_lock(void)
 {
       local_irq_enable();
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> preempted here
       _raw_spin_lock(&kernel_flag);
       local_irq_disable();
       preempt_disable();
}

After checking the 2.6.25.4-rt6, I think that same problem exist.
Isn't that lock_depth should be set to -1 before local_irq_enable() ?

 int __lockfunc __reacquire_kernel_lock(void)
 {
       struct task_struct *task = current;
       int saved_lock_depth = task->lock_depth;

       local_irq_enable();
       BUG_ON(saved_lock_depth < 0);
 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>preempted here
       task->lock_depth = -1;

       down(&kernel_sem);

       task->lock_depth = saved_lock_depth;

       local_irq_disable();

       return 0;
 }


OOPS message:
---------------------------------------------------------------------------------------------------------------------------------------------------
 [<c0024a50>] (dump_stack+0x0/0x24) from [<c002cf44>] (__schedule_bug
+0x48/0x54)
[<c002cefc>] (__schedule_bug+0x0/0x54) from [<c01991dc>] (__schedule
+0x9c/0x510)
 r6:000003ff r5:f70d0100 r4:c0199868
[<c0199140>] (__schedule+0x0/0x510) from [<c0199868>]
(preempt_schedule_irq+0x48/0x70)
[<c0199820>] (preempt_schedule_irq+0x0/0x70) from [<c0020a08>]
(svc_preempt+0x8/0x20)
 r4:ffffffff
[<c019ba20>] (__lock_text_start+0x0/0x2c) from [<c01995cc>] (__schedule
+0x48c/0x510)
[<c0199140>] (__schedule+0x0/0x510) from [<c01997e0>] (schedule
+0xc8/0x108)
[<c0199718>] (schedule+0x0/0x108) from [<c00ce488>] (nfs_wait_schedule
+0x34/0x40)
 r4:00000000
[<c00ce454>] (nfs_wait_schedule+0x0/0x40) from [<c019a6cc>]
(__wait_on_bit_lock+0x64/0x98)
 r4:cb65bacc
[<c019a668>] (__wait_on_bit_lock+0x0/0x98) from [<c019a77c>]
(out_of_line_wait_on_bit_lock+0x7c/0x88)
 r8:cb8172ec r7:00000002 r6:c00ce454 r5:c0000490 r4:cb65bae0
[<c019a700>] (out_of_line_wait_on_bit_lock+0x0/0x88) from [<c00ce57c>]
(__nfs_revalidate_inode+0xe8/0x2f4)
[<c00ce494>] (__nfs_revalidate_inode+0x0/0x2f4) from [<c00cc710>]
(nfs_lookup_revalidate+0x1b8/0x430)
[<c00cc558>] (nfs_lookup_revalidate+0x0/0x430) from [<c00822c8>]
(do_lookup+0x13c/0x184)
[<c008218c>] (do_lookup+0x0/0x184) from [<c0083d40>] (__link_path_walk
+0x6fc/0x8cc)
[<c0083644>] (__link_path_walk+0x0/0x8cc) from [<c0083f90>]
(link_path_walk+0x80/0x13c)
[<c0083f10>] (link_path_walk+0x0/0x13c) from [<c0084070>] (path_walk
+0x24/0x28)
 r8:cb656000 r7:cb65bf08 r6:00000001 r5:00000001 r4:cb9f22e0
[<c008404c>] (path_walk+0x0/0x28) from [<c00846a4>] (do_path_lookup
+0x2b4/0x2e0)
[<c00843f0>] (do_path_lookup+0x0/0x2e0) from [<c00851a4>]
(__path_lookup_intent_open+0x54/0x94)
 r8:00000001 r7:cb65bf08 r6:00000001 r5:ffffffe9 r4:ffffff9c
[<c0085150>] (__path_lookup_intent_open+0x0/0x94) from [<c0085278>]
(path_lookup_open+0x24/0x2c)
 r7:00000000 r6:cb656000 r5:cb65bf08 r4:00000000
[<c0085254>] (path_lookup_open+0x0/0x2c) from [<c00852e0>] (open_namei
+0x60/0x4d4)
[<c0085280>] (open_namei+0x0/0x4d4) from [<c0077ca0>] (do_filp_open
+0x2c/0x4c)
[<c0077c74>] (do_filp_open+0x0/0x4c) from [<c0077d14>] (do_sys_open
+0x54/0x98)
 r5:00000003 r4:00000000
[<c0077cc0>] (do_sys_open+0x0/0x98) from [<c0077d90>] (sys_open
+0x24/0x28)
 r8:c0020f04 r7:00000005 r6:00009bfd r5:00070060 r4:00000004
[<c0077d6c>] (sys_open+0x0/0x28) from [<c0020d80>] (ret_fast_syscall
+0x0/0x2c)



-- 
/*********************************************/
/* Junjie Cai (junjiec@gmail.com) */
/*********************************************/
