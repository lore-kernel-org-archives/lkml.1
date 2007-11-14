Return-Path: <linux-kernel-owner+w=401wt.eu-S1764484AbXKNHJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764484AbXKNHJZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 02:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762134AbXKNHIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 02:08:54 -0500
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:24526 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761015AbXKNHIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 02:08:52 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=YDzqhDmpbWUpVIj78OeT2adi4a3yy+w/y8lOltCul2PzaF1S//2l/W9aaEnrINi8rCkDpu7RaGU8KVTdNAtCbfXJEip3bs76DhejuRXcznm45Pss8S5zZNgs3q1GBO+KPTZGmixsEN0aT9VOpEW7dWWFOsCikuPPWGf7wfH8snI=  ;
X-YMail-OSG: BLha8ZwVM1l_HkfJvZ3YkYt8ORj22oXSaTScFOxlWIlpvEef_I9KvuGMGviAjhaGiRDW0C2vGQ--
From: David Brownell <david-b@pacbell.net>
To: "eric miao" <eric.y.miao@gmail.com>
Subject: Re: [patch/rfc 1/4] GPIO implementation framework
Date: Tue, 13 Nov 2007 23:08:47 -0800
User-Agent: KMail/1.9.6
Cc: "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Felipe Balbi" <felipebalbi@users.sourceforge.net>,
       "Bill Gatliff" <bgat@billgatliff.com>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Tony Lindgren" <tony@atomide.com>, "Jean Delvare" <khali@linux-fr.org>,
       "Kevin Hilman" <khilman@mvista.com>, "Paul Mundt" <lethal@linux-sh.org>,
       "Ben Dooks" <ben@trinity.fluff.org>
References: <200710291809.29936.david-b@pacbell.net> <200711131930.19878.david-b@pacbell.net> <f17812d70711132240m359fcd5doac56ab06bfe76f69@mail.gmail.com>
In-Reply-To: <f17812d70711132240m359fcd5doac56ab06bfe76f69@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200711132308.48779.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 November 2007, eric miao wrote:
> > > > We "can" do most anything. What would that improve though?
> >
> > ... What would that improve, though?  Your followup posts
> > still don't answer that question for me.  I see the code,
> > but don't have an answer to that question.
> >
> 
> to be honest, I don't feel like the holes. Put restrictions on
> the numbering of GPIOs might not be a good idea either.

So the point of these is to make it easier for platforms
(or even just boards) to make sure the GPIO number space
is densely packed, rather than loosely so?  Paying about
2KBytes for that privilege.  (Assuming a 32 bit system
with 256 GPIOs.)

I could see that being a reasonable tradeoff.  I wouldn't
have started there myself, but you know how that goes!

Does anyone else have any comments on that issue?


One point you haven't really brought up in this thread is
your concern about the impact of this on IRQs.  One issue
being that for GPIOs used as IRQs, with linear mappings
resembling

	static inline int gpio_to_irq(unsigned gpio)
	{
		if (gpio >= LAST_IRQ_CAPABLE_GPIO)
			return -EINVAL;
		return irq + FIRST_GPIO_IRQ_NUMBER;
	}

then tightly packed GPIOs mean less space wasted for IRQ
descriptors that would never be used.

And since an irq_desc bigger than your gpio_desc, there's
a tradeoff between wasting space on unused gpio_desc structs
versus unused irq_desc structs.  2 KBytes would cost about
only 35 irq_desc structs, vs 256 gpio_desc structs.

I'm guessing that's why you care about dense packing for
the GPIO numbers...

- Dave

