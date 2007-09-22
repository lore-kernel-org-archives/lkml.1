Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbXIVTS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbXIVTS1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 15:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757138AbXIVTSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 15:18:09 -0400
Received: from smtp107.sbc.mail.re2.yahoo.com ([68.142.229.98]:42184 "HELO
	smtp107.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756812AbXIVTSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 15:18:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=T0kIzcRFMyhOyC8f6YEo3rLPg/bYDB1YA0yRSaDn7J9mHcYTnWG/XTOIEvjQYT61FnsPvvnxtTTnsVzqeck8vpE1X8dSkhy5gZ7nnkQknTsltR9PTM8I9GqpE0w+1Z3PujdwE3B9DJERvb5cuzxE9kX+NBuFB2EL5XrmVRgRsbI=  ;
X-YMail-OSG: DBL0_FQVM1kJmW.yujefxtaEJ6psn8jBsHStvNHoDggKayBr2ZpYazoYve4yw_dz6hHi5JsnJkXKfza114WH_v7PmazRMzoLbjl5cSPe0gI23GQ0pVUVDzq9VuW3Cn3Z3AvZVdfAYEw5SaY-
Date: Sat, 22 Sep 2007 12:18:06 -0700
From: David Brownell <david-b@pacbell.net>
To: tglx@linutronix.de
Subject: Re: [PATCH] usb-gadget-ether: Prevent oops caused by error interrupt 
 race -V2 (comments update)
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, bene@linutronix.de,
       akpm@osdl.org
References: <1190299611.3481.34.camel@chaos>
 <200709211508.42968.david-b@pacbell.net>
 <1190482861.4035.59.camel@chaos>
In-Reply-To: <1190482861.4035.59.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070922191806.A2F59C2308@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think you misread my comment.  Those requests are **NOT** pending!!
So this update has a *MORE* incorrect description of the issue. 

That's just the freelist ... it's a fairly conventional model whereby
there's a pool of "free" request slots which can be issued.  When the
pool empties, the TX queue shuts down until one of the requests which
is pending in the hardware completes, and makes a slot free.

The problem you're addressing is that there's a small window where a
disconnect IRQ can shut down the TX queue (and empty that freelist)
after upper layers in the network stack started a transmission on
an active (pre-disconnect) TX queue.

That problem is *NOT* related to any pending requests at all!!

NAK...


> From tglx@linutronix.de  Sat Sep 22 10:51:00 2007
> Subject: [PATCH] usb-gadget-ether: Prevent oops caused by error interrupt
> 	race -V2 (comments update)
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Sat, 22 Sep 2007 19:41:01 +0200
>
> From: Benedikt Spranger <bene@linutronix.de>
>  
> eth_start_xmit() can race against a disconnect interrupt in the gadget
> device driver, which nukes all pending request. Right now we access the
> pending request list unconditionally and dereference the request list
> head itself in such a case, which results in an Oops.
>
> Check whether the list is empty before actually dereferencing
> dev->tx_reqs.next. Also add a comment for the second list_empty check
> further down to avoid confusion.
>
> Long standing bug. Patch should be applied to stable as well.
>
> Signed-off-by: Benedikt Spranger <bene@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>
> diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
> index 593e235..f2a7bd5 100644
> ...
