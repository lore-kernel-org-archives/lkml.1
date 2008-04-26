Return-Path: <linux-kernel-owner+w=401wt.eu-S1760589AbYDZSCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589AbYDZSCa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 14:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757643AbYDZSCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 14:02:22 -0400
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:25021 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752742AbYDZSCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 14:02:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qasOmHnGErSNClLED7dN91O+F8E3YEqCOsqBSpd3R2Z3YdjnPJAWEcOfQlsVGEN0XZw9Dn6EdL7rDFmFX9u46pgqchDWsYi47SUWXq0Q1VY6HOcnUO56xSPbNYP4XGHkHuk1X37N69vG1yxEa0XQjMa796vWj/aRDlb9AfvOAB8=  ;
X-YMail-OSG: VjoDqmEVM1n_XqA4vco4FdFJ.6DmoGX9lteqoz9DXmtfmBBY5a1aeDRzNipffwoHn193m4SCv74XXI9uw3yhUbwP7L_Lg7V6RqvfDXs__C2RVyQTE2SoIDsUNmUner7MQBs-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Dmitry <dbaryshkov@gmail.com>
Subject: Re: [PATCH 0/5] Clocklib: generic clocks framework
Date: Sat, 26 Apr 2008 11:02:15 -0700
User-Agent: KMail/1.9.6
Cc: "Paul Walmsley" <paul@pwsan.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>,
       "pHilipp Zabel" <philipp.zabel@gmail.com>,
       "Pavel Machek" <pavel@ucw.cz>, tony@atomide.com, hiroshi.DOYU@nokia.com
References: <20080420082925.GA32739@doriath.ww600.siemens.net> <alpine.DEB.1.00.0804250221040.14755@utopia.booyaka.com> <bc64b4640804260147o70253917me32b0e35a1ce6ad8@mail.gmail.com>
In-Reply-To: <bc64b4640804260147o70253917me32b0e35a1ce6ad8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200804261102.16011.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 April 2008, Dmitry wrote:
> > I wouldn't pretend to have a comprehensive list at this point.  But from a
> > brief look, your clk_round_rate() and clk_set_rate() implementations will
> > not work for the present OMAP clock tree.  In OMAP, many parent clocks do
> > not have the same rate as their children.
> 
> You can easily override any calculations in your clk->set_rate/clk->round_rate/
> clk->get_rate functions.

Speaking of which:  those clk_*() interfaces need to be better
specified.  Right now they're too vague to support fully portable
callers.

 - What kind of "rounding" is provided?  Using a 10 MHz target
   rate as an example, with a 48 MHz base and a binary divider:
     * "not-lower-than" would give 12 MHz (divide-by-4)
     * "not-higher-than" would give 6 MHz (divide-by-8)
     * "closest" would give 12 MHz, only 2 MHz off
   The differences can matter, depending on what the clock drives.

   Similarly, for DPLL based clocks (out = (in/DIV)*MUL) there
   can be "lowest power" goals, like "use biggest DIV that
   produces an output within <this> error bound". 

 - Does clk_set_rate() round, or does it fail when it can't set
   that exact rate?  (Would an 0.05% difference matter?)

This issue is orthogonal to whether clocklib merges or not (and
if so, when) ... except that if it does merge, then the answers
from clocklib will become the de facto answer to those questions.

- Dave
