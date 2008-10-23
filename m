Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbYJWFTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbYJWFTT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 01:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbYJWFTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 01:19:09 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:42788 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751068AbYJWFTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 01:19:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=a5dH9pyGkvXcz2kwDy1TXlVINX7BQ7ZBma5s2qMS4dbMVVF8l6zkZSXUSWAbdPiIioQBo7MhBRm0wE3EWT/m49TzewONCPAHi0mGYOwejPhLh23R1W4ZNJ4d6PdQMQvOjLQdNKC5pim7EzWe4LEYQFvR6ogmRgeGrQXKyL37HTY=  ;
X-YMail-OSG: mppC87MVM1lscba7Pdi4knRJD2MunL24trPvnWTpe6a3iehzMQxqWcaQ6O2cLV1CAYSuI7j00TU5Qz5WnjWK3eYcbJrkBbSWzYFZl7shzzOG4zVcKLAz_boRJYVBIreGjUOxM2b.LaIQatCGeL31jJg8lMMb4iNmN9glkkY-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [PATCH 4/7] gpiolib: implement dev_gpiochip_{add,remove} calls
Date: Wed, 22 Oct 2008 22:19:03 -0700
User-Agent: KMail/1.9.10
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, i2c@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>, David Miller <davem@davemloft.net>
References: <20081016171222.GA24812@oksana.dev.rtsoft.ru> <200810221452.46786.david-b@pacbell.net> <20081022222940.GA14636@oksana.dev.rtsoft.ru>
In-Reply-To: <20081022222940.GA14636@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810222219.04768.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 October 2008, Anton Vorontsov wrote:
> > 
> > So have it live in the __init text section...
> 
> Won't work, unfortunately. I2C devices are created by the
> i2c controllers, via drivers/of_i2c.c  of_register_i2c_devices().

And I'm pointing out a way to have the normal I2C core code
flow do that creation.  OF shouldn't need to be so much of a
special case.


> There is a good reason to do so, the code needs to know
> controller's OF node to walk down and register the child nodes
> (devices). See drivers/i2c/busses/i2c-mpc.c -- it calls
> of_register_i2c_devices() at the end of the probe().

I don't get it.  (But then, so much of the OF support seems
needlessly convoluted to me ... on top of seeming to be
insufficient for configuring board-specific details.)

There's an OF device tree, distinct from the Linux driver
model tree.  Why should there be any obstacle to accessing
records from that tree before the relevant driver model nodes
have been created?  Remember that the various board_info
structs get registered before the driver model nodes for
which they are templates.  Just translate the OF tree data
to those templates(*), then register them.

I understand that it's currently structured differetnly
than that ... consulting the OF tree "late" not early.
But that's still newish, and from what I've heard so far
it doesn't seem like the best structure either... nothing
seems to plug in smoothly.

- Dave

(*) The role of the board_info structs is very similar
    to the role of OF device attributes.  As is the role
    of the platform_data ... except that's more specific
    to the chip involved (and its driver), and expects
    any callbacks to be in C code not FORTH.
