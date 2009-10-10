Return-Path: <linux-kernel-owner+w=401wt.eu-S1762136AbZJJVUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762136AbZJJVUn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 17:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758574AbZJJVUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 17:20:42 -0400
Received: from gate.crashing.org ([63.228.1.57]:44142 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754673AbZJJVUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 17:20:41 -0400
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Josua Dietze <digidietze@draisberghof.de>, Ben Efros <ben@pc-doctor.com>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
In-Reply-To: <Pine.LNX.4.44L0.0910101220540.3859-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0910101220540.3859-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 11 Oct 2009 08:18:58 +1100
Message-Id: <1255209538.3387.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The device presented two LUNs on the mass-storage interface.  LUN 0 was 
> the emulated CDROM (named "Mass Storage") and LUN 1 was direct-access 
> (named "SD Storage").  LUN 0 appeared to work normally, although it 
> reported Not Ready, No Medium Present errors.  LUN 1 did the same 
> thing, but in its response to the REQUEST SENSE command it set the 
> additional-sense-length byte to 0x12 instead of 0x0a, for no apparent 
> reason.  This caused usb-storage to assume the device supported SANE 
> SENSE, which presumably it doesn't.

Interesting. Under the windows, the device exposes a CD-ROM (which
contains windows SW for it). It also has an micro-SD connector as some
kind of "bonus" though I've never used it.

> Further REQUEST SENSE commands therefore requested 96 bytes of data
> instead of the standard 18 bytes.  With LUN 0 this worked okay.  But 
> with LUN 1 it didn't; the device reported a failure of the REQUEST 
> SENSE.  This is what caused usb-storage to issue the device reset.

Might be interesting to see what happens with a micro-SD actually in the
slot. Also, doing a device-reset on a multi-function device because one
of the functions isn't too happy may be a tad harsh no ?

> After the reset usb-storage continued to ask for 96 bytes of sense
> data, and LUN 1 continued to fail the commands.  Hence the repeated
> resets.

Ok.

> Thus the two bugs in the Huawei device are: Incorrect 
> additional-sense-length byte for LUN 1, and incorrect CSW for a 96-byte 
> REQUEST SENSE on LUN 1.
> 
> I can see two approaches for working around this.  The first is to make
> the SENSE SENSE test more discriminating.  For example, test for
> additional-sense-length values larger than 0x12 instead of larger than
> 0x0a.  Ben Efros, would this be acceptable?
> 
> The second approach is to add a SINGLE_LUN flag to all the Huawei 
> entries in unusual_devs.h.  It's not clear that this is a good idea; if 
> one of those devices really does have an SD card then people might want 
> to be able to use it.

They do have an SD slot indeed.

Any pointer to the piece of code I can tweak to change 0xa to 0x12
(SENSE stuff) to see if that helps ?

Cheers,
Ben.

> Alan Stern
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


