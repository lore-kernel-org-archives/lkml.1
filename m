Return-Path: <linux-kernel-owner+w=401wt.eu-S1754974AbZKWObh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974AbZKWObh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754706AbZKWObg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:31:36 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:46959 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbZKWObf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:31:35 -0500
Date: Mon, 23 Nov 2009 15:31:40 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pavel Machek <pavel@ucw.cz>, Kay Sievers <kay.sievers@vrfy.org>,
       David Zeuthen <david@fubar.dk>, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle
	changes
Message-ID: <20091123143140.GG8742@kernel.dk>
References: <20091117185742.GA19829@srcf.ucam.org> <ac3eb2510911181130l6f25642cy1d5332f79a112cf9@mail.gmail.com> <20091118194053.GB12944@srcf.ucam.org> <ac3eb2510911181147ufeacb58u5194b0e1e5fd86d6@mail.gmail.com> <20091118195342.GA13627@srcf.ucam.org> <ac3eb2510911181203r1be5c3dajdacec94f196d550c@mail.gmail.com> <20091118200712.GA14026@srcf.ucam.org> <20091122233749.GA9699@ucw.cz> <20091123141754.GE8742@kernel.dk> <20091123142557.GA10084@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123142557.GA10084@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23 2009, Matthew Garrett wrote:
> On Mon, Nov 23, 2009 at 03:17:54PM +0100, Jens Axboe wrote:
> 
> > I have to agree, doing a mod_timer() on every single IO is going to suck
> > big time. I went to great lengths to avoid doing that even for timeout
> > detection. So that's pretty much a non-starter to begin with.
> 
> It's conditional on a (default off) setting, so it's not a hit unless 
> the user requests it. But yeah, the performance hit is obviously a 
> concern. It may be that polling is the least bad way of doing this.

Even if it's off by default, doesn't mean we shouldn't make the
implementation correct or fast :-)

> > Additionally, as Bart also wrote, you are not doing this in the right
> > place. You want to do this post-merge, not for each incoming IO. Have
> > you looked at laptop mode? Looks like you are essentially re-inventing
> > that, but in a bad way.
> 
> Right, that's mostly down to my having no familiarity with the block 
> layer at all :) I can fix that up easily enough, but if a deferrable 
> timer is going to be too expensive then it'll need some rethinking 
> anyway.

Well, take a look at laptop mode. A timer per-io is probably
unavoidable, but doing it at IO completion could mean a big decrease in
timer activity as opposed to doing it for each incoming IO. And since
you are looking at when the disk is idle, it makes a lot more sense to
me to do that when the we complete a request (and have no further
pending IO) rather than on incoming IO.

Your biggest performance issue here is going to be sync IO, since the
disk will go idle very briefly before being kicked into action again.

-- 
Jens Axboe

