Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbZG1TZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbZG1TZ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbZG1TZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:25:56 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:17951 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbZG1TZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:25:55 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Tiago Vignatti <tiago.vignatti@nokia.com>
Subject: Re: [PATCH 2/3] vga: drops a documentation regarding the VGA arbiter
Date: Tue, 28 Jul 2009 13:25:50 -0600
User-Agent: KMail/1.9.10
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1247759311-6254-1-git-send-email-tiago.vignatti@nokia.com> <1247759311-6254-2-git-send-email-tiago.vignatti@nokia.com> <1247759311-6254-3-git-send-email-tiago.vignatti@nokia.com>
In-Reply-To: <1247759311-6254-3-git-send-email-tiago.vignatti@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907281325.51077.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 July 2009 09:48:30 am Tiago Vignatti wrote:
> Signed-off-by: Tiago Vignatti <tiago.vignatti@nokia.com>
> ---
>  Documentation/vgaarbiter.txt |  197 ++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 197 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/vgaarbiter.txt

I think the documentation update should be part of the same patch
that adds the functionality.  Then the docs will always match
the code.

Bjorn

> diff --git a/Documentation/vgaarbiter.txt b/Documentation/vgaarbiter.txt
> new file mode 100644
> index 0000000..37d3126
> --- /dev/null
> +++ b/Documentation/vgaarbiter.txt
> @@ -0,0 +1,197 @@
> +
> +VGA Arbiter
> +===========
> +
> +Graphic devices are accessed through ranges in I/O or memory space. While most
> +modern devices allow relocation of such ranges, some "Legacy" VGA devices
> +implemented on PCI will typically have the same "hard-decoded" addresses as
> +they did on ISA. For more details see "PCI Bus Binding to IEEE Std 1275-1994
> +Standard for Boot (Initialization Configuration) Firmware Revision 2.1"
> +Section 7, Legacy Devices.
> +
> +The Resource Access Control (RAC) module inside the X server currently does
> +the task of arbitration when more than one legacy device co-exists on the same
> +machine. But the problem happens when these devices are trying to be accessed
> +by different userspace clients (e.g. two server in parallel). Their address
> +assignments conflict. Therefore an arbitration scheme _outside_ of the X
> +server is needed to control the sharing of these resources. This document
> +introduces the operation of the VGA arbiter implemented for Linux kernel.
> +
> +----------------------------------------------------------------------------
> +
> +I.  Details and Theory of Operation
> +        I.1 vgaarb
> +        I.2 libpciaccess
> +        I.3 xf86VGAArbiter (X server implementation)
> +II. Open Issues / Bugs
> +III.Credits
> +VI. References
> +
> +
> +I. Details and Theory of Operation
> +==================================
> +
> +I.1 vgaarb
> +----------
> +
> +The vgaarb is a module of the Linux Kernel. When it is initially loaded, it
> +scans all PCI devices and add the VGA ones inside the arbitration. The arbiter
> +then enables/disables the decoding of VGA legacy instructions by different
> +devices which are trying to use them on the same machine. The device which
> +does not want/need to use the arbiter may explicitly tell it by calling
> +vga_arb_decodes() from the VGA library function. Driver must take a special
> +care here.
> +
> +Basically the kernel exports a char device interface (/dev/vga_arbiter) to the
> +clients. It has the usual semantics:
> +
> + open       : open user instance of the arbiter. By default, it's attached to
> +              the default VGA device of the system.
> +
> + close      : close user instance. Release locks made by the user
> +
> + read       : return a string indicating the status of the target like:
> +
> +              "<card_ID>,decodes=<io_state>,owns=<io_state>,locks=<io_state> (ic,mc)"
> +
> +              An IO state string is of the form {io,mem,io+mem,none}, mc and
> +              ic are respectively mem and io lock counts (for debugging/
> +              diagnostic only). "decodes" indicate what the card currently
> +              decodes, "owns" indicates what is currently enabled on it, and
> +              "locks" indicates what is locked by this card. If the card is
> +              unplugged, we get "invalid" then for card_ID and an -ENODEV
> +              error is returned for any command until a new card is targeted.
> +
> +
> + write       : write a command to the arbiter. List of commands:
> +
> +  target <card_ID>   : switch target to card <card_ID> (see below)
> +  lock <io_state>    : acquires locks on target ("none" is an invalid io_state)
> +  trylock <io_state> : non-blocking acquire locks on target (returns EBUSY if
> +                       unsuccessful)
> +  unlock <io_state>  : release locks on target
> +  unlock all         : release all locks on target held by this user (not
> +                       implemented yet)
> +  decodes <io_state> : set the legacy decoding attributes for the card
> +
> +  poll               : event if something changes on any card (not just the
> +                       target)
> +
> +  card_ID is of the form "PCI:domain:bus:dev.fn". It can be set to "default"
> +  to go back to the system default card (TODO: not implemented yet). Currently,
> +  only PCI is supported as a prefix, but the userland API may support other bus
> +  types in the future, even if the current kernel implementation doesn't.
> +
> +Note about locks:
> +
> +The driver keeps track of which user has which locks on which card. It
> +supports stacking, like the kernel one. This complexifies the implementation
> +a bit, but makes the arbiter more tolerant to user space problems and able
> +to properly cleanup in all cases when a process dies.
> +Currently, a max of 16 cards can have locks simultaneously issued from
> +user space for a given user (file descriptor instance) of the arbiter.
> +
> +If the device is hot-{un,}plugged, there is a hook inside the module to notify
> +them being added/removed in the system and automatically added/removed in
> +the arbiter.
> +
> +There's also a in-kernel API of the arbiter in the case of DRM, vgacon and
> +others which may use the arbiter.
> +
> +
> +I.2 libpciaccess
> +----------------
> +
> +To use the vga arbiter char device it was implemented a serie of functions
> +inside the pciaccess library. Two fields were added to struct pci_device for
> +this be possible:
> +
> +    /* the type of resource decoded by the device */
> +    int vgaarb_rsrc;
> +    /* the file descriptor (/dev/vga_arbiter) */
> +    int vgaarb_fd;
> +
> +
> +and the functions:
> +
> +These functions below acquire VGA resources for the given card and mark those
> +resources as locked. If the resources requested are "normal" (and not legacy)
> +resources, the arbiter will first check whether the card is doing legacy
> +decoding for that type of resource. If yes, the lock is "converted" into a
> +legacy resource lock. The arbiter will first look for all VGA cards that
> +might conflict and disable their IOs and/or Memory access, including VGA
> +forwarding on P2P bridges if necessary, so that the requested resources can
> +be used. Then, the card is marked as locking these resources and the IO and/or
> +Memory access is enabled on the card (including VGA forwarding on parent
> +P2P bridges if any). In the case of vga_arb_lock(), the function will block
> +if some conflicting card is already locking one of the required resources (or
> +any resource on a different bus segment, since P2P bridges don't differentiate
> +VGA memory and IO afaik). If the card already owns the resources, the function
> +succeeds.  vga_arb_trylock() will return (-EBUSY) instead of blocking. Nested
> +calls are supported (a per-resource counter is maintained).
> +
> +
> +Set the target device of this client.
> +    int  pci_device_vgaarb_set_target   (struct pci_device *dev);
> +
> +
> +For instance, in x86 if two devices on the same bus want to lock different
> +resources, both will succeed (lock). If devices are in different buses and
> +trying to lock different resources, only the first who tried succeeds.
> +    int  pci_device_vgaarb_lock         (struct pci_device *dev);
> +    int  pci_device_vgaarb_trylock      (struct pci_device *dev);
> +
> +Unlock resources of device.
> +    int  pci_device_vgaarb_unlock       (struct pci_device *dev);
> +
> +Indicates to the arbiter if the card decodes legacy VGA IOs, legacy VGA
> +Memory, both, or none. All cards default to both, the card driver (fbdev for
> +example) should tell the arbiter if it has disabled legacy decoding, so the
> +card can be left out of the arbitration process (and can be safe to take
> +interrupts at any time.
> +    int  pci_device_vgaarb_decodes      (struct pci_device *dev);
> +
> +Connects to the arbiter device, allocates the struct
> +    int  pci_device_vgaarb_init         (struct pci_device *dev);
> +
> +Close the connection
> +    void pci_device_vgaarb_fini         (struct pci_device *dev);
> +
> +
> +I.3 xf86VGAArbiter (X server implementation)
> +--------------------------------------------
> +
> +(TODO)
> +
> +This work will probably remove the RAC (Resource Access Control) code inside
> +Xorg DDX. Complain: RAC is non-OS dependent. VGA Arbiter is.
> +
> +
> +II. Open Issues / Bugs
> +======================
> +
> +Current status:
> +    - two X servers is parallel works (multiseat style)
> +    - non-bottable card works
> +    - secondary card works
> +    - xinemara-like _doesn't_ works (need to trace more paths paths that touch
> +      the registers and bracket with lock/unlock)
> +
> +
> +III. Credits
> +===========
> +
> +Benjamin Herrenschmidt (IBM?) started this work when he discussed such design
> +with the Xorg community in 2005 [1, 2]. In the end of 2007, Paulo Zanoni and
> +Tiago Vignatti (both of C3SL/Federal University of Paraná) proceeded his work
> +enhancing the kernel code to adapt as a kernel module and also did the
> +implementation of the user space side [3]. Now (2009) Tiago Vignatti is
> +finally trying to push such work upstream.
> +
> +
> +VI. References
> +==============
> +
> +[1] http://lists.freedesktop.org/archives/xorg/2005-March/006663.html
> +[2] http://lists.freedesktop.org/archives/xorg/2005-March/006745.html
> +[3] http://lists.freedesktop.org/archives/xorg/2007-October/029507.html


