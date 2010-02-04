Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088Ab0BDBja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 20:39:30 -0500
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:35616 "HELO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932991Ab0BDBj2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 20:39:28 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PWM PATCH 1/5] API to consolidate PWM devices behind a common user and kernel interface
Date: Wed, 3 Feb 2010 20:39:26 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190902152ADB@mi8nycmail19.Mi8.com>
In-Reply-To: <c5873aa7c5d20254a9e54fc1ff179345b77c16b5.1265094517.git.bgat@billgatliff.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PWM PATCH 1/5] API to consolidate PWM devices behind a common user and kernel interface
Thread-Index: Acqj16fGQIbbe2TTS6qu8c6pDrkjVgBYWp4g
References: <cover.1265094517.git.bgat@billgatliff.com> <c5873aa7c5d20254a9e54fc1ff179345b77c16b5.1265094517.git.bgat@billgatliff.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Bill Gatliff" <bgat@billgatliff.com>, <linux-embedded@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 04 Feb 2010 01:39:25.0562 (UTC) FILETIME=[E23A05A0:01CAA53A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 02, 2010 12:15 AM, Bill Gatliff wrote:
> Signed-off-by: Bill Gatliff <bgat@billgatliff.com>
> ---
>  Documentation/pwm.txt   |  260 +++++++++++++++++++
>  drivers/pwm/pwm.c       |  633 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/pwm.h     |   31 ---
>  include/linux/pwm/pwm.h |  170 +++++++++++++
>  4 files changed, 1063 insertions(+), 31 deletions(-)
>  create mode 100644 Documentation/pwm.txt
>  create mode 100644 drivers/pwm/pwm.c
>  delete mode 100644 include/linux/pwm.h
>  create mode 100644 include/linux/pwm/pwm.h

[snip]

> diff --git a/drivers/pwm/pwm.c b/drivers/pwm/pwm.c
> new file mode 100644
> index 0000000..f369384
> --- /dev/null
> +++ b/drivers/pwm/pwm.c

[snip]

