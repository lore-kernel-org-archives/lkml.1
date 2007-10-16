Return-Path: <linux-kernel-owner+w=401wt.eu-S1762038AbXJPDD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762038AbXJPDD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 23:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757372AbXJPDDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 23:03:17 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:57397
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700AbXJPDDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 23:03:16 -0400
Date: Mon, 15 Oct 2007 20:06:43 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: Matthew Wilcox <matthew@wil.cx>, Rob Landley <rob@landley.net>,
       David Newall <david@davidnewall.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Nick Piggin <piggin@cyberone.com.au>
Subject: Re: What still uses the block layer?
In-Reply-To: <47139F15.7050702@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.64.0710151954550.3949@asgard.lang.hm>
References: <200710112011.22000.rob@landley.net> <200710141836.55211.rob@landley.net>
 <4712FE33.3000400@s5r6.in-berlin.de> <200710150426.04924.rob@landley.net>
 <20071015160800.GA324@parisc-linux.org> <47139F15.7050702@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2007, Stefan Richter wrote:

> Subject: Re: What still uses the block layer?
> 
> Matthew Wilcox wrote:
>> On Mon, Oct 15, 2007 at 04:26:04AM -0500, Rob Landley wrote:
>>> Combining USB and IDE into the same /dev/sd? namespace makes enumerating the
>>> IDE devices much harder than in the traditional "/dev/hdb doesn't move
>>> without a screwdriver" model.  The merger creates a new problem for IDE, one
>>> which didn't exist before: the addition or removal of other unrelated types
>>> of devices may change this device's location next boot.  It may be possible
>>> to add additional complication to the system to compensate, but what was the
>>> advantage of merging the namespaces in the first place?
>>
>> It's not something anyone particularly set out to do, it's just how
>> it worked out.  It was justified by saying "ok, this goes from a 99%
>> solution to a 96% solution, but there's 100% solution called uuids".
>> I don't particularly agree with this line of argumentation, but it did
>> hold sway.
>
> Low-level networking drivers suggest a default interface name (per
> interface or as a template like eth%d into which the networking core
> inserts a lowest spare number).  Userspace can rename interfaces, but
> nevertheless it's nice to have different default kernel names for
> ethernet, wlan etc..
>
> Could low-level SCSI drivers provide similar name templates which give a
> hint on the transport involved?  It's a bit more difficult as with
> networking interfaces though because
>  - SCSI devices can have sd, sr, st, osst, ch, sg interfaces,
>  - SCSI device files share a namespace with all other device files.
>
> E.g.
> /dev/sd-ide-b	- second IDE HDD,
> /dev/sd-iscsi-e	- fifth iSCSI direct access device,
> /dev/sr-sata-0	- first SATA CD-ROM,
> /dev/sr-usb-0	- a USB CD-ROM,
> /dev/st-fw-0	- a FireWire tape drive,
> /dev/sda	- a device whose transport driver didn't propose a name
>
> Of course the really interesting names will still be provided by
> udev-generated symlinks.

this is a nice option, and since most of the existing userspace code is 
looking for /dev/sd*, /dev/sr*, etc this should be able to work for new 
installs with no userspace changes. Since it would break existing installs 
it would need to be optional.

one other option that could be considered (and I do realize I'm bringing 
up flame-bait here) is that drivers that have fixed addresses could offer 
up a device name that include that address.
i.e. depending on the config option a device could show up as either sda, 
sd-scsi-a, sd-scsi-0:0:0:0, or even sd-scsi-<WWN>

if the driver or bus doesn't have a real numbering, it wouldn't invent a 
fake one (which is a big problem with most of the prior suggestions that 
have tried to offer a numbering option), it would just offer the most 
specific information it has.

David Lang
