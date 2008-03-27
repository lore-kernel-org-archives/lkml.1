Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbYC0JyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbYC0JyG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755659AbYC0Jxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:53:55 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:50073 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755655AbYC0Jxz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:53:55 -0400
Date: Thu, 27 Mar 2008 10:53:23 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Dmitry <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hskinnemoen@atmel.com, lethal@linux-sh.org,
       tony@atomide.com, paul@pwsan.com
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing
 clocks.
Message-ID: <20080327105323.28a369fd@hskinnemo-gx620.norway.atmel.com>
In-Reply-To: <20080327093301.GB32396@flint.arm.linux.org.uk>
References: <20080326154913.GA15326@doriath.ww600.siemens.net>
	<20080326155203.GA15405@doriath.ww600.siemens.net>
	<20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com>
	<bc64b4640803260952s58ad0645ve11766fdfa45e785@mail.gmail.com>
	<20080327100623.34d92c84@hskinnemo-gx620.norway.atmel.com>
	<20080327091810.GA32396@flint.arm.linux.org.uk>
	<20080327102648.225d6b4f@hskinnemo-gx620.norway.atmel.com>
	<20080327093301.GB32396@flint.arm.linux.org.uk>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Mar 2008 09:53:24.0010 (UTC) FILETIME=[65A208A0:01C88FF0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[domen.puncer@telargo.com keeps bouncing on me, removed from Cc]

On Thu, 27 Mar 2008 09:33:01 +0000
Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> On Thu, Mar 27, 2008 at 10:26:48AM +0100, Haavard Skinnemoen wrote:
> > You can extend the struct, put the rate there and use the same
> > getrate() function for all the clocks that need to keep track of the
> > current rate this way.  
> 
> Well, if you're really concerned about size, you could do what I did with
> PXA and introduce a struct clk_ops to contain all the constant function
> pointers, rather than mashing the function pointers together - which
> saves far more than trying to combine them.

I don't see what this has to do with the paragraph you quoted, but
yeah, good point. I don't think it should be used as an excuse for
filling up struct clk with platform-specific crap, however.

So how about something like this?

struct clk_ops {
	struct module	*owner;

	int (*can_get)	(struct clk *, struct device *);
	int (*set_parent) (struct clk *, struct clk *);
	int (*enable)	(struct clk *);
	void (*disable)	(struct clk *);
	unsigned long (*getrate) (struct clk*);
	int (*setrate)	(struct clk *, unsigned long);
	long (*roundrate) (struct clk *, unsigned long);
};

struct clk {
	struct list_head node;
	struct clk	*parent;

	const char	*name;
	int		users;

	const struct clk_ops *ops;
};

Haavard