> +int pwm_register(struct pwm_device *pwm)
> +{
> +	struct pwm_channel *p;
> +	int wchan;
> +	int ret;
> +
> +	spin_lock_init(&pwm->list_lock);
> +
> +	p = kcalloc(pwm->nchan, sizeof(*p), GFP_KERNEL);
> +	if (!p)
> +		return -ENOMEM;
> +
> +	for (wchan = 0; wchan < pwm->nchan; wchan++) {
> +		spin_lock_init(&p[wchan].lock);
> +		init_completion(&p[wchan].complete);
> +		p[wchan].chan = wchan;
> +		p[wchan].pwm = pwm;
> +	}
> +
> +	pwm->channels = p;
> +
> +	mutex_lock(&device_list_mutex);
> +
> +	list_add_tail(&pwm->list, &pwm_device_list);
> +	ret = __pwm_create_sysfs(pwm);
> +	if (ret) {
> +		mutex_unlock(&device_list_mutex);
> +		goto err_create_sysfs;
> +	}
> +
> +	mutex_unlock(&device_list_mutex);
> +
> +	dev_info(pwm->dev, "%d channel%s\n", pwm->nchan,
> +		 pwm->nchan > 1 ? "s" : "");
> +	return 0;
> +
> +err_create_sysfs:
> +	kfree(p);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(pwm_register);

Bill,

I'm trying to test your latest pwm patches using the ep93xx pwm driver
I wrote based on your previous patches.  I'm getting an Oops when booting
this that is hanging my system.  I put in the printascii hack to see
what's going on and got this:

<1>Unable to handle kernel NULL pointer dereference at virtual address 00000044
<1>pgd = c0004000
<1>[00000044] *pgd=00000000
<0>Internal error: Oops: 5 [#1] PREEMPT
<0>last sysfs file:
<d>Modules linked in:
CPU: 0    Not tainted  (2.6.32.7 #5)
PC is at dev_driver_string+0x0/0x38
LR is at pwm_register+0x17c/0x1e8
pc : [<c01b1b10>]    lr : [<c0187dfc>]    psr: 60000013
sp : c581bee0  ip : c036efa5  fp : 00000000
r10: c4511e60  r9 : 00000000  r8 : 00000000
r7 : c036ef6c  r6 : 00000050  r5 : c44c9b20  r4 : 00000001
r3 : 00000001  r2 : 00000001  r1 : 00000000  r0 : 00000000
Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
Control: c000717f  Table: c0004000  DAC: 00000017
<0>Process swapper (pid: 1, stack limit = 0xc581a270)
<0>Stack: (0xc581bee0 to 0xc581c000)
<0>bee0: c036ef6c c58449a0 00000000 c44c9b20 00000000 c44c9b20 00000000 c03bece8
<0>bf00: c58839c0 c03bece0 00000000 c0016784 00000000 00000000 c03bece8 c03bece8
<0>bf20: c03d105c c03d105c c03d4c40 c01b5e70 c03d105c c01b4f08 c0054498 c03bece8
<0>bf40: c03bed1c c03d105c c581bf60 c01b5038 00000000 c01b4fdc c03d105c c01b473c
<0>bf60: c58034d8 c5852dd0 c03d4c40 c00211c4 c03d105c c03d105c c4511ec0 c01b4028
<0>bf80: c0351a5d c581bf90 c01756c4 c00211c4 c002133c c03d105c c001666c 00000001
<0>bfa0: 00000000 c01b533c c00211c4 c002133c 00000000 c001666c 00000001 c00273a8
<0>bfc0: 00000000 00000078 c03c2aa0 00000000 c00211c4 c002133c 00000000 00000000
<0>bfe0: 00000000 c0008588 00000000 00000000 00000000 c00289d4 33cc33cc 33cc33cc
[<c01b1b10>] (dev_driver_string+0x0/0x38) from [<c0187dfc>] (pwm_register+0x17c/0x1e8)
[<c0187dfc>] (pwm_register+0x17c/0x1e8) from [<c0016784>] (ep93xx_pwm_probe+0x10c/0x17c)
[<c0016784>] (ep93xx_pwm_probe+0x10c/0x17c) from [<c01b5e70>] (platform_drv_probe+0x1c/0x24)
[<c01b5e70>] (platform_drv_probe+0x1c/0x24) from [<c01b4f08>] (driver_probe_device+0xac/0x180)
[<c01b4f08>] (driver_probe_device+0xac/0x180) from [<c01b5038>] (__driver_attach+0x5c/0x7c)
[<c01b5038>] (__driver_attach+0x5c/0x7c) from [<c01b473c>] (bus_for_each_dev+0x50/0x90)
[<c01b473c>] (bus_for_each_dev+0x50/0x90) from [<c01b4028>] (bus_add_driver+0xa0/0x224)
[<c01b4028>] (bus_add_driver+0xa0/0x224) from [<c01b533c>] (driver_register+0xbc/0x14c)
[<c01b533c>] (driver_register+0xbc/0x14c) from [<c00273a8>] (do_one_initcall+0x60/0x1c0)
[<c00273a8>] (do_one_initcall+0x60/0x1c0) from [<c0008588>] (kernel_init+0x9c/0x114)
[<c0008588>] (kernel_init+0x9c/0x114) from [<c00289d4>] (kernel_thread_exit+0x0/0x8)
<0>Code: c03c5c28 000080d0 c03d49c8 c03d4958 (e5903044)
<4>---[ end trace da227214a82491b7 ]---
<0>Kernel panic - not syncing: Attempted to kill init!
[<c002c7dc>] (unwind_backtrace+0x0/0xdc) from [<c02d7050>] (panic+0x3c/0x128)
[<c02d7050>] (panic+0x3c/0x128) from [<c003ee2c>] (do_exit+0x60/0x608)
[<c003ee2c>] (do_exit+0x60/0x608) from [<c002b5f8>] (die+0x178/0x19c)
[<c002b5f8>] (die+0x178/0x19c) from [<c002db1c>] (__do_kernel_fault+0x68/0x80)
[<c002db1c>] (__do_kernel_fault+0x68/0x80) from [<c002dcf8>] (do_page_fault+0x1c4/0x1dc)
[<c002dcf8>] (do_page_fault+0x1c4/0x1dc) from [<c00272e8>] (do_DataAbort+0x34/0x94)
[<c00272e8>] (do_DataAbort+0x34/0x94) from [<c0027ae0>] (__dabt_svc+0x40/0x60)
Exception stack(0xc581be98 to 0xc581bee0)
be80:                                                       00000000 00000000
bea0: 00000001 00000001 00000001 c44c9b20 00000050 c036ef6c 00000000 00000000
bec0: c4511e60 00000000 c036efa5 c581bee0 c0187dfc c01b1b10 60000013 ffffffff
[<c0027ae0>] (__dabt_svc+0x40/0x60) from [<c01b1b10>] (dev_driver_string+0x0/0x38)
[<c01b1b10>] (dev_driver_string+0x0/0x38) from [<c0187dfc>] (pwm_register+0x17c/0x1e8)
[<c0187dfc>] (pwm_register+0x17c/0x1e8) from [<c0016784>] (ep93xx_pwm_probe+0x10c/0x17c)
[<c0016784>] (ep93xx_pwm_probe+0x10c/0x17c) from [<c01b5e70>] (platform_drv_probe+0x1c/0x24)
[<c01b5e70>] (platform_drv_probe+0x1c/0x24) from [<c01b4f08>] (driver_probe_device+0xac/0x180)
[<c01b4f08>] (driver_probe_device+0xac/0x180) from [<c01b5038>] (__driver_attach+0x5c/0x7c)
[<c01b5038>] (__driver_attach+0x5c/0x7c) from [<c01b473c>] (bus_for_each_dev+0x50/0x90)
[<c01b473c>] (bus_for_each_dev+0x50/0x90) from [<c01b4028>] (bus_add_driver+0xa0/0x224)
[<c01b4028>] (bus_add_driver+0xa0/0x224) from [<c01b533c>] (driver_register+0xbc/0x14c)
[<c01b533c>] (driver_register+0xbc/0x14c) from [<c00273a8>] (do_one_initcall+0x60/0x1c0)
[<c00273a8>] (do_one_initcall+0x60/0x1c0) from [<c0008588>] (kernel_init+0x9c/0x114)
[<c0008588>] (kernel_init+0x9c/0x114) from [<c00289d4>] (kernel_thread_exit+0x0/0x8)

Your older patch just used printk's to output the messages.  I think the
Oops is being caused by the dev_<level>(pwm->dev, ...).  Where is pwm->dev
being setup?

Regards,
Hartley

