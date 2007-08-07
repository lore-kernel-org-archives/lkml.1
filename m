Return-Path: <linux-kernel-owner+w=401wt.eu-S933705AbXHGMzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933705AbXHGMzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760770AbXHGMy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:54:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:50857 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759632AbXHGMyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:54:53 -0400
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not 
	notified
From: Kay Sievers <kay.sievers@vrfy.org>
To: Javier Pello <javier.pello@urjc.es>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
In-Reply-To: <46B869C6.3090708@urjc.es>
References: <46B37CF7.2020803@urjc.es>
	 <20070806142451.5d28d41c@gondolin.boeb lingen.de.ibm.com>
	 <46B7832B.6010808@urjc.es>
	 <20070807125844.4d756b04@gondo l	in.boeblingen.de.ibm.com>
	 <3ae72650708070446y6452d13jb7cd802119dab3ce@mail .gmail.com>
	 <20070807141030.1bb0f76a@gondolin.boeblingen.de.ibm.com>
	 <46B869C6.3090708@urjc.es>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 14:57:52 +0200
Message-Id: <1186491472.3611.33.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18Twq7T2G/04psRQViOPTulV0/Y9Dt/eCRZmkZ
 CJiuYT1kP6f7SCJJQm3v/AG6LTcyccD6ITUPAyGZzAAN47AS5o
 AeT2VOXSS8YiMQax05aYXVD1PSLPoOw
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-08-07 at 14:47 +0200, Javier Pello wrote:
> On Tue, 07 Aug 2007, Cornelia Huck wrote:
> 
> > On Tue, 7 Aug 2007 13:46:55 +0200,
> > "Kay Sievers" <kay.sievers@vrfy.org> wrote:
> > > How do you check if events have been "handled"? None of the recent
> > > distros uses /sbin/hotplug anymore. Netlink events are broadcasted,
> > > but no failure in delivery doesn't mean anything like "handled", or
> > > delivered to the right instance. Even if you check that the netlink
> > > socket has listeners, that wouldn't be sufficient to tell that is
> > > handled.
> > 
> > You can't check if it's been handled, yes; but you can certainly check
> > if you delivered it. I guess Javier wants to exclude the cases where
> > userspace didn't have any chance to handle it.
> 
> That's right. There's no way to know if userspace does handle the event
> after reception, and that's why we have a timeout (so we don't wait
> forever), but we can be sure that userspace won't handle an event that
> wasn't received. We want to be conservative here: if there is any
> chance that the event was received, we set the timeout and wait.
> 
> > Javier: Do you have an idea how common the case "we broadcasted, but
> > nobody listened so we got a timeout" is? If the usual reason for the
> > timeout is that firmware was requested before a listener showed up,
> > I'm not sure whether that check is worth it...
> 
> I don't know how common this is in general, but in my box it happens
> (or rather happened, until I patched it) once per boot. I've got a
> device that requires some firmware during initialisation. I always
> build the driver into the kernel (I don't like modules for things
> that are permanently attached to the computer), and that means that
> it tries to initialise before the rootfs is mounted (there's no
> initramfs). Before the patch, the kernel would hang for a minute
> in request_firmware during each boot, which was rather annoying,
> and that is the reason why I decided to fix it.

If you don't have modules and the initial request fails, how do you load
the firmware later?

The real fix would be to change the driver not to block in the firmware
request and use async version of firmware loading. The whole firmware
class with its silly timeout is just a piece of crap, that needs to be
replaced.

Kay

