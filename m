Return-Path: <linux-kernel-owner+w=401wt.eu-S1754487AbZGUBcP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487AbZGUBcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 21:32:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbZGUBcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 21:32:14 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:45534 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754112AbZGUBcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 21:32:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=YlWk7bw//G3+SD90ccHd+9ZbG1Lw5m8H01C8rjAbmZNYoD70570oBdr9o+tX6er0g2
         EiT8NUuMMpndvlYAGjuetDf7nGV4Yy/MwDs0UgbYwMfgs89riR1Oj2YEWACj/8rOQH2g
         drVpnN6efMlaZcdp31VwzZVsgDd0KRQ7vK3hA=
Message-ID: <4A651A8E.5070407@gmail.com>
Date: Tue, 21 Jul 2009 09:31:58 +0800
From: Eric Miao <eric.y.miao@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: - Cortez - <omegamoon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com
Subject: Re: 2.6.31-rc1: zaurus suspend regressing
References: <20090704024416.GA1345@ucw.cz> <20090715002445.GB2360@ucw.cz>	 <1f96a3530907200711h1e08bfb5k7123491cf688d9b1@mail.gmail.com>	 <4A64823C.2040601@gmail.com> <1f96a3530907201350n209483a5va803235536d241d0@mail.gmail.com>
In-Reply-To: <1f96a3530907201350n209483a5va803235536d241d0@mail.gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Cortez - wrote:
> Eric,
> 
> Thanks a lot, that worked. I hereby confirm that suspend/resume for spitz
> (SL-C3100) works again in 2.6.31-rc3 when reverting commit
> 15bce40cb3133bcc07d548013df97e4653d363c1. Apart from disabling the offline
> charging, which is still needed, I applied following patch:
> 

David,

Could you please have a look into commit 15bce40c, which seems to cause some
trouble on spitz?

