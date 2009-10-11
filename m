Return-Path: <linux-kernel-owner+w=401wt.eu-S1759133AbZJKAbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133AbZJKAbQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 20:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbZJKAbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 20:31:15 -0400
Received: from mail.pc-doctor.com ([66.224.119.10]:34631 "EHLO
	mail.pc-doctor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbZJKAbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 20:31:14 -0400
X-Greylist: delayed 546 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Oct 2009 20:31:14 EDT
Date: Sat, 10 Oct 2009 17:21:26 -0700 (PDT)
From: Ben Efros <ben@pc-doctor.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>,
       Josua Dietze <digidietze@draisberghof.de>
Message-ID: <32355889.563271255220486481.JavaMail.root@mail.pc-doctor.com>
In-Reply-To: <11818577.563251255220394815.JavaMail.root@mail.pc-doctor.com>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [99.148.190.25]
X-Mailer: Zimbra 5.0.18_GA_3011.UBUNTU6 (ZimbraWebClient - FF3.0 (Linux)/5.0.18_GA_3011.UBUNTU6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Alan Stern" <stern@rowland.harvard.edu> wrote:

> The device presented two LUNs on the mass-storage interface.  LUN 0
> was 
> the emulated CDROM (named "Mass Storage") and LUN 1 was direct-access
> 
> (named "SD Storage").  LUN 0 appeared to work normally, although it 
> reported Not Ready, No Medium Present errors.  LUN 1 did the same 
> thing, but in its response to the REQUEST SENSE command it set the 
> additional-sense-length byte to 0x12 instead of 0x0a, for no apparent
> reason.  This caused usb-storage to assume the device supported SANE 
> SENSE, which presumably it doesn't.
> 
<SNIP>
> 
> Thus the two bugs in the Huawei device are: Incorrect 
> additional-sense-length byte for LUN 1, and incorrect CSW for a
> 96-byte 
> REQUEST SENSE on LUN 1.
> 
> I can see two approaches for working around this.  The first is to
> make
> the SENSE SENSE test more discriminating.  For example, test for
> additional-sense-length values larger than 0x12 instead of larger
> than
> 0x0a.  Ben Efros, would this be acceptable?
>
> The second approach is to add a SINGLE_LUN flag to all the Huawei
> entries in unusual_devs.h.  It's not clear that this is a good idea; if
> one of those devices really does have an SD card then people might want
> to be able to use it.

Most SAT devices will never set an additional sense length value higher than 0x0e on the Descriptor Format Sense Data when returning an ATA Return Descriptor.  I'd prefer not to arbitrarily set the range check to be > 0x12 for SANE_SENSE to kick in.  If that is the ultimate solution, then I'd rather see the whole SANE_SENSE detection if-block removed in its entirely.  I really don't think that will be necessary.

Both proposed solutions seem to have their drawbacks.  Maybe its time to start noting buggy devices that are known to be "insane" in regards to sense data.  If the device has usb flag "INSANE_SENSE" then we'll never ever set SANE_SENSE.

Ben Herrenschmidt's patch[1] to retry without SANE_SENSE might be combined be able to be used to detect this 'INSANE_SENSE' scenario, but not in its current form.

Devices lying about the "additional sense length" doesn't seem all that common, so it might be better to just flag the device as insane and not worry about reworking Ben Herrenschmidt's patch.


[1] http://lkml.org/lkml/2009/10/10/211

