Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbYC1OLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbYC1OLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 10:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYC1OLE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 10:11:04 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:54967 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbYC1OLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 10:11:01 -0400
Date: Fri, 28 Mar 2008 15:10:57 +0100 (MET)
From: Julia Lawall <julia@diku.dk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       rui.zhang@intel.com
Subject: Re: [patch] revert: "ACPI: drivers/acpi: elide a non-zero test on
 a result that is never 0"
In-Reply-To: <20080328135937.GA26179@elte.hu>
Message-ID: <Pine.LNX.4.58.0803281508570.1185@pc-041.diku.dk>
References: <200803270251.14446.lenb@kernel.org> <20080328135937.GA26179@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhang Rui already found the problem with the patch.

The calling context has to cope with both the results of the normal
definition of the function and a definition in a header file that returns
a completely different kind of result.

Sorry for not having studied the issue more thoroughly in the beginning.

julia


On Fri, 28 Mar 2008, Ingo Molnar wrote:

>
> * Len Brown <lenb@kernel.org> wrote:
>
> > I've not used "-b" until now.  I added it because Julia's patch was
> > simple, but since it changed indenting of a couple of blocks its
> > diffstat was otherwise large.
>
> > Julia Lawall (1):
> >       ACPI: drivers/acpi: elide a non-zero test on a result that is never 0
>
> overnight randconfig qa on x86.git/latest triggered a bootup crash after
> just 7 iterations, which i bisected down to the commit above. Find the
> revert below.
>
> Observation: the patch was just 3 days old when it went upstream and
> given that it touches 50 lines of code executed on most PC hardware
> during bootup so i dont think it was in the trivial category.
>
> Even if the fix is right (which is does look to be at first sight),
> there's clearly some side-effect here and the whitespace changes mixed
> into the functional changes make it hard to validate this change.
>
> now that i had a second look, one side-effect seems to be:
>
> +		acpi_driver_data(device) = cdev;
>
> this used to be executed before even with a NULL cdev and isnt executed
> now. (In any case, the revert below is the right thing to do i believe,
> the patch should have its clock reset and should restart its testing
> cycle at the tail of the development queue.)
>
> 	Ingo
>
> ---------------------->
> Subject: revert "ACPI: drivers/acpi: elide a non-zero test on a result that is never 0"
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri Mar 28 14:28:03 CET 2008
>
> revert:
>
>     ACPI: drivers/acpi: elide a non-zero test on a result that is never 0
>
> as randconfig testing found that it causes a crash during bootup:
>
> initcall 0x78878534 ran for 13 msecs: acpi_button_init+0x0/0x51()
> Calling initcall 0x78878585: acpi_fan_init+0x0/0x2c()
> BUG: unable to handle kernel NULL pointer dereference at 00000000
> IP: [<782b8ad0>] acpi_fan_add+0x7d/0xfd
> *pde = 00000000
> Oops: 0000 [#1]
> Modules linked in:
>
> Pid: 1, comm: swapper Not tainted (2.6.25-rc7-sched-devel.git-x86-latest.git #14)
> EIP: 0060:[<782b8ad0>] EFLAGS: 00010246 CPU: 0
> EIP is at acpi_fan_add+0x7d/0xfd
> EAX: b787c718 EBX: b787c400 ECX: b782ceb4 EDX: 00000007
> ESI: 00000000 EDI: b787c6f4 EBP: b782cee0 ESP: b782cecc
>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> Process swapper (pid: 1, ti=b782c000 task=b7846000 task.ti=b782c000)
> Stack: b787c459 00000000 b787c400 78790888 b787c60c b782cef8 782b6fb8 ffffffda
>        b787c60c 00000000 78790958 b782cf0c 783005d7 b787c60c 78790958 78790584
>        b782cf1c 783007f6 b782cf28 00000000 b782cf40 782ffc4a 78790958 b794d558
> Call Trace:
>  [<782b6fb8>] ? acpi_device_probe+0x3e/0xdb
>  [<783005d7>] ? driver_probe_device+0x82/0xfc
>  [<783007f6>] ? __driver_attach+0x3a/0x70
>  [<782ffc4a>] ? bus_for_each_dev+0x3e/0x60
>  [<7830048c>] ? driver_attach+0x14/0x16
>  [<783007bc>] ? __driver_attach+0x0/0x70
>  [<7830006a>] ? bus_add_driver+0x9d/0x1b0
>  [<783008c3>] ? driver_register+0x47/0xa3
>  [<7813db00>] ? timespec_to_ktime+0x9/0xc
>  [<782b7331>] ? acpi_bus_register_driver+0x3a/0x3c
>  [<78878592>] ? acpi_fan_init+0xd/0x2c
>  [<78863656>] ? kernel_init+0xac/0x1f9
>  [<788635aa>] ? kernel_init+0x0/0x1f9
>  [<78114563>] ? kernel_thread_helper+0x7/0x10
>  =======================
> Code: 6e 78 e8 57 44 e7 ff 58 e9 93 00 00 00 8b 55 f0 8d bb f4 02 00 00 80 4b 2d 10 8b 03 e8 87 cb ff ff 8d 83 18 03 00 00 80 63 2d ef <ff> 35 00 00 00 00 50 68 e8 9c 6e 78 e8 22 44 e7 ff b9 b6 9c 6e
> EIP: [<782b8ad0>] acpi_fan_add+0x7d/0xfd SS:ESP 0068:b782cecc
> ---[ end trace 778e504de7e3b1e3 ]---
> Kernel panic - not syncing: Attempted to kill init!
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  drivers/acpi/fan.c            |   34 ++++++++++++++++++----------------
>  drivers/acpi/processor_core.c |   30 ++++++++++++++++--------------
>  drivers/acpi/video.c          |   28 +++++++++++++++-------------
>  3 files changed, 49 insertions(+), 43 deletions(-)
>
> Index: linux-x86.q/drivers/acpi/fan.c
> ===================================================================
> --- linux-x86.q.orig/drivers/acpi/fan.c
> +++ linux-x86.q/drivers/acpi/fan.c
> @@ -260,22 +260,24 @@ static int acpi_fan_add(struct acpi_devi
>  		result = PTR_ERR(cdev);
>  		goto end;
>  	}
> -	printk(KERN_INFO PREFIX
> -		"%s is registered as cooling_device%d\n",
> -		device->dev.bus_id, cdev->id);
> -
> -	acpi_driver_data(device) = cdev;
> -	result = sysfs_create_link(&device->dev.kobj,
> -				   &cdev->device.kobj,
> -				   "thermal_cooling");
> -	if (result)
> -		return result;
> -
> -	result = sysfs_create_link(&cdev->device.kobj,
> -				   &device->dev.kobj,
> -				   "device");
> -	if (result)
> -		return result;
> +	if (cdev) {
> +		printk(KERN_INFO PREFIX
> +			"%s is registered as cooling_device%d\n",
> +			device->dev.bus_id, cdev->id);
> +
> +		acpi_driver_data(device) = cdev;
> +		result = sysfs_create_link(&device->dev.kobj,
> +					   &cdev->device.kobj,
> +					   "thermal_cooling");
> +		if (result)
> +			return result;
> +
> +		result = sysfs_create_link(&cdev->device.kobj,
> +					   &device->dev.kobj,
> +					   "device");
> +		if (result)
> +			return result;
> +	}
>
>  	result = acpi_fan_add_fs(device);
>  	if (result)
> Index: linux-x86.q/drivers/acpi/processor_core.c
> ===================================================================
> --- linux-x86.q.orig/drivers/acpi/processor_core.c
> +++ linux-x86.q/drivers/acpi/processor_core.c
> @@ -674,20 +674,22 @@ static int __cpuinit acpi_processor_star
>  		result = PTR_ERR(pr->cdev);
>  		goto end;
>  	}
> -	printk(KERN_INFO PREFIX
> -		"%s is registered as cooling_device%d\n",
> -		device->dev.bus_id, pr->cdev->id);
> -
> -	result = sysfs_create_link(&device->dev.kobj,
> -				   &pr->cdev->device.kobj,
> -				   "thermal_cooling");
> -	if (result)
> -		return result;
> -	result = sysfs_create_link(&pr->cdev->device.kobj,
> -				   &device->dev.kobj,
> -				   "device");
> -	if (result)
> -		return result;
> +	if (pr->cdev) {
> +		printk(KERN_INFO PREFIX
> +			"%s is registered as cooling_device%d\n",
> +			device->dev.bus_id, pr->cdev->id);
> +
> +		result = sysfs_create_link(&device->dev.kobj,
> +					   &pr->cdev->device.kobj,
> +					   "thermal_cooling");
> +		if (result)
> +			return result;
> +		result = sysfs_create_link(&pr->cdev->device.kobj,
> +					   &device->dev.kobj,
> +					   "device");
> +		if (result)
> +			return result;
> +	}
>
>  	if (pr->flags.throttling) {
>  		printk(KERN_INFO PREFIX "%s [%s] (supports",
> Index: linux-x86.q/drivers/acpi/video.c
> ===================================================================
> --- linux-x86.q.orig/drivers/acpi/video.c
> +++ linux-x86.q/drivers/acpi/video.c
> @@ -734,19 +734,21 @@ static void acpi_video_device_find_cap(s
>  		if (IS_ERR(device->cdev))
>  			return;
>
> -		printk(KERN_INFO PREFIX
> -			"%s is registered as cooling_device%d\n",
> -			device->dev->dev.bus_id, device->cdev->id);
> -		result = sysfs_create_link(&device->dev->dev.kobj,
> -				  &device->cdev->device.kobj,
> -				  "thermal_cooling");
> -		if (result)
> -			printk(KERN_ERR PREFIX "Create sysfs link\n");
> -		result = sysfs_create_link(&device->cdev->device.kobj,
> -				  &device->dev->dev.kobj,
> -				  "device");
> -		if (result)
> -			printk(KERN_ERR PREFIX "Create sysfs link\n");
> +		if (device->cdev) {
> +			printk(KERN_INFO PREFIX
> +				"%s is registered as cooling_device%d\n",
> +				device->dev->dev.bus_id, device->cdev->id);
> +			result = sysfs_create_link(&device->dev->dev.kobj,
> +					  &device->cdev->device.kobj,
> +					  "thermal_cooling");
> +			if (result)
> +				printk(KERN_ERR PREFIX "Create sysfs link\n");
> +			result = sysfs_create_link(&device->cdev->device.kobj,
> +					  &device->dev->dev.kobj,
> +					  "device");
> +                        if (result)
> +				printk(KERN_ERR PREFIX "Create sysfs link\n");
> +		}
>  	}
>  	if (device->cap._DCS && device->cap._DSS){
>  		static int count = 0;
>
