Return-Path: <linux-kernel-owner+w=401wt.eu-S932129AbXCFUyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129AbXCFUyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 15:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932130AbXCFUyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 15:54:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45201 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129AbXCFUyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 15:54:19 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: vgoyal@in.ibm.com
Subject: Re: BUG() during suspend to disk (2.6.21-rc2, x86_64)
Date: Tue, 6 Mar 2007 21:56:46 +0100
User-Agent: KMail/1.9.5
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Andi Kleen <ak@suse.de>
References: <20070306103247.GA11002@in.ibm.com>
In-Reply-To: <20070306103247.GA11002@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703062156.46905.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday, 6 March 2007 11:32, Vivek Goyal wrote:
> Hi,
> 
> I see following BUG() on serial console while hibernating on a x86_64
> machine. I am using 2.6.21-rc2 kernel.

I see it too.
 
> BUG: at arch/x86_64/kernel/acpi/sleep.c:70 init_low_mapping()
> 
> Call Trace:
>  [<ffffffff80214b9a>] acpi_save_state_mem+0x70/0xd6
>  [<ffffffff8036e90e>] acpi_pm_enter+0x23/0xc1
>  [<ffffffff8024eec4>] pm_suspend_disk+0x1ac/0x228
>  [<ffffffff8024dc9b>] enter_state+0x50/0x1e6
>  [<ffffffff8036ecce>] acpi_system_write_sleep+0x5c/0x79
>  [<ffffffff8027b767>] vfs_write+0xad/0x136
>  [<ffffffff8027bca4>] sys_write+0x45/0x6e
>  [<ffffffff80209bbe>] system_call+0x7e/0x83

Hm, it doesn't like the fact that nonboot CPUs are online at that point, but
we don't do anything to disable them.  Should we?

I think the appended patch might work.

Rafael

---
 kernel/power/disk.c |    1 +
 kernel/power/user.c |    1 +
 2 files changed, 2 insertions(+)

Index: linux-2.6.21-rc2/kernel/power/disk.c
===================================================================
--- linux-2.6.21-rc2.orig/kernel/power/disk.c
+++ linux-2.6.21-rc2/kernel/power/disk.c
@@ -61,6 +61,7 @@ static void power_down(suspend_disk_meth
 	switch(mode) {
 	case PM_DISK_PLATFORM:
 		if (pm_ops && pm_ops->enter) {
+			disable_nonboot_cpus();
 			kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
 			pm_ops->enter(PM_SUSPEND_DISK);
 			break;
Index: linux-2.6.21-rc2/kernel/power/user.c
===================================================================
--- linux-2.6.21-rc2.orig/kernel/power/user.c
+++ linux-2.6.21-rc2/kernel/power/user.c
@@ -398,6 +398,7 @@ static int snapshot_ioctl(struct inode *
 
 		case PMOPS_ENTER:
 			if (data->platform_suspend) {
+				disable_nonboot_cpus();
 				kernel_shutdown_prepare(SYSTEM_SUSPEND_DISK);
 				error = pm_ops->enter(PM_SUSPEND_DISK);
 				error = 0;
