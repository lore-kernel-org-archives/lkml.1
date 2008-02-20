Return-Path: <linux-kernel-owner+w=401wt.eu-S1764194AbYBTAUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764194AbYBTAUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758064AbYBTAUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:20:05 -0500
Received: from smtp113.sbc.mail.mud.yahoo.com ([68.142.198.212]:48319 "HELO
	smtp113.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756675AbYBTAUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:20:03 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fNGbeqn4CXMoxhwQh8yBG4+wfRNnNK9MxhyfETKVxou6jXLfeXQBQksmMxHl1h7VIYLGF6hYESu3awOu9IyJgBgRGyylqBnze4k8XVbOmnEkKKEF0INYDHHawD8OSm2jYsUiG5cndEvZKInGIkJG9NhPoLV/599U/4xzmSnfkCo=  ;
X-YMail-OSG: ZqvchYUVM1nEmUvN7s32HoWF_Zn.WRApbhvHwyzyGOZEqAtszQdoZ0fuPOgyjMYeE24W18IOQQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: David Miller <davem@davemloft.net>
Subject: Re: USB OOPS 2.6.25-rc2-git1
Date: Tue, 19 Feb 2008 16:19:54 -0800
User-Agent: KMail/1.9.6
Cc: andre@tomt.net, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <47BAF36C.4000509@tomt.net> <20080219.142401.152827357.davem@davemloft.net>
In-Reply-To: <20080219.142401.152827357.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802191619.55207.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008, David Miller wrote:
> From: Andre Tomt <andre@tomt.net>
> Date: Tue, 19 Feb 2008 16:19:08 +0100
> 
> > Got this on a serial console today, using 2.6.25-rc2-git1. Machine was 
> > not doing anything interesting at the time, but has its / and kernel on 
> > a usb-storage device (usb pen drive).
> > 
> > Intel ICH8R chipset (and USB controller), running x86_64 kernel. I'll 
> > post .config and some additional info when I get home later if it isn't 
> > obvious what broke.
> 
> FWIW, I've seen a near identical crash on my Niagara system.

Please try that diagnostic patch I sent ... with CONFIG_USB_DEBUG.

Near as I can tell this is caused by some hardware oddity that needs
to be worked around.  We seem to be at stage where we've fixed some
problems, nudging code paths around so another one shows up, and have
incidentally had a new silicion-specific hardware erratum reported
in this area.  So more info is needed...

A quick anti-oops patch is appended, it should work OK on top of that
diagnostic patch, but won't necessarily resolve the underlying problem.

- Dave


--- g26.orig/drivers/usb/host/ehci-q.c	2008-02-19 16:15:04.000000000 -0800
+++ g26/drivers/usb/host/ehci-q.c	2008-02-19 16:15:59.000000000 -0800
@@ -993,6 +993,11 @@ static void end_unlink_async (struct ehc
 
 	iaa_watchdog_done(ehci);
 
+	if (!qh) {
+		WARN_ON(1);
+		return;
+	}
+
 	// qh->hw_next = cpu_to_hc32(qh->qh_dma);
 	qh->qh_state = QH_STATE_IDLE;
 	qh->qh_next.qh = NULL;
