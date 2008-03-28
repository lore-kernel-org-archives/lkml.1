Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbYC1CNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbYC1CNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754568AbYC1CNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:13:37 -0400
Received: from rtr.ca ([76.10.145.34]:2775 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbYC1CNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:13:36 -0400
Message-ID: <47EC544E.7090806@rtr.ca>
Date: Thu, 27 Mar 2008 22:13:34 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: jkosina@suse.cz, Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, Pavel Machek <pavel@suse.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.25-rc7:  Ugh.
References: <47EBBD57.30902@rtr.ca> <20080327160700.GB828@suse.de> <47EC53B8.2050601@rtr.ca>
In-Reply-To: <47EC53B8.2050601@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Greg KH wrote:
>> On Thu, Mar 27, 2008 at 11:29:27AM -0400, Mark Lord wrote:
>>> It is with great reluctance when I attempt moving my main "desktop"
>>> over to a new kernel version -- because the USB subsystem seems to
>>> break every single time.
>>
>> That's not good, why not tell the linux-usb developers this?  (added to
>> the cc:)
>>
>>> So today I tried 2.6.25-rc7 on it for the first time.
>>> Not good.
>>>
>>> It boots, but just a simple suspend/resume (RAM) was enough to kill it.
>>> It comes back on resume, with an X desktop again,
>>> but with no USB functionality -- no mouse.
>>>
>>> The keyboard still works, so I dropped to a console and tried:
>>>
>>>   rmmod usbhid
>>>   insmod usbhid
>>>
>>> And the console hung at 100% CPU on the insmod.
> ..
> 
> Okay, correction there:  it just hangs the console, but not 100% CPU.
> Other tasks still continue running.
> 
> Same thing happens when I rmmod usbhid, and then rmmod ehci_hcd.
> The rmmod ehci_hcd hangs.
> 
> But since the rest of the system is still alive, including the non-USB 
> touchpad(!),
> here is the alt-sysrq-t from syslog:
> 
> rmmod         D f74c2ddc     0  4538   4492
>       f6d3b200 00000086 f74c2c90 f74c2ddc c281e840 00000001 c01131be 
> 00000000       00000001 c0324a00 c0324a00 00000000 00000001 7fffffff 
> 7fffffff f653cea8       00000002 c02906f8 00000000 00000012 c038f6aa 
> 00000086 c011aa05 00000000 Call Trace:
> [__wake_up_common+46/88] __wake_up_common+0x2e/0x58
> [schedule_timeout+19/134] schedule_timeout+0x13/0x86
> [wake_up_klogd+43/45] wake_up_klogd+0x2b/0x2d
> [wait_for_common+205/308] wait_for_common+0xcd/0x134
> [default_wake_function+0/8] default_wake_function+0x0/0x8
> [__cancel_work_timer+237/312] __cancel_work_timer+0xed/0x138
> [wq_barrier_func+0/8] wq_barrier_func+0x0/0x8
> [<f889f684>] usb_remove_hcd+0x63/0xd7 [usbcore]
> [<f88a858e>] usb_hcd_pci_remove+0x15/0x68 [usbcore]
> [pci_device_remove+22/53] pci_device_remove+0x16/0x35
> [__device_release_driver+88/118] __device_release_driver+0x58/0x76
> [driver_detach+122/182] driver_detach+0x7a/0xb6
> [bus_remove_driver+96/126] bus_remove_driver+0x60/0x7e
> [pci_unregister_driver+30/95] pci_unregister_driver+0x1e/0x5f
> [sys_delete_module+388/445] sys_delete_module+0x184/0x1bd
> [remove_vma+49/54] remove_vma+0x31/0x36
> [do_page_fault+506/1232] do_page_fault+0x1fa/0x4d0
> [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
> =======================
> 
> If nothing else, this should point to where USB is getting deadlocked.
..

Oh, I also had a hung "lsusb" in another window at the same time:

lsusb         D f74c187c     0  4491   4397
       f6d3bc80 00000082 f74c1730 f74c187c c2816840 00000000 c26cb440 f666bab8 
       00000003 c014b132 00000000 00000000 00000000 f75c1114 00000246 f75c111c 
       f74c1730 c0291678 00000001 f74c1730 c01156bc f75c1120 f77e5f78 f75c1000 
Call Trace:
 [handle_mm_fault+1205/1222] handle_mm_fault+0x4b5/0x4c6
 [__down+194/212] __down+0xc2/0xd4
 [default_wake_function+0/8] default_wake_function+0x0/0x8
 [__down_failed+7/12] __down_failed+0x7/0xc
 [<f88a70a0>] usbdev_ioctl+0x42/0x1132 [usbcore]
 [dput+22/197] dput+0x16/0xc5
 [__link_path_walk+2664/2969] __link_path_walk+0xa68/0xb99
 [mntput_no_expire+17/92] mntput_no_expire+0x11/0x5c
 [path_walk+144/152] path_walk+0x90/0x98
 [klist_del+24/59] klist_del+0x18/0x3b
 [klist_iter_exit+15/24] klist_iter_exit+0xf/0x18
 [bus_find_device+87/97] bus_find_device+0x57/0x61
 [kobject_get+15/19] kobject_get+0xf/0x13
 [get_device+14/20] get_device+0xe/0x14
 [<f889c29e>] usb_get_dev+0xf/0x13 [usbcore]
 [<f88a6d9c>] usbdev_open+0x13c/0x144 [usbcore]
 [chrdev_open+312/373] chrdev_open+0x138/0x175
 [open_namei+582/1357] open_namei+0x246/0x54d
 [chrdev_open+0/373] chrdev_open+0x0/0x175
 [__dentry_open+263/404] __dentry_open+0x107/0x194
 [nameidata_to_filp+28/44] nameidata_to_filp+0x1c/0x2c
 [do_filp_open+43/49] do_filp_open+0x2b/0x31
 [vfs_ioctl+71/93] vfs_ioctl+0x47/0x5d
 [do_vfs_ioctl+555/574] do_vfs_ioctl+0x22b/0x23e
 [sys_ioctl+44/69] sys_ioctl+0x2c/0x45
 [sysenter_past_esp+95/133] sysenter_past_esp+0x5f/0x85
 [schedule+53/1498] schedule+0x35/0x5da
 =======================
