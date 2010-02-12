Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763Ab0BLBzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 20:55:17 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41844 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab0BLBzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 20:55:14 -0500
Date: Thu, 11 Feb 2010 17:55:08 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Gary Hade <garyhade@us.ibm.com>, linux-pm@lists.linux-foundation.org,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 8/9] PCI / ACPI / PM: Platform support for PCI PME
	wake-up (rev. 7)
Message-ID: <20100212015508.GD10298@us.ibm.com>
References: <201001101431.38630.rjw@sisk.pl> <201002112132.02255.rjw@sisk.pl> <20100211215604.GA10298@us.ibm.com> <201002112321.13922.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002112321.13922.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 11, 2010 at 11:21:13PM +0100, Rafael J. Wysocki wrote:
> On Thursday 11 February 2010, Gary Hade wrote:
> > On Thu, Feb 11, 2010 at 09:32:02PM +0100, Rafael J. Wysocki wrote:
> > > On Thursday 11 February 2010, Gary Hade wrote:
> > > > On Thu, Feb 11, 2010 at 02:27:17PM +0100, Rafael J. Wysocki wrote:
> > > > > On Thursday 11 February 2010, Gary Hade wrote:
> > > > > > On Thu, Feb 11, 2010 at 01:56:54AM +0100, Rafael J. Wysocki wrote:
> > > > > > > On Thursday 11 February 2010, Rafael J. Wysocki wrote:
> > > > > > > > On Thursday 11 February 2010, Gary Hade wrote:
> > > > > > > > > On Wed, Feb 10, 2010 at 11:58:00PM +0100, Rafael J. Wysocki wrote:
> > > > > > > > > > On Wednesday 10 February 2010, Gary Hade wrote:
> > > > > > > > ...
> > > > > > > > > > > Yes, 6/9 also appeared to be the most likely suspect to me and
> > > > > > > > > > > I was already doing what you asked except in the opposite order.
> > > > > > > > > > > With 1/9 through 6/9 both the hot-add and hot-remove issues still
> > > > > > > > > > > reproduced.  After removing 6/9 both issues disappeared.
> > > > > > > > > > 
> > > > > > > > > > Thanks for verifying, I've already started to look for bugs in it.
> > > > > > > > > 
> > > > > > > > > Thanks!
> > > > > > > > > 
> > > > > > > > > > 
> > > > > > > > > > What's your kernel command line, BTW?
> > > > > > > > > 
> > > > > > > > > root=/dev/disk/by-id/scsi-35000c5000036ffcb-part7 ip=9.47.66.9:9.47.67.50:9.47.66.1:255.255.254.0 resume=/dev/disk/by-id/scsi-35000c50000370247-part3 crashkernel=256M-:128M console=tty0 console=ttyS0,115200 pci=use_crs pci=norom
> > > > > > > > 
> > > > > > > > Thanks.  We found a bug in the patch, but it would require you to use a
> > > > > > > > specific command line switch to trigger, which you don't use.
> > > > > > > > 
> > > > > > > > I'll let you know if I have anything to test.
> > > > > > > 
> > > > > > > OK, please try the patch below on top of [1-6/9].
> > > > > > 
> > > > > > Sorry, it didn't help.  The hot-add and hot-remove behaviors
> > > > > > still look the same.
> > > > > 
> > > > > Thanks for testing.
> > > > > 
> > > > > Well, this time I found another real bug, which is that we should add
> > > > > gpe_block->block_base_number to the GPE index within the block in order to
> > > > > compute the GPE number.  If there are GPE devices other than the FADT ones in
> > > > > your system, that may explain the symptoms.
> > > > > 
> > > > > Please try the patch below (on top of [1-6/9]).  In case it doesn't help, please
> > > > > look for "Failed to ebable GPE" messages in dmesg and let me know if there are
> > > > > any.
> > > > 
> > > > That one worked!  It corrected both the blinking amber LED
> > > > after hot-remove and acpiphp's failure to see the hot-add event.
> > > 
> > > Great!
> > > 
> > > > Now when you have patch(es) ready for Jesse's linux-next branch
> > > 
> > > Well, not quite.  I had to rework them in the meantime. ;-)
> > > 
> > > > I can get back to my original mission of checking out Bjorn's
> > > > _CRS enablement changes.
> > > 
> > > May I still ask you to test something?
> > 
> > Oh, I guess so. :)
> > 
> > > 
> > > In case I can, please try the appended patch on top of [1-3/6].  It is a
> > > replacement for [4-6/9] with the last fix included.
> > 
> > I just tried it and it seemed to work fine.
> 
> Great, thanks!
> 
> I have one more testing request if you don't mind, but I'd like to make sure
> the PCI runtime PM patches won't break the PCI hotplug again.
> 
> Please apply [7/9] (ACPI / PM: Add more run-time wake-up field) on top of the
> just tested patch and apply the appended patch on top of that.  Then, please
> check if the PCI hotplug still works.

There seems to be a problem.

