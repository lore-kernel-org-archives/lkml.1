Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbXGGAdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbXGGAdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 20:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbXGGAdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 20:33:18 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:56713 "EHLO
	asav01.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbXGGAdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 20:33:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtYjAFZ8jkZKhRO4R2dsb2JhbACBTIVdiAQBARsNBhEB
From: Dmitry Torokhov <dtor@insightbb.com>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [1/2] 2.6.22-rc7: known regressions
Date: Fri, 6 Jul 2007 20:33:16 -0400
User-Agent: KMail/1.9.3
Cc: Marcel Holtmann <marcel@holtmann.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <468A7D14.1050505@googlemail.com> <d120d5000707051403r1d946375nb119ff86b26580ef@mail.gmail.com> <Pine.LNX.4.64.0707070019110.11634@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0707070019110.11634@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707062033.18211.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 July 2007 18:50, Jiri Kosina wrote:
> (CC list trimmed)
> 
> On Thu, 5 Jul 2007, Dmitry Torokhov wrote:
> 
> > > >  NIP [c001870c] strlen+0x4/0x18
> > > >  LR [c0134fec] kobject_get_path+0x34/0xc4
> > > >  Call Trace:
> > > >  [eed5be90] [c01d5124] class_uevent+0xac/0x1bc
> > > >  [eed5bed0] [c01357e4] kobject_uevent_env+0x23c/0x460
> > > >  [eed5bf20] [c01d485c] class_device_del+0x178/0x1a0
> > > >  [eed5bf40] [c01d489c] class_device_unregister+0x18/0x30
> > > >  [eed5bf60] [c021f820] input_unregister_device+0xf4/0x130
> > > >  [eed5bf70] [c0242f4c] hidinput_disconnect+0x2c/0x60
> > > >  [eed5bf90] [f27f2bac] hidp_session+0x550/0x584 [hidp]
> > > >  [eed5bff0] [c0013e28] kernel_thread+0x44/0x60
> [...]
> > > I'm not seeing any reference counting or other protection for the device
> > > ("input") on "hid->inputs" list. But I don't know the code. Dmitry? Jiri?
> 
> This should be automatically done by proper dev.parent setting of the 
> corresponding input device, as already mentioned by Dmitry.
> 
> > This should pin hid object untill all inputs are released. However 
> > bluetooth does not use driver model and does not have hid->dev set up 
> > and so it looks like we are simply trying to unregister an input device 
> > that is already gone... I still don't quite get how we unregister the 
> > same device twice - it is done from a per-hid-device thread in hidp...
> 
> Actually even bluetooth HID seems to set up hid->dev correctly in 
> hidp_setup_hid() and also sets properly dev.parent in hidp_setup_input().
>

Ah, I missed that. It did not use to do that last time I looked closely there.
 
> Marcel, what is please the point behind this code in 
> hidp_add_connection():
> 
>         if (!session->hid) {
>                 session->input = input_allocate_device();
>                 if (!session->input) {
>                         kfree(session);
>                         return -ENOMEM;
>                 }
>         }
> 
> I suspect that the oops happens during freeing this extra device which is 
> not allocated inside hid core, but I can't immediately see from the code 
> what is the exact purpose of this 'extra' input device and why don't the 
> input devices allocated and registered in hidinput_connect() suffice? 
> usbhid doesn't need to register any extra input devices, everything is 
> handled solely in hid-input core.
>

This is for devices using boot protocol, not full HID as far as I understand.
 
> Seems like it could be triggered by ioctl() with ca->req->rd_size set to 
> 0, but I am not that familiar with the bluetooth code to see it 
> immediately.
> 
> Thanks,
> 

-- 
Dmitry
