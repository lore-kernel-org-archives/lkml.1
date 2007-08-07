Return-Path: <linux-kernel-owner+w=401wt.eu-S934778AbXHGOZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934778AbXHGOZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 10:25:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759965AbXHGOZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 10:25:20 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:9919 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbXHGOZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 10:25:17 -0400
Date: Tue, 7 Aug 2007 16:26:18 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Javier Pello <javier.pello@urjc.es>
Cc: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not
 notified
Message-ID: <20070807162618.3814ff78@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <46B87ACA.7010501@urjc.es>
References: <46B37CF7.2020803@urjc.es>
	<20070806142451.5d28d41c@gondolin.boeb
 lingen.de.ibm.com>
	<46B7832B.6010808@urjc.es>
	<20070807125844.4d756b04@gondo
 	l	in.boeblingen.de.ibm.com>
	<3ae72650708070446y6452d13jb7cd802119dab3ce@mail .gmail.com>
	<20070807141030.1bb0f76a@gondolin.boeblingen.de.ibm.com>
	<46B869C6.3090708@urjc.es>
	<1186491472.3611.33.camel@lov.localdomain>
	<46B87ACA.7010501@urjc.es>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007 15:59:38 +0200,
Javier Pello <javier.pello@urjc.es> wrote:

> On Tue, 07 Aug 2007, Kay Sievers wrote:
> 
> > If you don't have modules and the initial request fails, how do you
> > load the firmware later?
> 
> I trigger a rebinding of the device to the driver in an init file:
> # echo -n [device] >/sys/.../bind

So it is indeed that this driver wants to fail its probe if it cannot
get the firmware. A possibilty to achieve a similar effect would be to
use request_firmware_nowait() and to call device_release_driver() from
the callback if no firmware is loaded. (This would imply a split of
that driver's probe function into two stages.)

> 
> > The real fix would be to change the driver not to block in the
> > firmware request and use async version of firmware loading. The
> > whole firmware class with its silly timeout is just a piece of
> > crap, that needs to be replaced.
> 
> I don't think that would be a real fix. You've done away with the
> kernel blocking, but the timeout is still there, only that in the
> background, and my point is still true: it is useless to wait at
> all if userspace didn't receive the event. Waiting asynchronously
> is less annoying than waiting synchronously, but equally useless.

Well, at least it doesn't block the whole probing process... although
this waiting is indeed useless.
