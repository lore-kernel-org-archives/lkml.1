Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab0BLLTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 06:19:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52909 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687Ab0BLLTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 06:19:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gary Hade <garyhade@us.ibm.com>
Subject: Re: [PATCH 8/9] PCI / ACPI / PM: Platform support for PCI PME wake-up (rev. 7)
Date: Fri, 12 Feb 2010 12:19:36 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc7-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Matthew Garrett <mjg@redhat.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <201001101431.38630.rjw@sisk.pl> <201002112321.13922.rjw@sisk.pl> <20100212015508.GD10298@us.ibm.com>
In-Reply-To: <20100212015508.GD10298@us.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002121219.36350.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 12 February 2010, Gary Hade wrote:
> On Thu, Feb 11, 2010 at 11:21:13PM +0100, Rafael J. Wysocki wrote:
> > On Thursday 11 February 2010, Gary Hade wrote:
> > > On Thu, Feb 11, 2010 at 09:32:02PM +0100, Rafael J. Wysocki wrote:
> > > > On Thursday 11 February 2010, Gary Hade wrote:
> > > > > On Thu, Feb 11, 2010 at 02:27:17PM +0100, Rafael J. Wysocki wrote:
> > > > > > On Thursday 11 February 2010, Gary Hade wrote:
> > > > > > > On Thu, Feb 11, 2010 at 01:56:54AM +0100, Rafael J. Wysocki wrote:
> > > > > > > > On Thursday 11 February 2010, Rafael J. Wysocki wrote:
> > > > > > > > > On Thursday 11 February 2010, Gary Hade wrote:
> > > > > > > > > > On Wed, Feb 10, 2010 at 11:58:00PM +0100, Rafael J. Wysocki wrote:
> > > > > > > > > > > On Wednesday 10 February 2010, Gary Hade wrote:
> > > > > > > > > ...
> > > > > > > > > > > > Yes, 6/9 also appeared to be the most likely suspect to me and
> > > > > > > > > > > > I was already doing what you asked except in the opposite order.
> > > > > > > > > > > > With 1/9 through 6/9 both the hot-add and hot-remove issues still
> > > > > > > > > > > > reproduced.  After removing 6/9 both issues disappeared.
> > > > > > > > > > > 
> > > > > > > > > > > Thanks for verifying, I've already started to look for bugs in it.
> > > > > > > > > > 
> > > > > > > > > > Thanks!
> > > > > > > > > > 
> > > > > > > > > > > 
> > > > > > > > > > > What's your kernel command line, BTW?
> > > > > > > > > > 
> > > > > > > > > > root=/dev/disk/by-id/scsi-35000c5000036ffcb-part7 ip=9.47.66.9:9.47.67.50:9.47.66.1:255.255.254.0 resume=/dev/disk/by-id/scsi-35000c50000370247-part3 crashkernel=256M-:128M console=tty0 console=ttyS0,115200 pci=use_crs pci=norom
> > > > > > > > > 
> > > > > > > > > Thanks.  We found a bug in the patch, but it would require you to use a
> > > > > > > > > specific command line switch to trigger, which you don't use.
> > > > > > > > > 
> > > > > > > > > I'll let you know if I have anything to test.
> > > > > > > > 
> > > > > > > > OK, please try the patch below on top of [1-6/9].
> > > > > > > 
> > > > > > > Sorry, it didn't help.  The hot-add and hot-remove behaviors
> > > > > > > still look the same.
> > > > > > 
> > > > > > Thanks for testing.
> > > > > > 
> > > > > > Well, this time I found another real bug, which is that we should add
> > > > > > gpe_block->block_base_number to the GPE index within the block in order to
> > > > > > compute the GPE number.  If there are GPE devices other than the FADT ones in
> > > > > > your system, that may explain the symptoms.
> > > > > > 
> > > > > > Please try the patch below (on top of [1-6/9]).  In case it doesn't help, please
> > > > > > look for "Failed to ebable GPE" messages in dmesg and let me know if there are
> > > > > > any.
> > > > > 
> > > > > That one worked!  It corrected both the blinking amber LED
> > > > > after hot-remove and acpiphp's failure to see the hot-add event.
> > > > 
> > > > Great!
> > > > 
> > > > > Now when you have patch(es) ready for Jesse's linux-next branch
> > > > 
> > > > Well, not quite.  I had to rework them in the meantime. ;-)
> > > > 
> > > > > I can get back to my original mission of checking out Bjorn's
> > > > > _CRS enablement changes.
> > > > 
> > > > May I still ask you to test something?
> > > 
> > > Oh, I guess so. :)
> > > 
> > > > 
> > > > In case I can, please try the appended patch on top of [1-3/6].  It is a
> > > > replacement for [4-6/9] with the last fix included.
> > > 
> > > I just tried it and it seemed to work fine.
> > 
> > Great, thanks!
> > 
> > I have one more testing request if you don't mind, but I'd like to make sure
> > the PCI runtime PM patches won't break the PCI hotplug again.
> > 
> > Please apply [7/9] (ACPI / PM: Add more run-time wake-up field) on top of the
> > just tested patch and apply the appended patch on top of that.  Then, please
> > check if the PCI hotplug still works.
> 
> There seems to be a problem.
> 
> The first time I booted I was able to successfully hot-remove
> a PCIe card and then successfully hot-add it to a different slot.
> When I tried to hot-remove a PCI-X card that was also present
> during boot I saw that lingering blinking amber LED issue.
> 
> After rebooting I tried the same thing but this time I did
> not see the lingering blinking amber LED after removing the
> PCI-X card but I did see it when removing the PCIe card.
> I then tried to hot-add the PCIe card to a different slot
> and noticed the below messages.
> 
> I don't think I will be able to try to characterize this
> better or test any more patches until Monday.  

OK, thanks for testing.

It seems we have a deadlock on pci_acpi_notify_mtx, but I'm yet to understand
the exact mechanism of it.

Rafael
