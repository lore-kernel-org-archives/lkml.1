Return-Path: <linux-kernel-owner+w=401wt.eu-S1759821AbYB2LJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821AbYB2LJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 06:09:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbYB2LJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 06:09:31 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751742AbYB2LJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 06:09:30 -0500
Date: Fri, 29 Feb 2008 03:08:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Julia Lawall <julia@diku.dk>
Cc: Mark Pearson <devnull.port@googlemail.com>,
       Karol Kozimor <sziwan@hell.org.pl>, corentincj@iksaif.net,
       sziwan@users.sourceforge.net, acpi4asus-user@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/9] drivers/acpi/asus_acpi.c: Correct use of ! and &
Message-Id: <20080229030844.9a7594ba.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802291154100.1081@ask.diku.dk>
References: <Pine.LNX.4.64.0802262142120.18200@ask.diku.dk>
	<7C626792-02A6-4BE6-B5F2-D75899F3990C@hell.org.pl>
	<47C5ABFB.3050607@googlemail.com>
	<20080228215503.b942bb3c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0802291154100.1081@ask.diku.dk>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008 12:01:26 +0100 (CET) Julia Lawall <julia@diku.dk> wrote:

> On Thu, 28 Feb 2008, Andrew Morton wrote:
> 
> > On Wed, 27 Feb 2008 19:29:15 +0100 Mark Pearson <devnull.port@googlemail.com> wrote:
> > 
> > > Karol Kozimor wrote:
> > > > On 26-02-2008, at 21:42, Julia Lawall wrote:
> > > >>      if (invert)        /* invert target value */
> > > >> -        led_out = !led_out & 0x1;
> > > >> +        led_out = !(led_out & 0x1);
> > > >>
> > > >>      if (!write_acpi_int(hotk->handle, ledname, led_out, NULL))
> > > >>          printk(KERN_WARNING "Asus ACPI: LED (%s) write failed\n",
> > > > 
> > > > 
> > > > IIRC we're just supposed to flip the last bit here, so the original code
> > > > is correct.
> > > > Best regards,
> > > > 
> > > 
> > > Seems an odd way of doing:
> > > 
> > > 	led_out ^= 0x01;
> > 
> > It does.
> > 
> > > It this due to some optimisation?
> > 
> > Surely not ;)
> > 
> > That code has been there for many years.
> > 
> > I changed the patch to this:
> > 
> > --- a/drivers/acpi/asus_acpi.c~drivers-acpi-asus_acpic-correct-use-of-and
> > +++ a/drivers/acpi/asus_acpi.c
> > @@ -610,7 +610,7 @@ write_led(const char __user * buffer, un
> >  	    (led_out) ? (hotk->status | ledmask) : (hotk->status & ~ledmask);
> >  
> >  	if (invert)		/* invert target value */
> > -		led_out = !led_out & 0x1;
> > +		led_out = !led_out;
> 
> I don't think this is the same:
> 
> !(0110 & 0x01) = !0 = 1
> !0110 = 0
> 
> led_out ^= 0x01;
> 
> is also not the same:
> 
> 0110 ^ 0x01 = 0111
> 
> Is it desired to keep the value and flip the last bit or just obtain the 
> opposite of the last bit?
> 

led_out can only take the values 0 or 1 here.
