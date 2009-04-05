Return-Path: <linux-kernel-owner+w=401wt.eu-S1756826AbZDETcj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826AbZDETcj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 15:32:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbZDETcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 15:32:24 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:56889 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231AbZDETcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 15:32:23 -0400
Date: Sun, 5 Apr 2009 21:34:23 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Alex Chiang <achiang@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [git pull] PCI changes for 2.6.30
Message-ID: <20090405193423.GB24374@uranus.ravnborg.org>
References: <20090331121331.3673cf59@hobbes> <alpine.LFD.2.00.0904010957520.4130@localhost.localdomain> <20090401101309.67d0bea5@hobbes> <20090401183749.GC8188@ldl.fc.hp.com> <20090401191220.GB29673@uranus.ravnborg.org> <20090401222310.GA31290@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401222310.GA31290@ldl.fc.hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 01, 2009 at 04:23:10PM -0600, Alex Chiang wrote:
> * Sam Ravnborg <sam@ravnborg.org>:
> > On Wed, Apr 01, 2009 at 12:37:49PM -0600, Alex Chiang wrote:
> > > * Jesse Barnes <jbarnes@virtuousgeek.org>:
> > > > On Wed, 1 Apr 2009 10:01:12 -0700 (PDT)
> > > > Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > > > > On Tue, 31 Mar 2009, Jesse Barnes wrote:
> > > > > >
> > > > > > Please consider pulling my PCI tree from
> > > > > >   git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6
> > > > > > linux-next
> > > > > 
> > > > > This produces
> > > > > 
> > > > >   WARNING: drivers/built-in.o(.text+0x69a1): Section mismatch in
> > > > > reference from the function dev_rescan_store() to the
> > > > > function .devinit.text:pci_rescan_bus() The function
> > > > > dev_rescan_store() references the function __devinit
> > > > > pci_rescan_bus(). This is often because dev_rescan_store lacks a
> > > > > __devinit annotation or the annotation of pci_rescan_bus is wrong.
> > > > > 
> > > > > Hmm?
> > > > 
> > > > Arg how did I miss that?  Maybe the last build I did was missing
> > > > hotplug support or something... Anyway looking now (at first glance I
> > > > think pci_rescan_bus needs to drop __devinit).
> > > 
> > > This was my fault. pci_rescan_bus() definitely does not want
> > > __devinit.
> > > 
> > > But I'm confused -- didn't we used to have an option in
> > > menuconfig under Kernel Hacking that would turn on section
> > > mismatch warnings? I used to have that turned on, and don't
> > > remember turning it off, and I can't find it now.
> > > 
> > > I'm told that we're supposed to set it on the make command line,
> > > like:
> > > 
> > > 	make CONFIG_DEBUG_SECTION_MISMATCH=y -j16
> > > 
> > > or something. Has this changed recently or am I just imagining
> > > things (or just plain stupid?)
> > 
> > That was maybe one year ago we had it in menuconfig.
> > When I get on top of things I will enable it and try to
> > help fixing the remaining warnings.
> 
> Ah, ok.
> 
> > I have resisted enabling it for now as I cannot support the people
> > that see the warnings atm.
> 
> Nod, makes sense.
> 
> I took a look at the warning that Linus mentioned, and I'm not
> entirely sure how to fix it. The problem is this:
> 
> http://git.kernel.org/?p=linux/kernel/git/jbarnes/pci-2.6.git;a=commit;h=3ed4fd96b3188406ac5357d9290bcffa08c65cf6
> 
> I initially annoted pci_rescan_bus as __devinit, which it
> shouldn't have. Removing the annotation though, produces these
> other warnings:
> 
> WARNING: vmlinux.o(.text+0x1b9be6): Section mismatch in reference from the function pci_rescan_bus() to the function .devinit.text:pci_scan_child_bus()
> The function pci_rescan_bus() references
> the function __devinit pci_scan_child_bus().
> This is often because pci_rescan_bus lacks a __devinit 
> annotation or the annotation of pci_scan_child_bus is wrong.
> 
> Reading through Documentation/PCI/pci.txt says that under
> CONFIG_HOTPLUG, __devinit should be a nop?
The documentation is not up-to-date in this respect.

Annotating a function __devinit will no matter the configuration
locate the code in a section named .devinit.text

We then postprocess this section for illegal references using modpost.

The PCI_HOTPLUG code has often been troublesome with respect to these checks
as this code is only relevant if CONFIG_HOTPLUG is enabled
and will often not even be included in the kernel if not enabled.
This is true for pci_rescan_bus() for example.

And we would like to export these symbols too. But we do not allow exported
symbols to be annotated __devinit as this code will be blown away in some configurations.

So the correct solution which you also used in your patch is to tell
modpost to ignore references to *init sections from this specific funtion
as they are OK.

	Sam