> diff -Naur ori/drivers/mtd/mtdcore.c new/drivers/mtd/mtdcore.c
> --- ori/drivers/mtd/mtdcore.c    2009-07-13 22:26:13.000000000 +0200
> +++ new/drivers/mtd/mtdcore.c    2009-07-20 21:38:51.000000000 +0200
> @@ -23,15 +23,7 @@
> 
>  #include "mtdcore.h"
> 
> -static int mtd_cls_suspend(struct device *dev, pm_message_t state);
> -static int mtd_cls_resume(struct device *dev);
> -
> -static struct class mtd_class = {
> -    .name = "mtd",
> -    .owner = THIS_MODULE,
> -    .suspend = mtd_cls_suspend,
> -    .resume = mtd_cls_resume,
> -};
> +static struct class *mtd_class;
> 
>  /* These are exported solely for the purpose of mtd_blkdevs.c. You
>     should not use them for _anything_ else */
> @@ -59,26 +51,7 @@
> 
>      /* remove /dev/mtdXro node if needed */
>      if (index)
> -        device_destroy(&mtd_class, index + 1);
> -}
> -
> -static int mtd_cls_suspend(struct device *dev, pm_message_t state)
> -{
> -    struct mtd_info *mtd = dev_to_mtd(dev);
> -
> -    if (mtd->suspend)
> -        return mtd->suspend(mtd);
> -    else
> -        return 0;
> -}
> -
> -static int mtd_cls_resume(struct device *dev)
> -{
> -    struct mtd_info *mtd = dev_to_mtd(dev);
> -
> -    if (mtd->resume)
> -        mtd->resume(mtd);
> -    return 0;
> +        device_destroy(mtd_class, index + 1);
>  }
> 
>  static ssize_t mtd_type_show(struct device *dev,
> @@ -295,7 +268,7 @@
>               * physical device.
>               */
>              mtd->dev.type = &mtd_devtype;
> -            mtd->dev.class = &mtd_class;
> +            mtd->dev.class = mtd_class;
>              mtd->dev.devt = MTD_DEVT(i);
>              dev_set_name(&mtd->dev, "mtd%d", i);
>              if (device_register(&mtd->dev) != 0) {
> @@ -304,7 +277,7 @@
>              }
> 
>              if (MTD_DEVT(i))
> -                device_create(&mtd_class, mtd->dev.parent,
> +                device_create(mtd_class, mtd->dev.parent,
>                          MTD_DEVT(i) + 1,
>                          NULL, "mtd%dro", i);
> 
> @@ -630,12 +603,11 @@
> 
>  static int __init init_mtd(void)
>  {
> -    int ret;
> -    ret = class_register(&mtd_class);
> +    mtd_class = class_create(THIS_MODULE, "mtd");
> 
> -    if (ret) {
> -        pr_err("Error registering mtd class: %d\n", ret);
> -        return ret;
> +    if (IS_ERR(mtd_class)) {
> +        pr_err("Error creating mtd class.\n");
> +        return PTR_ERR(mtd_class);
>      }
>  #ifdef CONFIG_PROC_FS
>      if ((proc_mtd = create_proc_entry( "mtd", 0, NULL )))
> @@ -650,7 +622,7 @@
>          if (proc_mtd)
>          remove_proc_entry( "mtd", NULL);
>  #endif /* CONFIG_PROC_FS */
> -    class_unregister(&mtd_class);
> +    class_destroy(mtd_class);
>  }
> 
>  module_init(init_mtd);
> 
> Cheers,
> cortez
> 
> On Mon, Jul 20, 2009 at 4:42 PM, Eric Miao <eric.y.miao@gmail.com> wrote:
> 
>> - Cortez - wrote:
>>> Hi,
>>>
>>> Just tried to test suspend/resume with 2.6.31-rc3 on spitz (with charging
>>> disabled). This results in following kernel panic:
>>>
>> I suspect this is caused by commit 15bce40cb3133bcc07d548013df97e4653d363c1
>>
>>    [MTD] Restore suspend/resume support for mtd devices
>>
>>    This is intended to suspend/resume the _chip_, while we leave board
>>    drivers to handle their own suspend/resume for the controller.
>>
>> Cortez,
>>
>> Could you please revert this and give another try?
>>
>>> Unable to handle kernel NULL pointer dereference at virtual address
>> 00000000
>>> pgd = c0004000
>>> [00000000] *pgd=00000000
>>> Internal error: Oops: 0 [#1] PREEMPT
>>> Modules linked in:
>>> CPU: 0    Tainted: G        W   (2.6.31-rc3-omegamoon-spitz #1)
>>> PC is at 0x0
>>> LR is at 0xc39cad3c
>>> pc : [<00000000>]    lr : [<c39cad3c>]    psr: 60000013
>>> sp : c3195ff8  ip : c39c9f00  fp : c39c9efc
>>> r10: c03ce9b8  r9 : 00000005  r8 : c39ca7b4
>>> r7 : 00000000  r6 : 00000000  r5 : c39ca780  r4 : 00000000
>>> r3 : 00000000  r2 : 00000000  r1 : 00000002  r0 : 00000000
>>> Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
>>> Control: 0000397f  Table: a1168000  DAC: 00000017
>>> Process kapmd (pid: 1426, stack limit = 0xc3194278)
>>> Stack: (0xc3195ff8 to 0xc3196000)
>>> 5fe0:                                                       00000000
>>> 00000000
>>> Backtrace:
>>> [<c021f2fc>] (mtd_cls_suspend+0x0/0x30) from [<c02029e4>]
>>> (dpm_suspend_start+0x2
>>> ac/0x444)
>>> [<c0202738>] (dpm_suspend_start+0x0/0x444) from [<c0067500>]
>>> (suspend_devices_an
>>> d_enter+0x48/0x198)
>>> [<c00674b8>] (suspend_devices_and_enter+0x0/0x198) from [<c0067704>]
>>> (enter_stat
>>> e+0xb4/0xf4)
>>>  r6:c040e608 r5:00000003 r4:00000000
>>> [<c0067650>] (enter_state+0x0/0xf4) from [<c0067768>]
>> (pm_suspend+0x24/0x28)
>>>  r5:c39c8000 r4:0000000a
>>> [<c0067744>] (pm_suspend+0x0/0x28) from [<c01f6858>] (kapmd+0x174/0x1d8)
>>> [<c01f66e4>] (kapmd+0x0/0x1d8) from [<c0051284>] (kthread+0x80/0x84)
>>> [<c0051204>] (kthread+0x0/0x84) from [<c003bedc>] (do_exit+0x0/0x6dc)
>>>  r7:00000000 r6:00000000 r5:00000000 r4:00000000
>>> Code: bad PC value.
>>> Unable to handle kernel NULL pointer dereference at virtual address
>> 00000000
>>> pgd = c0004000
>>> [00000000] *pgd=00000000
>>> Internal error: Oops: 0 [#2] PREEMPT
>>> Modules linked in:
>>> CPU: 0    Tainted: G      D W   (2.6.31-rc3-omegamoon-spitz #1)
>>> PC is at 0x0
>>> LR is at 0xc39cad3c
>>> pc : [<00000000>]    lr : [<c39cad3c>]    psr: 60000013
>>> sp : c39c9ef0  ip : c39c9f00  fp : c39c9efc
>>> r10: c03ce9b8  r9 : 00000005  r8 : c39ca7b4
>>> r7 : 00000002  r6 : 00000000  r5 : c39ca780  r4 : 00000000
>>> r3 : 00000000  r2 : 00000000  r1 : 00000002  r0 : 00000592
>>> Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
>>> Control: 0000397f  Table: a1168000  DAC: 00000017
>>> Process kapmd (pid: 307, stack limit = 0xc39c8278)
>>> Stack: (0xc39c9ef0 to 0xc39ca000)
>>> 9ee0:                                     c39c9f34 c39c9f00 c02029e4
>>> c021f308
>>> 9f00: c3aa64ac c2e8335c c39c9f2c 00000000 c03e0ce8 00000003 c39c9f84
>>> c040e5f8
>>> 9f20: 00000000 c39c9f90 c39c9f54 c39c9f38 c0067500 c0202744 00000000
>>> 00000000
>>> 9f40: 00000003 c040e608 c39c9f6c c39c9f58 c0067704 c00674c4 0000000a
>>> c39c8000
>>> 9f60: c39c9f7c c39c9f70 c0067768 c006765c c39c9fc4 c39c9f80 c01f6858
>>> c0067750
>>> 9f80: c39c9fc4 00000000 c3ad4000 c005136c c39c9f90 c39c9f90 c39c9fc4
>>> c39c9fcc
>>> 9fa0: c3825ef8 00000000 c01f66e4 00000000 00000000 00000000 c39c9ff4
>>> c39c9fc8
>>> 9fc0: c0051284 c01f66f0 00000000 00000000 c39c9fd0 c39c9fd0 00000000
>>> 00000000
>>> 9fe0: 00000000 00000000 00000000 c39c9ff8 c003bedc c0051210 726f7373
>>> 74656420
>>> Backtrace:
>>> [<c021f2fc>] (mtd_cls_suspend+0x0/0x30) from [<c02029e4>]
>>> (dpm_suspend_start+0x2
>>> ac/0x444)
>>> [<c0202738>] (dpm_suspend_start+0x0/0x444) from [<c0067500>]
>>> (suspend_devices_an
>>> d_enter+0x48/0x198)
>>> [<c00674b8>] (suspend_devices_and_enter+0x0/0x198) from [<c0067704>]
>>> (enter_stat
>>> e+0xb4/0xf4)
>>>  r6:c040e608 r5:00000003 r4:00000000
>>> [<c0067650>] (enter_state+0x0/0xf4) from [<c0067768>]
>> (pm_suspend+0x24/0x28)
>>>  r5:c39c8000 r4:0000000a
>>> [<c0067744>] (pm_suspend+0x0/0x28) from [<c01f6858>] (kapmd+0x174/0x1d8)
>>> [<c01f66e4>] (kapmd+0x0/0x1d8) from [<c0051284>] (kthread+0x80/0x84)
>>> [<c0051204>] (kthread+0x0/0x84) from [<c003bedc>] (do_exit+0x0/0x6dc)
>>>  r7:00000000 r6:00000000 r5:00000000 r4:00000000
>>> Code: bad PC value.
>>> ---[ end trace 1b75b31a2719ed1e ]---
>>> ---[ end trace 1b75b31a2719ed1f ]---
>>>
>>>
>>> On Wed, Jul 15, 2009 at 2:24 AM, Pavel Machek <pavel@ucw.cz> wrote:
>>>
>>>> On Sat 2009-07-04 04:44:16, Pavel Machek wrote:
>>>>> Hi!
>>>>>
>>>>> In 2.6.30, spitz suspended with PSPR fix + charging disabled.
>>>>>
>>>>> In 2.6.31-rc1, PSPR fix is in, but suspend does not work, not even
>>>>> with charging disabled.
>>>>>
>>>>> Any ideas?
>>>> Tried -rc2-git, still broken. Even pm-test=devices killed the machine,
>>>> so I hope it is the IDE problem that should be fixed in -rc3.
>>>>
>>>> --
>>>> (english) http://www.livejournal.com/~pavelmachek<http://www.livejournal.com/%7Epavelmachek>
>> <http://www.livejournal.com/%7Epavelmachek>
>>>> (cesky, pictures)
>>>> http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html<http://atrey.karlin.mff.cuni.cz/%7Epavel/picture/horses/blog.html>
>> <http://atrey.karlin.mff.cuni.cz/%7Epavel/picture/horses/blog.html>
>>> -------------------------------------------------------------------
>>> List admin:
>> http://lists.arm.linux.org.uk/mailman/listinfo/linux-arm-kernel
>>> FAQ:        http://www.arm.linux.org.uk/mailinglists/faq.php
>>> Etiquette:  http://www.arm.linux.org.uk/mailinglists/etiquette.php
>>
> 

