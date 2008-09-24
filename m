Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbYIXKl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbYIXKl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 06:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYIXKlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 06:41:49 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:5713 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbYIXKls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 06:41:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:from:sender;
        b=budqsO/9IIbHb3f1LHtoUaaIqrl69Y/9z9Px2HMkVZNJCN3FU6yjx+E2B75IZYEm4F
         ou6xaH/C4bAJfz5tUrIvW1Rthq5zgG5c56dnVprtHqmmLSsGXQrIYKY0g142i0UJ7ldc
         WyqVyXFMcMcqh7GJZc4rFGPkOe2fp+rhvOBp4=
Message-ID: <48DA1967.3000801@tuffmail.co.uk>
Date: Wed, 24 Sep 2008 11:41:43 +0100
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: fastboot: usbmon WARNING
References: <20080920110036.302261c7@infradead.org>
In-Reply-To: <20080920110036.302261c7@infradead.org>
Content-Type: multipart/mixed;
 boundary="------------010701000901070400060403"
From: Alan Jenkins <aj504@student.cs.york.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010701000901070400060403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Arjan van de Ven wrote:
> The fastboot.git tree has a set of patches (all posted and reviewed on lkml before)
> that speed up the kernel boot process of the kernel.
> 
> There's 3 major pieces of this
> 1) The creation of an asynchronous initcall level (6a) that runs asynchronous from
>    the regular driver init, and is for non-boot critical initcalls only
> 2) A rework of the non-initrd boot code to try mounting /, and if that fails,
>    only THEN wait for all the various driver probings to finish (and then retry)
> 3) A tool "bootgraph.pl" that outputs a SVG graphic of where the kernel boot spends
>    its time 

Enabling fastboot makes usbmon (CONFIG_USB_MON) squawk, trying to create duplicate sysfs files.

I see mon_init is run in parallel with uhci_hcd_init (see attached bootgraph.pl output).  Maybe it would go away if mon_init was also moved to the asynchronous runlevel - it should be  non-boot critical.

And maybe this was a latent bug that needs fixing regardless.

Yours
Alan

