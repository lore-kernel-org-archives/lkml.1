Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756984Ab0BPPwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 10:52:22 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42881 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756775Ab0BPPwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 10:52:20 -0500
Date: Tue, 16 Feb 2010 10:52:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roel Kluin <roel.kluin@gmail.com>
cc: Joe Perches <joe@perches.com>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
       <linux-usb@vger.kernel.org>, <usb-storage@lists.one-eyed-alien.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: misplaced parenthesis
In-Reply-To: <4B7A7E86.4090806@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1002161047240.1716-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, Roel Kluin wrote:

> > I think it'd be better if you hoisted the set'n'test out of the if()
> 
> ok, I agree.
> 
> > Isn't this the current logic?
> > 
> > 	result = usbat_write_block(us, USBAT_ATA, srb->cmnd, 12,
> > 				   srb->cmnd[0] == GPCMD_BLANK ? 75 : 10, 0);
> > 	result = result != USB_STOR_TRANSPORT_GOOD;
> > 	if (result)
> > 		return result;
> 
> Thanks for your comments, Yes that was the current logic, which I thought
> was wrong, but now I think it could also be obscurely written but right:
> 
> in drivers/usb/storage/transport.h line 100 note the definitions:
> 
> #define USB_STOR_TRANSPORT_GOOD    0   /* Transport good, command good     */
> #define USB_STOR_TRANSPORT_FAILED  1   /* Transport good, command failed   */
> #define USB_STOR_TRANSPORT_NO_SENSE 2  /* Command failed, no auto-sense    */
> #define USB_STOR_TRANSPORT_ERROR   3   /* Transport bad (i.e. device dead) */
> 
> With the current logic usbat_hp8200e_transport() returns TRANSPORT_FAILED,
> even if usbat_write_block() returned TRANSPORT_NO_SENSE or TRANSPORT_ERROR.
> 
> This could be intended, but then the author chose a very obscure way to write:
> 
> 	if (usbat_write_block(us, USBAT_ATA, srb->cmnd, 12,
> 			      srb->cmnd[0] == GPCMD_BLANK ? 75 : 10, 0) !=
> 			      USB_STOR_TRANSPORT_GOOD) 
> 		return USB_STOR_TRANSPORT_FAILED;
> 
> Or was the parenthesis misplaced and should it really be:
> 
> 	result = usbat_write_block(us, USBAT_ATA, srb->cmnd, 12,
> 				   srb->cmnd[0] == GPCMD_BLANK ? 75 : 10, 0);
> 
> 	if (result != USB_STOR_TRANSPORT_GOOD)
>  		return result;
>  
> Maybe someone with the specs/more knowledge of this driver could look into
> this?

It seems pretty clear that your patch was correct and the parens were 
misplaced.  In usb-storage, transport routines like 
usbat_hp8200e_transport() are supposed to return one of the 
USB_STOR_TRANSPORT_* codes, not a Boolean value.

I do agree with Joe that it would be better form to separate the 
function call and the "if" into two statements, as in your second 
version above.  Compare with the code a few lines higher:

        if ( (result = usbat_multiple_write(us, 
                        registers, data, 7)) != USB_STOR_TRANSPORT_GOOD) {
                return result;
        }

The meaning is clear, even though this also unnecessarily squeezes a 
function call and a test into one statement and includes unneeded {}'s.

Alan Stern

