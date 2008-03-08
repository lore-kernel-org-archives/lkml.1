Return-Path: <linux-kernel-owner+w=401wt.eu-S1760886AbYCHDna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886AbYCHDna (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 22:43:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758718AbYCHDnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 22:43:18 -0500
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:23277 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758583AbYCHDnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 22:43:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=X6srNiHZ/dNPZApZFwvs1enyFT182uqO0gKpVnrmyXjmwQym23bj0kWLos7Ob7EoRUPB2b9501DPfIhOD6EesDwIfpEFSohIBFiE9r1ishhDM4u7+dHCqsu8Re1Yuc7zCzChQORBtex/FlVqIrMJGJqfGUmv6lvMPEvDaRIF6fQ=  ;
X-YMail-OSG: IQ4OE2wVM1kQdEjPrSSF0yVXfF.ZJpxbm3Yc7ilS7i.JWkE1mq94E3VPZBOWKHlyEs64fCpJuQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
Date: Fri, 7 Mar 2008 19:43:14 -0800
User-Agent: KMail/1.9.6
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main>
In-Reply-To: <1204827056.15360.147.camel@a10323.wolfsonmicro.main>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803071943.14805.david-b@pacbell.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2008, Liam Girdwood wrote:
> +static inline int uA_to_A(int uA) { return uA / 1000000; }

So:  999999 uA == 0A ... should DIV_ROUND_UP() or another
rounding function be involved in some of these conversions?
 
Or maybe the dividing conversions should not be provided, and
code should just be doing math in units that don't encourage
such problems to appear.  I don't think one rounding policy
can fit all (including truncation, as above).


> +struct regulator *__must_check regulator_get(struct device *dev,
> +                                            const char *id);

The semantics of "id" and "dev" are unspecified in this patch,
so this isn't a good definition of the consumer interface!

Plus, that works more like a "lookup" than a "get" ... the
usual convention is that "get" and "put" update refcounts.
But I think I see an assumption here that a regulator may
have only one user...


> +int regulator_set_voltage(struct regulator *regulator, int uV);

You described a mode where consumers could set ranges that
might overlap (e.g. 1.6 to 1.9V, 1.8 to 2.0) and the result
would be some compatible result.  But I don't see how that
could be achieved, since that's the only call to provide
a consumer's constraints.

Presumably one configures a voltage then enables it?  How
does one turn a voltage supply on or off?  I'm guessing
that zero volts doesn't equate to "off"...

Something that's lacking here is simple examples.  Like:  how
do I get the power supply associated with an MMC/SD card socket,
turn it on (to, say, 3V3), set it to supply a different voltage
(maybe 1V8), then turn it off?  How would I cope with that
voltage supply being shared by two sockets, with cards that may
support different voltage ranges and have different current
requirements?  (Configurations of interest include two cards
that can coexist at 1V8, and two that can't ... one might not
support 1V8, or it might demand too much power.  Also, zero
and one cards present.)

- Dave

