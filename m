Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbZLUUfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbZLUUfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 15:35:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756616AbZLUUfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 15:35:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:42890 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395AbZLUUf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 15:35:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Asynchronous suspend/resume - test results
Date: Mon, 21 Dec 2009 21:36:12 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rjw; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <Pine.LNX.4.44L0.0912211200200.2979-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912211200200.2979-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912212136.12665.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 December 2009, Alan Stern wrote:
> On Mon, 21 Dec 2009, Rafael J. Wysocki wrote:
> 
> > Hi,
> > 
> > After the Dmitry's suggestion to use PSMOUSE_CMD_RESET_DIS during suspend
> > (and analogously for atkbd), I found that it reduced the suspend time
> > significantly and changed the picture quite a bit.  For this reason I re-ran
> > the async suspend and resume tests on the nx6325 and Wind U100.
> > 
> > This time I marked the following devices as "async":
> > - all USB devices (including interfaces and endpoints)
> > - ACPI battery
> > - sd and its parent
> 
> Apparently not.  On nx6325 the sd device is 0:0:0:0, which did suspend
> in a different thread, but its parent is target0:0:0 which suspended
> and resumed in the main thread.  And its grandparent, host0, also
> suspended and resumed in the main thread.

Hmm.  I must have confused things, then.

...
> There are still some odd things going on.  Look at 
> nx6325-async-suspend-upfront-dmesg.log.  There's a peculiar gap between 
> 
> [  233.176029] call 0000:00:14.2+ returned 0 after 217543 usecs
> 
> and
> 
> [  234.059948] call 0:0:0:0+ returned 0 after 1078047 usecs
> 
> A lot of stuff could have happened during that gap, but nothing did.  
> That's because the target0:0:0 device was synchronous, and it was
> waiting for its child (the long-running async 0:0:0:0) to finish.  Not
> that it made much difference in the end, because the entire suspend
> finished about 16 ms later.  But if there was more than one disk or if
> the disk had been a USB drive, it would have mattered.
> 
> You should also make SCSI targets and hosts async.  Hosts are added in
> drivers/scsi/hosts.c:scsi_add_host_with_dma() (in 2.6.32 this was
> named scsi_add_host()).  Targets are added in
> drivers/scsi/scsi_sysfs.c:scsi_target_add().  And for thoroughness,
> SCSI devices are added in scsi_sysfs_add_sdev() in the same file.

Thanks a lot for the pointers.

Do you think it's a good idea to mark all SCSI devices as async?  Well, for
testing it probably is, but I doubt in general.

> More importantly, why did 0:0:0:0 wait almost 20 ms to begin 
> suspending?  Undoubtedly because it was blocked, waiting for some 
> unlogged synchronous device.  That's why you need to print out log 
> entries for devices without methods.  In this case it was probably a 
> class device.

OK

> Although USB host controllers aren't the longest-running devices to
> resume, they do tend to be on the longest paths.  Speeding them up
> would help.  One change you could try is in the patch below.  
> Currently when a controller has to be reset, the root hub beneath it is
> also reset and then re-suspended.  However there's no reason to suspend
> it if the PM core is only going to resume it a little bit later.  The
> patch gets rid of the unnecessary suspend.  Note: I haven't tested it.

OK, I'll try it.

Rafael

 
> Index: usb-2.6/drivers/usb/host/ohci-hub.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/host/ohci-hub.c
> +++ usb-2.6/drivers/usb/host/ohci-hub.c
> @@ -333,14 +333,12 @@ static void ohci_finish_controller_resum
>  		}
>  	}
>  
> -	/* If needed, reinitialize and suspend the root hub */
> +	/* If needed, reinitialize the root hub */
>  	if (need_reinit) {
>  		spin_lock_irq(&ohci->lock);
>  		hcd->state = HC_STATE_RESUMING;
> -		ohci_rh_resume(ohci);
> -		hcd->state = HC_STATE_QUIESCING;
> -		ohci_rh_suspend(ohci, 0);
> -		hcd->state = HC_STATE_SUSPENDED;
> +		if (ohci_rh_resume(ohci) == 0)
> +			hcd->state = HC_STATE_RUNNING;
>  		spin_unlock_irq(&ohci->lock);
>  	}
>  
> Index: usb-2.6/drivers/usb/host/uhci-hcd.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/host/uhci-hcd.c
> +++ usb-2.6/drivers/usb/host/uhci-hcd.c
> @@ -835,7 +835,6 @@ static int uhci_pci_resume(struct usb_hc
>  
>  		/* The controller had to be reset */
>  		usb_root_hub_lost_power(hcd->self.root_hub);
> -		suspend_rh(uhci, UHCI_RH_SUSPENDED);
>  	}
>  
>  	spin_unlock_irq(&uhci->lock);
> 
