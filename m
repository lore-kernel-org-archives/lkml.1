Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbYK2Wzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbYK2Wzt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 17:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120AbYK2WzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 17:55:11 -0500
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:30448 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752935AbYK2WzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 17:55:09 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=GjyVxeGGq4XSbRSnjxACpRxxKkNyL38WXg7/IQcF7Yc0R8EO4kUyq3fc9w8YIPUtr0Cg2AC461zQmcf0ItghOltxULIl1ojZjEil4eNVgFSqi11/k1yxnxgJpK2TR88al+n/sxw60xHYlORGefQrSU4Zc5klIkkjFriiEgUwLlM=  ;
X-YMail-OSG: pDLLlbQVM1mxkIQyPjlrCXwq6OKsDDDRj4YfPjU9fCMVotLnoBw2edxAfNIawELSGUSRt9StRDBrtuPOp.WbuzCR.QHlOyEyWNu4cYxcDa_cfmC_gndBlbiJvwX2B4EwYRQ-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Jaya Kumar" <jayakumar.lkml@gmail.com>,
       "Paulius Zaleckas" <paulius.zaleckas@teltonika.lt>
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
Date: Sat, 29 Nov 2008 14:47:28 -0800
User-Agent: KMail/1.9.10
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "Eric Miao" <eric.miao@marvell.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Philipp Zabel" <philipp.zabel@gmail.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Ben Gardner" <bgardner@wabtec.com>, "Greg KH" <greg@kroah.com>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com> <492D125D.5010607@teltonika.lt> <45a44e480811260118v440716bbqa8d37c8b696c148a@mail.gmail.com>
In-Reply-To: <45a44e480811260118v440716bbqa8d37c8b696c148a@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200811291447.29932.david-b@pacbell.net>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 November 2008, Jaya Kumar wrote:
> On Wed, Nov 26, 2008 at 4:09 AM, Paulius Zaleckas wrote:
> > Jaya Kumar wrote:
> >>       void                    (*set)(struct gpio_chip *chip,
> >>                                               unsigned offset, int value);
> >> +     void                    (*set_bus)(struct gpio_chip *chip,
> >> +                                             unsigned offset, int values,
> >
> > I think values should be unsigned
> 
> Okay, can do but it is unusual no?

For bitmasks, anything except "unsigned long" is unusual.
In fact, <linux/bitmask.h> uses them in arrays...

If this goes through, I suspect it would be fair to expect
a gpio_chip to work with only one word at at time.  SOC based
GPIO controllers stick to their natural word sizes (32 or 16
bits in most cases), in arrays, and I've yet to come across
external controllers that are any different.  So passing in
arrays of "unsigned long" would seem to be overkill.

However, "set_bus" is seems misleading to me:  "set" because
it makes me think it's writing to the set_bits register,
which won't clear things; "bus" because this is doing ganged
operations, which aren't only for busses ... and in fact a
bus operation probably needs multiple ganged operations,
e.g. first write the address, handshake, then write data and
handshake again.

Maybe words like "assign" and "bitmask" would get past those
particular issues... though I don't hugely like "assign".

In terms of low level primitives, I've already commented
that the "read" side is missing.  An additional issue came
to mind:  the policy of using contiguous bits should not
be mandated here.  It doesn't need to be, either ... just
pass a mask of valid bits, along with a mask of values.


> since set uses int value, i figured set_bus should be similar right?

It doesn't take a bitmask; that's a single zero/nonzero value,
for which the sign (bit) is irrelevant.  It's signed mostly to
distinguish the two parameters by type, so it's less easy to
confuse them; sometimes the compiler will point out goofage.
(Plus, the offsets can ever be negative.)

- Dave
