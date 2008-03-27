Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbYC0J3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbYC0J3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751023AbYC0J3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:29:30 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:12388 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYC0J33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:29:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Dmty2mmxGvKVKu/rT8AekvhiktKAQ+bQON0oF0vSGRXrnWixUqGiEfT4BdsbOsozM6eMvPIjQ8QxIubbzn+mbbC3vdCfbYHFhIJqABm8LTWrUJln9pzfVwlzO0RNz5OGqUJDGMcW87e6QWidI7NgkrCkENaOTftPLDGzmQ7oAdg=
Message-ID: <74d0deb30803270229h1244c5bfr5ca521dbb87b0583@mail.gmail.com>
Date: Thu, 27 Mar 2008 10:29:27 +0100
From: "pHilipp Zabel" <philipp.zabel@gmail.com>
To: "Russell King" <rmk+lkml@arm.linux.org.uk>
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing clocks.
Cc: "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       Dmitry <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hskinnemoen@atmel.com,
       domen.puncer@telargo.com, lethal@linux-sh.org, tony@atomide.com,
       paul@pwsan.com
In-Reply-To: <20080327091810.GA32396@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080326154913.GA15326@doriath.ww600.siemens.net>
	 <20080326155203.GA15405@doriath.ww600.siemens.net>
	 <20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com>
	 <bc64b4640803260952s58ad0645ve11766fdfa45e785@mail.gmail.com>
	 <20080327100623.34d92c84@hskinnemo-gx620.norway.atmel.com>
	 <20080327091810.GA32396@flint.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2008 at 10:18 AM, Russell King
<rmk+lkml@arm.linux.org.uk> wrote:
> On Thu, Mar 27, 2008 at 10:06:23AM +0100, Haavard Skinnemoen wrote:
>  > > +   int             users;
>  >
>  > Reference counting, probably need that too.
>  >
>  > > +   unsigned long   rate;
>  >
>  > This one is redundant. Use getrate() instead.
>
>  ... which means a separate getrate() functions for every clock.  Not really
>  practical for PXA.

struct pxa_clk {
       struct clk generic_clk;
       int rate;
       int delay;
}

unsigned long pxa_clk_getrate (struct clk *clk)
{
        return container_of(clk, struct pxa_clk, generic_clk)->rate;
}

>  > > +   int             delay;
>  >
>  > Huh? A delay after enabling the clock? Why can't the enable() hook do
>  > that if it's really necessary?
>
>  ... which means a separate enable() function for each clock.  The delay
>  there has not a lot to do with the actual register you're frobbing, but
>  the resy of the SoC.  So, again, not really practical for PXA.

int pxa_clk_mode(struct clk *clk, bool enabled)
{
        if (enabled)
                udelay(container_of(clk, struct pxa_clk, generic_clk)->delay);
        generic_clk_mode(clk, enabled);
}

>  The result for PXA is a tradeoff between reducing the data size and
>  increasing the text size, or increasing the data size and keeping
>  the existing data size.

Wouldn't something like the above work without increasing text size too much?

regards
Philipp
