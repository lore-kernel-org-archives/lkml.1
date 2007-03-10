Return-Path: <linux-kernel-owner+w=401wt.eu-S932691AbXCJKJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691AbXCJKJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 05:09:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933454AbXCJKJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 05:09:43 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39790 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932691AbXCJKJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 05:09:41 -0500
Date: Sat, 10 Mar 2007 02:09:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: 2.6.21-rc3-mm2 (+hotfixes) -- BUG: atomic counter underflow at:
 [<c0104d40>] show_trace_log_lvl+0x1a/0x2f
Message-Id: <20070310020934.bba024ee.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0703100126i5139994r1d566b6aedac263a@mail.gmail.com>
References: <a44ae5cd0703100126i5139994r1d566b6aedac263a@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, 10 Mar 2007 01:26:19 -0800 "Miles Lane" <miles.lane@gmail.com> wrote:
> [   36.623291] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network
> Driver, 1.2.0kdmprq
> [   36.623297] ipw2200: Copyright(c) 2003-2006 Intel Corporation
> [   36.623975] ACPI: PCI Interrupt 0000:01:06.0[A] -> GSI 18 (level,
> low) -> IRQ 18
> [   36.624119] ipw2200: Detected Intel PRO/Wireless 2200BG Network Connection
> [   36.624384] PM: Adding info for No Bus:0000:01:06.0
> [   36.678071] PM: Adding info for No Bus:timer
> [   36.740214] PM: Removing info for No Bus:0000:01:06.0
> [   36.861227] PM: Adding info for No Bus:eth0
> [   36.861465] ipw2200: Detected geography ZZM (11 802.11bg channels,
> 0 802.11a channels)
> [   36.907183] PM: Adding info for No Bus:seq
> [   36.970611] eth0 renamed to eth1
> 
> [  322.402321] PM: Removing info for No Bus:eth1
> [  322.513172] ACPI: PCI interrupt for device 0000:01:06.0 disabled
> [  322.516617] BUG: atomic counter underflow at:
> [  322.516623]  [<c0104d40>] show_trace_log_lvl+0x1a/0x2f
> [  322.516633]  [<c01052da>] show_trace+0x12/0x14
> [  322.516636]  [<c010535e>] dump_stack+0x16/0x18
> [  322.516640]  [<c01d201b>] kref_put+0x69/0x86
> [  322.516646]  [<c01d13fa>] kobject_put+0x14/0x16
> [  322.516650]  [<c01d153e>] kobject_unregister+0x22/0x25
> [  322.516654]  [<c02272d0>] bus_remove_driver+0x6c/0x79
> [  322.516660]  [<c0227d5b>] driver_unregister+0xb/0x18
> [  322.516664]  [<c01de0ea>] pci_unregister_driver+0x13/0x55
> [  322.516671]  [<f91bcd3d>] ipw_exit+0x1c/0x1e [ipw2200]
> [  322.516702]  [<c013ab50>] sys_delete_module+0x16e/0x196
> [  322.516708]  [<c0103da4>] syscall_call+0x7/0xb
> [  322.516711]  =======================
> [  550.060449] PM: Preparing system for mem sleep
> [  550.061431] Stopping tasks ... done.

Yup, the below patch is supposed to fix this.  But it makes the IMPI driver
lock the machine instead, and I don't think we've worked out why yet.



From: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: git-commits-head@vger.kernel.org
Subject: Revert "driver core: refcounting fix"
Date: 	Sat, 10 Mar 2007 06:59:51 GMT
Sender: git-commits-head-owner@vger.kernel.org

Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=161e232b8823e230d4fdf8064e606bbdf26f47e2
Commit:     161e232b8823e230d4fdf8064e606bbdf26f47e2
Parent:     a967e127d0233f2472af64597de3f3920872310c
Author:     Greg Kroah-Hartman <gregkh@suse.de>
AuthorDate: Fri Mar 9 15:25:04 2007 -0800
Committer:  Greg Kroah-Hartman <gregkh@suse.de>
CommitDate: Fri Mar 9 15:25:04 2007 -0800

    Revert "driver core: refcounting fix"
    
    This reverts commit 63ce18cfe685115ff8d341bae4c9204a79043cf0.
    
    It was the incorrect fix and causes a reference counting bug whenever
    any driver module is removed from the system. Mike Galbraith
    <efault@gmx.de> is looking for the real fix for his problem.
    
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/module.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index f77e893..fbc51de 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2419,12 +2419,6 @@ void module_remove_driver(struct device_driver *drv)
 			kfree(driver_name);
 		}
 	}
-	/*
-	 * Undo the additional reference we added in module_add_driver()
-	 * via kset_find_obj()
-	 */
-	if (drv->mod_name)
-		kobject_put(&drv->kobj);
 }
 EXPORT_SYMBOL(module_remove_driver);
 #endif
-
To unsubscribe from this list: send the line "unsubscribe git-commits-head" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

