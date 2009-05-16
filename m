Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbZEPWut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbZEPWut (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 18:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbZEPWuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 18:50:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188AbZEPWui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 18:50:38 -0400
Date: Sat, 16 May 2009 15:49:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, mingo@elte.hu,
       Ozan =?UTF-8?Q?=C3=87a?= =?UTF-8?Q?=C4=9Flayan?= 
	<ozan@pardus.org.tr>,
       David Brownell <david-b@pacbell.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       Tejun Heo <tj@kernel.org>
Subject: Re: [rtc-linux] Re: [BUG 2.6.30_rc5] Null pointer dereference in
 rtc-cmos driver
Message-Id: <20090516154912.a0efc677.akpm@linux-foundation.org>
In-Reply-To: <20090515210134.758f3123@i1501.lan.towertech.it>
References: <4A0C43C3.9090404@pardus.org.tr>
	<20090515174056.GD29647@elte.hu>
	<20090515210134.758f3123@i1501.lan.towertech.it>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 May 2009 21:01:34 +0200 Alessandro Zummo <alessandro.zummo@towertech.it> wrote:

> On Fri, 15 May 2009 19:40:56 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
>  more Cc:s
>  

c'mon guys, it isn't that hard.

>
> ...
>
> > > [   10.428691] Error: Driver 'rtc_cmos' is already registered, aborting...

This should fix the symptoms:

From: Andrew Morton <akpm@linux-foundation.org>

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13326

Prevents a null-pointer deref under the above-described circumstances.

pnp_unregister_driver() shouldn't oops the kernel either - that's a
different bug.

Reported-by: <ozan@pardus.org.tr>
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Brownell <david-b@pacbell.net>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value
+++ a/drivers/rtc/rtc-cmos.c
@@ -1179,7 +1179,9 @@ static int __init cmos_init(void)
 	int retval = 0;
 
 #ifdef	CONFIG_PNP
-	pnp_register_driver(&cmos_pnp_driver);
+	retval = pnp_register_driver(&cmos_pnp_driver);
+	if (retval < 0)
+		return retval;
 #endif
 
 	if (!cmos_rtc.dev)
_


Can someone please test it?

> > > [   10.428728] BUG: unable to handle kernel NULL pointer dereference at 00000018
> > > [   10.432460] IP: [<c01e16ba>] sysfs_remove_file+0x1/0xf
> > > [   10.459009] *pde = 00000000 
> > > [   10.459009] Oops: 0000 [#1] SMP 
> > > [   10.459009] last sysfs file: /sys/devices/pci0000:00/0000:00:12.0/host2/target2:0:0/2:0:0:0/type
> > > [   10.459009] Modules linked in: rtc_cmos(+) sg ati_agp k8temp hwmon i2c_piix4 shpchp agpgart i2c_core mii brd sd_mod crc_t10dif sr_mod cdrom ata_generic pata_acpi ahci pata_atiixp libata scsi_mod
> > > [   10.459009] 
> > > [   10.459009] Pid: 633, comm: modprobe Tainted: G        W  (2.6.30_rc5-116 #1) Unknow
> > > [   10.459009] EIP: 0060:[<c01e16ba>] EFLAGS: 00210282 CPU: 1
> > > [   10.459009] EIP is at sysfs_remove_file+0x1/0xf
> > > [   10.459009] EAX: 00000000 EBX: f885a2ec ECX: c1e1a664 EDX: c054d1a0
> > > [   10.459009] ESI: 00000000 EDI: 00000000 EBP: f6bcdf08 ESP: f6bcdf00
> > > [   10.459009]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> > > [   10.459009] Process modprobe (pid: 633, ti=f6bcc000 task=f6a8d710 task.ti=f6bcc000)
> > > [   10.459009] Stack:
> > > [   10.459009]  f6bcdf08 c03037e6 f6bcdf1c c0302809 00000000 f885a2ec 00000000 f6bcdf2c
> > > [   10.459009]  c030367d ffffffed fffffffc f6bcdf34 c02dcf14 f6bcdf40 f885d038 f885a38c
> > > [   10.459009]  f6bcdf9c c0101137 f885d000 00000000 f885a38c 00000001 00000000 c0536a04
> > > [   10.459009] Call Trace:
> > > [   10.459009]  [<c03037e6>] ? driver_remove_file+0xf/0x11
> > > [   10.459009]  [<c0302809>] ? bus_remove_driver+0x1a/0x89
> > > [   10.459009]  [<c030367d>] ? driver_unregister+0x2a/0x2e
> > > [   10.459009]  [<c02dcf14>] ? pnp_unregister_driver+0xb/0xd
> > > [   10.459009]  [<f885d038>] ? cmos_init+0x38/0x3d [rtc_cmos]
> > > [   10.459009]  [<c0101137>] ? do_one_initcall+0x4a/0x115
> > > [   10.459009]  [<f885d000>] ? cmos_init+0x0/0x3d [rtc_cmos]
> > > [   10.459009]  [<c0145a65>] ? __blocking_notifier_call_chain+0x40/0x4c
> > > [   10.459009]  [<c01538d0>] ? sys_init_module+0x87/0x18b
> > > [   10.459009]  [<c01031d4>] ? sysenter_do_call+0x12/0x28
> > > [   10.459009] Code: 43 04 89 42 04 89 10 b8 08 9f 53 c0 c7 46 e8 00 01 10 00 c7 43 04 00 02 20 00 e8 1e 9e 1f 00 89 d8 e8 fa ba fb ff 5b 5e 5d c3 55 <8b> 40 18 8b 12 89 e5 e8 12 f5 ff ff 5d c3 55 85 c9 89 e5 57 89 
> > > [   10.459009] EIP: [<c01e16ba>] sysfs_remove_file+0x1/0xf SS:ESP 0068:f6bcdf00

But we have arguably multiple more bugs here. 
pnp_unregister_driver(unregistered-driver) shouldn't oops the kernel. 
Neither pnp_unregister_driver() nor driver_unregister() nor
bus_remove_driver() nor driver_remove_file() nor sysfs_remove_file()
detected this.

Kay, Greg: there are already a pile of checks on that path, but it
seems there's one missing.  Could you please take a look and decide at
the design level where this check should be occurring?

Rafael, let's keep this one open even if the rtc-cmos fix repairs the
proximate cause.

Thanks.


