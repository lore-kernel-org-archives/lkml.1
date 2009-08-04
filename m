Return-Path: <linux-kernel-owner+w=401wt.eu-S1755243AbZHDDgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbZHDDgJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 23:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZHDDgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 23:36:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:32221 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbZHDDgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 23:36:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,318,1246863600"; 
   d="scan'208";a="480470583"
Subject: Re: [PATCH V2 0/4] introduce device async actions mechanism
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Alan Stern <stern@rowland.harvard.edu>,
       Arjan van de Ven <arjan@linux.intel.com>, "dtor@mail.ru" <dtor@mail.ru>
In-Reply-To: <200908032318.35070.rjw@sisk.pl>
References: <1248404514.2670.107.camel@rzhang-dt>
	 <200908032318.35070.rjw@sisk.pl>
Content-Type: multipart/mixed; boundary="=-+hGPqoFT3a+rQCfs8teV"
Date: Tue, 04 Aug 2009 11:35:37 +0800
Message-Id: <1249356937.2670.335.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+hGPqoFT3a+rQCfs8teV
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On Tue, 2009-08-04 at 05:18 +0800, Rafael J. Wysocki wrote:
> On Friday 24 July 2009, Zhang Rui wrote:
> > Hi,
> 
> Hi,
> 
> > this is the patch set I made to speed up the device
> > suspend/resume/shutdown process.
> > 
> > A new mechanism called Device Async Actions is introduced
> > in this patch set.
> 
> Well, I'm not sure we'll need that.
> 
> > The basic idea is that,
> > if the suspend/resume/shutdown process of a device group, including
> > a root device and its child devices, are independent of other devices,
> > we create an async domain for this device group,
> > and make them suspend/resume/shutdown asynchronously.    
> 
> I don't really think this is the right approach.  IMO, we should rather try to
> identify groups of devices for which the PM callbacks (forget about .shutdown()
> for now) can be executed in parallel.

hah, I see.
You want to execute as more PM callbacks﻿ at one time as possible,
right?
I'm afraid this won't bring as many benefits as it looks like because
most of the suspend/resume time is cost on several specified devices.

Take the dmesg I attached for example.

total device suspend time is 1.532s.
serio2		0.407s
sd 0.0.0.0	0.452s
serio0		0.103s
0b.4.2		0.114s
00.1f.2		0.080s
00.19.0		0.072s
all the others	0.304s

total device resume time is 2.899s
PNP0C0A:00(bat)	0.896s
00.19.0		0.056s
0b.4.0		0.139s
0b.1.1		0.064s
usb1		0.052s
usb2		0.051s
usb3		0.042s
usb8		0.248s
sd 0.0.0.0	0.118s
usb 3-1		0.261s
usb 8-1		0.511s
all the others	0.461s

We can see that these several devices take 80%~85% suspend/resume time,
while all the other (nearly 500) devices take 20%.

Running a lot device PM callbacks at one time is not equal to saving a
lot time if the devices listed above still run synchronously.

So I think the key point to speed up suspend/resume is to invoke the PM
callbacks of these devices asynchronously.
And I use the asynchronous functions for two reasons.
1. devices with dependency are in the same asynchronous domain so that
   their PM callbacks run in-order.
﻿2. PM callbacks of the devices without any dependency run
asynchronously
   by using different asynchronous domains.

> One such group is leaf devices, ie.
> devices that have no children.  Of course, some of them will depend of the
> other indirectly, so we should make it possible to declare (in the driver)
> whether the device can be suspended/resumed asynchronously and use the
> following logic (at the core level), in pseudo code:
> 
> if (has_no_children(dev) && asynchronous_suspend_resume_allowed(dev))
>     async_resume(dev);
> else
>     resume(dev);
> 
> and analogously for suspend.  Then, we can easily use one async domain for all
> of these devices.

> Later, we can add async domains for devices that have children, but can be
> suspended and woken up in parallel with each other.
>   IOW, I think the async
> domains should span the levels rather than branches of the device
> tree.
> 

Hmm, as I said above,
this approach works only if we can make sure that the specified devices
are put in the same async domain, i.e. run in parallel.
are there any prototype patches available?

thanks,
rui

--=-+hGPqoFT3a+rQCfs8teV
Content-Disposition: attachment; filename=dmesg-synchronously
Content-Type: text/plain; name=dmesg-synchronously; charset=utf-8
Content-Transfer-Encoding: 7bit

