Return-Path: <linux-kernel-owner+w=401wt.eu-S1754671AbZCIU2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671AbZCIU2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbZCIU2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:28:05 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:45495 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbZCIU2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:28:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mhp0A8pH30BCvDIoHeangw61UofV7nuQyeZNEjVJRnHspmW+3/xe+x6OuTQX/9UMGD
         yPZ8i/UL7tuZRLLjO85R4f4n/ULawz4l/LRAMDQJMHo9Wc2MQTJBnipylOkr+oV9Bc1c
         Tgz7958EqJjXjHoZtTkUo7rdzqIsmxhlnqdBY=
MIME-Version: 1.0
In-Reply-To: <20090309195250.GQ32589@ldl.fc.hp.com>
References: <20090309052933.3918.86601.stgit@bob.kio>
	 <20090309185117.GJ32589@ldl.fc.hp.com>
	 <19f34abd0903091230q27a04f37mdb0ba75ba170e6a@mail.gmail.com>
	 <20090309195250.GQ32589@ldl.fc.hp.com>
Date: Mon, 9 Mar 2009 21:28:00 +0100
Message-ID: <19f34abd0903091328q4471bb3he0c6e07fa32a6a1f@mail.gmail.com>
Subject: Re: [PATCH v3 00/11] PCI core learns hotplug
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Alex Chiang <achiang@hp.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, xyzzy@speakeasy.org, djwong@us.ibm.com,
       shimada-yxb@necst.nec.co.jp, rjw@sisk.pl, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/9 Alex Chiang <achiang@hp.com>:
>> It reproduces reliably if I do this:
>>
>> $ while true; do echo 1 > /sys/bus/pci/devices/0000\:00\:00.0/remove; done
>
> I was going to ask for lspci -v output so that I could see what
> device 0000:00:00.0 might be, but I was able to reproduce
> something similar on my machine.
>
> Can I ask why you're doing the above with a while loop? Just to
> torture the code? Or something else?

Yes, purely for the purpose of torture ;-)

I also found one more use-after-free error using kmemcheck:

[  263.258025] WARNING: kmemcheck: Caught 8-bit read from freed memory
(ffff88003d8f315c)
[  263.266131] 80e1803f0088ffff20d67b81ffffffff0000000000000000000000000d000000
[  263.275104]  f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f f
[  263.284053]                                                          ^
[  263.290696]
[  263.292303] Pid: 881, comm: udevd Not tainted 2.6.29-rc6 #361 945P-A
[  263.298770] RIP: 0010:[<ffffffff811eb501>]  [<ffffffff811eb501>]
kobject_put+0x11/0x60
[  263.306938] RSP: 0018:ffff88003f8bde60  EFLAGS: 00010282
[  263.312367] RAX: 0000000000000001 RBX: ffff88003d8f3120 RCX: 0000000000000000
[  263.319616] RDX: 0000000000000001 RSI: 0000000000000003 RDI: ffff88003d8f3120
[  263.326865] RBP: ffff88003f8bde70 R08: 00000000002ec000 R09: 0000000000000000
[  263.334114] R10: ffff88003d95fdc0 R11: 0000000000000010 R12: ffff88003d946ac0
[  263.341362] R13: ffff88003f80a908 R14: ffff88003f80a908 R15: ffff88003f8adf00
[  263.348613] FS:  0000000000000000(0000) GS:ffff8800019f1000(0063)
knlGS:00000000f7d6c700
[  263.356884] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[  263.362747] CR2: ffff88003f806ea0 CR3: 000000003e44a000 CR4: 00000000000006a0
[  263.369995] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  263.377246] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[  263.384494]  [<ffffffff81125048>] sysfs_schedule_callback_work+0x28/0x40
[  263.391378]  [<ffffffff81055510>] run_workqueue+0x70/0x130
[  263.397049]  [<ffffffff81055677>] worker_thread+0xa7/0x120
[  263.402720]  [<ffffffff810593d9>] kthread+0x49/0x90
[  263.407784]  [<ffffffff8100d45a>] child_rip+0xa/0x20
[  263.412935]  [<ffffffffffffffff>] 0xffffffffffffffff
[  281.464381] NOHZ: local_softirq_pending 01

This is how I triggered it:

# echo 1 > /sys/bus/pci/devices/0000\:00\:00.0/remove
# echo 1 > /sys/bus/pci/rescan
# echo 1 > /sys/bus/pci/rescan
# echo 1 > /sys/bus/pci/devices/0000\:00\:00.0/remove

The line numbers:

$ addr2line -e vmlinux -i ffffffff811eb501 ffffffff81125048
lib/kobject.c:589
fs/sysfs/file.c:677

586 void kobject_put(struct kobject *kobj)
587 {
588         if (kobj) {
589                 if (!kobj->state_initialized)
590                         WARN(1, KERN_WARNING "kobject: '%s' (%p): is not "
591                                "initialized, yet kobject_put() is being "
592                                "called.\n", kobject_name(kobj), kobj);
593                 kref_put(&kobj->kref, kobject_release);
594         }
595 }

669 static void sysfs_schedule_callback_work(struct work_struct *work)
670 {
671         struct sysfs_schedule_callback_struct *ss = container_of(work,
672                         struct sysfs_schedule_callback_struct, work);
673
674         (ss->func)(ss->data);
675         kobject_put(ss->kobj);
676         module_put(ss->owner);
677         kfree(ss);
678 }

(The short story: the ss->kobj was already freed when this function was called.)

Hope this helps :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
