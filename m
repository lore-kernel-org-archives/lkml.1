Return-Path: <linux-kernel-owner+w=401wt.eu-S1758574AbZCMCiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbZCMCiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758146AbZCMCgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:36:40 -0400
Received: from mail-ew0-f177.google.com ([209.85.219.177]:43490 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757655AbZCMCgi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:36:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=rUZQYDG4F8lH2Zb/CXSxkKpinwJ3BNZQdqJth+hTZxYt1m/AHPUgkXIoKj2L1vVsdK
         yGLQrosdJkmlefdn0brzd1FINFgGUEG3bi7E8TJb6j3cC5F6NnwneZpGSNkRK09UvYBY
         9G3jrlMUfIMmILyVBTBKd3iqISIL3EERgfBV0=
Message-ID: <49B9C6AE.5050308@gmail.com>
Date: Thu, 12 Mar 2009 20:36:30 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.alsa.devel,gmane.linux.kernel
To: "Christian P. Schmidt" <schmidt@digadd.de>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: How can PCI resource allocation fail?
References: <49B9959F.1080705@digadd.de>
In-Reply-To: <49B9959F.1080705@digadd.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian P. Schmidt wrote:
> Hi all,
> 
> I'm toying with the alsa-driver for the Creative Labs X-Fi. I'm working on the PCI Express version of this card, though, which is
> the same as the PCI version plus a PCIe to PCI bridge but has a different ID:
> 
>           +-1c.2-[0000:03-04]----00.0-[0000:04]----00.0  1102:0009
> 
> 03:00.0 PCI bridge: Creative Labs Device 7006
> 04:00.0 Audio device: Creative Labs [SB X-Fi Xtreme Audio] CA0110-IBG
> 
> Now, after adding the ID, the driver fails:
> 
> [46833.487579] CA0106 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [46833.487586] CA0106 0000:04:00.0: PCI INT A disabled
> [46833.487588] cannot allocate the port
> [46833.487594] CA0106: probe of 0000:04:00.0 failed with error -16
> 
> The actual error is occurring in
> 
> 	chip->port = pci_resource_start(pci, 0);
> 	chip->res_port = request_region(chip->port, pci_resource_len(pci,0), "snd_ca0106");
> 	if (!chip->res_port) {
> 		snd_ca0106_free(chip);
> 		printk(KERN_ERR "cannot allocate the port\n");
> 		return -EBUSY;
> 	}
> 
> This from /proc/iomem:
> 
> f9f00000-f9ffffff : PCI Bus 0000:03
>   f9f00000-f9ffffff : PCI Bus 0000:04
>     f9ffc000-f9ffffff : 0000:04:00.0
> 
> Some additional debug output tells me that the code is actually trying to allocate 16k starting from f9ffc000. What could be
> potential reasons for the failure? Do I have to do something with the bridge before I can try to request the region?

request_region is requesting IO ports. The PCI BAR on the card is MMIO 
memory, not IO ports, so request_mem_region has to be used. It's 
possible that this driver isn't set up to handle MMIO space.
