Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567AbXIQGra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbXIQGra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 02:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbXIQGrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 02:47:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60738 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752725AbXIQGrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 02:47:19 -0400
Date: Sun, 16 Sep 2007 23:46:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Kees Cook" <kees@ubuntu.com>, "Greg KH" <greg@kroah.com>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Jeff Garzik" <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       "Ben Collins" <bcollins@ubuntu.com>,
       "Michael Wu" <flamingice@sourmilk.net>
Subject: Re: [PATCH] modpost: detect unterminated device id lists
Message-Id: <20070916234657.6548efe3.akpm@linux-foundation.org>
In-Reply-To: <a781481a0709161724r6cf664e6q453331911cd0b493@mail.gmail.com>
References: <20070912064134.GO7910@outflux.net>
	<46E7C91D.3070001@garzik.org>
	<b6fcc0a0709120448s69528fc9reed593229124a4fa@mail.gmail.com>
	<20070912215356.GC23294@kroah.com>
	<20070913004937.GM8183@outflux.net>
	<20070916151447.dc925a9e.akpm@linux-foundation.org>
	<a781481a0709161724r6cf664e6q453331911cd0b493@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 05:54:45 +0530 "Satyam Sharma" <satyam.sharma@gmail.com> wrote:

> On 9/17/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 12 Sep 2007 17:49:37 -0700 Kees Cook <kees@ubuntu.com> wrote:
> >
> > > This patch against 2.6.23-rc6 will cause modpost to fail if any device
> > > id lists are incorrectly terminated, after reporting the offender.
> >
> > I'm getting this:
> >
> > rusb2/pvrusb2: struct usb_device_id is 20 bytes.  The last of 3 is:
> > 0x03 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00
> > 0x00 0x00 0x00 0x00 0x00
> > FATAL: drivers/media/video/pvrusb2/pvrusb2: struct usb_device_id is not terminated
> > with a NULL entry!
> >
> > ("rusb2/pvrusb2" ??)
> 
> Hmm? Are you sure you didn't see any "drivers/media/video/pv" before the
> "rusb2/pvrusb2" bit?

Fairly.  I looked twice.

> Looking at Kees' patch (and the existing code), I've no
> clue how/why this should happen ... will try to reproduce here ...
> 
> 
> > but:
> >
> > struct usb_device_id pvr2_device_table[] = {
> >         [PVR2_HDW_TYPE_29XXX] = { USB_DEVICE(0x2040, 0x2900) },
> >         [PVR2_HDW_TYPE_24XXX] = { USB_DEVICE(0x2040, 0x2400) },
> >         { USB_DEVICE(0, 0) },
> > };
> >
> > looks OK?
> >
> > Using plain old "{ }" shut the warning up.
> 
> USB_DEVICE(0, 0) is not empty termination, actually, and this looks like
> a genuine bug caught by the patch. As that dump shows, USB_DEVICE(0, 0)
> assigns "0x03 0x00" (in little endian) to usb_device_id.match_flags. And
> I don't think the USB code treats such an entry as an empty entry (?)
> 
> Interestingly, the "USB_DEVICE(0, 0)" thing is absent from latest -git
> tree and also in my copy of 23-rc4-mm1 -- so this looks like something
> you must've merged recently.

git-dvb very carefully does

--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c~git-dvb
+++ a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -44,7 +44,7 @@
 struct usb_device_id pvr2_device_table[] = {
 		[PVR2_HDW_TYPE_29XXX] = { USB_DEVICE(0x2040, 0x2900) },
 		[PVR2_HDW_TYPE_24XXX] = { USB_DEVICE(0x2040, 0x2400) },
-       { }
+       { USB_DEVICE(0, 0) },
};
	 
MODULE_DEVICE_TABLE(usb, pvr2_device_table);
	
