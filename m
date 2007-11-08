Return-Path: <linux-kernel-owner+w=401wt.eu-S1760072AbXKHJSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072AbXKHJSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 04:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbXKHJSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 04:18:10 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753541AbXKHJSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 04:18:08 -0500
Message-ID: <4732D439.3020703@redhat.com>
Date: Thu, 08 Nov 2007 10:17:45 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
CC: Gregory Haskins <gregory.haskins.ml@gmail.com>,
       Anthony Liguori <aliguori@us.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Dor Laor <dor.laor@qumranet.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Use of virtio device IDs
References: <4730A15A.6070001@us.ibm.com> <4730B753.2000901@us.ibm.com> <4731334A.6090405@gmail.com> <47314FBD.1070505@qumranet.com> <47322262.8000101@gmail.com> <4732AE9A.4070701@qumranet.com>
In-Reply-To: <4732AE9A.4070701@qumranet.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>> You are
>> probably better off designing something that is PV specific instead of
>> shoehorning it in to fit a different model (at least for the things I
>> have in mind).  
> 
> Well, if we design our pv devices to look like hardware, they will fit
> quite well.  Both to the guest OS and to user's expectations.

Disclaimer: Havn't looked at the virtio code much.

I think we should keep the door open for both models and don't nail the
 virtio infrastructure to one of them.

For pure pv devices I don't see the point in trying to squeeze it into
the PCI model.  Also s390 has no PCI, so there effecticely is no way
around that, we must be able have some pure virtual bus like xenbus.

IMHO the PCI model is most useful for emulated devices with a optional
pv path.  Say the usual emulated piix3 IDE controller, give it an
additional pv mode, so the guest can drive it in pv mode if it knows
about it, and use the generic piix ide driver if it doesn't.  That kind
of devices we probably want identify by pci subsystem id.

>> Its not a heck of a lot of code to write a pv-centric
>> version of these facilities.
> 
> It is.  Especially if you consider Windows and a gazillion versions of
> deployed, non-pv-capable Linux systems.  For pv-friendly newer Linux,
> it's probably doable, but why?
> 
> Look at the mess Xen finds itself in.

Uhm, well, yea.  Guess you are refering to the pv-on-hvm drivers.  Been
there, dealt with it.  What exactly do you think is messy there?

IMHO the most messy thing is the boot problem.  hvm bios can't deal with
pv disks, so you can't boot with pv disks only.  "fixed" by having the
(boot) disk twice in the system, once via emulated ide, once as pv disk.
 Ouch.

Other than that I don't see major problems with the virtual bus model.

> It's "necessary" in a pragmatic sense: we want to deliver drivers that
> provide features for a wide variety of guests in a reasonable
> timeframe.  And that means no rewriting guest OS infrastructure.

At least for any udev-based linux distro there is no need to rewrite any
guest os infrastructure.  Your virtual bus driver needs a proper uevent
callback, the virtual device drivers a module alias, and you are done.
udev autoloads your virtual device driver modules nicely, without any
distro tool hacking or config file writing ...

cheers,
  Gerd

