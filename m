Return-Path: <linux-kernel-owner+w=401wt.eu-S1756566AbZBIRzh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbZBIRzh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:55:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZBIRz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:55:28 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56926 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbZBIRz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:55:27 -0500
Date: Mon, 9 Feb 2009 17:55:14 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Davide Rizzo <elpa.rizzo@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, ben-linux@fluff.org,
       linux-api@vger.kernel.org
Subject: Re: [PATCH 1/2] User access to internal clocks
Message-ID: <20090209175514.GB19453@n2100.arm.linux.org.uk>
References: <8447d6730902090904y138af9c6r3d64278bc7a30811@mail.gmail.com> <20090209171042.GA19453@n2100.arm.linux.org.uk> <8447d6730902090944s9bc96f7r76da82ea09c629f0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8447d6730902090944s9bc96f7r76da82ea09c629f0@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 09, 2009 at 06:44:40PM +0100, Davide Rizzo wrote:
> >> This driver is for user level programs to interact with system clocks.
> >> It allows to read and modify rates and parents, using virtual files.
> >> It requires the implementation of 2 additional functions in the clk interface:
> >>  clk_for_each() and clk_name().
> >> Actually I implemented that functions only for Samsung S3C24xx platform.
> >
> > NAK.
> >
> >> +       name = clk_get_name(clk);
> >
> > This implies that there is a 1:1 relationship between a 'name' and a
> > struct clk.  No such thing exists (and where it does, it's being
> > eliminated in ARM because it's just plain and simple WRONG.)
>
> Not exactly, clk_get() could work in both way: a struct clk can be
> exactly identified by name and device id (like clk_get is acting now)
> or by full name, in the format clkname.device

You're not understanding the issue(s).

1. there is no 1:1 mapping between the identifiers (struct device +
   connection ID) and the struct clk.  It's actually a many-to-one
   mapping.

   That means there is _no_ name associated with a struct clk.

   Conceptually, clk_get() gives you a struct clk for the struct device
   and a connection ID.  How that mapping is achieved isn't specified
   in the API, all that's required is that such a mapping is performed.
   It is _specifically_ intended that more than one set of {device,id}
   pairs will map to the same clk.

   So, now to insist that you can go from a struct clk to some kind of
   string identifier for it is changing this - you're now requiring
   that every struct clk has a unique name.  This is not the case.
   PXA, for instance, struct clk's are now completely nameless.  They
   have no identifier.

   If you want to have a string identifier which works in every case,
   this will:

	sprintf(identifer, "%p", clk);

   Or, I guess you could force every struct clk to have a 'sysfs_name'
   field just to export them out via sysfs - and that'll be all that
   it's used for.

2. there is no generic way to walk a set of struct clk's - indeed, there
   may be no list of them (and there exists implmentations where that is
   true) and the only list which does exist is a set ID to clk mapping
   structures.

> Otherwise, what do you suggest to enumerate and distinguish all system
> clocks ?

There exists no such concept in the API, what you're asking for is
implementation specific.
