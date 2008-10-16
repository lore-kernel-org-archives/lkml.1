Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbYJPRKB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbYJPRKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:10:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYJPRJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:09:52 -0400
Received: from smtp128.sbc.mail.sp1.yahoo.com ([69.147.65.187]:23191 "HELO
	smtp128.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751507AbYJPRJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:09:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=K7Ga2Qtzfn+FJN1xEG8Wa1y36pPxlj7HqDboI5Wq0Jkg/hv/A4dmbGq7wqmxIIZ7HoI1dhp2rmCWxkmCyqNHShVZYYze3Nc15zADo2bBSxRlrJoaTjDaqkB7yK/vvjJFzobgdE8p0z66157OeE4LhcRFcbzEpZUi22r+Y7fivI4=  ;
X-YMail-OSG: _Ov..jUVM1mQBUGbstDKvTmRYCGyYjqL9HqrX2XIaqwyw5gxOg2h55koUR1tLIeXl2FIBkb06i1O1ItZHaEo35PnH3J51JMxq2NgD9ESKCU3yc2Kep3wr9mEK5_qsJD_fSs-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: avorontsov@ru.mvista.com
Subject: Re: [patch] gpiolib: fix oops in gpio_get_value_cansleep()
Date: Thu, 16 Oct 2008 10:06:21 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
References: <200810160845.22281.david-b@pacbell.net> <20081016164330.GB27938@oksana.dev.rtsoft.ru>
In-Reply-To: <20081016164330.GB27938@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200810161006.21276.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 October 2008, Anton Vorontsov wrote:
> > -     return chip->get(chip, gpio - chip->base);
> > +     return chip->get ? chip->get(chip, gpio - chip->base) : 0;
> 
> Why don't we check the .set in the gpio_set_value? Because
> we must always call gpio_direction_output()?

Yes.  The output driver needs to be explicitly enabled,
to avoid misbehaving electic circuitry.


> It is not exactly the 
> same we work with the input direction.. is this documented anywhere?

In Documentation/gpio.txt since the very first versions.

See the section on "Spinlock-Safe GPIO access", where
special cases for reading the value of output GPIOs are
desribed.  Other aspects are mentioned in other spots.

For example, open drain signals -- as used with I2C and
other protocols -- only drive the "low" signal level,
and if code wants a "high" level it's got to verify that
nobody else is driving that shared line to low.  By
reading it back, even though it's configured as output.

- Dave