[    1.030041] usb 1-8: new high speed USB device using ehci_hcd and address 3
[    1.030359] uhci_hcd 0000:00:1d.0: PCI INT A -> Link[LNKH] -> GSI 3 (level, low) -> IRQ 3
[    1.030512] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.030522] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.030736] initcall piix_init+0x0/0x20 returned 0 after 525 msecs
[    1.030844] calling  mon_init+0x0/0xd1 @ 1
[    1.031038] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    1.031218] uhci_hcd 0000:00:1d.0: irq 3, io base 0x0000e400
[    1.031731] usb usb2: configuration #1 chosen from 1 choice
[    1.031997] hub 2-0:1.0: USB hub found
[    1.032109] hub 2-0:1.0: 2 ports detected
[    1.133721] uhci_hcd 0000:00:1d.1: PCI INT B -> Link[LNKD] -> GSI 7 (level, low) -> IRQ 7
[    1.133871] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.133879] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.134224] ------------[ cut here ]------------
[    1.134320] WARNING: at fs/sysfs/dir.c:463 sysfs_add_one+0x27/0x2f()
[    1.134422] sysfs: duplicate filename 'usbmon3' can not be created
[    1.134522] Modules linked in:
[    1.134656] Pid: 1, comm: swapper Not tainted 2.6.27-rc6eeepc #30
[    1.134760]  [<c0119215>] warn_slowpath+0x61/0x85
[    1.134908]  [<c01ae295>] number+0x13d/0x217
[    1.135050]  [<c0114819>] __dequeue_entity+0x1f/0x71
[    1.135197]  [<c01aacd0>] idr_get_empty_slot+0x122/0x1e6
[    1.135341]  [<c01aae63>] ida_get_new_above+0xcf/0x148
[    1.135483]  [<c018cf4e>] sysfs_new_dirent+0x24/0xc7
[    1.135625]  [<c018cc1f>] sysfs_ilookup_test+0x0/0xd
[    1.135769]  [<c016c9e2>] ifind+0xa/0x49
[    1.135909]  [<c018ce10>] sysfs_find_dirent+0x13/0x23
[    1.136052]  [<c018cea2>] sysfs_add_one+0x27/0x2f
[    1.136193]  [<c018d279>] create_dir+0x3c/0x6b
[    1.136332]  [<c018d2d1>] sysfs_create_dir+0x29/0x3b
[    1.136474]  [<c01ab6a8>] kobject_get+0xf/0x13
[    1.136613]  [<c01ab787>] kobject_add_internal+0x9b/0x134
[    1.136777]  [<c01abb0d>] kobject_add+0x4a/0x4e
[    1.136916]  [<c01fa6a0>] device_add+0x75/0x4b6
[    1.137058]  [<c01fa3ec>] device_initialize+0x77/0x9f
[    1.137199]  [<c01fab69>] device_create_vargs+0x78/0x99
[    1.137342]  [<c03da27c>] mon_init+0x0/0xd1
[    1.137484]  [<c01fabae>] device_create+0x24/0x28
[    1.137625]  [<c022e2a8>] mon_bin_add+0x3b/0x54
[    1.137769]  [<c022c69b>] mon_bus_init+0x45/0x77
[    1.137909]  [<c03da30d>] mon_init+0x91/0xd1
[    1.138047]  [<c010112b>] _stext+0x43/0x111
[    1.138188]  [<c0113c00>] __sched_fork+0x4b/0x6f
[    1.138329]  [<c011671e>] __wake_up+0xf/0x15
[    1.138469]  [<c0124298>] insert_work+0x40/0x44
[    1.138611]  [<c03c2719>] kernel_init+0xcb/0x12e
[    1.138757]  [<c03c264e>] kernel_init+0x0/0x12e
[    1.138895]  [<c010415f>] kernel_thread_helper+0x7/0x10
[    1.139040]  =======================
[    1.139142] ---[ end trace 32b8bb2cd8e5acac ]---
[    1.139240] kobject_add_internal failed for usbmon3 with -EEXIST, don't try to register things with the same name in the same directory.
[    1.139401] Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc6eeepc #30
[    1.139504]  [<c01ab7ea>] kobject_add_internal+0xfe/0x134
[    1.139650]  [<c01abb0d>] kobject_add+0x4a/0x4e
[    1.139789]  [<c01fa6a0>] device_add+0x75/0x4b6
[    1.139928]  [<c01fa3ec>] device_initialize+0x77/0x9f
[    1.140077]  [<c01fab69>] device_create_vargs+0x78/0x99
[    1.140219]  [<c03da27c>] mon_init+0x0/0xd1
[    1.140357]  [<c01fabae>] device_create+0x24/0x28
[    1.140497]  [<c022e2a8>] mon_bin_add+0x3b/0x54
[    1.140637]  [<c022c69b>] mon_bus_init+0x45/0x77
[    1.140777]  [<c03da30d>] mon_init+0x91/0xd1
[    1.140916]  [<c010112b>] _stext+0x43/0x111
[    1.141053]  [<c0113c00>] __sched_fork+0x4b/0x6f
[    1.141193]  [<c011671e>] __wake_up+0xf/0x15
[    1.141333]  [<c0124298>] insert_work+0x40/0x44
[    1.141473]  [<c03c2719>] kernel_init+0xcb/0x12e
[    1.141612]  [<c03c264e>] kernel_init+0x0/0x12e
[    1.141751]  [<c010415f>] kernel_thread_helper+0x7/0x10
[    1.141893]  =======================
[    1.142142] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    1.142334] uhci_hcd 0000:00:1d.1: irq 7, io base 0x0000e480
[    1.142699] initcall mon_init+0x0/0xd1 returned 0 after 106 msecs



--------------010701000901070400060403
Content-Type: image/svg+xml;
 name="bootgraph.svg"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="bootgraph.svg"