[  144.348917] PM: Syncing filesystems ... done.
[  144.357728] PM: Preparing system for mem sleep
[  145.970864] [drm:gm45_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 0
[  145.971487] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  145.972536] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  145.972572] PM: Entering mem sleep
[  145.972589] Suspending console(s) (use no_console_suspend to debug)
[  145.972807] Rui: device vcsa63, action 0 started
[  145.972809] Rui: device vcsa63, action 0 done
[  145.972810] Rui: device vcs63, action 0 started
[  145.972811] Rui: device vcs63, action 0 done
[  145.972812] Rui: device 0:22, action 0 started
[  145.972813] Rui: device 0:22, action 0 done
[  145.972815] Rui: device iwl-phy0::TX, action 0 started
[  145.972816] Rui: device iwl-phy0::TX, action 0 done
[  145.972817] Rui: device iwl-phy0::RX, action 0 started
[  145.972819] Rui: device iwl-phy0::RX, action 0 done
[  145.972820] Rui: device iwl-phy0::assoc, action 0 started
[  145.972821] Rui: device iwl-phy0::assoc, action 0 done
[  145.972822] Rui: device iwl-phy0::radio, action 0 started
[  145.972824] Rui: device iwl-phy0::radio, action 0 done
[  145.972825] Rui: device event11, action 0 started
[  145.972826] Rui: device event11, action 0 done
[  145.972827] Rui: device input11, action 0 started
[  145.972828] Rui: device input11, action 0 done
[  145.972830] Rui: device event10, action 0 started
[  145.972831] Rui: device event10, action 0 done
[  145.972832] Rui: device input10, action 0 started
[  145.972833] Rui: device input10, action 0 done
[  145.972834] Rui: device card0, action 0 started
[  145.988306] pci 0000:00:02.0: power state changed by ACPI to D3
[  145.988313] Rui: device card0, action 0 done
[  145.988317] Rui: device vcsa7, action 0 started
[  145.988321] Rui: device vcsa7, action 0 done
[  145.988325] Rui: device vcs7, action 0 started
[  145.988328] Rui: device vcs7, action 0 done
[  145.988332] Rui: device pan0, action 0 started
[  145.988335] Rui: device pan0, action 0 done
[  145.988339] Rui: device mixer, action 0 started
[  145.988343] Rui: device mixer, action 0 done
[  145.988347] Rui: device controlC0, action 0 started
[  145.988350] Rui: device controlC0, action 0 done
[  145.988354] Rui: device audio, action 0 started
[  145.988358] Rui: device audio, action 0 done
[  145.988361] Rui: device dsp, action 0 started
[  145.988365] Rui: device dsp, action 0 done
[  145.988369] Rui: device pcmC0D0c, action 0 started
[  145.988372] Rui: device pcmC0D0c, action 0 done
[  145.988376] Rui: device pcmC0D0p, action 0 started
[  145.988380] Rui: device pcmC0D0p, action 0 done
[  145.988383] Rui: device adsp, action 0 started
[  145.988387] Rui: device adsp, action 0 done
[  145.988390] Rui: device pcmC0D1p, action 0 started
[  145.988394] Rui: device pcmC0D1p, action 0 done
[  145.988398] Rui: device card0, action 0 started
[  145.988401] Rui: device card0, action 0 done
[  145.988405] Rui: device event9, action 0 started
[  145.988409] Rui: device event9, action 0 done
[  145.988412] Rui: device input9, action 0 started
[  145.988416] Rui: device input9, action 0 done
[  145.988420] Rui: device event8, action 0 started
[  145.988423] Rui: device event8, action 0 done
[  145.988427] Rui: device mouse3, action 0 started
[  145.988431] Rui: device mouse3, action 0 done
[  145.988434] Rui: device input8, action 0 started
[  145.988438] Rui: device input8, action 0 done
[  145.988441] Rui: device event7, action 0 started
[  145.988445] Rui: device event7, action 0 done
[  145.988448] Rui: device mouse2, action 0 started
[  145.988452] Rui: device mouse2, action 0 done
[  145.988456] Rui: device input7, action 0 started
[  145.988459] Rui: device input7, action 0 done
[  145.988463] Rui: device sequencer2, action 0 started
[  145.988467] Rui: device sequencer2, action 0 done
[  145.988471] Rui: device sequencer, action 0 started
[  145.988474] Rui: device sequencer, action 0 done
[  145.988478] Rui: device wlan0, action 0 started
[  145.988482] Rui: device wlan0, action 0 done
[  145.988486] Rui: device wmaster0, action 0 started
[  145.988489] Rui: device wmaster0, action 0 done
[  145.988493] Rui: device seq, action 0 started
[  145.988497] Rui: device seq, action 0 done
[  145.988500] Rui: device rfkill3, action 0 started
[  145.988505] Rui: device rfkill3, action 0 done
[  145.988509] Rui: device phy0, action 0 started
[  146.031691] Rui: device phy0, action 0 done
[  146.031696] Rui: device timer, action 0 started
[  146.031701] Rui: device timer, action 0 done
[  146.031705] Rui: device pcmcia_socket0, action 0 started
[  146.031708] Rui: device pcmcia_socket0, action 0 done
[  146.031712] Rui: device mmc0, action 0 started
[  146.031716] Rui: device mmc0, action 0 done
[  146.031719] Rui: device mmc0::, action 0 started
[  146.031723] Rui: device mmc0::, action 0 done
[  146.031727] Rui: device iTCO_wdt, action 0 started
[  146.031730] Rui: device iTCO_wdt, action 0 done
[  146.031734] Rui: device event6, action 0 started
[  146.031738] Rui: device event6, action 0 done
[  146.031742] Rui: device input6, action 0 started
[  146.031745] Rui: device input6, action 0 done
[  146.031749] Rui: device rfkill2, action 0 started
[  146.031753] Rui: device rfkill2, action 0 done
[  146.031757] Rui: device rfkill1, action 0 started
[  146.031760] Rui: device rfkill1, action 0 done
[  146.031764] Rui: device sony-laptop, action 0 started
[  146.031768] Rui: device sony-laptop, action 0 done
[  146.031772] Rui: device sonypi, action 0 started
[  146.031776] Rui: device sonypi, action 0 done
[  146.031780] Rui: device event5, action 0 started
[  146.031783] Rui: device event5, action 0 done
[  146.031787] Rui: device mouse1, action 0 started
[  146.031790] Rui: device mouse1, action 0 done
[  146.031794] Rui: device input5, action 0 started
[  146.031797] Rui: device input5, action 0 done
[  146.031801] Rui: device event4, action 0 started
[  146.031804] Rui: device event4, action 0 done
[  146.031808] Rui: device input4, action 0 started
[  146.031811] Rui: device input4, action 0 done
[  146.031815] Rui: device agpgart, action 0 started
[  146.031819] Rui: device agpgart, action 0 done
[  146.031823] Rui: device regulatory.0, action 0 started
[  146.031827] Rui: device regulatory.0, action 0 done
[  146.031830] Rui: device rfkill0, action 0 started
[  146.031834] Rui: device rfkill0, action 0 done
[  146.031838] Rui: device hci0, action 0 started
[  146.031842] Rui: device hci0, action 0 done
[  146.031846] Rui: device 0800460302aefbe1, action 0 started
[  146.031849] Rui: device 0800460302aefbe1, action 0 done
[  146.031853] Rui: device 0800460302aefbe1, action 0 started
[  146.031857] Rui: device 0800460302aefbe1, action 0 done
[  146.031861] Rui: device eth0, action 0 started
[  146.031865] Rui: device eth0, action 0 done
[  146.031869] Rui: device fw-host0, action 0 started
[  146.031872] Rui: device fw-host0, action 0 done
[  146.031876] Rui: device fw-host0, action 0 started
[  146.031880] Rui: device fw-host0, action 0 done
[  146.031883] Rui: device vcsa8, action 0 started
[  146.031887] Rui: device vcsa8, action 0 done
[  146.031890] Rui: device vcs8, action 0 started
[  146.031894] Rui: device vcs8, action 0 done
[  146.031898] Rui: device vcsa6, action 0 started
[  146.031901] Rui: device vcsa6, action 0 done
[  146.031905] Rui: device vcs6, action 0 started
[  146.031908] Rui: device vcs6, action 0 done
[  146.031912] Rui: device vcsa5, action 0 started
[  146.031916] Rui: device vcsa5, action 0 done
[  146.031919] Rui: device vcs5, action 0 started
[  146.031923] Rui: device vcs5, action 0 done
[  146.031926] Rui: device vcsa4, action 0 started
[  146.031930] Rui: device vcsa4, action 0 done
[  146.031934] Rui: device vcs4, action 0 started
[  146.031937] Rui: device vcs4, action 0 done
[  146.031941] Rui: device vcsa3, action 0 started
[  146.031944] Rui: device vcsa3, action 0 done
[  146.031948] Rui: device vcs3, action 0 started
[  146.031951] Rui: device vcs3, action 0 done
[  146.031955] Rui: device vcsa2, action 0 started
[  146.031958] Rui: device vcsa2, action 0 done
[  146.031962] Rui: device vcs2, action 0 started
[  146.031966] Rui: device vcs2, action 0 done
[  146.031969] Rui: device ep_00, action 0 started
[  146.031973] Rui: device ep_00, action 0 done
[  146.031976] Rui: device 8-2:1.3, action 0 started
[  146.031980] Rui: device 8-2:1.3, action 0 done
[  146.031984] Rui: device ep_04, action 0 started
[  146.031987] Rui: device ep_04, action 0 done
[  146.031991] Rui: device ep_84, action 0 started
[  146.032013] Rui: device ep_84, action 0 done
[  146.032017] Rui: device 8-2:1.2, action 0 started
[  146.032020] Rui: device 8-2:1.2, action 0 done
[  146.032024] Rui: device ep_03, action 0 started
[  146.032027] Rui: device ep_03, action 0 done
[  146.032031] Rui: device ep_83, action 0 started
[  146.032034] Rui: device ep_83, action 0 done
[  146.032038] Rui: device 8-2:1.1, action 0 started
[  146.032041] Rui: device 8-2:1.1, action 0 done
[  146.032045] Rui: device ep_02, action 0 started
[  146.032049] Rui: device ep_02, action 0 done
[  146.032052] Rui: device ep_82, action 0 started
[  146.032056] Rui: device ep_82, action 0 done
[  146.032060] Rui: device ep_81, action 0 started
[  146.032063] Rui: device ep_81, action 0 done
[  146.032067] Rui: device 8-2:1.0, action 0 started
[  146.032070] Rui: device 8-2:1.0, action 0 done
[  146.032074] Rui: device 8-2, action 0 started
[  146.033449] btusb_bulk_complete: hci0 urb ffff8800379390c0 failed to resubmit (1)
[  146.034441] btusb_bulk_complete: hci0 urb ffff880037939000 failed to resubmit (1)
[  146.035439] btusb_intr_complete: hci0 urb ffff8800379399c0 failed to resubmit (1)
[  146.048559] Rui: device 8-2, action 0 done
[  146.048564] Rui: device sg1, action 0 started
[  146.048567] Rui: device sg1, action 0 done
[  146.048571] Rui: device 1:0:0:0, action 0 started
[  146.048575] Rui: device 1:0:0:0, action 0 done
[  146.048578] Rui: device 11:0, action 0 started
[  146.048582] Rui: device 11:0, action 0 done
[  146.048586] Rui: device sr0, action 0 started
[  146.048589] Rui: device sr0, action 0 done
[  146.048593] Rui: device 1:0:0:0, action 0 started
[  146.048600] Rui: device 1:0:0:0, action 0 done
[  146.048604] Rui: device target1:0:0, action 0 started
[  146.048608] Rui: device target1:0:0, action 0 done
[  146.048612] Rui: device ep_00, action 0 started
[  146.048615] Rui: device ep_00, action 0 done
[  146.048619] Rui: device ep_83, action 0 started
[  146.048622] Rui: device ep_83, action 0 done
[  146.048626] Rui: device ep_02, action 0 started
[  146.048630] Rui: device ep_02, action 0 done
[  146.048633] Rui: device ep_81, action 0 started
[  146.048637] Rui: device ep_81, action 0 done
[  146.048640] Rui: device 3-1:1.0, action 0 started
[  146.048644] Rui: device 3-1:1.0, action 0 done
[  146.048648] Rui: device 3-1, action 0 started
[  146.064067] Rui: device 3-1, action 0 done
[  146.064072] Rui: device ep_00, action 0 started
[  146.064075] Rui: device ep_00, action 0 done
[  146.064079] Rui: device 1-2:1.1, action 0 started
[  146.064082] Rui: device 1-2:1.1, action 0 done
[  146.064086] Rui: device ep_81, action 0 started
[  146.064090] Rui: device ep_81, action 0 done
[  146.064093] Rui: device 1-2:1.0, action 0 started
[  146.064097] Rui: device 1-2:1.0, action 0 done
[  146.064100] Rui: device 1-2, action 0 started
[  146.080096] Rui: device 1-2, action 0 done
[  146.080100] Rui: device serio4, action 0 started
[  146.080105] Rui: device serio4, action 0 done
[  146.080108] Rui: device serio3, action 0 started
[  146.080112] Rui: device serio3, action 0 done
[  146.080115] Rui: device serio2, action 0 started
[  146.487886] Rui: device serio2, action 0 done
[  146.487890] Rui: device 8:0, action 0 started
[  146.487894] Rui: device 8:0, action 0 done
[  146.487898] Rui: device sda7, action 0 started
[  146.487901] Rui: device sda7, action 0 done
[  146.487905] Rui: device sda6, action 0 started
[  146.487909] Rui: device sda6, action 0 done
[  146.487912] Rui: device sda5, action 0 started
[  146.487916] Rui: device sda5, action 0 done
[  146.487919] Rui: device sda3, action 0 started
[  146.487922] Rui: device sda3, action 0 done
[  146.487926] Rui: device sda1, action 0 started
[  146.487930] Rui: device sda1, action 0 done
[  146.487933] Rui: device sda, action 0 started
[  146.487937] Rui: device sda, action 0 done
[  146.487941] Rui: device sg0, action 0 started
[  146.487944] Rui: device sg0, action 0 done
[  146.487948] Rui: device 0:0:0:0, action 0 started
[  146.487951] Rui: device 0:0:0:0, action 0 done
[  146.487955] Rui: device 0:0:0:0, action 0 started
[  146.487958] Rui: device 0:0:0:0, action 0 done
[  146.487962] Rui: device 0:0:0:0, action 0 started
[  146.487970] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  146.488144] sd 0:0:0:0: [sda] Stopping disk
[  146.949349] Rui: device 0:0:0:0, action 0 done
[  146.949354] Rui: device target0:0:0, action 0 started
[  146.949358] Rui: device target0:0:0, action 0 done
[  146.949362] Rui: device serio1, action 0 started
[  146.949366] Rui: device serio1, action 0 done
[  146.949369] Rui: device event3, action 0 started
[  146.949373] Rui: device event3, action 0 done
[  146.949377] Rui: device input3, action 0 started
[  146.949380] Rui: device input3, action 0 done
[  146.949384] Rui: device network_throughput, action 0 started
[  146.949388] Rui: device network_throughput, action 0 done
[  146.949392] Rui: device network_latency, action 0 started
[  146.949396] Rui: device network_latency, action 0 done
[  146.949400] Rui: device cpu_dma_latency, action 0 started
[  146.949403] Rui: device cpu_dma_latency, action 0 done
[  146.949407] Rui: device device-mapper, action 0 started
[  146.949411] Rui: device device-mapper, action 0 done
[  146.949415] Rui: device serio0, action 0 started
[  147.052076] Rui: device serio0, action 0 done
[  147.052080] Rui: device rtc0, action 0 started
[  147.052111] Rui: device rtc0, action 0 done
[  147.052114] Rui: device event2, action 0 started
[  147.052118] Rui: device event2, action 0 done
[  147.052121] Rui: device event1, action 0 started
[  147.052125] Rui: device event1, action 0 done
[  147.052128] Rui: device event0, action 0 started
[  147.052132] Rui: device event0, action 0 done
[  147.052135] Rui: device psaux, action 0 started
[  147.052139] Rui: device psaux, action 0 done
[  147.052143] Rui: device mouse0, action 0 started
[  147.052147] Rui: device mouse0, action 0 done
[  147.052150] Rui: device mice, action 0 started
[  147.052154] Rui: device mice, action 0 done
[  147.052157] Rui: device i8042, action 0 started
[  147.052863] Rui: device i8042, action 0 done
[  147.052867] Rui: device ep_00, action 0 started
[  147.052870] Rui: device ep_00, action 0 done
[  147.052874] Rui: device ep_81, action 0 started
[  147.052877] Rui: device ep_81, action 0 done
[  147.052881] Rui: device 8-0:1.0, action 0 started
[  147.052884] Rui: device 8-0:1.0, action 0 done
[  147.052888] Rui: device usb8, action 0 started
[  147.052915] Rui: device usb8, action 0 done
[  147.052919] Rui: device usbmon8, action 0 started
[  147.052922] Rui: device usbmon8, action 0 done
[  147.052926] Rui: device ep_00, action 0 started
[  147.052929] Rui: device ep_00, action 0 done
[  147.052933] Rui: device ep_81, action 0 started
[  147.052937] Rui: device ep_81, action 0 done
[  147.052940] Rui: device 7-0:1.0, action 0 started
[  147.052944] Rui: device 7-0:1.0, action 0 done
[  147.052948] Rui: device usb7, action 0 started
[  147.052951] Rui: device usb7, action 0 done
[  147.052955] Rui: device usbmon7, action 0 started
[  147.052959] Rui: device usbmon7, action 0 done
[  147.052962] Rui: device ep_00, action 0 started
[  147.052966] Rui: device ep_00, action 0 done
[  147.052970] Rui: device ep_81, action 0 started
[  147.052973] Rui: device ep_81, action 0 done
[  147.052977] Rui: device 6-0:1.0, action 0 started
[  147.052981] Rui: device 6-0:1.0, action 0 done
[  147.052984] Rui: device usb6, action 0 started
[  147.052988] Rui: device usb6, action 0 done
[  147.052992] Rui: device usbmon6, action 0 started
[  147.052995] Rui: device usbmon6, action 0 done
[  147.052999] Rui: device ep_00, action 0 started
[  147.053002] Rui: device ep_00, action 0 done
[  147.053006] Rui: device ep_81, action 0 started
[  147.053009] Rui: device ep_81, action 0 done
[  147.053013] Rui: device 5-0:1.0, action 0 started
[  147.053017] Rui: device 5-0:1.0, action 0 done
[  147.053020] Rui: device usb5, action 0 started
[  147.053024] Rui: device usb5, action 0 done
[  147.053027] Rui: device usbmon5, action 0 started
[  147.053031] Rui: device usbmon5, action 0 done
[  147.053035] Rui: device ep_00, action 0 started
[  147.053038] Rui: device ep_00, action 0 done
[  147.053042] Rui: device ep_81, action 0 started
[  147.053045] Rui: device ep_81, action 0 done
[  147.053049] Rui: device 4-0:1.0, action 0 started
[  147.053052] Rui: device 4-0:1.0, action 0 done
[  147.053056] Rui: device usb4, action 0 started
[  147.053059] Rui: device usb4, action 0 done
[  147.053063] Rui: device usbmon4, action 0 started
[  147.053067] Rui: device usbmon4, action 0 done
[  147.053070] Rui: device ep_00, action 0 started
[  147.053074] Rui: device ep_00, action 0 done
[  147.053077] Rui: device ep_81, action 0 started
[  147.053081] Rui: device ep_81, action 0 done
[  147.053084] Rui: device 3-0:1.0, action 0 started
[  147.053088] Rui: device 3-0:1.0, action 0 done
[  147.053091] Rui: device usb3, action 0 started
[  147.053113] Rui: device usb3, action 0 done
[  147.053117] Rui: device usbmon3, action 0 started
[  147.053121] Rui: device usbmon3, action 0 done
[  147.053124] Rui: device ep_00, action 0 started
[  147.053128] Rui: device ep_00, action 0 done
[  147.053131] Rui: device ep_81, action 0 started
[  147.053135] Rui: device ep_81, action 0 done
[  147.053138] Rui: device 2-0:1.0, action 0 started
[  147.053142] Rui: device 2-0:1.0, action 0 done
[  147.053145] Rui: device usb2, action 0 started
[  147.053149] Rui: device usb2, action 0 done
[  147.053153] Rui: device usbmon2, action 0 started
[  147.053156] Rui: device usbmon2, action 0 done
[  147.053160] Rui: device ep_00, action 0 started
[  147.053163] Rui: device ep_00, action 0 done
[  147.053167] Rui: device ep_81, action 0 started
[  147.053171] Rui: device ep_81, action 0 done
[  147.053174] Rui: device 1-0:1.0, action 0 started
[  147.053178] Rui: device 1-0:1.0, action 0 done
[  147.053181] Rui: device usb1, action 0 started
[  147.053212] Rui: device usb1, action 0 done
[  147.053215] Rui: device usbmon1, action 0 started
[  147.053219] Rui: device usbmon1, action 0 done
[  147.053222] Rui: device usbmon0, action 0 started
[  147.053226] Rui: device usbmon0, action 0 done
[  147.053229] Rui: device ppp, action 0 started
[  147.053233] Rui: device ppp, action 0 done
[  147.053237] Rui: device 0, action 0 started
[  147.053240] Rui: device 0, action 0 done
[  147.053244] Rui: device Fixed MDIO bus.0, action 0 started
[  147.053248] Rui: device Fixed MDIO bus.0, action 0 done
[  147.053252] Rui: device host5, action 0 started
[  147.053255] Rui: device host5, action 0 done
[  147.053259] Rui: device host5, action 0 started
[  147.053263] Rui: device host5, action 0 done
[  147.053266] Rui: device host4, action 0 started
[  147.053270] Rui: device host4, action 0 done
[  147.053273] Rui: device host4, action 0 started
[  147.053277] Rui: device host4, action 0 done
[  147.053280] Rui: device host3, action 0 started
[  147.053284] Rui: device host3, action 0 done
[  147.053288] Rui: device host3, action 0 started
[  147.053291] Rui: device host3, action 0 done
[  147.053295] Rui: device host2, action 0 started
[  147.053298] Rui: device host2, action 0 done
[  147.053302] Rui: device host2, action 0 started
[  147.053305] Rui: device host2, action 0 done
[  147.053309] Rui: device host1, action 0 started
[  147.053313] Rui: device host1, action 0 done
[  147.053317] Rui: device host1, action 0 started
[  147.053320] Rui: device host1, action 0 done
[  147.053324] Rui: device host0, action 0 started
[  147.053327] Rui: device host0, action 0 done
[  147.053331] Rui: device host0, action 0 started
[  147.053334] Rui: device host0, action 0 done
[  147.053338] Rui: device tgt, action 0 started
[  147.053341] Rui: device tgt, action 0 done
[  147.053345] Rui: device BAT0, action 0 started
[  147.053348] Rui: device BAT0, action 0 done
[  147.053352] Rui: device input2, action 0 started
[  147.053356] Rui: device input2, action 0 done
[  147.053359] Rui: device pktcdvd!control, action 0 started
[  147.053363] Rui: device pktcdvd!control, action 0 done
[  147.053367] Rui: device 7:7, action 0 started
[  147.053370] Rui: device 7:7, action 0 done
[  147.053374] Rui: device loop7, action 0 started
[  147.053378] Rui: device loop7, action 0 done
[  147.053382] Rui: device 7:6, action 0 started
[  147.053385] Rui: device 7:6, action 0 done
[  147.053389] Rui: device loop6, action 0 started
[  147.053392] Rui: device loop6, action 0 done
[  147.053396] Rui: device 7:5, action 0 started
[  147.053399] Rui: device 7:5, action 0 done
[  147.053403] Rui: device loop5, action 0 started
[  147.053406] Rui: device loop5, action 0 done
[  147.053410] Rui: device 7:4, action 0 started
[  147.053413] Rui: device 7:4, action 0 done
[  147.053417] Rui: device loop4, action 0 started
[  147.053421] Rui: device loop4, action 0 done
[  147.053424] Rui: device 7:3, action 0 started
[  147.053428] Rui: device 7:3, action 0 done
[  147.053431] Rui: device loop3, action 0 started
[  147.053435] Rui: device loop3, action 0 done
[  147.053438] Rui: device 7:2, action 0 started
[  147.053442] Rui: device 7:2, action 0 done
[  147.053445] Rui: device loop2, action 0 started
[  147.053449] Rui: device loop2, action 0 done
[  147.053453] Rui: device 7:1, action 0 started
[  147.053456] Rui: device 7:1, action 0 done
[  147.053460] Rui: device loop1, action 0 started
[  147.053463] Rui: device loop1, action 0 done
[  147.053467] Rui: device 7:0, action 0 started
[  147.053470] Rui: device 7:0, action 0 done
[  147.053474] Rui: device loop0, action 0 started
[  147.053478] Rui: device loop0, action 0 done
[  147.053482] Rui: device 1:15, action 0 started
[  147.053485] Rui: device 1:15, action 0 done
[  147.053489] Rui: device ram15, action 0 started
[  147.053492] Rui: device ram15, action 0 done
[  147.053496] Rui: device 1:14, action 0 started
[  147.053499] Rui: device 1:14, action 0 done
[  147.053503] Rui: device ram14, action 0 started
[  147.053506] Rui: device ram14, action 0 done
[  147.053510] Rui: device 1:13, action 0 started
[  147.053514] Rui: device 1:13, action 0 done
[  147.053517] Rui: device ram13, action 0 started
[  147.053521] Rui: device ram13, action 0 done
[  147.053524] Rui: device 1:12, action 0 started
[  147.053528] Rui: device 1:12, action 0 done
[  147.053532] Rui: device ram12, action 0 started
[  147.053535] Rui: device ram12, action 0 done
[  147.053539] Rui: device 1:11, action 0 started
[  147.053542] Rui: device 1:11, action 0 done
[  147.053546] Rui: device ram11, action 0 started
[  147.053549] Rui: device ram11, action 0 done
[  147.053553] Rui: device 1:10, action 0 started
[  147.053556] Rui: device 1:10, action 0 done
[  147.053560] Rui: device ram10, action 0 started
[  147.053563] Rui: device ram10, action 0 done
[  147.053567] Rui: device 1:9, action 0 started
[  147.053570] Rui: device 1:9, action 0 done
[  147.053574] Rui: device ram9, action 0 started
[  147.053578] Rui: device ram9, action 0 done
[  147.053582] Rui: device 1:8, action 0 started
[  147.053585] Rui: device 1:8, action 0 done
[  147.053589] Rui: device ram8, action 0 started
[  147.053592] Rui: device ram8, action 0 done
[  147.053596] Rui: device 1:7, action 0 started
[  147.053599] Rui: device 1:7, action 0 done
[  147.053603] Rui: device ram7, action 0 started
[  147.053606] Rui: device ram7, action 0 done
[  147.053610] Rui: device 1:6, action 0 started
[  147.053613] Rui: device 1:6, action 0 done
[  147.053617] Rui: device ram6, action 0 started
[  147.053620] Rui: device ram6, action 0 done
[  147.053624] Rui: device 1:5, action 0 started
[  147.053627] Rui: device 1:5, action 0 done
[  147.053631] Rui: device ram5, action 0 started
[  147.053635] Rui: device ram5, action 0 done
[  147.053638] Rui: device 1:4, action 0 started
[  147.053641] Rui: device 1:4, action 0 done
[  147.053645] Rui: device ram4, action 0 started
[  147.053649] Rui: device ram4, action 0 done
[  147.053652] Rui: device 1:3, action 0 started
[  147.053656] Rui: device 1:3, action 0 done
[  147.053660] Rui: device ram3, action 0 started
[  147.053663] Rui: device ram3, action 0 done
[  147.053667] Rui: device 1:2, action 0 started
[  147.053670] Rui: device 1:2, action 0 done
[  147.053674] Rui: device ram2, action 0 started
[  147.053677] Rui: device ram2, action 0 done
[  147.053681] Rui: device 1:1, action 0 started
[  147.053684] Rui: device 1:1, action 0 done
[  147.053688] Rui: device ram1, action 0 started
[  147.053691] Rui: device ram1, action 0 done
[  147.053695] Rui: device 1:0, action 0 started
[  147.053699] Rui: device 1:0, action 0 done
[  147.053702] Rui: device ram0, action 0 started
[  147.053706] Rui: device ram0, action 0 done
[  147.053709] Rui: device ttyS3, action 0 started
[  147.053713] Rui: device ttyS3, action 0 done
[  147.053716] Rui: device ttyS2, action 0 started
[  147.053720] Rui: device ttyS2, action 0 done
[  147.053723] Rui: device ttyS1, action 0 started
[  147.053727] Rui: device ttyS1, action 0 done
[  147.053730] Rui: device ttyS0, action 0 started
[  147.053734] Rui: device ttyS0, action 0 done
[  147.053738] Rui: device serial8250, action 0 started
[  147.053744] Rui: device serial8250, action 0 done
[  147.053748] Rui: device hpet, action 0 started
[  147.053751] Rui: device hpet, action 0 done
[  147.053754] Rui: device ptmx, action 0 started
[  147.053758] Rui: device ptmx, action 0 done
[  147.053762] Rui: device tty63, action 0 started
[  147.053765] Rui: device tty63, action 0 done
[  147.053768] Rui: device tty62, action 0 started
[  147.053772] Rui: device tty62, action 0 done
[  147.053775] Rui: device tty61, action 0 started
[  147.053779] Rui: device tty61, action 0 done
[  147.053782] Rui: device tty60, action 0 started
[  147.053786] Rui: device tty60, action 0 done
[  147.053789] Rui: device tty59, action 0 started
[  147.053793] Rui: device tty59, action 0 done
[  147.053796] Rui: device tty58, action 0 started
[  147.053800] Rui: device tty58, action 0 done
[  147.053803] Rui: device tty57, action 0 started
[  147.053807] Rui: device tty57, action 0 done
[  147.053810] Rui: device tty56, action 0 started
[  147.053814] Rui: device tty56, action 0 done
[  147.053817] Rui: device tty55, action 0 started
[  147.053821] Rui: device tty55, action 0 done
[  147.053824] Rui: device tty54, action 0 started
[  147.053828] Rui: device tty54, action 0 done
[  147.053831] Rui: device tty53, action 0 started
[  147.053835] Rui: device tty53, action 0 done
[  147.053838] Rui: device tty52, action 0 started
[  147.053842] Rui: device tty52, action 0 done
[  147.053845] Rui: device tty51, action 0 started
[  147.053849] Rui: device tty51, action 0 done
[  147.053852] Rui: device tty50, action 0 started
[  147.053856] Rui: device tty50, action 0 done
[  147.053859] Rui: device tty49, action 0 started
[  147.053863] Rui: device tty49, action 0 done
[  147.053866] Rui: device tty48, action 0 started
[  147.053870] Rui: device tty48, action 0 done
[  147.053873] Rui: device tty47, action 0 started
[  147.053877] Rui: device tty47, action 0 done
[  147.053880] Rui: device tty46, action 0 started
[  147.053884] Rui: device tty46, action 0 done
[  147.053887] Rui: device tty45, action 0 started
[  147.053891] Rui: device tty45, action 0 done
[  147.053894] Rui: device tty44, action 0 started
[  147.053898] Rui: device tty44, action 0 done
[  147.053901] Rui: device tty43, action 0 started
[  147.053905] Rui: device tty43, action 0 done
[  147.053908] Rui: device tty42, action 0 started
[  147.053912] Rui: device tty42, action 0 done
[  147.053915] Rui: device tty41, action 0 started
[  147.053919] Rui: device tty41, action 0 done
[  147.053922] Rui: device tty40, action 0 started
[  147.053926] Rui: device tty40, action 0 done
[  147.053929] Rui: device tty39, action 0 started
[  147.053933] Rui: device tty39, action 0 done
[  147.053936] Rui: device tty38, action 0 started
[  147.053940] Rui: device tty38, action 0 done
[  147.053943] Rui: device tty37, action 0 started
[  147.053947] Rui: device tty37, action 0 done
[  147.053950] Rui: device tty36, action 0 started
[  147.053954] Rui: device tty36, action 0 done
[  147.053957] Rui: device tty35, action 0 started
[  147.053961] Rui: device tty35, action 0 done
[  147.053964] Rui: device tty34, action 0 started
[  147.053968] Rui: device tty34, action 0 done
[  147.053971] Rui: device tty33, action 0 started
[  147.053975] Rui: device tty33, action 0 done
[  147.053978] Rui: device tty32, action 0 started
[  147.053982] Rui: device tty32, action 0 done
[  147.053985] Rui: device tty31, action 0 started
[  147.053989] Rui: device tty31, action 0 done
[  147.053992] Rui: device tty30, action 0 started
[  147.053995] Rui: device tty30, action 0 done
[  147.053999] Rui: device tty29, action 0 started
[  147.054002] Rui: device tty29, action 0 done
[  147.054006] Rui: device tty28, action 0 started
[  147.054009] Rui: device tty28, action 0 done
[  147.054013] Rui: device tty27, action 0 started
[  147.054016] Rui: device tty27, action 0 done
[  147.054020] Rui: device tty26, action 0 started
[  147.054023] Rui: device tty26, action 0 done
[  147.054027] Rui: device tty25, action 0 started
[  147.054031] Rui: device tty25, action 0 done
[  147.054034] Rui: device tty24, action 0 started
[  147.054037] Rui: device tty24, action 0 done
[  147.054041] Rui: device tty23, action 0 started
[  147.054044] Rui: device tty23, action 0 done
[  147.054048] Rui: device tty22, action 0 started
[  147.054051] Rui: device tty22, action 0 done
[  147.054055] Rui: device tty21, action 0 started
[  147.054058] Rui: device tty21, action 0 done
[  147.054062] Rui: device tty20, action 0 started
[  147.054065] Rui: device tty20, action 0 done
[  147.054069] Rui: device tty19, action 0 started
[  147.054073] Rui: device tty19, action 0 done
[  147.054076] Rui: device tty18, action 0 started
[  147.054080] Rui: device tty18, action 0 done
[  147.054083] Rui: device tty17, action 0 started
[  147.054087] Rui: device tty17, action 0 done
[  147.054090] Rui: device tty16, action 0 started
[  147.054094] Rui: device tty16, action 0 done
[  147.054097] Rui: device tty15, action 0 started
[  147.054101] Rui: device tty15, action 0 done
[  147.054104] Rui: device tty14, action 0 started
[  147.054108] Rui: device tty14, action 0 done
[  147.054111] Rui: device tty13, action 0 started
[  147.054115] Rui: device tty13, action 0 done
[  147.054118] Rui: device tty12, action 0 started
[  147.054122] Rui: device tty12, action 0 done
[  147.054125] Rui: device tty11, action 0 started
[  147.054129] Rui: device tty11, action 0 done
[  147.054132] Rui: device tty10, action 0 started
[  147.054136] Rui: device tty10, action 0 done
[  147.054140] Rui: device tty9, action 0 started
[  147.054143] Rui: device tty9, action 0 done
[  147.054146] Rui: device tty8, action 0 started
[  147.054150] Rui: device tty8, action 0 done
[  147.054153] Rui: device tty7, action 0 started
[  147.054157] Rui: device tty7, action 0 done
[  147.054160] Rui: device tty6, action 0 started
[  147.054164] Rui: device tty6, action 0 done
[  147.054167] Rui: device tty5, action 0 started
[  147.054170] Rui: device tty5, action 0 done
[  147.054174] Rui: device tty4, action 0 started
[  147.054177] Rui: device tty4, action 0 done
[  147.054181] Rui: device tty3, action 0 started
[  147.054184] Rui: device tty3, action 0 done
[  147.054188] Rui: device tty2, action 0 started
[  147.054191] Rui: device tty2, action 0 done
[  147.054195] Rui: device tty1, action 0 started
[  147.054198] Rui: device tty1, action 0 done
[  147.054201] Rui: device vcsa, action 0 started
[  147.054205] Rui: device vcsa, action 0 done
[  147.054209] Rui: device vcs, action 0 started
[  147.054212] Rui: device vcs, action 0 done
[  147.054215] Rui: device tty0, action 0 started
[  147.054219] Rui: device tty0, action 0 done
[  147.054222] Rui: device console, action 0 started
[  147.054226] Rui: device console, action 0 done
[  147.054230] Rui: device tty, action 0 started
[  147.054233] Rui: device tty, action 0 done
[  147.054237] Rui: device hwmon0, action 0 started
[  147.054240] Rui: device hwmon0, action 0 done
[  147.054244] Rui: device thermal_zone0, action 0 started
[  147.054248] Rui: device thermal_zone0, action 0 done
[  147.054252] Rui: device cooling_device1, action 0 started
[  147.054256] Rui: device cooling_device1, action 0 done
[  147.054260] Rui: device cooling_device0, action 0 started
[  147.054263] Rui: device cooling_device0, action 0 done
[  147.054267] Rui: device input1, action 0 started
[  147.054271] Rui: device input1, action 0 done
[  147.054274] Rui: device input0, action 0 started
[  147.054278] Rui: device input0, action 0 done
[  147.054282] Rui: device AC, action 0 started
[  147.054285] Rui: device AC, action 0 done
[  147.054289] Rui: device 0000:00:1c.3:pcie08, action 0 started
[  147.054293] Rui: device 0000:00:1c.3:pcie08, action 0 done
[  147.054297] Rui: device 0000:00:1c.3:pcie04, action 0 started
[  147.054301] Rui: device 0000:00:1c.3:pcie04, action 0 done
[  147.054305] Rui: device 0000:00:1c.3:pcie01, action 0 started
[  147.054308] Rui: device 0000:00:1c.3:pcie01, action 0 done
[  147.054312] Rui: device 0000:00:1c.1:pcie08, action 0 started
[  147.054316] Rui: device 0000:00:1c.1:pcie08, action 0 done
[  147.054320] Rui: device 0000:00:1c.1:pcie04, action 0 started
[  147.054324] Rui: device 0000:00:1c.1:pcie04, action 0 done
[  147.054328] Rui: device 0000:00:1c.1:pcie01, action 0 started
[  147.054332] Rui: device 0000:00:1c.1:pcie01, action 0 done
[  147.054335] Rui: device 0000:00:1c.0:pcie08, action 0 started
[  147.054339] Rui: device 0000:00:1c.0:pcie08, action 0 done
[  147.054343] Rui: device 0000:00:1c.0:pcie04, action 0 started
[  147.054347] Rui: device 0000:00:1c.0:pcie04, action 0 done
[  147.054351] Rui: device 0000:00:1c.0:pcie01, action 0 started
[  147.054355] Rui: device 0000:00:1c.0:pcie01, action 0 done
[  147.054359] Rui: device 0000:00:01.0:pcie08, action 0 started
[  147.054362] Rui: device 0000:00:01.0:pcie08, action 0 done
[  147.054366] Rui: device 0000:00:01.0:pcie04, action 0 started
[  147.054370] Rui: device 0000:00:01.0:pcie04, action 0 done
[  147.054374] Rui: device 0000:00:01.0:pcie01, action 0 started
[  147.054378] Rui: device 0000:00:01.0:pcie01, action 0 done
[  147.054382] Rui: device fuse, action 0 started
[  147.054385] Rui: device fuse, action 0 done
[  147.054389] Rui: device ecryptfs, action 0 started
[  147.054393] Rui: device ecryptfs, action 0 done
[  147.054396] Rui: device snapshot, action 0 started
[  147.054400] Rui: device snapshot, action 0 done
[  147.054404] Rui: device pcspkr, action 0 started
[  147.054413] Rui: device pcspkr, action 0 done
[  147.054417] Rui: device kmsg, action 0 started
[  147.054421] Rui: device kmsg, action 0 done
[  147.054424] Rui: device urandom, action 0 started
[  147.054428] Rui: device urandom, action 0 done
[  147.054431] Rui: device random, action 0 started
[  147.054435] Rui: device random, action 0 done
[  147.054438] Rui: device full, action 0 started
[  147.054442] Rui: device full, action 0 done
[  147.054445] Rui: device zero, action 0 started
[  147.054449] Rui: device zero, action 0 done
[  147.054452] Rui: device port, action 0 started
[  147.054456] Rui: device port, action 0 done
[  147.054459] Rui: device null, action 0 started
[  147.054463] Rui: device null, action 0 done
[  147.054466] Rui: device mem, action 0 started
[  147.054470] Rui: device mem, action 0 done
[  147.054473] Rui: device 00:0a, action 0 started
[  147.054478] Rui: device 00:0a, action 0 done
[  147.054481] Rui: device 00:09, action 0 started
[  147.054485] Rui: device 00:09, action 0 done
[  147.054488] Rui: device 00:08, action 0 started
[  147.054518] Rui: device 00:08, action 0 done
[  147.054522] Rui: device 00:07, action 0 started
[  147.054539] Rui: device 00:07, action 0 done
[  147.054542] Rui: device 00:06, action 0 started
[  147.054546] Rui: device 00:06, action 0 done
[  147.054549] Rui: device 00:05, action 0 started
[  147.054553] Rui: device 00:05, action 0 done
[  147.054557] Rui: device 00:04, action 0 started
[  147.054560] Rui: device 00:04, action 0 done
[  147.054564] Rui: device 00:03, action 0 started
[  147.054585] Rui: device 00:03, action 0 done
[  147.054589] Rui: device 00:02, action 0 started
[  147.054593] Rui: device 00:02, action 0 done
[  147.054596] Rui: device 00:01, action 0 started
[  147.054612] Rui: device 00:01, action 0 done
[  147.054616] Rui: device 00:00, action 0 started
[  147.054620] Rui: device 00:00, action 0 done
[  147.054623] Rui: device pnp0, action 0 started
[  147.054627] Rui: device pnp0, action 0 done
[  147.054631] Rui: device rfkill, action 0 started
[  147.054635] Rui: device rfkill, action 0 done
[  147.054639] Rui: device lo, action 0 started
[  147.054642] Rui: device lo, action 0 done
[  147.054646] Rui: device 0000:0b, action 0 started
[  147.054650] Rui: device 0000:0b, action 0 done
[  147.054653] Rui: device 0000:0c, action 0 started
[  147.054657] Rui: device 0000:0c, action 0 done
[  147.054660] Rui: device 0000:0b:04.4, action 0 started
[  147.054666] Rui: device 0000:0b:04.4, action 0 done
[  147.054670] Rui: device 0000:0b:04.2, action 0 started
[  147.056617] mmc0: Reset 0x1 never completed.
[  147.056617] sdhci: ============== REGISTER DUMP ==============
[  147.056617] sdhci: Sys addr: 0x00000000 | Version:  0x00000400
[  147.056617] sdhci: Blk size: 0x00000000 | Blk cnt:  0x00000000
[  147.056617] sdhci: Argument: 0x00000000 | Trn mode: 0x00000000
[  147.056617] sdhci: Present:  0x00020000 | Host ctl: 0x00000000
[  147.056617] sdhci: Power:    0x00000000 | Blk gap:  0x00000000
[  147.056617] sdhci: Wake-up:  0x00000000 | Clock:    0x00004007
[  147.056617] sdhci: Timeout:  0x00000000 | Int stat: 0x00000000
[  147.056617] sdhci: Int enab: 0x00000000 | Sig enab: 0x00000000
[  147.056617] sdhci: AC12 err: 0x00000000 | Slot int: 0x00000000
[  147.056617] sdhci: Caps:     0x01c021a1 | Max curr: 0x00000040
[  147.056617] sdhci: ===========================================
[  147.154202] ACPI handle has no context!
[  147.154212] sdhci-pci 0000:0b:04.2: PME# disabled
[  147.154223] sdhci-pci 0000:0b:04.2: PCI INT C disabled
[  147.154233] ACPI handle has no context!
[  147.168081] Rui: device 0000:0b:04.2, action 0 done
[  147.168086] Rui: device 0000:0b:04.1, action 0 started
[  147.173146] ACPI handle has no context!
[  147.188093] Rui: device 0000:0b:04.1, action 0 done
[  147.188098] Rui: device 0000:0b:04.0, action 0 started
[  147.188201] Rui: device 0000:0b:04.0, action 0 done
[  147.188204] Rui: device 0000:08, action 0 started
[  147.188208] Rui: device 0000:08, action 0 done
[  147.188212] Rui: device 0000:06, action 0 started
[  147.188215] Rui: device 0000:06, action 0 done
[  147.188219] Rui: device 0000:06:00.0, action 0 started
[  147.204095] Rui: device 0000:06:00.0, action 0 done
[  147.204099] Rui: device 0000:02, action 0 started
[  147.204103] Rui: device 0000:02, action 0 done
[  147.204106] Rui: device 0000:01, action 0 started
[  147.204110] Rui: device 0000:01, action 0 done
[  147.204114] Rui: device 0000:01:00.0, action 0 started
[  147.204118] Rui: device 0000:01:00.0, action 0 done
[  147.204122] Rui: device 0000:00:1f.3, action 0 started
[  147.204126] Rui: device 0000:00:1f.3, action 0 done
[  147.204129] Rui: device 0000:00:1f.2, action 0 started
[  147.284078] Rui: device 0000:00:1f.2, action 0 done
[  147.284083] Rui: device 0000:00:1f.0, action 0 started
[  147.284087] Rui: device 0000:00:1f.0, action 0 done
[  147.284091] Rui: device 0000:00:1e.0, action 0 started
[  147.284095] Rui: device 0000:00:1e.0, action 0 done
[  147.284099] Rui: device 0000:00:1d.7, action 0 started
[  147.284111] ehci_hcd 0000:00:1d.7: PCI INT A disabled
[  147.284115] Rui: device 0000:00:1d.7, action 0 done
[  147.284118] Rui: device 0000:00:1d.2, action 0 started
[  147.284130] uhci_hcd 0000:00:1d.2: PCI INT C disabled
[  147.284133] Rui: device 0000:00:1d.2, action 0 done
[  147.284137] Rui: device 0000:00:1d.1, action 0 started
[  147.284148] uhci_hcd 0000:00:1d.1: PCI INT B disabled
[  147.284151] Rui: device 0000:00:1d.1, action 0 done
[  147.284156] Rui: device 0000:00:1d.0, action 0 started
[  147.284166] uhci_hcd 0000:00:1d.0: PCI INT A disabled
[  147.284170] Rui: device 0000:00:1d.0, action 0 done
[  147.284174] Rui: device 0000:00:1c.3, action 0 started
[  147.284180] Rui: device 0000:00:1c.3, action 0 done
[  147.284184] Rui: device 0000:00:1c.1, action 0 started
[  147.284190] Rui: device 0000:00:1c.1, action 0 done
[  147.284194] Rui: device 0000:00:1c.0, action 0 started
[  147.284200] Rui: device 0000:00:1c.0, action 0 done
[  147.284204] Rui: device 0000:00:1b.0, action 0 started
[  147.316097] HDA Intel 0000:00:1b.0: PCI INT A disabled
[  147.316169] ACPI handle has no context!
[  147.332091] Rui: device 0000:00:1b.0, action 0 done
[  147.332096] Rui: device 0000:00:1a.7, action 0 started
[  147.332107] ehci_hcd 0000:00:1a.7: PCI INT C disabled
[  147.332111] Rui: device 0000:00:1a.7, action 0 done
[  147.332115] Rui: device 0000:00:1a.2, action 0 started
[  147.332125] uhci_hcd 0000:00:1a.2: PCI INT C disabled
[  147.332129] Rui: device 0000:00:1a.2, action 0 done
[  147.332133] Rui: device 0000:00:1a.1, action 0 started
[  147.332143] uhci_hcd 0000:00:1a.1: PCI INT B disabled
[  147.332147] Rui: device 0000:00:1a.1, action 0 done
[  147.332151] Rui: device 0000:00:1a.0, action 0 started
[  147.332161] uhci_hcd 0000:00:1a.0: PCI INT A disabled
[  147.332165] Rui: device 0000:00:1a.0, action 0 done
[  147.332169] Rui: device 0000:00:19.0, action 0 started
[  147.390608] e1000e 0000:00:19.0: PCI INT A disabled
[  147.390620] e1000e 0000:00:19.0: PME# enabled
[  147.390784] e1000e 0000:00:19.0: wake-up capability enabled by ACPI
[  147.404081] Rui: device 0000:00:19.0, action 0 done
[  147.404086] Rui: device 0000:00:02.0, action 0 started
[  147.404090] Rui: device 0000:00:02.0, action 0 done
[  147.404094] Rui: device 0000:00:01.0, action 0 started
[  147.404101] Rui: device 0000:00:01.0, action 0 done
[  147.404104] Rui: device 0000:00:00.0, action 0 started
[  147.404109] Rui: device 0000:00:00.0, action 0 done
[  147.404113] Rui: device 0000:00, action 0 started
[  147.404117] Rui: device 0000:00, action 0 done
[  147.404121] Rui: device pci0000:00, action 0 started
[  147.404124] Rui: device pci0000:00, action 0 done
[  147.404129] Rui: device dock.0, action 0 started
[  147.404133] Rui: device dock.0, action 0 done
[  147.404137] Rui: device LNXTHERM:01, action 0 started
[  147.404141] Rui: device LNXTHERM:01, action 0 done
[  147.404145] Rui: device LNXTHERM:00, action 0 started
[  147.404149] Rui: device LNXTHERM:00, action 0 done
[  147.404153] Rui: device LNXPOWER:01, action 0 started
[  147.404156] Rui: device LNXPOWER:01, action 0 done
[  147.404160] Rui: device LNXPOWER:00, action 0 started
[  147.404164] Rui: device LNXPOWER:00, action 0 done
[  147.404168] Rui: device pnp0c14:00, action 0 started
[  147.404172] Rui: device pnp0c14:00, action 0 done
[  147.404176] Rui: device device:3e, action 0 started
[  147.404180] Rui: device device:3e, action 0 done
[  147.404184] Rui: device device:3d, action 0 started
[  147.404188] Rui: device device:3d, action 0 done
[  147.404192] Rui: device device:3c, action 0 started
[  147.404196] Rui: device device:3c, action 0 done
[  147.404200] Rui: device device:3b, action 0 started
[  147.404204] Rui: device device:3b, action 0 done
[  147.404208] Rui: device device:3a, action 0 started
[  147.404211] Rui: device device:3a, action 0 done
[  147.404216] Rui: device device:39, action 0 started
[  147.404220] Rui: device device:39, action 0 done
[  147.404223] Rui: device device:38, action 0 started
[  147.404227] Rui: device device:38, action 0 done
[  147.404231] Rui: device device:37, action 0 started
[  147.404234] Rui: device device:37, action 0 done
[  147.404239] Rui: device device:36, action 0 started
[  147.404242] Rui: device device:36, action 0 done
[  147.404246] Rui: device device:35, action 0 started
[  147.404250] Rui: device device:35, action 0 done
[  147.404254] Rui: device device:34, action 0 started
[  147.404258] Rui: device device:34, action 0 done
[  147.404262] Rui: device device:33, action 0 started
[  147.404266] Rui: device device:33, action 0 done
[  147.404270] Rui: device device:32, action 0 started
[  147.404273] Rui: device device:32, action 0 done
[  147.404277] Rui: device device:31, action 0 started
[  147.404281] Rui: device device:31, action 0 done
[  147.404285] Rui: device device:30, action 0 started
[  147.404288] Rui: device device:30, action 0 done
[  147.404292] Rui: device device:2f, action 0 started
[  147.404296] Rui: device device:2f, action 0 done
[  147.404300] Rui: device device:2e, action 0 started
[  147.404303] Rui: device device:2e, action 0 done
[  147.404307] Rui: device device:2d, action 0 started
[  147.404311] Rui: device device:2d, action 0 done
[  147.404315] Rui: device device:2c, action 0 started
[  147.404318] Rui: device device:2c, action 0 done
[  147.404322] Rui: device device:2b, action 0 started
[  147.404326] Rui: device device:2b, action 0 done
[  147.404330] Rui: device device:2a, action 0 started
[  147.404334] Rui: device device:2a, action 0 done
[  147.404338] Rui: device device:29, action 0 started
[  147.404341] Rui: device device:29, action 0 done
[  147.404345] Rui: device device:28, action 0 started
[  147.404349] Rui: device device:28, action 0 done
[  147.404353] Rui: device device:27, action 0 started
[  147.404356] Rui: device device:27, action 0 done
[  147.404360] Rui: device device:26, action 0 started
[  147.404364] Rui: device device:26, action 0 done
[  147.404368] Rui: device device:25, action 0 started
[  147.404371] Rui: device device:25, action 0 done
[  147.404375] Rui: device device:24, action 0 started
[  147.404379] Rui: device device:24, action 0 done
[  147.404383] Rui: device device:23, action 0 started
[  147.404387] Rui: device device:23, action 0 done
[  147.404391] Rui: device device:22, action 0 started
[  147.404395] Rui: device device:22, action 0 done
[  147.404399] Rui: device device:21, action 0 started
[  147.404403] Rui: device device:21, action 0 done
[  147.404407] Rui: device device:20, action 0 started
[  147.404411] Rui: device device:20, action 0 done
[  147.404415] Rui: device device:1f, action 0 started
[  147.404418] Rui: device device:1f, action 0 done
[  147.404422] Rui: device device:1e, action 0 started
[  147.404426] Rui: device device:1e, action 0 done
[  147.404430] Rui: device device:1d, action 0 started
[  147.404434] Rui: device device:1d, action 0 done
[  147.404438] Rui: device device:1c, action 0 started
[  147.404441] Rui: device device:1c, action 0 done
[  147.404445] Rui: device device:1b, action 0 started
[  147.404449] Rui: device device:1b, action 0 done
[  147.404453] Rui: device device:1a, action 0 started
[  147.404456] Rui: device device:1a, action 0 done
[  147.404460] Rui: device device:19, action 0 started
[  147.404464] Rui: device device:19, action 0 done
[  147.404468] Rui: device device:18, action 0 started
[  147.404472] Rui: device device:18, action 0 done
[  147.404476] Rui: device device:17, action 0 started
[  147.404480] Rui: device device:17, action 0 done
[  147.404484] Rui: device device:16, action 0 started
[  147.404488] Rui: device device:16, action 0 done
[  147.404492] Rui: device device:15, action 0 started
[  147.404495] Rui: device device:15, action 0 done
[  147.404499] Rui: device device:14, action 0 started
[  147.404514] Rui: device device:14, action 0 done
[  147.404518] Rui: device device:13, action 0 started
[  147.404522] Rui: device device:13, action 0 done
[  147.404526] Rui: device device:12, action 0 started
[  147.404530] Rui: device device:12, action 0 done
[  147.404534] Rui: device device:11, action 0 started
[  147.404537] Rui: device device:11, action 0 done
[  147.404541] Rui: device device:10, action 0 started
[  147.404545] Rui: device device:10, action 0 done
[  147.404549] Rui: device SNY5001:00, action 0 started
[  147.404553] Rui: device SNY5001:00, action 0 done
[  147.404557] Rui: device IFX0102:00, action 0 started
[  147.404561] Rui: device IFX0102:00, action 0 done
[  147.404565] Rui: device SNY6001:00, action 0 started
[  147.404575] Rui: device SNY6001:00, action 0 done
[  147.404579] Rui: device PNP0C09:00, action 0 started
[  147.404590] Rui: device PNP0C09:00, action 0 done
[  147.404594] Rui: device SNY9001:00, action 0 started
[  147.404598] Rui: device SNY9001:00, action 0 done
[  147.404602] Rui: device PNP0303:00, action 0 started
[  147.404606] Rui: device PNP0303:00, action 0 done
[  147.404610] Rui: device INT0800:00, action 0 started
[  147.404614] Rui: device INT0800:00, action 0 done
[  147.404618] Rui: device PNP0100:00, action 0 started
[  147.404621] Rui: device PNP0100:00, action 0 done
[  147.404625] Rui: device PNP0C04:00, action 0 started
[  147.404629] Rui: device PNP0C04:00, action 0 done
[  147.404633] Rui: device PNP0000:00, action 0 started
[  147.404637] Rui: device PNP0000:00, action 0 done
[  147.404641] Rui: device PNP0103:00, action 0 started
[  147.404645] Rui: device PNP0103:00, action 0 done
[  147.404649] Rui: device PNP0B00:00, action 0 started
[  147.404652] Rui: device PNP0B00:00, action 0 done
[  147.404656] Rui: device PNP0200:00, action 0 started
[  147.404660] Rui: device PNP0200:00, action 0 done
[  147.404664] Rui: device PNP0C02:00, action 0 started
[  147.404668] Rui: device PNP0C02:00, action 0 done
[  147.404672] Rui: device PNP0C0F:07, action 0 started
[  147.404676] Rui: device PNP0C0F:07, action 0 done
[  147.404680] Rui: device PNP0C0F:06, action 0 started
[  147.404683] Rui: device PNP0C0F:06, action 0 done
[  147.404687] Rui: device PNP0C0F:05, action 0 started
[  147.404691] Rui: device PNP0C0F:05, action 0 done
[  147.404695] Rui: device PNP0C0F:04, action 0 started
[  147.404699] Rui: device PNP0C0F:04, action 0 done
[  147.404703] Rui: device PNP0C0F:03, action 0 started
[  147.404707] Rui: device PNP0C0F:03, action 0 done
[  147.404711] Rui: device PNP0C0F:02, action 0 started
[  147.404715] Rui: device PNP0C0F:02, action 0 done
[  147.404719] Rui: device PNP0C0F:01, action 0 started
[  147.404722] Rui: device PNP0C0F:01, action 0 done
[  147.404726] Rui: device PNP0C0F:00, action 0 started
[  147.404730] Rui: device PNP0C0F:00, action 0 done
[  147.404734] Rui: device device:0f, action 0 started
[  147.404738] Rui: device device:0f, action 0 done
[  147.404742] Rui: device device:0e, action 0 started
[  147.404746] Rui: device device:0e, action 0 done
[  147.404750] Rui: device device:0d, action 0 started
[  147.404753] Rui: device device:0d, action 0 done
[  147.404757] Rui: device device:0c, action 0 started
[  147.404761] Rui: device device:0c, action 0 done
[  147.404765] Rui: device device:0b, action 0 started
[  147.404769] Rui: device device:0b, action 0 done
[  147.404773] Rui: device device:0a, action 0 started
[  147.404777] Rui: device device:0a, action 0 done
[  147.404781] Rui: device device:09, action 0 started
[  147.404784] Rui: device device:09, action 0 done
[  147.404788] Rui: device device:08, action 0 started
[  147.404792] Rui: device device:08, action 0 done
[  147.404796] Rui: device device:07, action 0 started
[  147.404800] Rui: device device:07, action 0 done
[  147.404804] Rui: device device:06, action 0 started
[  147.404808] Rui: device device:06, action 0 done
[  147.404812] Rui: device device:05, action 0 started
[  147.404816] Rui: device device:05, action 0 done
[  147.404820] Rui: device device:04, action 0 started
[  147.404823] Rui: device device:04, action 0 done
[  147.404828] Rui: device device:03, action 0 started
[  147.404831] Rui: device device:03, action 0 done
[  147.404835] Rui: device device:02, action 0 started
[  147.404839] Rui: device device:02, action 0 done
[  147.404843] Rui: device device:01, action 0 started
[  147.404846] Rui: device device:01, action 0 done
[  147.404850] Rui: device PNP0A08:00, action 0 started
[  147.404854] Rui: device PNP0A08:00, action 0 done
[  147.404859] Rui: device ACPI0003:00, action 0 started
[  147.404863] Rui: device ACPI0003:00, action 0 done
[  147.404867] Rui: device PNP0C0A:00, action 0 started
[  147.404871] Rui: device PNP0C0A:00, action 0 done
[  147.404875] Rui: device PNP0C0D:00, action 0 started
[  147.404879] Rui: device PNP0C0D:00, action 0 done
[  147.404883] Rui: device PNP0C0C:00, action 0 started
[  147.404886] Rui: device PNP0C0C:00, action 0 done
[  147.404890] Rui: device device:00, action 0 started
[  147.404894] Rui: device device:00, action 0 done
[  147.404898] Rui: device LNXCPU:03, action 0 started
[  147.404905] Rui: device LNXCPU:03, action 0 done
[  147.404909] Rui: device LNXCPU:02, action 0 started
[  147.404913] Rui: device LNXCPU:02, action 0 done
[  147.404917] Rui: device LNXCPU:01, action 0 started
[  147.404921] Rui: device LNXCPU:01, action 0 done
[  147.404925] Rui: device LNXCPU:00, action 0 started
[  147.404928] Rui: device LNXCPU:00, action 0 done
[  147.404932] Rui: device LNXSYSTM:00, action 0 started
[  147.404936] Rui: device LNXSYSTM:00, action 0 done
[  147.404940] Rui: device default, action 0 started
[  147.404944] Rui: device default, action 0 done
[  147.404948] Rui: device id, action 0 started
[  147.404952] Rui: device id, action 0 done
[  147.404955] Rui: device vtcon0, action 0 started
[  147.404959] Rui: device vtcon0, action 0 done
[  147.404963] Rui: device platform, action 0 started
[  147.404967] Rui: device platform, action 0 done
[  147.404970] Rui: before async synchronization
[  147.404973] Rui: after async synchronization
[  147.405694] ehci_hcd 0000:00:1d.7: PME# disabled
[  147.420444] ehci_hcd 0000:00:1a.7: PME# disabled
[  147.437361] ACPI: Preparing to enter system sleep state S3
[  147.771792] Disabling non-boot CPUs ...
[  147.774130] CPU 1 is now offline
[  147.774134] SMP alternatives: switching to UP code
[  147.788298] CPU0 attaching NULL sched-domain.
[  147.788301] CPU1 attaching NULL sched-domain.
[  147.788306] CPU0 attaching NULL sched-domain.
[  147.788430] CPU1 is down
[  147.788467] Extended CMOS year: 2000
[  147.788467] Back to C!
[  147.788467] Extended CMOS year: 2000
[  147.788467] Enabling non-boot CPUs ...
[  147.788467] SMP alternatives: switching to SMP code
[  147.793942] Booting processor 1 APIC 0x1 ip 0x6000
[  147.788194] Initializing CPU#1
[  147.788194] Calibrating delay using timer specific routine.. 4794.11 BogoMIPS (lpj=9588226)
[  147.788194] CPU: L1 I cache: 32K, L1 D cache: 32K
[  147.788194] CPU: L2 cache: 3072K
[  147.788194] CPU: Physical Processor ID: 0
[  147.788194] CPU: Processor Core ID: 1
[  147.888137] CPU1: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz stepping 06
[  147.888199] CPU0 attaching NULL sched-domain.
[  147.892016] Switched to high resolution mode on CPU 1
[  147.904012] CPU0 attaching sched-domain:
[  147.904015]  domain 0: span 0-1 level MC
[  147.904017]   groups: 0 1
[  147.904020] CPU1 attaching sched-domain:
[  147.904021]  domain 0: span 0-1 level MC
[  147.904023]   groups: 1 0
[  147.904512] CPU1 is up
[  147.904514] ACPI: Waking up from system sleep state S3
[  148.489185] pcieport-driver 0000:00:01.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100407)
[  148.489207] pci 0000:00:02.0: restoring config space at offset 0x6 (was 0xc, writing 0xd000000c)
[  148.489211] pci 0000:00:02.0: restoring config space at offset 0x1 (was 0x900007, writing 0x900403)
[  148.489234] e1000e 0000:00:19.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[  148.489247] e1000e 0000:00:19.0: restoring config space at offset 0x6 (was 0x1, writing 0x8101)
[  148.489251] e1000e 0000:00:19.0: restoring config space at offset 0x5 (was 0x0, writing 0xee924000)
[  148.489256] e1000e 0000:00:19.0: restoring config space at offset 0x4 (was 0x0, writing 0xee900000)
[  148.489262] e1000e 0000:00:19.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  148.489301] uhci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  148.489336] uhci_hcd 0000:00:1a.1: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  148.489370] uhci_hcd 0000:00:1a.2: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  148.489413] ehci_hcd 0000:00:1a.7: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[  148.489431] ehci_hcd 0000:00:1a.7: PME# disabled
[  148.489461] HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[  148.489466] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100006, writing 0x100002)
[  148.489491] pcieport-driver 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[  148.489501] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0xe971e881)
[  148.489505] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0xee80ed90)
[  148.489509] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20000000, writing 0x6060)
[  148.489513] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x6 (was 0x0, writing 0x50200)
[  148.489522] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  148.489560] pcieport-driver 0000:00:1c.1: restoring config space at offset 0xf (was 0x200, writing 0x20a)
[  148.489570] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0xea71e981)
[  148.489574] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0xed80ec80)
[  148.489578] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x7 (was 0x20000000, writing 0x5050)
[  148.489582] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x6 (was 0x0, writing 0x60600)
[  148.489591] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  148.489629] pcieport-driver 0000:00:1c.3: restoring config space at offset 0xf (was 0x400, writing 0x40a)
[  148.489639] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x9 (was 0x10001, writing 0xeb71ea81)
[  148.489643] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x8 (was 0x0, writing 0xec70eb80)
[  148.489647] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x7 (was 0x20000000, writing 0x4040)
[  148.489652] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x6 (was 0x0, writing 0x80800)
[  148.489660] pcieport-driver 0000:00:1c.3: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[  148.489711] uhci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  148.489745] uhci_hcd 0000:00:1d.1: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  148.489779] uhci_hcd 0000:00:1d.2: restoring config space at offset 0x1 (was 0x2900005, writing 0x2900001)
[  148.489821] ehci_hcd 0000:00:1d.7: restoring config space at offset 0x1 (was 0x2900006, writing 0x2900002)
[  148.489839] ehci_hcd 0000:00:1d.7: PME# disabled
[  148.489854] pci 0000:00:1e.0: restoring config space at offset 0x9 (was 0x10001, writing 0xe1f1e001)
[  148.489858] pci 0000:00:1e.0: restoring config space at offset 0x8 (was 0x0, writing 0xe800e600)
[  148.489862] pci 0000:00:1e.0: restoring config space at offset 0x7 (was 0x22800000, writing 0x22803030)
[  148.489866] pci 0000:00:1e.0: restoring config space at offset 0x6 (was 0x200c0b00, writing 0x200f0b00)
[  148.489875] pci 0000:00:1e.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[  148.489951] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00007, writing 0x2b00407)
[  148.490028] pci 0000:01:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[  148.490039] pci 0000:01:00.0: restoring config space at offset 0xc (was 0x0, writing 0xfffe0000)
[  148.490051] pci 0000:01:00.0: restoring config space at offset 0x9 (was 0x1, writing 0x7001)
[  148.490062] pci 0000:01:00.0: restoring config space at offset 0x7 (was 0x4, writing 0xe2000004)
[  148.490072] pci 0000:01:00.0: restoring config space at offset 0x5 (was 0xc, writing 0xc000000c)
[  148.490082] pci 0000:01:00.0: restoring config space at offset 0x4 (was 0x0, writing 0xe4000000)
[  148.490154] iwlagn 0000:06:00.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[  148.490189] iwlagn 0000:06:00.0: restoring config space at offset 0x4 (was 0x4, writing 0xec800004)
[  148.490204] iwlagn 0000:06:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
[  148.490278] yenta_cardbus 0000:0b:04.0: restoring config space at offset 0xf (was 0x7000100, writing 0x580010a)
[  148.490283] yenta_cardbus 0000:0b:04.0: restoring config space at offset 0xe (was 0x0, writing 0x34fc)
[  148.490287] yenta_cardbus 0000:0b:04.0: restoring config space at offset 0xd (was 0x0, writing 0x3400)
[  148.490292] yenta_cardbus 0000:0b:04.0: restoring config space at offset 0xc (was 0x0, writing 0x30fc)
[  148.490297] yenta_cardbus 0000:0b:04.0: restoring config space at offset 0xb (was 0x0, writing 0x3000)
[  148.490302] yenta_cardbus 0000:0b:04.0: restoring config space at offset 0xa (was 0x0, writing 0xf7fff000)
[  148.490306] yenta_cardbus 0000:0b:04.0: restoring config space at offset 0x9 (was 0x0, writing 0xf4000000)
[  148.490311] yenta_cardbus 0000:0b:04.0: restoring config space at offset 0x8 (was 0x0, writing 0xf3fff000)
[  148.490316] yenta_cardbus 0000:0b:04.0: restoring config space at offset 0x7 (was 0x0, writing 0xf0000000)
[  148.490321] yenta_cardbus 0000:0b:04.0: restoring config space at offset 0x6 (was 0x0, writing 0xb00f0c0b)
[  148.490328] yenta_cardbus 0000:0b:04.0: restoring config space at offset 0x4 (was 0x0, writing 0xe8000000)
[  148.490332] yenta_cardbus 0000:0b:04.0: restoring config space at offset 0x3 (was 0x820000, writing 0x82a800)
[  148.490339] yenta_cardbus 0000:0b:04.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100007)
[  148.490361] ohci1394 0000:0b:04.1: restoring config space at offset 0xf (was 0x4020200, writing 0x402020a)
[  148.490381] ohci1394 0000:0b:04.1: restoring config space at offset 0x4 (was 0x0, writing 0xe8001000)
[  148.490386] ohci1394 0000:0b:04.1: restoring config space at offset 0x3 (was 0x800000, writing 0x804000)
[  148.490393] ohci1394 0000:0b:04.1: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
[  148.490414] sdhci-pci 0000:0b:04.2: restoring config space at offset 0xf (was 0x300, writing 0x30a)
[  148.490434] sdhci-pci 0000:0b:04.2: restoring config space at offset 0x4 (was 0x0, writing 0xe8001900)
[  148.490439] sdhci-pci 0000:0b:04.2: restoring config space at offset 0x3 (was 0x800000, writing 0x804000)
[  148.490445] sdhci-pci 0000:0b:04.2: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
[  148.490466] pci 0000:0b:04.4: restoring config space at offset 0xf (was 0x300, writing 0x30a)
[  148.490486] pci 0000:0b:04.4: restoring config space at offset 0x4 (was 0x0, writing 0xe8001800)
[  148.490494] pci 0000:0b:04.4: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
[  148.490556] Rui: device platform, action 1 started
[  148.490557] Rui: device platform, action 1 done
[  148.490559] Rui: device vtcon0, action 1 started
[  148.490560] Rui: device vtcon0, action 1 done
[  148.490561] Rui: device id, action 1 started
[  148.490563] Rui: device id, action 1 done
[  148.490564] Rui: device default, action 1 started
[  148.490565] Rui: device default, action 1 done
[  148.490567] Rui: device LNXSYSTM:00, action 1 started
[  148.490568] Rui: device LNXSYSTM:00, action 1 done
[  148.490569] Rui: device LNXCPU:00, action 1 started
[  148.490573] Rui: device LNXCPU:00, action 1 done
[  148.490574] Rui: device LNXCPU:01, action 1 started
[  148.490575] Rui: device LNXCPU:01, action 1 done
[  148.490577] Rui: device LNXCPU:02, action 1 started
[  148.490578] Rui: device LNXCPU:02, action 1 done
[  148.490579] Rui: device LNXCPU:03, action 1 started
[  148.490581] Rui: device LNXCPU:03, action 1 done
[  148.490582] Rui: device device:00, action 1 started
[  148.490583] Rui: device device:00, action 1 done
[  148.490584] Rui: device PNP0C0C:00, action 1 started
[  148.490586] Rui: device PNP0C0C:00, action 1 done
[  148.490587] Rui: device PNP0C0D:00, action 1 started
[  148.544247] Rui: device PNP0C0D:00, action 1 done
[  148.544252] Rui: device PNP0C0A:00, action 1 started
[  149.440330] Rui: device PNP0C0A:00, action 1 done
[  149.440335] Rui: device ACPI0003:00, action 1 started
[  149.496224] Rui: device ACPI0003:00, action 1 done
[  149.496229] Rui: device PNP0A08:00, action 1 started
[  149.496233] Rui: device PNP0A08:00, action 1 done
[  149.496237] Rui: device device:01, action 1 started
[  149.496242] Rui: device device:01, action 1 done
[  149.496246] Rui: device device:02, action 1 started
[  149.496250] Rui: device device:02, action 1 done
[  149.496254] Rui: device device:03, action 1 started
[  149.496257] Rui: device device:03, action 1 done
[  149.496261] Rui: device device:04, action 1 started
[  149.496265] Rui: device device:04, action 1 done
[  149.496268] Rui: device device:05, action 1 started
[  149.496272] Rui: device device:05, action 1 done
[  149.496276] Rui: device device:06, action 1 started
[  149.496280] Rui: device device:06, action 1 done
[  149.496284] Rui: device device:07, action 1 started
[  149.496287] Rui: device device:07, action 1 done
[  149.496291] Rui: device device:08, action 1 started
[  149.496295] Rui: device device:08, action 1 done
[  149.496299] Rui: device device:09, action 1 started
[  149.496303] Rui: device device:09, action 1 done
[  149.496307] Rui: device device:0a, action 1 started
[  149.496310] Rui: device device:0a, action 1 done
[  149.496314] Rui: device device:0b, action 1 started
[  149.496318] Rui: device device:0b, action 1 done
[  149.496321] Rui: device device:0c, action 1 started
[  149.496325] Rui: device device:0c, action 1 done
[  149.496329] Rui: device device:0d, action 1 started
[  149.496332] Rui: device device:0d, action 1 done
[  149.496336] Rui: device device:0e, action 1 started
[  149.496340] Rui: device device:0e, action 1 done
[  149.496344] Rui: device device:0f, action 1 started
[  149.496347] Rui: device device:0f, action 1 done
[  149.496351] Rui: device PNP0C0F:00, action 1 started
[  149.496355] Rui: device PNP0C0F:00, action 1 done
[  149.496359] Rui: device PNP0C0F:01, action 1 started
[  149.496363] Rui: device PNP0C0F:01, action 1 done
[  149.496367] Rui: device PNP0C0F:02, action 1 started
[  149.496370] Rui: device PNP0C0F:02, action 1 done
[  149.496374] Rui: device PNP0C0F:03, action 1 started
[  149.496378] Rui: device PNP0C0F:03, action 1 done
[  149.496382] Rui: device PNP0C0F:04, action 1 started
[  149.496385] Rui: device PNP0C0F:04, action 1 done
[  149.496389] Rui: device PNP0C0F:05, action 1 started
[  149.496393] Rui: device PNP0C0F:05, action 1 done
[  149.496397] Rui: device PNP0C0F:06, action 1 started
[  149.496400] Rui: device PNP0C0F:06, action 1 done
[  149.496404] Rui: device PNP0C0F:07, action 1 started
[  149.496408] Rui: device PNP0C0F:07, action 1 done
[  149.496412] Rui: device PNP0C02:00, action 1 started
[  149.496416] Rui: device PNP0C02:00, action 1 done
[  149.496419] Rui: device PNP0200:00, action 1 started
[  149.496423] Rui: device PNP0200:00, action 1 done
[  149.496427] Rui: device PNP0B00:00, action 1 started
[  149.496431] Rui: device PNP0B00:00, action 1 done
[  149.496434] Rui: device PNP0103:00, action 1 started
[  149.496438] Rui: device PNP0103:00, action 1 done
[  149.496442] Rui: device PNP0000:00, action 1 started
[  149.496446] Rui: device PNP0000:00, action 1 done
[  149.496450] Rui: device PNP0C04:00, action 1 started
[  149.496453] Rui: device PNP0C04:00, action 1 done
[  149.496457] Rui: device PNP0100:00, action 1 started
[  149.496461] Rui: device PNP0100:00, action 1 done
[  149.496465] Rui: device INT0800:00, action 1 started
[  149.496468] Rui: device INT0800:00, action 1 done
[  149.496472] Rui: device PNP0303:00, action 1 started
[  149.496476] Rui: device PNP0303:00, action 1 done
[  149.496480] Rui: device SNY9001:00, action 1 started
[  149.496483] Rui: device SNY9001:00, action 1 done
[  149.496487] Rui: device PNP0C09:00, action 1 started
[  149.496497] Rui: device PNP0C09:00, action 1 done
[  149.496501] Rui: device SNY6001:00, action 1 started
[  149.500052] Rui: device SNY6001:00, action 1 done
[  149.500057] Rui: device IFX0102:00, action 1 started
[  149.500062] Rui: device IFX0102:00, action 1 done
[  149.500066] Rui: device SNY5001:00, action 1 started
[  149.516391] Rui: device SNY5001:00, action 1 done
[  149.516396] Rui: device device:10, action 1 started
[  149.516400] Rui: device device:10, action 1 done
[  149.516404] Rui: device device:11, action 1 started
[  149.516408] Rui: device device:11, action 1 done
[  149.516411] Rui: device device:12, action 1 started
[  149.516415] Rui: device device:12, action 1 done
[  149.516419] Rui: device device:13, action 1 started
[  149.516423] Rui: device device:13, action 1 done
[  149.516427] Rui: device device:14, action 1 started
[  149.516430] Rui: device device:14, action 1 done
[  149.516434] Rui: device device:15, action 1 started
[  149.516438] Rui: device device:15, action 1 done
[  149.516442] Rui: device device:16, action 1 started
[  149.516445] Rui: device device:16, action 1 done
[  149.516449] Rui: device device:17, action 1 started
[  149.516453] Rui: device device:17, action 1 done
[  149.516457] Rui: device device:18, action 1 started
[  149.516460] Rui: device device:18, action 1 done
[  149.516464] Rui: device device:19, action 1 started
[  149.516468] Rui: device device:19, action 1 done
[  149.516471] Rui: device device:1a, action 1 started
[  149.516475] Rui: device device:1a, action 1 done
[  149.516479] Rui: device device:1b, action 1 started
[  149.516482] Rui: device device:1b, action 1 done
[  149.516486] Rui: device device:1c, action 1 started
[  149.516490] Rui: device device:1c, action 1 done
[  149.516494] Rui: device device:1d, action 1 started
[  149.516497] Rui: device device:1d, action 1 done
[  149.516501] Rui: device device:1e, action 1 started
[  149.516509] Rui: device device:1e, action 1 done
[  149.516513] Rui: device device:1f, action 1 started
[  149.516516] Rui: device device:1f, action 1 done
[  149.516520] Rui: device device:20, action 1 started
[  149.516524] Rui: device device:20, action 1 done
[  149.516528] Rui: device device:21, action 1 started
[  149.516531] Rui: device device:21, action 1 done
[  149.516535] Rui: device device:22, action 1 started
[  149.516539] Rui: device device:22, action 1 done
[  149.516543] Rui: device device:23, action 1 started
[  149.516546] Rui: device device:23, action 1 done
[  149.516550] Rui: device device:24, action 1 started
[  149.516554] Rui: device device:24, action 1 done
[  149.516558] Rui: device device:25, action 1 started
[  149.516561] Rui: device device:25, action 1 done
[  149.516565] Rui: device device:26, action 1 started
[  149.516569] Rui: device device:26, action 1 done
[  149.516573] Rui: device device:27, action 1 started
[  149.516576] Rui: device device:27, action 1 done
[  149.516580] Rui: device device:28, action 1 started
[  149.516584] Rui: device device:28, action 1 done
[  149.516588] Rui: device device:29, action 1 started
[  149.516591] Rui: device device:29, action 1 done
[  149.516595] Rui: device device:2a, action 1 started
[  149.516599] Rui: device device:2a, action 1 done
[  149.516603] Rui: device device:2b, action 1 started
[  149.516607] Rui: device device:2b, action 1 done
[  149.516610] Rui: device device:2c, action 1 started
[  149.516614] Rui: device device:2c, action 1 done
[  149.516618] Rui: device device:2d, action 1 started
[  149.516622] Rui: device device:2d, action 1 done
[  149.516625] Rui: device device:2e, action 1 started
[  149.516629] Rui: device device:2e, action 1 done
[  149.516633] Rui: device device:2f, action 1 started
[  149.516636] Rui: device device:2f, action 1 done
[  149.516640] Rui: device device:30, action 1 started
[  149.516644] Rui: device device:30, action 1 done
[  149.516648] Rui: device device:31, action 1 started
[  149.516651] Rui: device device:31, action 1 done
[  149.516655] Rui: device device:32, action 1 started
[  149.516659] Rui: device device:32, action 1 done
[  149.516663] Rui: device device:33, action 1 started
[  149.516666] Rui: device device:33, action 1 done
[  149.516670] Rui: device device:34, action 1 started
[  149.516674] Rui: device device:34, action 1 done
[  149.516678] Rui: device device:35, action 1 started
[  149.516681] Rui: device device:35, action 1 done
[  149.516685] Rui: device device:36, action 1 started
[  149.516689] Rui: device device:36, action 1 done
[  149.516693] Rui: device device:37, action 1 started
[  149.516696] Rui: device device:37, action 1 done
[  149.516700] Rui: device device:38, action 1 started
[  149.516704] Rui: device device:38, action 1 done
[  149.516708] Rui: device device:39, action 1 started
[  149.516712] Rui: device device:39, action 1 done
[  149.516716] Rui: device device:3a, action 1 started
[  149.516719] Rui: device device:3a, action 1 done
[  149.516723] Rui: device device:3b, action 1 started
[  149.516727] Rui: device device:3b, action 1 done
[  149.516731] Rui: device device:3c, action 1 started
[  149.516734] Rui: device device:3c, action 1 done
[  149.516738] Rui: device device:3d, action 1 started
[  149.516742] Rui: device device:3d, action 1 done
[  149.516746] Rui: device device:3e, action 1 started
[  149.516749] Rui: device device:3e, action 1 done
[  149.516753] Rui: device pnp0c14:00, action 1 started
[  149.516757] Rui: device pnp0c14:00, action 1 done
[  149.516761] Rui: device LNXPOWER:00, action 1 started
[  149.516865] Rui: device LNXPOWER:00, action 1 done
[  149.516870] Rui: device LNXPOWER:01, action 1 started
[  149.516969] Rui: device LNXPOWER:01, action 1 done
[  149.516973] Rui: device LNXTHERM:00, action 1 started
[  149.516977] Rui: device LNXTHERM:00, action 1 done
[  149.516981] Rui: device LNXTHERM:01, action 1 started
[  149.517923] Rui: device LNXTHERM:01, action 1 done
[  149.517928] Rui: device dock.0, action 1 started
[  149.517932] Rui: device dock.0, action 1 done
[  149.517936] Rui: device pci0000:00, action 1 started
[  149.517939] Rui: device pci0000:00, action 1 done
[  149.517943] Rui: device 0000:00, action 1 started
[  149.517947] Rui: device 0000:00, action 1 done
[  149.517950] Rui: device 0000:00:00.0, action 1 started
[  149.524935] Rui: device 0000:00:00.0, action 1 done
[  149.524942] Rui: device 0000:00:01.0, action 1 started
[  149.524952] Rui: device 0000:00:01.0, action 1 done
[  149.524957] Rui: device 0000:00:02.0, action 1 started
[  149.524971] pci 0000:00:02.0: PME# disabled
[  149.524975] Rui: device 0000:00:02.0, action 1 done
[  149.524979] Rui: device 0000:00:19.0, action 1 started
[  149.525075] e1000e 0000:00:19.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[  149.525081] e1000e 0000:00:19.0: pci_enable_pcie_error_reporting failed 0xfffffffb
[  149.525090] e1000e 0000:00:19.0: setting latency timer to 64
[  149.525099] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[  149.525107] e1000e 0000:00:19.0: PME# disabled
[  149.525113] e1000e 0000:00:19.0: wake-up capability disabled by ACPI
[  149.525120] e1000e 0000:00:19.0: PME# disabled
[  149.525181] e1000e 0000:00:19.0: irq 29 for MSI/MSI-X
[  149.580318] Rui: device 0000:00:19.0, action 1 done
[  149.580330] Rui: device 0000:00:1a.0, action 1 started
[  149.580344] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[  149.580355] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[  149.580386] usb usb3: root hub lost power or was reset
[  149.580424] Rui: device 0000:00:1a.0, action 1 done
[  149.580428] Rui: device 0000:00:1a.1, action 1 started
[  149.580439] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 23 (level, low) -> IRQ 23
[  149.580450] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[  149.580479] usb usb4: root hub lost power or was reset
[  149.580497] Rui: device 0000:00:1a.1, action 1 done
[  149.580501] Rui: device 0000:00:1a.2, action 1 started
[  149.580511] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 23 (level, low) -> IRQ 23
[  149.580522] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[  149.580550] usb usb5: root hub lost power or was reset
[  149.580569] Rui: device 0000:00:1a.2, action 1 done
[  149.580573] Rui: device 0000:00:1a.7, action 1 started
[  149.580584] ehci_hcd 0000:00:1a.7: PME# disabled
[  149.580594] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 23 (level, low) -> IRQ 23
[  149.580604] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[  149.580613] Rui: device 0000:00:1a.7, action 1 done
[  149.580618] Rui: device 0000:00:1b.0, action 1 started
[  149.580690] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[  149.580699] HDA Intel 0000:00:1b.0: setting latency timer to 64
[  149.580726] Rui: device 0000:00:1b.0, action 1 done
[  149.580730] Rui: device 0000:00:1c.0, action 1 started
[  149.580737] Rui: device 0000:00:1c.0, action 1 done
[  149.580741] Rui: device 0000:00:1c.1, action 1 started
[  149.580747] Rui: device 0000:00:1c.1, action 1 done
[  149.580751] Rui: device 0000:00:1c.3, action 1 started
[  149.580757] Rui: device 0000:00:1c.3, action 1 done
[  149.580761] Rui: device 0000:00:1d.0, action 1 started
[  149.580772] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[  149.580783] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[  149.580812] usb usb6: root hub lost power or was reset
[  149.580830] Rui: device 0000:00:1d.0, action 1 done
[  149.580834] Rui: device 0000:00:1d.1, action 1 started
[  149.580845] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 20 (level, low) -> IRQ 20
[  149.580855] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[  149.580884] usb usb7: root hub lost power or was reset
[  149.580902] Rui: device 0000:00:1d.1, action 1 done
[  149.580906] Rui: device 0000:00:1d.2, action 1 started
[  149.580916] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[  149.580926] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[  149.580955] usb usb8: root hub lost power or was reset
[  149.580994] Rui: device 0000:00:1d.2, action 1 done
[  149.580998] Rui: device 0000:00:1d.7, action 1 started
[  149.581008] ehci_hcd 0000:00:1d.7: PME# disabled
[  149.581017] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[  149.581027] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[  149.581036] Rui: device 0000:00:1d.7, action 1 done
[  149.581040] Rui: device 0000:00:1e.0, action 1 started
[  149.581052] pci 0000:00:1e.0: setting latency timer to 64
[  149.581057] Rui: device 0000:00:1e.0, action 1 done
[  149.581061] Rui: device 0000:00:1f.0, action 1 started
[  149.581067] Rui: device 0000:00:1f.0, action 1 done
[  149.581071] Rui: device 0000:00:1f.2, action 1 started
[  149.581169] ahci 0000:00:1f.2: setting latency timer to 64
[  149.581236] Rui: device 0000:00:1f.2, action 1 done
[  149.581321] Rui: device 0000:00:1f.3, action 1 started
[  149.581328] Rui: device 0000:00:1f.3, action 1 done
[  149.581332] Rui: device 0000:01:00.0, action 1 started
[  149.581354] pci 0000:01:00.0: PME# disabled
[  149.581358] Rui: device 0000:01:00.0, action 1 done
[  149.581363] Rui: device 0000:01, action 1 started
[  149.581367] Rui: device 0000:01, action 1 done
[  149.581370] Rui: device 0000:02, action 1 started
[  149.581374] Rui: device 0000:02, action 1 done
[  149.581378] Rui: device 0000:06:00.0, action 1 started
[  149.581634] iwlagn 0000:06:00.0: restoring config space at offset 0x1 (was 0x100406, writing 0x100006)
[  149.581923] Rui: device 0000:06:00.0, action 1 done
[  149.581927] Rui: device 0000:06, action 1 started
[  149.581931] Rui: device 0000:06, action 1 done
[  149.581935] Rui: device 0000:08, action 1 started
[  149.581938] Rui: device 0000:08, action 1 done
[  149.581942] Rui: device 0000:0b:04.0, action 1 started
[  149.720078] Rui: device 0000:0b:04.0, action 1 done
[  149.720082] Rui: device 0000:0b:04.1, action 1 started
[  149.778083] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[21]  MMIO=[e8001000-e80017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
[  149.784098] Rui: device 0000:0b:04.1, action 1 done
[  149.784117] Rui: device 0000:0b:04.2, action 1 started
[  149.784180] sdhci-pci 0000:0b:04.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[  149.784186] sdhci-pci 0000:0b:04.2: Will use DMA mode even though HW doesn't fully claim to support it.
[  149.785201] Rui: device 0000:0b:04.2, action 1 done
[  149.785202] Rui: device 0000:0b:04.4, action 1 started
[  149.785207] pci 0000:0b:04.4: PME# disabled
[  149.785208] Rui: device 0000:0b:04.4, action 1 done
[  149.785209] Rui: device 0000:0c, action 1 started
[  149.785211] Rui: device 0000:0c, action 1 done
[  149.785212] Rui: device 0000:0b, action 1 started
[  149.785213] Rui: device 0000:0b, action 1 done
[  149.785215] Rui: device lo, action 1 started
[  149.785216] Rui: device lo, action 1 done
[  149.785217] Rui: device rfkill, action 1 started
[  149.785219] Rui: device rfkill, action 1 done
[  149.785220] Rui: device pnp0, action 1 started
[  149.785221] Rui: device pnp0, action 1 done
[  149.785222] Rui: device 00:00, action 1 started
[  149.785224] Rui: device 00:00, action 1 done
[  149.785225] Rui: device 00:01, action 1 started
[  149.785228] Rui: device 00:01, action 1 done
[  149.785229] Rui: device 00:02, action 1 started
[  149.785230] Rui: device 00:02, action 1 done
[  149.785231] Rui: device 00:03, action 1 started
[  149.785234] Rui: device 00:03, action 1 done
[  149.785235] Rui: device 00:04, action 1 started
[  149.785236] Rui: device 00:04, action 1 done
[  149.785237] Rui: device 00:05, action 1 started
[  149.785239] Rui: device 00:05, action 1 done
[  149.785240] Rui: device 00:06, action 1 started
[  149.785241] Rui: device 00:06, action 1 done
[  149.785243] Rui: device 00:07, action 1 started
[  149.785244] Rui: device 00:07, action 1 done
[  149.785246] Rui: device 00:08, action 1 started
[  149.785247] Rui: device 00:08, action 1 done
[  149.785249] Rui: device 00:09, action 1 started
[  149.785250] Rui: device 00:09, action 1 done
[  149.785251] Rui: device 00:0a, action 1 started
[  149.785252] Rui: device 00:0a, action 1 done
[  149.785254] Rui: device mem, action 1 started
[  149.785255] Rui: device mem, action 1 done
[  149.785256] Rui: device null, action 1 started
[  149.785258] Rui: device null, action 1 done
[  149.785259] Rui: device port, action 1 started
[  149.785260] Rui: device port, action 1 done
[  149.785261] Rui: device zero, action 1 started
[  149.785262] Rui: device zero, action 1 done
[  149.785264] Rui: device full, action 1 started
[  149.785265] Rui: device full, action 1 done
[  149.785266] Rui: device random, action 1 started
[  149.785267] Rui: device random, action 1 done
[  149.785269] Rui: device urandom, action 1 started
[  149.785270] Rui: device urandom, action 1 done
[  149.785271] Rui: device kmsg, action 1 started
[  149.785272] Rui: device kmsg, action 1 done
[  149.785274] Rui: device pcspkr, action 1 started
[  149.785276] Rui: device pcspkr, action 1 done
[  149.785277] Rui: device snapshot, action 1 started
[  149.785278] Rui: device snapshot, action 1 done
[  149.785280] Rui: device ecryptfs, action 1 started
[  149.785281] Rui: device ecryptfs, action 1 done
[  149.785282] Rui: device fuse, action 1 started
[  149.785283] Rui: device fuse, action 1 done
[  149.785285] Rui: device 0000:00:01.0:pcie01, action 1 started
[  149.785286] Rui: device 0000:00:01.0:pcie01, action 1 done
[  149.785288] Rui: device 0000:00:01.0:pcie04, action 1 started
[  149.785289] Rui: device 0000:00:01.0:pcie04, action 1 done
[  149.785290] Rui: device 0000:00:01.0:pcie08, action 1 started
[  149.785292] Rui: device 0000:00:01.0:pcie08, action 1 done
[  149.785293] Rui: device 0000:00:1c.0:pcie01, action 1 started
[  149.785294] Rui: device 0000:00:1c.0:pcie01, action 1 done
[  149.785295] Rui: device 0000:00:1c.0:pcie04, action 1 started
[  149.785297] Rui: device 0000:00:1c.0:pcie04, action 1 done
[  149.785298] Rui: device 0000:00:1c.0:pcie08, action 1 started
[  149.785299] Rui: device 0000:00:1c.0:pcie08, action 1 done
[  149.785300] Rui: device 0000:00:1c.1:pcie01, action 1 started
[  149.785302] Rui: device 0000:00:1c.1:pcie01, action 1 done
[  149.785303] Rui: device 0000:00:1c.1:pcie04, action 1 started
[  149.785304] Rui: device 0000:00:1c.1:pcie04, action 1 done
[  149.785306] Rui: device 0000:00:1c.1:pcie08, action 1 started
[  149.785307] Rui: device 0000:00:1c.1:pcie08, action 1 done
[  149.785308] Rui: device 0000:00:1c.3:pcie01, action 1 started
[  149.785310] Rui: device 0000:00:1c.3:pcie01, action 1 done
[  149.785311] Rui: device 0000:00:1c.3:pcie04, action 1 started
[  149.785312] Rui: device 0000:00:1c.3:pcie04, action 1 done
[  149.785313] Rui: device 0000:00:1c.3:pcie08, action 1 started
[  149.785315] Rui: device 0000:00:1c.3:pcie08, action 1 done
[  149.785316] Rui: device AC, action 1 started
[  149.785317] Rui: device AC, action 1 done
[  149.785318] Rui: device input0, action 1 started
[  149.785320] Rui: device input0, action 1 done
[  149.785321] Rui: device input1, action 1 started
[  149.785322] Rui: device input1, action 1 done
[  149.785324] Rui: device cooling_device0, action 1 started
[  149.785325] Rui: device cooling_device0, action 1 done
[  149.785327] Rui: device cooling_device1, action 1 started
[  149.785328] Rui: device cooling_device1, action 1 done
[  149.785329] Rui: device thermal_zone0, action 1 started
[  149.785331] Rui: device thermal_zone0, action 1 done
[  149.785332] Rui: device hwmon0, action 1 started
[  149.785333] Rui: device hwmon0, action 1 done
[  149.785334] Rui: device tty, action 1 started
[  149.785336] Rui: device tty, action 1 done
[  149.785337] Rui: device console, action 1 started
[  149.785338] Rui: device console, action 1 done
[  149.785340] Rui: device tty0, action 1 started
[  149.785341] Rui: device tty0, action 1 done
[  149.785342] Rui: device vcs, action 1 started
[  149.785343] Rui: device vcs, action 1 done
[  149.785345] Rui: device vcsa, action 1 started
[  149.785346] Rui: device vcsa, action 1 done
[  149.785347] Rui: device tty1, action 1 started
[  149.785348] Rui: device tty1, action 1 done
[  149.785349] Rui: device tty2, action 1 started
[  149.785351] Rui: device tty2, action 1 done
[  149.785352] Rui: device tty3, action 1 started
[  149.785353] Rui: device tty3, action 1 done
[  149.785354] Rui: device tty4, action 1 started
[  149.785356] Rui: device tty4, action 1 done
[  149.785357] Rui: device tty5, action 1 started
[  149.785358] Rui: device tty5, action 1 done
[  149.785359] Rui: device tty6, action 1 started
[  149.785360] Rui: device tty6, action 1 done
[  149.785362] Rui: device tty7, action 1 started
[  149.785363] Rui: device tty7, action 1 done
[  149.785364] Rui: device tty8, action 1 started
[  149.785365] Rui: device tty8, action 1 done
[  149.785366] Rui: device tty9, action 1 started
[  149.785368] Rui: device tty9, action 1 done
[  149.785369] Rui: device tty10, action 1 started
[  149.785370] Rui: device tty10, action 1 done
[  149.785371] Rui: device tty11, action 1 started
[  149.785373] Rui: device tty11, action 1 done
[  149.785374] Rui: device tty12, action 1 started
[  149.785375] Rui: device tty12, action 1 done
[  149.785376] Rui: device tty13, action 1 started
[  149.785377] Rui: device tty13, action 1 done
[  149.785379] Rui: device tty14, action 1 started
[  149.785380] Rui: device tty14, action 1 done
[  149.785381] Rui: device tty15, action 1 started
[  149.785382] Rui: device tty15, action 1 done
[  149.785383] Rui: device tty16, action 1 started
[  149.785385] Rui: device tty16, action 1 done
[  149.785386] Rui: device tty17, action 1 started
[  149.785387] Rui: device tty17, action 1 done
[  149.785388] Rui: device tty18, action 1 started
[  149.785389] Rui: device tty18, action 1 done
[  149.785391] Rui: device tty19, action 1 started
[  149.785392] Rui: device tty19, action 1 done
[  149.785393] Rui: device tty20, action 1 started
[  149.785394] Rui: device tty20, action 1 done
[  149.785395] Rui: device tty21, action 1 started
[  149.785397] Rui: device tty21, action 1 done
[  149.785398] Rui: device tty22, action 1 started
[  149.785399] Rui: device tty22, action 1 done
[  149.785400] Rui: device tty23, action 1 started
[  149.785402] Rui: device tty23, action 1 done
[  149.785403] Rui: device tty24, action 1 started
[  149.785404] Rui: device tty24, action 1 done
[  149.785405] Rui: device tty25, action 1 started
[  149.785407] Rui: device tty25, action 1 done
[  149.785408] Rui: device tty26, action 1 started
[  149.785409] Rui: device tty26, action 1 done
[  149.785410] Rui: device tty27, action 1 started
[  149.785411] Rui: device tty27, action 1 done
[  149.785412] Rui: device tty28, action 1 started
[  149.785414] Rui: device tty28, action 1 done
[  149.785415] Rui: device tty29, action 1 started
[  149.785416] Rui: device tty29, action 1 done
[  149.785417] Rui: device tty30, action 1 started
[  149.785418] Rui: device tty30, action 1 done
[  149.785420] Rui: device tty31, action 1 started
[  149.785421] Rui: device tty31, action 1 done
[  149.785422] Rui: device tty32, action 1 started
[  149.785423] Rui: device tty32, action 1 done
[  149.785425] Rui: device tty33, action 1 started
[  149.785426] Rui: device tty33, action 1 done
[  149.785427] Rui: device tty34, action 1 started
[  149.785428] Rui: device tty34, action 1 done
[  149.785429] Rui: device tty35, action 1 started
[  149.785431] Rui: device tty35, action 1 done
[  149.785432] Rui: device tty36, action 1 started
[  149.785433] Rui: device tty36, action 1 done
[  149.785434] Rui: device tty37, action 1 started
[  149.785435] Rui: device tty37, action 1 done
[  149.785437] Rui: device tty38, action 1 started
[  149.785438] Rui: device tty38, action 1 done
[  149.785439] Rui: device tty39, action 1 started
[  149.785440] Rui: device tty39, action 1 done
[  149.785442] Rui: device tty40, action 1 started
[  149.785443] Rui: device tty40, action 1 done
[  149.785444] Rui: device tty41, action 1 started
[  149.785445] Rui: device tty41, action 1 done
[  149.785446] Rui: device tty42, action 1 started
[  149.785448] Rui: device tty42, action 1 done
[  149.785449] Rui: device tty43, action 1 started
[  149.785450] Rui: device tty43, action 1 done
[  149.785451] Rui: device tty44, action 1 started
[  149.785452] Rui: device tty44, action 1 done
[  149.785454] Rui: device tty45, action 1 started
[  149.785455] Rui: device tty45, action 1 done
[  149.785456] Rui: device tty46, action 1 started
[  149.785457] Rui: device tty46, action 1 done
[  149.785458] Rui: device tty47, action 1 started
[  149.785460] Rui: device tty47, action 1 done
[  149.785461] Rui: device tty48, action 1 started
[  149.785462] Rui: device tty48, action 1 done
[  149.785463] Rui: device tty49, action 1 started
[  149.785465] Rui: device tty49, action 1 done
[  149.785466] Rui: device tty50, action 1 started
[  149.785467] Rui: device tty50, action 1 done
[  149.785468] Rui: device tty51, action 1 started
[  149.785469] Rui: device tty51, action 1 done
[  149.785471] Rui: device tty52, action 1 started
[  149.785472] Rui: device tty52, action 1 done
[  149.785473] Rui: device tty53, action 1 started
[  149.785474] Rui: device tty53, action 1 done
[  149.785475] Rui: device tty54, action 1 started
[  149.785477] Rui: device tty54, action 1 done
[  149.785478] Rui: device tty55, action 1 started
[  149.785479] Rui: device tty55, action 1 done
[  149.785480] Rui: device tty56, action 1 started
[  149.785481] Rui: device tty56, action 1 done
[  149.785483] Rui: device tty57, action 1 started
[  149.785484] Rui: device tty57, action 1 done
[  149.785485] Rui: device tty58, action 1 started
[  149.785486] Rui: device tty58, action 1 done
[  149.785487] Rui: device tty59, action 1 started
[  149.785489] Rui: device tty59, action 1 done
[  149.785490] Rui: device tty60, action 1 started
[  149.785491] Rui: device tty60, action 1 done
[  149.785492] Rui: device tty61, action 1 started
[  149.785493] Rui: device tty61, action 1 done
[  149.785495] Rui: device tty62, action 1 started
[  149.785496] Rui: device tty62, action 1 done
[  149.785497] Rui: device tty63, action 1 started
[  149.785498] Rui: device tty63, action 1 done
[  149.785500] Rui: device ptmx, action 1 started
[  149.785501] Rui: device ptmx, action 1 done
[  149.785502] Rui: device hpet, action 1 started
[  149.785503] Rui: device hpet, action 1 done
[  149.785505] Rui: device serial8250, action 1 started
[  149.785507] Rui: device serial8250, action 1 done
[  149.785509] Rui: device ttyS0, action 1 started
[  149.785510] Rui: device ttyS0, action 1 done
[  149.785511] Rui: device ttyS1, action 1 started
[  149.785512] Rui: device ttyS1, action 1 done
[  149.785513] Rui: device ttyS2, action 1 started
[  149.785515] Rui: device ttyS2, action 1 done
[  149.785516] Rui: device ttyS3, action 1 started
[  149.785517] Rui: device ttyS3, action 1 done
[  149.785519] Rui: device ram0, action 1 started
[  149.785520] Rui: device ram0, action 1 done
[  149.785521] Rui: device 1:0, action 1 started
[  149.785522] Rui: device 1:0, action 1 done
[  149.785524] Rui: device ram1, action 1 started
[  149.785525] Rui: device ram1, action 1 done
[  149.785526] Rui: device 1:1, action 1 started
[  149.785527] Rui: device 1:1, action 1 done
[  149.785529] Rui: device ram2, action 1 started
[  149.785530] Rui: device ram2, action 1 done
[  149.785531] Rui: device 1:2, action 1 started
[  149.785533] Rui: device 1:2, action 1 done
[  149.785534] Rui: device ram3, action 1 started
[  149.785535] Rui: device ram3, action 1 done
[  149.785536] Rui: device 1:3, action 1 started
[  149.785538] Rui: device 1:3, action 1 done
[  149.785539] Rui: device ram4, action 1 started
[  149.785540] Rui: device ram4, action 1 done
[  149.785542] Rui: device 1:4, action 1 started
[  149.785543] Rui: device 1:4, action 1 done
[  149.785544] Rui: device ram5, action 1 started
[  149.785545] Rui: device ram5, action 1 done
[  149.785547] Rui: device 1:5, action 1 started
[  149.785548] Rui: device 1:5, action 1 done
[  149.785549] Rui: device ram6, action 1 started
[  149.785550] Rui: device ram6, action 1 done
[  149.785552] Rui: device 1:6, action 1 started
[  149.785553] Rui: device 1:6, action 1 done
[  149.785554] Rui: device ram7, action 1 started
[  149.785555] Rui: device ram7, action 1 done
[  149.785557] Rui: device 1:7, action 1 started
[  149.785558] Rui: device 1:7, action 1 done
[  149.785559] Rui: device ram8, action 1 started
[  149.785561] Rui: device ram8, action 1 done
[  149.785562] Rui: device 1:8, action 1 started
[  149.785563] Rui: device 1:8, action 1 done
[  149.785564] Rui: device ram9, action 1 started
[  149.785565] Rui: device ram9, action 1 done
[  149.785567] Rui: device 1:9, action 1 started
[  149.785568] Rui: device 1:9, action 1 done
[  149.785569] Rui: device ram10, action 1 started
[  149.785571] Rui: device ram10, action 1 done
[  149.785572] Rui: device 1:10, action 1 started
[  149.785573] Rui: device 1:10, action 1 done
[  149.785574] Rui: device ram11, action 1 started
[  149.785576] Rui: device ram11, action 1 done
[  149.785577] Rui: device 1:11, action 1 started
[  149.785578] Rui: device 1:11, action 1 done
[  149.785579] Rui: device ram12, action 1 started
[  149.785581] Rui: device ram12, action 1 done
[  149.785582] Rui: device 1:12, action 1 started
[  149.785583] Rui: device 1:12, action 1 done
[  149.785585] Rui: device ram13, action 1 started
[  149.785586] Rui: device ram13, action 1 done
[  149.785587] Rui: device 1:13, action 1 started
[  149.785588] Rui: device 1:13, action 1 done
[  149.785590] Rui: device ram14, action 1 started
[  149.785591] Rui: device ram14, action 1 done
[  149.785592] Rui: device 1:14, action 1 started
[  149.785593] Rui: device 1:14, action 1 done
[  149.785595] Rui: device ram15, action 1 started
[  149.785596] Rui: device ram15, action 1 done
[  149.785597] Rui: device 1:15, action 1 started
[  149.785599] Rui: device 1:15, action 1 done
[  149.785600] Rui: device loop0, action 1 started
[  149.785601] Rui: device loop0, action 1 done
[  149.785602] Rui: device 7:0, action 1 started
[  149.785604] Rui: device 7:0, action 1 done
[  149.785605] Rui: device loop1, action 1 started
[  149.785606] Rui: device loop1, action 1 done
[  149.785607] Rui: device 7:1, action 1 started
[  149.785609] Rui: device 7:1, action 1 done
[  149.785610] Rui: device loop2, action 1 started
[  149.785611] Rui: device loop2, action 1 done
[  149.785612] Rui: device 7:2, action 1 started
[  149.785613] Rui: device 7:2, action 1 done
[  149.785615] Rui: device loop3, action 1 started
[  149.785616] Rui: device loop3, action 1 done
[  149.785617] Rui: device 7:3, action 1 started
[  149.785619] Rui: device 7:3, action 1 done
[  149.785620] Rui: device loop4, action 1 started
[  149.785621] Rui: device loop4, action 1 done
[  149.785623] Rui: device 7:4, action 1 started
[  149.785624] Rui: device 7:4, action 1 done
[  149.785625] Rui: device loop5, action 1 started
[  149.785626] Rui: device loop5, action 1 done
[  149.785628] Rui: device 7:5, action 1 started
[  149.785629] Rui: device 7:5, action 1 done
[  149.785630] Rui: device loop6, action 1 started
[  149.785631] Rui: device loop6, action 1 done
[  149.785633] Rui: device 7:6, action 1 started
[  149.785634] Rui: device 7:6, action 1 done
[  149.785635] Rui: device loop7, action 1 started
[  149.785636] Rui: device loop7, action 1 done
[  149.785638] Rui: device 7:7, action 1 started
[  149.785639] Rui: device 7:7, action 1 done
[  149.785640] Rui: device pktcdvd!control, action 1 started
[  149.785642] Rui: device pktcdvd!control, action 1 done
[  149.785643] Rui: device input2, action 1 started
[  149.785644] Rui: device input2, action 1 done
[  149.785646] Rui: device BAT0, action 1 started
[  149.785647] Rui: device BAT0, action 1 done
[  149.785648] Rui: device tgt, action 1 started
[  149.785649] Rui: device tgt, action 1 done
[  149.785651] Rui: device host0, action 1 started
[  149.785652] Rui: device host0, action 1 done
[  149.785653] Rui: device host0, action 1 started
[  149.785654] Rui: device host0, action 1 done
[  149.785656] Rui: device host1, action 1 started
[  149.785657] Rui: device host1, action 1 done
[  149.785658] Rui: device host1, action 1 started
[  149.785659] Rui: device host1, action 1 done
[  149.785661] Rui: device host2, action 1 started
[  149.785662] Rui: device host2, action 1 done
[  149.785663] Rui: device host2, action 1 started
[  149.785664] Rui: device host2, action 1 done
[  149.785666] Rui: device host3, action 1 started
[  149.785667] Rui: device host3, action 1 done
[  149.785668] Rui: device host3, action 1 started
[  149.785669] Rui: device host3, action 1 done
[  149.785670] Rui: device host4, action 1 started
[  149.785672] Rui: device host4, action 1 done
[  149.785673] Rui: device host4, action 1 started
[  149.785674] Rui: device host4, action 1 done
[  149.785675] Rui: device host5, action 1 started
[  149.785677] Rui: device host5, action 1 done
[  149.785678] Rui: device host5, action 1 started
[  149.785679] Rui: device host5, action 1 done
[  149.785680] Rui: device Fixed MDIO bus.0, action 1 started
[  149.785682] Rui: device Fixed MDIO bus.0, action 1 done
[  149.785683] Rui: device 0, action 1 started
[  149.785684] Rui: device 0, action 1 done
[  149.785686] Rui: device ppp, action 1 started
[  149.785687] Rui: device ppp, action 1 done
[  149.785688] Rui: device usbmon0, action 1 started
[  149.785690] Rui: device usbmon0, action 1 done
[  149.785691] Rui: device usbmon1, action 1 started
[  149.785692] Rui: device usbmon1, action 1 done
[  149.785693] Rui: device usb1, action 1 started
[  149.837152] Rui: device usb1, action 1 done
[  149.837157] Rui: device 1-0:1.0, action 1 started
[  149.837161] Rui: device 1-0:1.0, action 1 done
[  149.837165] Rui: device ep_81, action 1 started
[  149.837169] Rui: device ep_81, action 1 done
[  149.837173] Rui: device ep_00, action 1 started
[  149.837177] Rui: device ep_00, action 1 done
[  149.837181] Rui: device usbmon2, action 1 started
[  149.837185] Rui: device usbmon2, action 1 done
[  149.837189] Rui: device usb2, action 1 started
[  149.888630] Rui: device usb2, action 1 done
[  149.888635] Rui: device 2-0:1.0, action 1 started
[  149.888638] Rui: device 2-0:1.0, action 1 done
[  149.888642] Rui: device ep_81, action 1 started
[  149.888646] Rui: device ep_81, action 1 done
[  149.888650] Rui: device ep_00, action 1 started
[  149.888654] Rui: device ep_00, action 1 done
[  149.888658] Rui: device usbmon3, action 1 started
[  149.888661] Rui: device usbmon3, action 1 done
[  149.888665] Rui: device usb3, action 1 started
[  149.900607] ata6: SATA link down (SStatus 0 SControl 300)
[  149.916078] ata5: SATA link down (SStatus 0 SControl 300)
[  149.924607] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  149.928046] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 rejected by device (Stat=0x51 Err=0x04)
[  149.932094] ata2.00: ACPI cmd 00/00:00:00:00:00:a0 rejected by device (Stat=0x51 Err=0x04)
[  149.932133] ata2.00: configured for UDMA/33
[  149.948086] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[  149.948091] ata2: irq_stat 0x40000001
[  149.952123] ata2.00: configured for UDMA/33
[  149.952128] ata2: EH complete
[  150.136594] Rui: device usb3, action 1 done
[  150.136598] Rui: device 3-0:1.0, action 1 started
[  150.136602] Rui: device 3-0:1.0, action 1 done
[  150.136606] Rui: device ep_81, action 1 started
[  150.136610] Rui: device ep_81, action 1 done
[  150.136614] Rui: device ep_00, action 1 started
[  150.136617] Rui: device ep_00, action 1 done
[  150.136621] Rui: device usbmon4, action 1 started
[  150.136625] Rui: device usbmon4, action 1 done
[  150.136629] Rui: device usb4, action 1 started
[  150.136633] Rui: device usb4, action 1 done
[  150.136637] Rui: device 4-0:1.0, action 1 started
[  150.136640] Rui: device 4-0:1.0, action 1 done
[  150.136644] Rui: device ep_81, action 1 started
[  150.136648] Rui: device ep_81, action 1 done
[  150.136652] Rui: device ep_00, action 1 started
[  150.136656] Rui: device ep_00, action 1 done
[  150.136660] Rui: device usbmon5, action 1 started
[  150.136663] Rui: device usbmon5, action 1 done
[  150.136667] Rui: device usb5, action 1 started
[  150.136671] Rui: device usb5, action 1 done
[  150.136675] Rui: device 5-0:1.0, action 1 started
[  150.136678] Rui: device 5-0:1.0, action 1 done
[  150.136683] Rui: device ep_81, action 1 started
[  150.136686] Rui: device ep_81, action 1 done
[  150.136690] Rui: device ep_00, action 1 started
[  150.136694] Rui: device ep_00, action 1 done
[  150.136698] Rui: device usbmon6, action 1 started
[  150.136701] Rui: device usbmon6, action 1 done
[  150.136705] Rui: device usb6, action 1 started
[  150.136709] Rui: device usb6, action 1 done
[  150.136713] Rui: device 6-0:1.0, action 1 started
[  150.136716] Rui: device 6-0:1.0, action 1 done
[  150.136720] Rui: device ep_81, action 1 started
[  150.136724] Rui: device ep_81, action 1 done
[  150.136728] Rui: device ep_00, action 1 started
[  150.136732] Rui: device ep_00, action 1 done
[  150.136736] Rui: device usbmon7, action 1 started
[  150.136739] Rui: device usbmon7, action 1 done
[  150.136743] Rui: device usb7, action 1 started
[  150.136747] Rui: device usb7, action 1 done
[  150.136751] Rui: device 7-0:1.0, action 1 started
[  150.136755] Rui: device 7-0:1.0, action 1 done
[  150.136759] Rui: device ep_81, action 1 started
[  150.136763] Rui: device ep_81, action 1 done
[  150.136767] Rui: device ep_00, action 1 started
[  150.136770] Rui: device ep_00, action 1 done
[  150.136774] Rui: device usbmon8, action 1 started
[  150.136778] Rui: device usbmon8, action 1 done
[  150.136782] Rui: device usb8, action 1 started
[  150.384591] Rui: device usb8, action 1 done
[  150.384595] Rui: device 8-0:1.0, action 1 started
[  150.384599] Rui: device 8-0:1.0, action 1 done
[  150.384603] Rui: device ep_81, action 1 started
[  150.384607] Rui: device ep_81, action 1 done
[  150.384611] Rui: device ep_00, action 1 started
[  150.384614] Rui: device ep_00, action 1 done
[  150.384618] Rui: device i8042, action 1 started
[  150.388210] Rui: device i8042, action 1 done
[  150.388214] Rui: device mice, action 1 started
[  150.388218] Rui: device mice, action 1 done
[  150.388222] Rui: device mouse0, action 1 started
[  150.388226] Rui: device mouse0, action 1 done
[  150.388230] Rui: device psaux, action 1 started
[  150.388233] Rui: device psaux, action 1 done
[  150.388237] Rui: device event0, action 1 started
[  150.388241] Rui: device event0, action 1 done
[  150.388245] Rui: device event1, action 1 started
[  150.388249] Rui: device event1, action 1 done
[  150.388253] Rui: device event2, action 1 started
[  150.388257] Rui: device event2, action 1 done
[  150.388261] Rui: device rtc0, action 1 started
[  150.388319] Rui: device rtc0, action 1 done
[  150.388323] Rui: device serio0, action 1 started
[  150.388329] Rui: device serio0, action 1 done
[  150.388333] Rui: device device-mapper, action 1 started
[  150.388337] Rui: device device-mapper, action 1 done
[  150.388341] Rui: device cpu_dma_latency, action 1 started
[  150.388345] Rui: device cpu_dma_latency, action 1 done
[  150.388349] Rui: device network_latency, action 1 started
[  150.388353] Rui: device network_latency, action 1 done
[  150.388358] Rui: device network_throughput, action 1 started
[  150.388362] Rui: device network_throughput, action 1 done
[  150.388366] Rui: device input3, action 1 started
[  150.388370] Rui: device input3, action 1 done
[  150.388374] Rui: device event3, action 1 started
[  150.388377] Rui: device event3, action 1 done
[  150.388381] Rui: device serio1, action 1 started
[  150.388386] Rui: device serio1, action 1 done
[  150.388390] Rui: device target0:0:0, action 1 started
[  150.388394] Rui: device target0:0:0, action 1 done
[  150.388398] Rui: device 0:0:0:0, action 1 started
[  150.388404] sd 0:0:0:0: [sda] Starting disk
[  150.464589] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  150.465900] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  150.474391] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
[  150.474646] ata1.00: configured for UDMA/133
[  150.488088] ata1: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[  150.488093] ata1: irq_stat 0x00400040, connection status changed
[  150.490823] ata1.00: configured for UDMA/133
[  150.490828] ata1: EH complete
[  150.506688] Rui: device 0:0:0:0, action 1 done
[  150.506693] Rui: device 0:0:0:0, action 1 started
[  150.506697] Rui: device 0:0:0:0, action 1 done
[  150.506701] Rui: device 0:0:0:0, action 1 started
[  150.506705] Rui: device 0:0:0:0, action 1 done
[  150.506709] Rui: device sg0, action 1 started
[  150.506712] Rui: device sg0, action 1 done
[  150.506716] Rui: device sda, action 1 started
[  150.506719] Rui: device sda, action 1 done
[  150.506723] Rui: device sda1, action 1 started
[  150.506727] Rui: device sda1, action 1 done
[  150.506730] Rui: device sda3, action 1 started
[  150.506734] Rui: device sda3, action 1 done
[  150.506737] Rui: device sda5, action 1 started
[  150.506740] Rui: device sda5, action 1 done
[  150.506744] Rui: device sda6, action 1 started
[  150.506748] Rui: device sda6, action 1 done
[  150.506751] Rui: device sda7, action 1 started
[  150.506755] Rui: device sda7, action 1 done
[  150.506759] Rui: device 8:0, action 1 started
[  150.506762] Rui: device 8:0, action 1 done
[  150.506766] Rui: device serio2, action 1 started
[  150.506771] Rui: device serio2, action 1 done
[  150.506774] Rui: device serio3, action 1 started
[  150.506779] Rui: device serio3, action 1 done
[  150.506783] Rui: device serio4, action 1 started
[  150.506787] Rui: device serio4, action 1 done
[  150.506791] Rui: device 1-2, action 1 started
[  150.552254] Rui: device 1-2, action 1 done
[  150.552259] Rui: device 1-2:1.0, action 1 started
[  150.552263] Rui: device 1-2:1.0, action 1 done
[  150.552267] Rui: device ep_81, action 1 started
[  150.552271] Rui: device ep_81, action 1 done
[  150.552274] Rui: device 1-2:1.1, action 1 started
[  150.552278] Rui: device 1-2:1.1, action 1 done
[  150.552282] Rui: device ep_00, action 1 started
[  150.552286] Rui: device ep_00, action 1 done
[  150.552290] Rui: device 3-1, action 1 started
[  150.664082] usb 3-1: reset full speed USB device using uhci_hcd and address 2
[  150.813628] Rui: device 3-1, action 1 done
[  150.813632] Rui: device 3-1:1.0, action 1 started
[  150.813636] Rui: device 3-1:1.0, action 1 done
[  150.813640] Rui: device ep_81, action 1 started
[  150.813644] Rui: device ep_81, action 1 done
[  150.813648] Rui: device ep_02, action 1 started
[  150.813652] Rui: device ep_02, action 1 done
[  150.813655] Rui: device ep_83, action 1 started
[  150.813659] Rui: device ep_83, action 1 done
[  150.813663] Rui: device ep_00, action 1 started
[  150.813667] Rui: device ep_00, action 1 done
[  150.813671] Rui: device target1:0:0, action 1 started
[  150.813675] Rui: device target1:0:0, action 1 done
[  150.813679] Rui: device 1:0:0:0, action 1 started
[  150.813683] Rui: device 1:0:0:0, action 1 done
[  150.813687] Rui: device sr0, action 1 started
[  150.813691] Rui: device sr0, action 1 done
[  150.813695] Rui: device 11:0, action 1 started
[  150.813698] Rui: device 11:0, action 1 done
[  150.813702] Rui: device 1:0:0:0, action 1 started
[  150.813706] Rui: device 1:0:0:0, action 1 done
[  150.813710] Rui: device sg1, action 1 started
[  150.813714] Rui: device sg1, action 1 done
[  150.813718] Rui: device 8-2, action 1 started
[  150.924080] usb 8-2: reset full speed USB device using uhci_hcd and address 2
[  151.075625] btusb 8-2:1.0: no reset_resume for driver btusb?
[  151.075631] btusb 8-2:1.1: no reset_resume for driver btusb?
[  151.324262] Rui: device 8-2, action 1 done
[  151.324267] Rui: device 8-2:1.0, action 1 started
[  151.324271] Rui: device 8-2:1.0, action 1 done
[  151.324275] Rui: device ep_81, action 1 started
[  151.324279] Rui: device ep_81, action 1 done
[  151.324283] Rui: device ep_82, action 1 started
[  151.324287] Rui: device ep_82, action 1 done
[  151.324290] Rui: device ep_02, action 1 started
[  151.324294] Rui: device ep_02, action 1 done
[  151.324298] Rui: device 8-2:1.1, action 1 started
[  151.324302] Rui: device 8-2:1.1, action 1 done
[  151.324305] Rui: device ep_83, action 1 started
[  151.324309] Rui: device ep_83, action 1 done
[  151.324313] Rui: device ep_03, action 1 started
[  151.324317] Rui: device ep_03, action 1 done
[  151.324320] Rui: device 8-2:1.2, action 1 started
[  151.324324] Rui: device 8-2:1.2, action 1 done
[  151.324328] Rui: device ep_84, action 1 started
[  151.324332] Rui: device ep_84, action 1 done
[  151.324336] Rui: device ep_04, action 1 started
[  151.324339] Rui: device ep_04, action 1 done
[  151.324343] Rui: device 8-2:1.3, action 1 started
[  151.324347] Rui: device 8-2:1.3, action 1 done
[  151.324351] Rui: device ep_00, action 1 started
[  151.324355] Rui: device ep_00, action 1 done
[  151.324358] Rui: device vcs2, action 1 started
[  151.324363] Rui: device vcs2, action 1 done
[  151.324367] Rui: device vcsa2, action 1 started
[  151.324370] Rui: device vcsa2, action 1 done
[  151.324374] Rui: device vcs3, action 1 started
[  151.324377] Rui: device vcs3, action 1 done
[  151.324382] Rui: device vcsa3, action 1 started
[  151.324385] Rui: device vcsa3, action 1 done
[  151.324389] Rui: device vcs4, action 1 started
[  151.324393] Rui: device vcs4, action 1 done
[  151.324397] Rui: device vcsa4, action 1 started
[  151.324400] Rui: device vcsa4, action 1 done
[  151.324404] Rui: device vcs5, action 1 started
[  151.324408] Rui: device vcs5, action 1 done
[  151.324412] Rui: device vcsa5, action 1 started
[  151.324415] Rui: device vcsa5, action 1 done
[  151.324419] Rui: device vcs6, action 1 started
[  151.324423] Rui: device vcs6, action 1 done
[  151.324427] Rui: device vcsa6, action 1 started
[  151.324430] Rui: device vcsa6, action 1 done
[  151.324434] Rui: device vcs8, action 1 started
[  151.324438] Rui: device vcs8, action 1 done
[  151.324442] Rui: device vcsa8, action 1 started
[  151.324445] Rui: device vcsa8, action 1 done
[  151.324450] Rui: device fw-host0, action 1 started
[  151.324454] Rui: device fw-host0, action 1 done
[  151.324458] Rui: device fw-host0, action 1 started
[  151.324461] Rui: device fw-host0, action 1 done
[  151.324465] Rui: device eth0, action 1 started
[  151.324469] Rui: device eth0, action 1 done
[  151.324474] Rui: device 0800460302aefbe1, action 1 started
[  151.324477] Rui: device 0800460302aefbe1, action 1 done
[  151.324482] Rui: device 0800460302aefbe1, action 1 started
[  151.324486] Rui: device 0800460302aefbe1, action 1 done
[  151.324490] Rui: device regulatory.0, action 1 started
[  151.324494] Rui: device regulatory.0, action 1 done
[  151.324498] Rui: device agpgart, action 1 started
[  151.324502] Rui: device agpgart, action 1 done
[  151.324506] Rui: device input4, action 1 started
[  151.324510] Rui: device input4, action 1 done
[  151.324514] Rui: device event4, action 1 started
[  151.324517] Rui: device event4, action 1 done
[  151.324521] Rui: device input5, action 1 started
[  151.324525] Rui: device input5, action 1 done
[  151.324529] Rui: device mouse1, action 1 started
[  151.324533] Rui: device mouse1, action 1 done
[  151.324537] Rui: device event5, action 1 started
[  151.324540] Rui: device event5, action 1 done
[  151.324544] Rui: device sonypi, action 1 started
[  151.324548] Rui: device sonypi, action 1 done
[  151.324552] Rui: device sony-laptop, action 1 started
[  151.324556] Rui: device sony-laptop, action 1 done
[  151.324560] Rui: device rfkill1, action 1 started
[  151.334508] Rui: device rfkill1, action 1 done
[  151.334514] Rui: device rfkill2, action 1 started
[  151.344648] Rui: device rfkill2, action 1 done
[  151.344653] Rui: device input6, action 1 started
[  151.344658] Rui: device input6, action 1 done
[  151.344662] Rui: device event6, action 1 started
[  151.344665] Rui: device event6, action 1 done
[  151.344670] Rui: device iTCO_wdt, action 1 started
[  151.344674] Rui: device iTCO_wdt, action 1 done
[  151.344678] Rui: device mmc0::, action 1 started
[  151.344682] Rui: device mmc0::, action 1 done
[  151.344686] Rui: device mmc0, action 1 started
[  151.344690] Rui: device mmc0, action 1 done
[  151.344694] Rui: device pcmcia_socket0, action 1 started
[  151.344698] Rui: device pcmcia_socket0, action 1 done
[  151.344702] Rui: device timer, action 1 started
[  151.344706] Rui: device timer, action 1 done
[  151.344710] Rui: device phy0, action 1 started
[  151.376804] Registered led device: iwl-phy0::radio
[  151.376839] Registered led device: iwl-phy0::assoc
[  151.376871] Registered led device: iwl-phy0::RX
[  151.376906] Registered led device: iwl-phy0::TX
[  151.388079] Rui: device phy0, action 1 done
[  151.388091] Rui: device rfkill3, action 1 started
[  151.388113] Rui: device rfkill3, action 1 done
[  151.388117] Rui: device seq, action 1 started
[  151.388121] Rui: device seq, action 1 done
[  151.388125] Rui: device wmaster0, action 1 started
[  151.388129] Rui: device wmaster0, action 1 done
[  151.388133] Rui: device wlan0, action 1 started
[  151.388137] Rui: device wlan0, action 1 done
[  151.388141] Rui: device sequencer, action 1 started
[  151.388145] Rui: device sequencer, action 1 done
[  151.388149] Rui: device sequencer2, action 1 started
[  151.388153] Rui: device sequencer2, action 1 done
[  151.388157] Rui: device input7, action 1 started
[  151.388161] Rui: device input7, action 1 done
[  151.388165] Rui: device mouse2, action 1 started
[  151.388169] Rui: device mouse2, action 1 done
[  151.388172] Rui: device event7, action 1 started
[  151.388176] Rui: device event7, action 1 done
[  151.388180] Rui: device input8, action 1 started
[  151.388184] Rui: device input8, action 1 done
[  151.388188] Rui: device mouse3, action 1 started
[  151.388192] Rui: device mouse3, action 1 done
[  151.388195] Rui: device event8, action 1 started
[  151.388199] Rui: device event8, action 1 done
[  151.388203] Rui: device input9, action 1 started
[  151.388207] Rui: device input9, action 1 done
[  151.388211] Rui: device event9, action 1 started
[  151.388215] Rui: device event9, action 1 done
[  151.388219] Rui: device card0, action 1 started
[  151.388222] Rui: device card0, action 1 done
[  151.388226] Rui: device pcmC0D1p, action 1 started
[  151.388230] Rui: device pcmC0D1p, action 1 done
[  151.388234] Rui: device adsp, action 1 started
[  151.388238] Rui: device adsp, action 1 done
[  151.388242] Rui: device pcmC0D0p, action 1 started
[  151.388245] Rui: device pcmC0D0p, action 1 done
[  151.388249] Rui: device pcmC0D0c, action 1 started
[  151.388253] Rui: device pcmC0D0c, action 1 done
[  151.388257] Rui: device dsp, action 1 started
[  151.388260] Rui: device dsp, action 1 done
[  151.388264] Rui: device audio, action 1 started
[  151.388268] Rui: device audio, action 1 done
[  151.388271] Rui: device controlC0, action 1 started
[  151.388275] Rui: device controlC0, action 1 done
[  151.388279] Rui: device mixer, action 1 started
[  151.388283] Rui: device mixer, action 1 done
[  151.388287] Rui: device pan0, action 1 started
[  151.388291] Rui: device pan0, action 1 done
[  151.388295] Rui: device vcs7, action 1 started
[  151.388298] Rui: device vcs7, action 1 done
[  151.388302] Rui: device vcsa7, action 1 started
[  151.388306] Rui: device vcsa7, action 1 done
[  151.388310] Rui: device card0, action 1 started
[  151.388371] pci 0000:00:02.0: setting latency timer to 64
[  151.389610] Rui: device card0, action 1 done
[  151.389615] Rui: device input10, action 1 started
[  151.389619] Rui: device input10, action 1 done
[  151.389622] Rui: device event10, action 1 started
[  151.389626] Rui: device event10, action 1 done
[  151.389630] Rui: device input11, action 1 started
[  151.389634] Rui: device input11, action 1 done
[  151.389638] Rui: device event11, action 1 started
[  151.389642] Rui: device event11, action 1 done
[  151.389646] Rui: device 0:22, action 1 started
[  151.389649] Rui: device 0:22, action 1 done
[  151.389653] Rui: device vcs63, action 1 started
[  151.389657] Rui: device vcs63, action 1 done
[  151.389661] Rui: device vcsa63, action 1 started
[  151.389664] Rui: device vcsa63, action 1 done
[  151.389668] Rui: before async synchronization
[  151.389671] Rui: after async synchronization
[  151.391328] PM: Finishing wakeup.
[  151.391332] Restarting tasks ... done.
[  152.549263] e1000e: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
[  152.549267] 0000:00:19.0: eth0: 10/100 speed: disabling TSO
[  153.209283] input: PS/2 Mouse as /devices/platform/i8042/serio2/input/input12
[  153.225781] input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio2/input/input13

--=-+hGPqoFT3a+rQCfs8teV
Content-Disposition: attachment; filename=lspci
Content-Type: text/plain; name=lspci; charset=utf-8
Content-Transfer-Encoding: 7bit

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory Controller Hub (rev 07)
00:01.0 PCI bridge: Intel Corporation Mobile 4 Series Chipset PCI Express Graphics Port (rev 07)
00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network Connection (rev 03)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 03)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 03)
00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 03)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 03)
00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 2 (rev 03)
00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 4 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev 03)
00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
01:00.0 VGA compatible controller: nVidia Corporation GeForce 9300M GS (rev a1)
06:00.0 Network controller: Intel Corporation Wireless WiFi Link 5100
0b:04.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
0b:04.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev 04)
0b:04.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter (rev 21)
0b:04.4 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host Adapter (rev 11)

--=-+hGPqoFT3a+rQCfs8teV--

