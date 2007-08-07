Return-Path: <linux-kernel-owner+w=401wt.eu-S932636AbXHGMqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636AbXHGMqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759303AbXHGMqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:46:45 -0400
Received: from antonio.urjc.es ([193.147.184.24]:42797 "EHLO antonio.urjc.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758436AbXHGMqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:46:44 -0400
Message-ID: <46B869C6.3090708@urjc.es>
Date: Tue, 07 Aug 2007 14:47:02 +0200
From: Javier Pello <javier.pello@urjc.es>
Organization: Universidad Rey Juan Carlos
User-Agent: Thunderbird 2.0.0.0 (X11/20070503)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not 
	notified
References: <46B37CF7.2020803@urjc.es><20070806142451.5d28d41c@gondolin.boeb
		lingen.de.ibm.com><46B7832B.6010808@urjc.es><20070807125844.4d756b04@gondo
	l	in.boeblingen.de.ibm.com><3ae72650708070446y6452d13jb7cd802119dab3ce@mail
	.gmail.com> <20070807141030.1bb0f76a@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070807141030.1bb0f76a@gondolin.boeblingen.de.ibm.com>
Content-Type: text/plain;
	charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender DNS name whitelisted, not delayed by 
	milter-greylist-2.0.2 (antonio.urjc.es [193.147.184.24]); Tue, 07 Aug 2007 
	14:46:36 +0200 (CEST)
X-imss-version: 2.047
X-imss-result: Passed
X-imss-scanInfo: M:B L:E SM:2
X-imss-tmaseResult: TT:1 TS:-14.5607 TC:1F TRN:48 TV:3.6.1039(15346.003)
X-imss-scores: Clean:100.00000 C:0 M:0 S:0 R:0
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007, Cornelia Huck wrote:

> On Tue, 7 Aug 2007 13:46:55 +0200,
> "Kay Sievers" <kay.sievers@vrfy.org> wrote:
> > How do you check if events have been "handled"? None of the recent
> > distros uses /sbin/hotplug anymore. Netlink events are broadcasted,
> > but no failure in delivery doesn't mean anything like "handled", or
> > delivered to the right instance. Even if you check that the netlink
> > socket has listeners, that wouldn't be sufficient to tell that is
> > handled.
> 
> You can't check if it's been handled, yes; but you can certainly check
> if you delivered it. I guess Javier wants to exclude the cases where
> userspace didn't have any chance to handle it.

That's right. There's no way to know if userspace does handle the event
after reception, and that's why we have a timeout (so we don't wait
forever), but we can be sure that userspace won't handle an event that
wasn't received. We want to be conservative here: if there is any
chance that the event was received, we set the timeout and wait.

> Javier: Do you have an idea how common the case "we broadcasted, but
> nobody listened so we got a timeout" is? If the usual reason for the
> timeout is that firmware was requested before a listener showed up,
> I'm not sure whether that check is worth it...

I don't know how common this is in general, but in my box it happens
(or rather happened, until I patched it) once per boot. I've got a
device that requires some firmware during initialisation. I always
build the driver into the kernel (I don't like modules for things
that are permanently attached to the computer), and that means that
it tries to initialise before the rootfs is mounted (there's no
initramfs). Before the patch, the kernel would hang for a minute
in request_firmware during each boot, which was rather annoying,
and that is the reason why I decided to fix it.

Javier


