Return-Path: <linux-kernel-owner+w=401wt.eu-S1755061AbYIXUs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbYIXUs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbYIXUr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:47:59 -0400
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:37523 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753387AbYIXUr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:47:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Vhj3EiOPtqXwyt0ffbZ5lYZ8osTtKF+FSSvSFp7gvjZmRAqTY/96Y9AuzyPIAgvKSLx1U5j7WskLzgdXwVbHmY4zmu0bUAn5N6ZI5J/H7dLZEmCvJPasg0U8bCLHH9Fv+BuPphhxnu5hQg3IRHi/TYuUwge3CUu5zhLta2xqBtc=  ;
X-YMail-OSG: n9JxKt0VM1msZb.DkC_U8f.Uou6fHJQJ7TS76bR9lYtTM0mQt7A6TtLbNNC0xYmnEYxpDqa8vKlC11.UEnlLzubZGe018h8awco_FzpArrIxsHp.Wa7FZY8ne9GGD7Ksda4-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Laurent Pinchart <laurentp@cse-semaphore.com>
Subject: Re: [PATCH 0/3] Patches to support QE USB Host Controller
Date: Wed, 24 Sep 2008 13:04:24 -0700
User-Agent: KMail/1.9.9
Cc: linuxppc-dev@ozlabs.org, avorontsov@ru.mvista.com,
       "Greg Kroah-Hartman" <greg@kroah.com>, linux-usb@vger.kernel.org,
       Li Yang <leoli@freescale.com>, linux-kernel@vger.kernel.org,
       Timur Tabi <timur@freescale.com>
References: <20080808161717.GA19095@polina.dev.rtsoft.ru> <200808141415.42109.laurentp@cse-semaphore.com>
In-Reply-To: <200808141415.42109.laurentp@cse-semaphore.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809241304.24878.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 August 2008, Laurent Pinchart wrote:
> 
> > David, could you bear with gpio_to_chip() exported function, just as
> > a stopgap for a proper api?
> 
> I need gpio_to_chip() (or another 'proper API') as well for RTS/CTS
> based flow control in the CPM/CPM2 UART driver. 

I'l still say "proper".  This should be straightforward; along
the lines of

	struct qe_pin {
		struct ... *qe_ports;	/* includes gpio_chip */
		unsigned offset;
	};

And instead of having the driver look up a "gpio" for such
non-GPIO usage, have it call something that sets up a qe_pin.
All that infrastructure exists already...

Then drivers can use calls which mux the pin into its "normal"
mode (QE function of some kind), or into its "gpio" mode.

The gpio number would be gpio_chip->base + offset, and the
gpio_chip is visible -- in a fully typesafe manner! -- from
the qe_ports structure.

No type-unsafe interfaces.  No confusion between roles of a
given pin.  No hidden assumption there's only one kind of GPIO
(backed by QE ports).  And ... no need to change any core
structural assumptions of the GPIO framework.

- Dave

