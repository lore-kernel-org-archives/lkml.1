Return-Path: <linux-kernel-owner+w=401wt.eu-S1755698AbYAQIMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbYAQIMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 03:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753473AbYAQIMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 03:12:07 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:51090 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbYAQIMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 03:12:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=RRMJDdI43r6/1+IloQNSnKanNxBgkbnA2YNYqjtcXey17/ihuxnUvYz4Z2B3g0QHjJ5YwAHP+JuRgOYVWM+zjWgfU/FGQSKiURcXu1vWATviOlVWEglrRzwZ2Z+Tu7VBpM+RBHk6QDQFX9XrTx5ekOsX0xV0oQErGsCpTn3cNrI=
Date: Thu, 17 Jan 2008 16:15:04 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, kay.sievers@vrfy.org,
       Greg KH <greg@kroah.com>, Marcel Holtmann <marcel@holtmann.org>,
       davem@davemloft.net
Subject: Re: [Bluez-devel] Oops involving RFCOMM and sysfs
Message-ID: <20080117081504.GA3123@darkstar.te-china.tietoenator.com>
References: <20080108133215.GA15814@boogie.lpds.sztaki.hu> <478490D2.5050902@gmail.com> <20080110011117.GA3968@darkstar.te-china.tietoenator.com> <20080111230929.GA7052@boogie.lpds.sztaki.hu> <a8e1da0801132305s4f0c3d7asa268382bb6e44777@mail.gmail.com> <20080114135228.6b9a8da2@gondolin.boeblingen.de.ibm.com> <20080115015741.GB2780@darkstar.te-china.tietoenator.com> <20080116010205.GA2970@darkstar.te-china.tietoenator.com> <20080116230646.GB6715@boogie.lpds.sztaki.hu> <a8e1da0801162324r2cd82684iede3fc8c2f8c391c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0801162324r2cd82684iede3fc8c2f8c391c@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 03:24:50PM +0800, Dave Young wrote:
> On Jan 17, 2008 7:06 AM, Gabor Gombas <gombasg@sztaki.hu> wrote:
> > Hi,
> >
> > On Wed, Jan 16, 2008 at 09:02:05AM +0800, Dave Young wrote:
> >
> > > The rfcomm tty device will possibly retain even when conn is down,
> > > and sysfs doesn't support zombie device moving, so this patch
> > > move the tty device before conn device is destroyed.
> > >
> > > Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> >
> > This seems to work, both the oops and the hang are gone. I get these
> > messages in syslog when the Bluetooth link hangs and I want to kill pppd
> > with "poff":
> >
> > Jan 16 23:55:59 twister kernel: unregister_netdevice: waiting for ppp0 to become free. Usage count = 1
> > Jan 16 23:56:09 twister kernel: unregister_netdevice: waiting for ppp0 to become free. Usage count = 1
> >
> > But a "killall -9 pppd" seems to help and then the re-connect (after the
> > phone got power-cycled) works.
> 
> Weird, I guess "device_move(dev, NULL) two times" cause the problem.
> 
> Anyway, device_move should check the old_parent and new_parent , if
> they equal to each other then just return.
> 
> Am I right?

Could you apply this patch as well to test? Thanks.

diff -upr linux/net/bluetooth/rfcomm/tty.c linux.new/net/bluetooth/rfcomm/tty.c
--- linux/net/bluetooth/rfcomm/tty.c	2008-01-17 16:09:34.000000000 +0800
+++ linux.new/net/bluetooth/rfcomm/tty.c	2008-01-17 16:10:22.000000000 +0800
@@ -692,7 +692,8 @@ static void rfcomm_tty_close(struct tty_
 	BT_DBG("tty %p dev %p dlc %p opened %d", tty, dev, dev->dlc, dev->opened);
 
 	if (--dev->opened == 0) {
-		device_move(dev->tty_dev, NULL);
+		if (dev->tty_dev->parent)
+			device_move(dev->tty_dev, NULL);
 
 		/* Close DLC and dettach TTY */
 		rfcomm_dlc_close(dev->dlc, 0);

> 
> >
> >
> > Gabor
> >
> > --
> >      ---------------------------------------------------------
> >      MTA SZTAKI Computer and Automation Research Institute
> >                 Hungarian Academy of Sciences
> >      ---------------------------------------------------------
> >
