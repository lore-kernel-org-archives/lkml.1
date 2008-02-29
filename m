Return-Path: <linux-kernel-owner+w=401wt.eu-S932270AbYB2M3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbYB2M3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 07:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758884AbYB2M3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 07:29:07 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:36149 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758202AbYB2M3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:29:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=VspksfGXza1z1gvi6gqWRr884JZTb6OvZ4E073aVemN8YBlKvIqAD5NRo834vpAifSf+ozX45T7EfcAqjrWLO1ypKsrZLjKiba993D2Xq4qVBY1DjBqKfMqDZROSwO5IdJ3vuwVVhp9QJXrIoQqylflSoSI4C151w2qlN6WdT+A=
Message-ID: <47C7FA8B.7040306@gmail.com>
Date: Fri, 29 Feb 2008 21:28:59 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: devres and requesting resources
References: <47C75392.3020606@garzik.org> <20080229112651.5b2a7f6f@core> <47C7F664.5040102@garzik.org>
In-Reply-To: <47C7F664.5040102@garzik.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Only rare PCI devices are shareable among multiple drivers.
> 
> sata_* at least intentionally used pci_request_regions() because it is
> obvious from the hardware spec that multiple regions accessed by
> multiple drivers is highly unlikely, without the driver being
> specifically coded to support such sharing.  Such sharing code is far
> beyond simple resource reservation, to avoid stepping on toes when there
> is a single MMIO region and set of interrupt clearing registers.
> 
> So reading your email it sounds like there are valid cases for both
> configurations.
> 
> Its a design choice either way, not a bug either way.

I was thinking like Alan when I was writing pcim_request_regions() but I
agree reserving all the regions does avoid certain problems.  Especially
true for controller which duals as native SATA and compatible SFF
controller like ICH AHCIs.  ata_generic or ide generic might attach to a
controller which is already being driven by ahci under certain
configurations.

Please note that pcim_request_regions() is a helper to do
pci_request_region() calls and pcim_iomap() in one go.  Drivers which
have different requirements can just open code pci_request_regions() and
pcim_iomap().  pcim_request_regions() should provide sensible default
behavior for common cases.

I think the best solution is to allow duplicate request regions for
managed devices which is okay as we know we're holding the resource and
let drivers which need to reserve all regions call pci_request_regions()
before calling pcim_request_regions().

How does it sound?

Thanks.

-- 
tejun
