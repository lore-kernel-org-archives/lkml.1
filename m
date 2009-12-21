Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbZLUUK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbZLUUK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 15:10:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbZLUUK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 15:10:27 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:33562 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755645AbZLUUK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 15:10:27 -0500
Date: Mon, 21 Dec 2009 15:10:25 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [RFC] Asynchronous suspend/resume - test results
In-Reply-To: <200912210140.19713.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0912211200200.2979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Dec 2009, Rafael J. Wysocki wrote:

> Hi,
> 
> After the Dmitry's suggestion to use PSMOUSE_CMD_RESET_DIS during suspend
> (and analogously for atkbd), I found that it reduced the suspend time
> significantly and changed the picture quite a bit.  For this reason I re-ran
> the async suspend and resume tests on the nx6325 and Wind U100.
> 
> This time I marked the following devices as "async":
> - all USB devices (including interfaces and endpoints)
> - ACPI battery
> - sd and its parent

Apparently not.  On nx6325 the sd device is 0:0:0:0, which did suspend
in a different thread, but its parent is target0:0:0 which suspended
and resumed in the main thread.  And its grandparent, host0, also
suspended and resumed in the main thread.

> - serio and i8042
> - all PCI devices (including bridges)
> for all tests (except for the sync suspend/resume test).
> 
> The results are as follows (all times in milliseconds):
> 
> 			HP nx6325	MSI Wind U100
> 
> sync suspend		1391 (+/- 32)	 703 (+/- 26)
> sync resume		3027 (+/- 6)	3562 (+/- 25)
> 
> async suspend		1306 (+/- 66)	 659 (+/- 22)
> async resume		2809 (+/- 250)	3564 (+/- 35)
> 
> async "upfront" suspend	1038 (+/- 46)	 564 (+/- 50)
> async "upfront" resume	1783 (+/- 7)	1925 (+/- 41)
> 
> where the "upfront" versions are with all of the async threads started in an
> additional loop over dpm_list before the main "sync" suspend/resume loop.
> 
> The raw data are at:
> 
> http://www.sisk.pl/kernel/data/async-suspend-new.pdf
> http://www.sisk.pl/kernel/data/nx6325/
> http://www.sisk.pl/kernel/data/wind/
> 
> (hopefully this time I didn't make mistakes in the file names).
> 
> The data seem to suggest that "normal" async suspend and resume may be a little
> (10% - 20%) faster than sync suspend and resume, but not as much as the
> versions where all of the async threads had been started before the main
> suspend (resume) thread began handling the "sync" devices.
> 
> IMO it also is worth noting that the "async upfront suspend" time on the Wind
> is pretty close to the suspend time of the slowest device (~ .5 s).  The same
> applies to the "async upfront resume" time on the Wind (the slowest device
> resumes in ~1.5 s) and the "async upfront suspend" time on the nx6325 (the
> slowest device suspends in ~1 s).  So, it looks like with the above set of
> async devices we can approach pretty close to the achievable limit on both
> test boxes.
> 
> I'm not sure what the next step should be at this point.  To me, the picture is
> quite clear now, but perhaps we ought to run more tests on some other machines
> or something.  Please let me know what you think.

There are still some odd things going on.  Look at 
nx6325-async-suspend-upfront-dmesg.log.  There's a peculiar gap between 

[  233.176029] call 0000:00:14.2+ returned 0 after 217543 usecs

and

[  234.059948] call 0:0:0:0+ returned 0 after 1078047 usecs

A lot of stuff could have happened during that gap, but nothing did.  
That's because the target0:0:0 device was synchronous, and it was
waiting for its child (the long-running async 0:0:0:0) to finish.  Not
that it made much difference in the end, because the entire suspend
finished about 16 ms later.  But if there was more than one disk or if
the disk had been a USB drive, it would have mattered.

You should also make SCSI targets and hosts async.  Hosts are added in
drivers/scsi/hosts.c:scsi_add_host_with_dma() (in 2.6.32 this was
named scsi_add_host()).  Targets are added in
drivers/scsi/scsi_sysfs.c:scsi_target_add().  And for thoroughness,
SCSI devices are added in scsi_sysfs_add_sdev() in the same file.

More importantly, why did 0:0:0:0 wait almost 20 ms to begin 
suspending?  Undoubtedly because it was blocked, waiting for some 
unlogged synchronous device.  That's why you need to print out log 
entries for devices without methods.  In this case it was probably a 
class device.

Although USB host controllers aren't the longest-running devices to
resume, they do tend to be on the longest paths.  Speeding them up
would help.  One change you could try is in the patch below.  
Currently when a controller has to be reset, the root hub beneath it is
also reset and then re-suspended.  However there's no reason to suspend
it if the PM core is only going to resume it a little bit later.  The
patch gets rid of the unnecessary suspend.  Note: I haven't tested it.

Alan Stern


Index: usb-2.6/drivers/usb/host/ohci-hub.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ohci-hub.c
+++ usb-2.6/drivers/usb/host/ohci-hub.c
@@ -333,14 +333,12 @@ static void ohci_finish_controller_resum
 		}
 	}
 
-	/* If needed, reinitialize and suspend the root hub */
+	/* If needed, reinitialize the root hub */
 	if (need_reinit) {
 		spin_lock_irq(&ohci->lock);
 		hcd->state = HC_STATE_RESUMING;
-		ohci_rh_resume(ohci);
-		hcd->state = HC_STATE_QUIESCING;
-		ohci_rh_suspend(ohci, 0);
-		hcd->state = HC_STATE_SUSPENDED;
+		if (ohci_rh_resume(ohci) == 0)
+			hcd->state = HC_STATE_RUNNING;
 		spin_unlock_irq(&ohci->lock);
 	}
 
Index: usb-2.6/drivers/usb/host/uhci-hcd.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/uhci-hcd.c
+++ usb-2.6/drivers/usb/host/uhci-hcd.c
@@ -835,7 +835,6 @@ static int uhci_pci_resume(struct usb_hc
 
 		/* The controller had to be reset */
 		usb_root_hub_lost_power(hcd->self.root_hub);
-		suspend_rh(uhci, UHCI_RH_SUSPENDED);
 	}
 
 	spin_unlock_irq(&uhci->lock);