The first time I booted I was able to successfully hot-remove
a PCIe card and then successfully hot-add it to a different slot.
When I tried to hot-remove a PCI-X card that was also present
during boot I saw that lingering blinking amber LED issue.

After rebooting I tried the same thing but this time I did
not see the lingering blinking amber LED after removing the
PCI-X card but I did see it when removing the PCIe card.
I then tried to hot-add the PCIe card to a different slot
and noticed the below messages.

I don't think I will be able to try to characterize this
better or test any more patches until Monday.  

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

[  271.776748] acpiphp: disable_slot - physical_slot = 5
[  271.856119] igb 0000:15:00.0: PCI INT A disabled
[  271.952110] igb 0000:15:00.1: PCI INT B disabled
[  281.294973] acpiphp: get_power_status - physical_slot = 5
[  363.144064] INFO: task kacpi_notify:107 blocked for more than 120 seconds.
[  363.144070] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  363.144074] kacpi_notify  D 0000000000000000     0   107      2 0x00000000
[  363.144081]  ffff88017b38b910 0000000000000046 0000000000000000 ffff8801763a2680
[  363.144087]  000000000000e720 ffff88017b38bfd8 ffff88017b3885c0 ffff88017b3889a0
[  363.144093]  ffff880176323980 ffff88000d40e720 ffffffff8160c020 00000000ffffbf2c
[  363.144098] Call Trace:
[  363.144118]  [<ffffffff813a963f>] __mutex_lock_slowpath+0x12f/0x180
[  363.144123]  [<ffffffff813a8fbe>] mutex_lock+0x1e/0x40
[  363.144135]  [<ffffffff81224101>] pci_acpi_add_pm_notifier+0x41/0x130
[  363.144146]  [<ffffffff81245b5f>] acpi_pci_bind+0x32/0x103
[  363.144157]  [<ffffffff8118a63c>] ? sysfs_add_file+0xc/0x10
[  363.144162]  [<ffffffff8118a701>] ? sysfs_create_file+0x21/0x30
[  363.144167]  [<ffffffff81240f1a>] acpi_add_single_object+0xbb1/0xd60
[  363.144172]  [<ffffffff8123cc72>] ? acpi_os_signal_semaphore+0x66/0x6f
[  363.144177]  [<ffffffff8123fda6>] ? acpi_bus_data_handler+0x0/0x6
[  363.144185]  [<ffffffff81268fc5>] ? acpi_ut_release_mutex+0xad/0xb6
[  363.144190]  [<ffffffff812411a0>] acpi_bus_check_add+0xd7/0x12c
[  363.144194]  [<ffffffff8123cc72>] ? acpi_os_signal_semaphore+0x66/0x6f
[  363.144198]  [<ffffffff81241226>] acpi_bus_scan+0x31/0x6e
[  363.144203]  [<ffffffff812412ae>] acpi_bus_add+0x25/0x29
[  363.144212]  [<ffffffffa01b97a5>] enable_device+0x205/0x42b [acpiphp]
[  363.144219]  [<ffffffffa01b784d>] ? get_slot_status+0x4d/0xd0 [acpiphp]
[  363.144224]  [<ffffffff8123ced5>] ? acpi_os_execute_deferred+0x0/0x31
[  363.144230]  [<ffffffffa01b8630>] acpiphp_enable_slot+0xe0/0x160 [acpiphp]
[  363.144235]  [<ffffffffa01b8715>] acpiphp_check_bridge+0x65/0xf0 [acpiphp]
[  363.144241]  [<ffffffffa01b9383>] handle_hotplug_event_bridge+0x2d3/0x4d0 [acpiphp]
[  363.144253]  [<ffffffff81003330>] ? ptregscall_common+0x0/0x40
[  363.144260]  [<ffffffff8125b9ca>] ? acpi_get_data+0x5e/0x70
[  363.144264]  [<ffffffff8123f2fb>] ? acpi_bus_get_device+0x2a/0x71
[  363.144269]  [<ffffffff81223fb9>] pci_acpi_event_fn+0x49/0xa0
[  363.144278]  [<ffffffff8124fa3e>] acpi_ev_notify_dispatch+0x5f/0x6d
[  363.144282]  [<ffffffff8123cef9>] acpi_os_execute_deferred+0x24/0x31
[  363.144292]  [<ffffffff8106d709>] worker_thread+0x189/0x260
[  363.144299]  [<ffffffff81071d90>] ? autoremove_wake_function+0x0/0x40
[  363.144303]  [<ffffffff8106d580>] ? worker_thread+0x0/0x260
[  363.144308]  [<ffffffff810717c6>] kthread+0x96/0xa0
[  363.144313]  [<ffffffff81003dc4>] kernel_thread_helper+0x4/0x10
[  363.144318]  [<ffffffff81071730>] ? kthread+0x0/0xa0
[  363.144322]  [<ffffffff81003dc0>] ? kernel_thread_helper+0x0/0x10

