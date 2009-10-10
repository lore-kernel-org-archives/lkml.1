Return-Path: <linux-kernel-owner+w=401wt.eu-S934518AbZJJRoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934518AbZJJRoh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 13:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933829AbZJJRoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 13:44:37 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:45172 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934351AbZJJRog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 13:44:36 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2
Date: Sat, 10 Oct 2009 19:43:45 +0200
User-Agent: KMail/1.9.10
Cc: Josua Dietze <digidietze@draisberghof.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ben Efros <ben@pc-doctor.com>, fangxiaozhi <huananhu@huawei.com>,
       Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
References: <Pine.LNX.4.44L0.0910101220540.3859-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0910101220540.3859-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910101943.49326.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 October 2009 19:05:22 Alan Stern wrote:
> On Sat, 10 Oct 2009, Josua Dietze wrote:
> > Benjamin Herrenschmidt schrieb:
> > > The symptom is that the USB modem just disconnects/reconnects in a
> > > loop. The log looks like what I pasted below when plugging the device
> > > (and leaving it in, the disconnects don't correspond to the device
> > > being removed).
> >
> > This is one of the mode switching devices. It is switched to modem
> > mode by "usb_stor_huawei_e220_init".
> >
> > Something keeps resetting it to initial mode. It might be a
> > powersave/suspend issue.
>
> It's not related to powersave or suspend.  (Although both trace files
> show that the device's remote-wakeup feature did get enabled; I have no
> idea what code was responsible for doing that.  AFAIK it shouldn't
> happen unless the device is about to be suspended.)
>
> No, the problem is related to the mode-switching.  In particular, the
> 2.6.31.3 log shows that the mass-storage interface got into trouble
> because of a couple of bugs in the device.  These bugs caused
> usb-storage to issue a device reset, but after the reset the same thing
> happened again and we entered an endless loop.
>
> The reason this doesn't happen under 2.6.31.1 is explained by commit
> b7c8b54df8c2a82757d8aab48aaac198a49e2ff9 (which in the upstream kernel
> is commit d0defb855c8504c49b92bdc0203689ce9b4cf7ba).  It allows
> usb-storage to bind to the Huawei Datacard device, whereas before the
> mode switch would occur with no binding.
>
> Regardless, we have to figure out some way to work around the device's
> bugs.  In some detail, here's what happened:
>
> The device presented two LUNs on the mass-storage interface.  LUN 0 was
> the emulated CDROM (named "Mass Storage") and LUN 1 was direct-access
> (named "SD Storage").  LUN 0 appeared to work normally, although it
> reported Not Ready, No Medium Present errors.  LUN 1 did the same
> thing, but in its response to the REQUEST SENSE command it set the
> additional-sense-length byte to 0x12 instead of 0x0a, for no apparent
> reason.  This caused usb-storage to assume the device supported SANE
> SENSE, which presumably it doesn't.
>
> Further REQUEST SENSE commands therefore requested 96 bytes of data
> instead of the standard 18 bytes.  With LUN 0 this worked okay.  But
> with LUN 1 it didn't; the device reported a failure of the REQUEST
> SENSE.  This is what caused usb-storage to issue the device reset.
>
> After the reset usb-storage continued to ask for 96 bytes of sense
> data, and LUN 1 continued to fail the commands.  Hence the repeated
> resets.
>
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

No, this is not a good idea. Some of the devices have a MicroSD slot - like 
Huawei E176. The bad thing is that E176 uses the same device ID as Huawei 
E220 (and possibly some other devices too).

-- 
Ondrej Zary
