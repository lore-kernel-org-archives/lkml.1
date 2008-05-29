Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680AbYE2JXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbYE2JXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 05:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYE2JXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 05:23:42 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:33619 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751696AbYE2JXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 05:23:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=nzWhSmQv0l3cAhqVkdbCcQylAgKiRDzMvdI5U6UwEgMykG4JHW/U5Jh4gW4BxQ36kIRnbpRaUA99KUjXvvwO39uy863lqvm64pB2gVlEqHjvgp6RD1gcQ3yEPs52pvo1ngjKWRgtY3Nh90Pher/g/qWah2vbqnzSk4PRxHBxQnY=  ;
X-YMail-OSG: 6EMnlbsVM1mYcSVd9GgOW6pBy5oAx2xndez7db4r4rG9vaDYSCDlsGO7imrSt5onOuhGoRzPdEeeQNx2VGsOFyq2Hkga7Ilrqcp7eGPxkpl_CUymH4yScF5xLCwgTz1fdQo-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Eugene_Bordenkircher@selinc.com
Subject: Re: BUG/OOPS: Double Lock in fsl_usb2_udc.c
Date: Thu, 29 May 2008 02:23:39 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, Li Yang <leoli@freescale.com>
References: <OF581BDA23.991E51FC-ON88257457.007166AD-88257457.007B3064@selinc.com> <20080529014535.6065fa39.akpm@linux-foundation.org>
In-Reply-To: <20080529014535.6065fa39.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805290223.39368.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 28 May 2008 15:25:31 -0700 Eugene_Bordenkircher@selinc.com wrote:
> 
> > Looking through other drivers, I have seen them releasing the lock 
> > immediately before calling disconnect(), however, without being an expert 
> > with this driver, I'm not entirely sure that is the best option here. 

Yeah, general policy is to drop the UDC spinlock whenever
you call out to gadget driver code, since it may need to
reenter for various reasons.  (Though if drivers adopt some
other locking policy that works, that should be fine too.
Multiple locks don't seem to be needed.)

If this particular UDC driver doesn't let disconnect()
disable the endpoints, that's a bug.  All gadget drivers
should clean up on disconnect; and while the UDC code
ought to have aborted any pending I/Os, it should never
be disabling things the gadget driver enabled.

And as for calling disconnect() before proceeding with
enumeration ... if the UDC driver can sense disconnect
(most often done with a GPIO hooked up to provide IRQs
on VBUS edge transitions), it should do so then.  But
for boards that don't have VBUS sensing, then the only
hook to scrub out all the old/invalid connection state
is the USB reset sequence that starts enumeration.  And
that's what seems to be happening here.

- Dave
