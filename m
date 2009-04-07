Return-Path: <linux-kernel-owner+w=401wt.eu-S1761523AbZDGP0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761523AbZDGP0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759830AbZDGPNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:13:06 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:44720 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759771AbZDGPNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:13:02 -0400
Message-ID: <49DB6D0D.2070805@s5r6.in-berlin.de>
Date: Tue, 07 Apr 2009 17:11:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15
MIME-Version: 1.0
To: Jon Grant <jg@jguk.org>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: USB disconnect, address 6
References: <19ac3f7a0904051104h1abc4cf3rae6dc1a027207831@mail.gmail.com>	 <20090406022356.GA866@kroah.com>	 <19ac3f7a0904060211s5a79b659tf8ac315010151dbb@mail.gmail.com>	 <20090406150431.GA25557@kroah.com> <19ac3f7a0904061233i7a889cebr86a73fe02cb34421@mail.gmail.com>
In-Reply-To: <19ac3f7a0904061233i7a889cebr86a73fe02cb34421@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Grant wrote:
> 2009/4/6 Greg KH <greg@kroah.com>:
>> On Mon, Apr 06, 2009 at 11:11:55AM +0200, Jon Grant wrote:
> [..]
>>> The idea was that the disconnect could give more information.
>>> Otherwise it's necessary to go hunting back up the log to track down
>>> which USB device was the one disconnected (which works fine, but isn't
>>> ideal for time consumed doing this regularly).
>>
>> As you yanked the device out, don't you know which one it was?
> 
> I do get devices disappear without me disconnecting them, various
> different PCs, and laptops.

Try FireWire then. ;-)

> [..]
>>> Apr  5 18:56:58 data-laptop kernel: usb 5-1: USB disconnect, address 6
>>> (Samsung  Mighty Drive)
>>>
>>> Would this not be clearer?
>>
>> That might be nice, but note that the kernel doesn't even know the
>> strings after a device is gone, as it had to read them from the device
>> :)
> 
> Yeah, would need to cache the names, perhaps you don't want to bloat
> the kernel that way.

"Samsung Mighty Drives" is some information which the Linux SCSI layer
obtained from the device's response to the SCSI INQUIRY command.  The
USB layer sits beneath the SCSI layer and passes SCSI commands and
responses through without looking at them... most of the time, at least.
I haven't checked whether usb-storage examines SCSI inquiry buffers
these days.  Typically we don't want to duplicate high-level
functionality into lower layers, hence knowledge of SCSI commands and
responses is mostly kept out of Linux' SCSI transports layer (e.g.
usb-storage).

The INQUIRY reposne however /is/ already cached by Linux.  It's in
<scsi/scsi_device.h>'s struct scsi_device { .inquiry_len; .inquiry; }.
Furthermore, .vendor; .model; .rev; point into respective byte fields in
the inquiry response buffer.  Here is the code line which produces the
initial dmesg line with the vendor/model/rev strings:
http://lxr.linux.no/linux+v2.6.29/drivers/scsi/scsi_scan.c#L847

However, it would be slightly difficult for the USB stack to access this
information.  It's in a (grand-grand-?)child of the actual USB device
representations with which the USB stack deals directly.  To implement
what you want, the USB stack would have to check whether
(grand-grand-?)children of type scsi_device were ever created, then peek
into its device data (with some SCSI-specific knowledge).  Or the
usb-storage driver would have to watch for scsi_device creations by the
upper layers (i.e. by layers outside of the USB stack) and copy their
data into whichever USB parent device for possible later use.

Not quite cleanly doable.

Plus, Greg was right when he said that the strings in these INQUIRY
responses are generally not unique and sometimes pure garbage.
-- 
Stefan Richter
-=====-==--= -=-- --===
http://arcgraph.de/sr/