PD94bWwgdmVyc2lvbj0iMS4wIiBzdGFuZGFsb25lPSJubyI/PiAKPHN2ZyB3aWR0aD0iMTAw
MCIgaGVpZ2h0PSIxMDAlIiB2ZXJzaW9uPSIxLjEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9y
Zy8yMDAwL3N2ZyI+CjxyZWN0IHg9IjY1My4wOTU5MzE0OTE0NTkiIHdpZHRoPSIxOS4wODQ2
OTc2ODI5MDQyIiB5PSIxNTAiIGhlaWdodD0iMTQ1IiBzdHlsZT0iZmlsbDpyZ2IoMCwwLDI1
NSk7ZmlsbC1vcGFjaXR5OjAuNTtzdHJva2Utd2lkdGg6MTtzdHJva2U6cmdiKDAsMCwwKSIv
Pgo8dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSg2NTkuMDk1OTMxNDkxNDU5LDE1NCkgcm90
YXRlKDkwKSI+aTgwNDJfaW5pdDwvdGV4dD4KPHJlY3QgeD0iMjIxLjExMDkwNDk4ODY4OCIg
d2lkdGg9IjI1LjExMjg1NzE0NTQ4OTciIHk9IjMwMCIgaGVpZ2h0PSIxNDUiIHN0eWxlPSJm
aWxsOnJnYigwLDI1NSwwKTtmaWxsLW9wYWNpdHk6MC41O3N0cm9rZS13aWR0aDoxO3N0cm9r
ZTpyZ2IoMCwwLDApIi8+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDIyNy4xMTA5MDQ5
ODg2ODgsMzA0KSByb3RhdGUoOTApIj5hY3BpX3RoZXJtYWxfaW5pdDwvdGV4dD4KPHJlY3Qg
eD0iMjQ2LjI4ODUzNzEyOTM3MSIgd2lkdGg9IjEzMC4zNTM1NTA0NjIxNDgiIHk9IjMwMCIg
aGVpZ2h0PSIxNDUiIHN0eWxlPSJmaWxsOnJnYigyNTUsMCwyMCk7ZmlsbC1vcGFjaXR5OjAu
NTtzdHJva2Utd2lkdGg6MTtzdHJva2U6cmdiKDAsMCwwKSIvPgo8dGV4dCB0cmFuc2Zvcm09
InRyYW5zbGF0ZSgyNTIuMjg4NTM3MTI5MzcxLDMwNCkgcm90YXRlKDkwKSI+ZWhjaV9oY2Rf
aW5pdDwvdGV4dD4KPHJlY3QgeD0iNjMuNDAwMTMxMzMxMzc5NiIgd2lkdGg9IjE3LjU5MDc4
Nzg4Mzg1MSIgeT0iMTUwIiBoZWlnaHQ9IjE0NSIgc3R5bGU9ImZpbGw6cmdiKDI1NSwyNTUs
MjApO2ZpbGwtb3BhY2l0eTowLjU7c3Ryb2tlLXdpZHRoOjE7c3Ryb2tlOnJnYigwLDAsMCki
Lz4KPHRleHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoNjkuNDAwMTMxMzMxMzc5NiwxNTQpIHJv
dGF0ZSg5MCkiPmluaXRfYWNwaV9wbV9jbG9ja3NvdXJjZTwvdGV4dD4KPHJlY3QgeD0iMTEy
LjA0NzkwMzM5NzEwOSIgd2lkdGg9Ijk4LjYzNDIyNzM2NTQ1NDQiIHk9IjE1MCIgaGVpZ2h0
PSIxNDUiIHN0eWxlPSJmaWxsOnJnYigyNTUsMCwyNTUpO2ZpbGwtb3BhY2l0eTowLjU7c3Ry
b2tlLXdpZHRoOjE7c3Ryb2tlOnJnYigwLDAsMCkiLz4KPHRleHQgdHJhbnNmb3JtPSJ0cmFu
c2xhdGUoMTE4LjA0NzkwMzM5NzEwOSwxNTQpIHJvdGF0ZSg5MCkiPmFjcGlfYWNfaW5pdDwv
dGV4dD4KPHJlY3QgeD0iMzc2LjcwNzQ0NjE0NTIyOCIgd2lkdGg9IjU2OC45MjI4Njc2OTI1
NDIiIHk9IjMwMCIgaGVpZ2h0PSIxNDUiIHN0eWxlPSJmaWxsOnJnYigwLDI1NSwyNTUpO2Zp
bGwtb3BhY2l0eTowLjU7c3Ryb2tlLXdpZHRoOjE7c3Ryb2tlOnJnYigwLDAsMCkiLz4KPHRl
eHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMzgyLjcwNzQ0NjE0NTIyOCwzMDQpIHJvdGF0ZSg5
MCkiPnVoY2lfaGNkX2luaXQ8L3RleHQ+CjxyZWN0IHg9IjIyNy4yOTgzNzU5MjU5MzgiIHdp
ZHRoPSIxOC42OTc3OTgzODcyOSIgeT0iMTUwIiBoZWlnaHQ9IjE0NSIgc3R5bGU9ImZpbGw6
cmdiKDAsMTI4LDI1NSk7ZmlsbC1vcGFjaXR5OjAuNTtzdHJva2Utd2lkdGg6MTtzdHJva2U6
cmdiKDAsMCwwKSIvPgo8dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSgyMzMuMjk4Mzc1OTI1
OTM4LDE1NCkgcm90YXRlKDkwKSI+aHBldF9pbml0PC90ZXh0Pgo8cmVjdCB4PSI4Ni41ODM3
NDQwMjU0MzU4IiB3aWR0aD0iMTI0LjI4NzQ1OTY5NjA3IiB5PSIzMDAiIGhlaWdodD0iMTQ1
IiBzdHlsZT0iZmlsbDpyZ2IoMCwyNTUsMTI4KTtmaWxsLW9wYWNpdHk6MC41O3N0cm9rZS13
aWR0aDoxO3N0cm9rZTpyZ2IoMCwwLDApIi8+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRl
KDkyLjU4Mzc0NDAyNTQzNTgsMzA0KSByb3RhdGUoOTApIj5hY3BpX2JhdHRlcnlfaW5pdDwv
dGV4dD4KPHJlY3QgeD0iNTc4LjE3NDAyMDgzNDg4MiIgd2lkdGg9IjY1LjI3MzkzNzcyMzg2
MzciIHk9IjE1MCIgaGVpZ2h0PSIxNDUiIHN0eWxlPSJmaWxsOnJnYigyNTUsMCwxMjgpO2Zp
bGwtb3BhY2l0eTowLjU7c3Ryb2tlLXdpZHRoOjE7c3Ryb2tlOnJnYigwLDAsMCkiLz4KPHRl
eHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoNTg0LjE3NDAyMDgzNDg4MiwxNTQpIHJvdGF0ZSg5
MCkiPm1vbl9pbml0PC90ZXh0Pgo8cmVjdCB4PSIyNTYuNjg0NjMyMDc4NjQyIiB3aWR0aD0i
MzIxLjQyNjM2NDQzNjU5MyIgeT0iMTUwIiBoZWlnaHQ9IjE0NSIgc3R5bGU9ImZpbGw6cmdi
KDI1NSwyNTUsMTI4KTtmaWxsLW9wYWNpdHk6MC41O3N0cm9rZS13aWR0aDoxO3N0cm9rZTpy
Z2IoMCwwLDApIi8+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDI2Mi42ODQ2MzIwNzg2
NDIsMTU0KSByb3RhdGUoOTApIj5waWl4X2luaXQ8L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0i
dHJhbnNsYXRlKDAsODkpIHJvdGF0ZSg5MCkiPjAuMDQ8L3RleHQ+Cjx0ZXh0IHRyYW5zZm9y
bT0idHJhbnNsYXRlKDYzLjMzMzMzMzMzMzMzMzMsODkpIHJvdGF0ZSg5MCkiPjAuMTQ8L3Rl
eHQ+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDEyNi42NjY2NjY2NjY2NjcsODkpIHJv
dGF0ZSg5MCkiPjAuMjU8L3RleHQ+Cjx0ZXh0IHRyYW5zZm9ybT0idHJhbnNsYXRlKDE5MCw4
OSkgcm90YXRlKDkwKSI+MC4zNjwvdGV4dD4KPHRleHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUo
MjUzLjMzMzMzMzMzMzMzMyw4OSkgcm90YXRlKDkwKSI+MC40NzwvdGV4dD4KPHRleHQgdHJh
bnNmb3JtPSJ0cmFuc2xhdGUoMzE2LjY2NjY2NjY2NjY2Nyw4OSkgcm90YXRlKDkwKSI+MC41
ODwvdGV4dD4KPHRleHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMzgwLDg5KSByb3RhdGUoOTAp
Ij4wLjY5PC90ZXh0Pgo8dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSg0NDMuMzMzMzMzMzMz
MzMzLDg5KSByb3RhdGUoOTApIj4wLjc5PC90ZXh0Pgo8dGV4dCB0cmFuc2Zvcm09InRyYW5z
bGF0ZSg1MDYuNjY2NjY2NjY2NjY3LDg5KSByb3RhdGUoOTApIj4wLjk8L3RleHQ+Cjx0ZXh0
IHRyYW5zZm9ybT0idHJhbnNsYXRlKDU3MCw4OSkgcm90YXRlKDkwKSI+MS4wMTwvdGV4dD4K
PHRleHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoNjMzLjMzMzMzMzMzMzMzMyw4OSkgcm90YXRl
KDkwKSI+MS4xMjwvdGV4dD4KPHRleHQgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoNjk2LjY2NjY2
NjY2NjY2Nyw4OSkgcm90YXRlKDkwKSI+MS4yMzwvdGV4dD4KPHRleHQgdHJhbnNmb3JtPSJ0
cmFuc2xhdGUoNzYwLDg5KSByb3RhdGUoOTApIj4xLjM0PC90ZXh0Pgo8dGV4dCB0cmFuc2Zv
cm09InRyYW5zbGF0ZSg4MjMuMzMzMzMzMzMzMzM0LDg5KSByb3RhdGUoOTApIj4xLjQ1PC90
ZXh0Pgo8dGV4dCB0cmFuc2Zvcm09InRyYW5zbGF0ZSg4ODYuNjY2NjY2NjY2NjY3LDg5KSBy
b3RhdGUoOTApIj4xLjU1PC90ZXh0Pgo8L3N2Zz4K
--------------010701000901070400060403--
