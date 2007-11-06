Return-Path: <linux-kernel-owner+w=401wt.eu-S1756802AbXKFBiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802AbXKFBiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 20:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbXKFBij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 20:38:39 -0500
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:26090 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753632AbXKFBii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 20:38:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ztxMiMCW4TPubl13ZCr9sTLv5qKRIY1cRXTo/FGZr/0VZv2j6jMY49yBtE1fPoSiRhSsF9kqFBecWLcdND5Y2xd38ecigvHEz64mx8JpCWFIw4J97BZjuqdfJJJ9KgkehzEnM454ZUFOBzo5LWzYsudpCECks37IeIwFjijdZ34=  ;
X-YMail-OSG: cTaBGakVM1mn.QQXO3B7TATquUQxhinyis.sU7RwO9e523z5
From: David Brownell <david-b@pacbell.net>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [linux-usb-devel] device struct bloat
Date: Mon, 5 Nov 2007 17:38:34 -0800
User-Agent: KMail/1.9.6
Cc: linux-usb-devel@lists.sourceforge.net, Greg KH <greg@kroah.com>,
       Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>,
       Ingo Molnar <mingo@elte.hu>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       linux-kernel@vger.kernel.org, apw <apw@shadowen.org>
References: <20071103124823.6059640e@shemminger-laptop> <1194260234.27652.425.camel@twins> <20071105224929.GA30521@kroah.com>
In-Reply-To: <20071105224929.GA30521@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711051738.35080.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 November 2007, Greg KH wrote:
> --- linux-2.6-2.orig/drivers/spi/spi.c
> +++ linux-2.6-2/drivers/spi/spi.c

It'd be quicker to end up in the right hands if you had
split this big and random patch according to subsystem...

There's already a patch in the MM queue that removes
the SPI-private semaphore.  Except that it's missing
the bug noted below.

The class semaphore removal would be a different issue.


> @@ -613,7 +613,7 @@ int spi_write_then_read(struct spi_devic
>         }
>  
>         /* ... unless someone else is using the pre-allocated buffer */
> -       if (down_trylock(&lock)) {
> +       if (mutex_trylock(&lock)) {

According to its kerneldoc, mutex_trylock() follows the
spinlock model not the semaphore model.  So the sense of
this test is incorrect ... as will be any similar changes
in other parts of this patch:

 * NOTE: this function follows the spin_trylock() convention, so
 * it is negated to the down_trylock() return values! Be careful
 * about this when converting semaphore users to mutexes.

So the patch in the MM queue says "if (!mutex_trylock(...)) {

>                 local_buf = kmalloc(SPI_BUFSIZ, GFP_KERNEL);
>                 if (!local_buf)
>                         return -ENOMEM;

