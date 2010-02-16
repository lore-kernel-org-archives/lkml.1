Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab0BPLJA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 06:09:00 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:62765 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab0BPLI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 06:08:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eCo+3imZupObeTyBCgN+GaR6yJM+N4b4utWpMSvr5toApsbA1imMMBqKg4vaZaoO/y
         7u5Gt9zdQSYfqHu7WJeUyqLyHfIwYifif7sdC7rYEwO98D+HOB1KyKj1Hme72rVT4n9w
         UAdgFH4d1CTR4xAUZcYvbsAzMPe0Xm5lHLk8E=
Message-ID: <4B7A7E86.4090806@gmail.com>
Date: Tue, 16 Feb 2010 12:16:22 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-usb@vger.kernel.org,
       usb-storage@lists.one-eyed-alien.net,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: misplaced parenthesis
References: <4B79CD49.8070607@gmail.com> <1266273848.29987.21.camel@Joe-Laptop.home>
In-Reply-To: <1266273848.29987.21.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think it'd be better if you hoisted the set'n'test out of the if()

ok, I agree.

> Isn't this the current logic?
> 
> 	result = usbat_write_block(us, USBAT_ATA, srb->cmnd, 12,
> 				   srb->cmnd[0] == GPCMD_BLANK ? 75 : 10, 0);
> 	result = result != USB_STOR_TRANSPORT_GOOD;
> 	if (result)
> 		return result;

Thanks for your comments, Yes that was the current logic, which I thought
was wrong, but now I think it could also be obscurely written but right:

in drivers/usb/storage/transport.h line 100 note the definitions:

#define USB_STOR_TRANSPORT_GOOD    0   /* Transport good, command good     */
#define USB_STOR_TRANSPORT_FAILED  1   /* Transport good, command failed   */
#define USB_STOR_TRANSPORT_NO_SENSE 2  /* Command failed, no auto-sense    */
#define USB_STOR_TRANSPORT_ERROR   3   /* Transport bad (i.e. device dead) */

With the current logic usbat_hp8200e_transport() returns TRANSPORT_FAILED,
even if usbat_write_block() returned TRANSPORT_NO_SENSE or TRANSPORT_ERROR.

This could be intended, but then the author chose a very obscure way to write:

	if (usbat_write_block(us, USBAT_ATA, srb->cmnd, 12,
			      srb->cmnd[0] == GPCMD_BLANK ? 75 : 10, 0) !=
			      USB_STOR_TRANSPORT_GOOD) 
		return USB_STOR_TRANSPORT_FAILED;

Or was the parenthesis misplaced and should it really be:

	result = usbat_write_block(us, USBAT_ATA, srb->cmnd, 12,
				   srb->cmnd[0] == GPCMD_BLANK ? 75 : 10, 0);

	if (result != USB_STOR_TRANSPORT_GOOD)
 		return result;
 
Maybe someone with the specs/more knowledge of this driver could look into
this?

Thanks, Roel
