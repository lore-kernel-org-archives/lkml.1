Return-Path: <linux-kernel-owner+w=401wt.eu-S1753705AbZDORGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705AbZDORGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 13:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbZDORGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 13:06:20 -0400
Received: from sj-iport-2.cisco.com ([171.71.176.71]:43157 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZDORGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 13:06:19 -0400
X-IronPort-AV: E=Sophos;i="4.40,192,1238976000"; 
   d="scan'208";a="155029297"
Date: Wed, 15 Apr 2009 10:06:17 -0700
From: VomLehn <dvomlehn@cisco.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Jeff Garzik <jeff@garzik.org>,
       Linux USB kernel mailing list <linux-usb@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: USB storage no-boot regression (bisected)
Message-ID: <20090415170617.GA14485@cuplxvomd02.corp.sa.net>
References: <Pine.LNX.4.44L0.0904151146210.3072-100000@iolanthe.rowland.org> <49E60219.9080103@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E60219.9080103@rtr.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-1; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 11:49:45AM -0400, Mark Lord wrote:
> Alan Stern wrote:
>> On Wed, 15 Apr 2009, Alan Cox wrote:
>>
>>> Why should every user suffer a slower boot and a poorer resume time ?
>>>
>>> Instead make the root fs mounting look like this
>>>
>>>
>>> 	while(my_rootfs_hasnt_appeared_and_i_am_sad()) {
>>> 		wait_on(&new_disk_discovery);
>>> 	}
>>>
>>> and poke the queue whenever we add a relevant device.
>>>
>>> That way if you are booting off an initrd you can finish the SATA probe
>>> in parallel to getting userspace ticking over.
>>>
>>> On what is nowdays essentially a hot plug system it all needs turning
>>> this way up - eg RAID volumes should assemble and come online as the
>>> drives are discovered not at some fixed point later in userspace.
>>
>> Indeed, something like this should also be used for  
>> resume-from-hibernation, to wait for the swap device.
> ..
>
> It just needs a way to set a finite timeout, so that server room
> equipment can auto-panic-reboot and try again if a device has died.

The problem with USB root devices is the same one I brought up a couple of
weeks ago--faster booting means that USB boot devices fail. We now have
problems with three different classes of devices:

o	Disks
o	Network devices
o	Serial consoles

Saying that we were "lucky" that things worked before is no help and
you should be aware that it ticks people off. I agree that this is not a
USB problem, but there is a *very* real problem:

     The work to decrease boot time has exposed race conditions that
     always existed, but are now making the kernel less usable.

So, instead of spending time denying that there is a USB problem, let's
focus on solve the boot device synchronization problem.  I have already
posted a (probably incomplete, possibly wrong) patch to synchronize console
initialization. We need to do the same for other boot devices, too.

David VomLehn
