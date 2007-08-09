Return-Path: <linux-kernel-owner+w=401wt.eu-S935165AbXHILze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935165AbXHILze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 07:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756682AbXHILzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 07:55:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59955 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135AbXHILzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 07:55:24 -0400
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not 
	notified
From: Kay Sievers <kay.sievers@vrfy.org>
To: Javier Pello <javier.pello@urjc.es>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       GregKH <greg@kroah.com>
In-Reply-To: <46BAE005.4000906@urjc.es>
References: <46B37CF7.2020803@urjc.es>
	 <20070806142451.5d28d41c@gondolin.boeb lingen.de.ibm.com>
	 <46B7832B.6010808@urjc.es>
	 <20070807125844.4d756b04@gondo l	in.boeblingen.de.ibm.com>
	 <3ae72650708070446y6452d13jb7cd802119dab3ce@ma il	  .gmail.com>
	 <20070807141030.1bb0f76a@gondolin.boeblingen.de.ibm.com>
	 <46B869	 C6.3090708@urjc.es><1186491472.3611.33.camel@lov.localdomain>
	 <46B87ACA.7010 501@urjc.es>
	 <20070807162618.3814ff78@gondolin.boeblingen.de.ibm.com>
	 <46BAE005.4000906@urjc.es>
Content-Type: text/plain
Date: Thu, 09 Aug 2007 13:58:36 +0200
Message-Id: <1186660716.21247.94.camel@lov.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/eIkLWhXcoEFRaE2vggwt/N0KAYoZkRpJgT/w
 4ApGLH6a0Iz/XJA6Jfcgn7AfEwa0uNa7z0Dqpp7vGOVANX5nYc
 udtAtodc6szwdIktxDrMSB+wxXY5ohk
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 11:36 +0200, Javier Pello wrote:
> On Tue, 07 Aug 2007, Cornelia Huck wrote:
> 
> > So it is indeed that this driver wants to fail its probe if it
> > cannot get the firmware.
> 
> That's right. The driver unbinds itself from the device if it doesn't
> get the firmware.
> 
> > A possibilty to achieve a similar effect would be to use
> > request_firmware_nowait() and to call device_release_driver() from
> > the callback if no firmware is loaded. (This would imply a split of
> > that driver's probe function into two stages.)
> 
> The comments in the source code say that request_firmware_nowait()
> is an "asynchronous version of request_firmware() for contexts where
> it is not possible to sleep". So a driver's decision to call one of
> them is not based on whether it wants to wait or not, but whether it
> _can_ wait.
> 
> Of course, it can be decided that we never want to wait, but then
> the best course of action would be to make request_firmware itself
> behave as request_firmware_nowait (no need to change drivers).
> 
> Anyway, my point is that it is useless to have the kernel block for
> a minute at boot waiting for something that cannot happen, and that
> it should be avoided (even if my proposed solution is not the way
> to go).

That's true. And it sounds all reasonable from your point of view, and
the firmware loader needs fixing, and the silly blocking request needs
to be removed from the kernel, that's known for a very long time now,
but nobody did the work so far.

But in this specific case, it is more the combination of your options,
what causes this problem to appear. You don't have an initramfs, you
don't use modules, but you are linking a driver into the kernel image
which depends on a conceptually broken blocking userspace transaction to
initialize.
This combination of options just doesn't make sense. Either use
initramfs, or use a kernel module for the driver that needs userspace to
initialize, or patch the driver not to block in the request, or patch
the driver to optionally include the firmware in the driver.

You just picked a set of options that doesn't work nicely together. No
distro setup has this problem, that's probably why nobody really cared
and it didn't get fixed so far.

Kay

