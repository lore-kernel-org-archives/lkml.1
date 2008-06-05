Return-Path: <linux-kernel-owner+w=401wt.eu-S1763184AbYFESu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763184AbYFESu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761607AbYFESuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:50:40 -0400
Received: from hpsmtp-eml14.kpnxchange.com ([213.75.38.114]:25980 "EHLO
	hpsmtp-eml14.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761568AbYFESuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:50:37 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.1, stray noise in dmesg
Date: Thu, 5 Jun 2008 20:50:33 +0200
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>, Gene Heskett <gene.heskett@gmail.com>
References: <200805021126.15225.gene.heskett@gmail.com> <200805021910.45266.elendil@planet.nl>
In-Reply-To: <200805021910.45266.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806052050.34537.elendil@planet.nl>
X-OriginalArrivalTime: 05 Jun 2008 18:50:35.0159 (UTC) FILETIME=[09CF9270:01C8C73D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 May 2008, Frans Pop wrote:
> Gene Heskett wrote:
> > I just rebooted to 2.6.25.1, and was momentarily panic'd by the
> > messages going by early in the boot, but on putting 2&2 together,
> > found they were just noise.
> >
> > From dmesg:
> > [root@coyote ~]# dmesg|grep unable
> > [    2.093502] hub 1-0:1.0: unable to enumerate USB device on port 2
> > [    2.248475] hub 1-0:1.0: unable to enumerate USB device on port 5
> > [    2.454444] hub 1-0:1.0: unable to enumerate USB device on port 6
>
> I'm seeing these too (hub 5-0):
> hub 5-0:1.0: USB hub found
> hub 5-0:1.0: unable to enumerate USB device on port 5
> hub 5-0:1.0: unable to enumerate USB device on port 7

I'm going to bring this up one last time.

Google currently already shows 1060 hits for this new error:
http://www.google.com/search?q=%22unable+to+enumerate+USB+device%22&ie=UTF-8&oe=UTF-8

This one is particularly interesting as it shows quite a few systems
are affected: https://bugzilla.redhat.com/show_bug.cgi?id=446845

Given its apparent prevalence I'm still wondering whether this is
really broken hardware in all cases or that there could be an error
in detection in some cases.

Note that in my case this is not with an external hub or anything, but just
the internal USB ports of the system.

One thing with this message is that because of its "error" status, it
also shows when the system is booted with the "quiet" option. Could it be
an option to apply the following patch so that at least that is avoided?

---
From: Frans Pop <elendil@planet.nl>

usb core: lower severity of 'unable to enumerate USB device' message
    
This message is relatively common and in most cases can be safely
ignored. Lower its severity from 'err' to 'notice' so it is not printed
on the console when systems are booted with the "quiet" boot parameter.
    
Signed-off-by: Frans Pop <elendil@planet.nl>

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 8eb4da3..ea1ef37 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2756,7 +2756,7 @@ loop:
 	if (hub->hdev->parent ||
 			!hcd->driver->port_handed_over ||
 			!(hcd->driver->port_handed_over)(hcd, port1))
-		dev_err(hub_dev, "unable to enumerate USB device on port %d\n",
+		dev_notice(hub_dev, "unable to enumerate USB device on port %d\n",
 				port1);
  
 done:
