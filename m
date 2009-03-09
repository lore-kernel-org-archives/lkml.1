Return-Path: <linux-kernel-owner+w=401wt.eu-S1752521AbZCIPH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbZCIPH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 11:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751199AbZCIPHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 11:07:15 -0400
Received: from kroah.org ([198.145.64.141]:53400 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750883AbZCIPHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 11:07:14 -0400
Date: Mon, 9 Mar 2009 08:04:53 -0700
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>, kay.sievers@vrfy.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: kobj refcounting weirdness
Message-ID: <20090309150453.GB7627@kroah.com>
References: <20090309063654.GB23137@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090309063654.GB23137@ldl.fc.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 12:36:54AM -0600, Alex Chiang wrote:
> Hi Kay, Greg,
> 
> I've been working on this patch series recently that adds
> function and device level hotplug into the PCI core:
> 
> 	http://thread.gmane.org/gmane.linux.kernel.pci/3495
> 
> For the last two weeks, I've been beating my head against a
> refcounting/kobject problem, and was hoping you could give me
> some advice, since I seem to have run into a wall.
> 
> My test case has been removing device 0000:04:00.0, which should
> remove all the devices below it.

You are removing the children before the parent device, right?  If not,
you have to be _very_ careful (personally, I don't think you should be
allowed to do that, but others, like the scsi developers, like doing
things like this...)

>  +-[0000:03]---00.0-[0000:04-07]----00.0-[0000:05-07]--+-02.0-[0000:06]--+-00.0  Intel Corporation 82571EB Quad Port Gigabit Mezzanine Adapter
>  |                                                     |                 \-00.1  Intel Corporation 82571EB Quad Port Gigabit Mezzanine Adapter
>  |                                                     \-04.0-[0000:07]--+-00.0  Intel Corporation 82571EB Quad Port Gigabit Mezzanine Adapter
>  |                                                                       \-00.1  Intel Corporation 82571EB Quad Port Gigabit Mezzanine Adapter
> 
> I can remove the device and rescan the bus once, and it works
> fine. The second removal works fine, and then, unpredictably,
> later rescan/remove cycles eventually end up producing a warning
> and oops every time. Sometimes I die on the 2nd rescan, sometimes
> not until the 4th or 5th remove/rescan cycle.

What is the warning and oops?

> In this data set, I turned on kobject debugging, and managed to
> capture a trace where we die on the 2nd rescan.
> 
> In this data set, we:
> 
> 	- create a kobject for 0000:04:00.0 (e00000018cac2920)
> 	- remove the device
> 	- observe '0000:04:00.0' (e00000018cac2920): calling ktype release
> 	- rescan the bus
> 	- discover that e00000018cac2920 is still hanging around!

What do you mean by "rescan"?  And sure, if you create a new device, it
could be allocated at the same location, that's what the slab allocators
do, right?

Can you provide the full debug log that shows the problem?

thanks,

greg k-h
