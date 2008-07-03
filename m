Return-Path: <linux-kernel-owner+w=401wt.eu-S935408AbYGCHMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935408AbYGCHMl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 03:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbYGCG62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 02:58:28 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:39629 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754863AbYGCFlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 01:41:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=n3SdR7rsFHvpMyQPckTyt6IO7e/43SURYRrXKz8guPr55sXsVASNlVu17tK7ov/r3dvunB+fYp2/D/DC0SgfogeFMblLFtL50JLJqcyPcS3sicnHcl1o2D6bFzXLO7/ppaJQyipFB0dVxnyTquCAXnm8aAsM9KswVtu0DevxCz0=  ;
X-YMail-OSG: NPYjdkoVM1lqP8mRNhRnHs7T0WHmV_OHQXFYwXdJXg1thm_P4EmRBwQk.SweTCYHsxMko49blMq6ByNdNGaqyt_LBcmKO6PdZeu8GNRFfA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] gpiolib: Allow user-selection
Date: Wed, 2 Jul 2008 22:41:27 -0700
User-Agent: KMail/1.9.9
Cc: Michael Buesch <mb@bu3sch.de>, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
References: <200807022346.53222.mb@bu3sch.de> <200807022200.49428.david-b@pacbell.net> <20080702220842.44364045.akpm@linux-foundation.org>
In-Reply-To: <20080702220842.44364045.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807022241.28046.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 July 2008, Andrew Morton wrote:
> 
> > I'm thinking some driver model changes broke the gpio sysfs
> > interface code, and this happens to show up right now because
> > that code wasn't previously getting built.
> > 
> > Grumph.  I can easily switch the device_create() over to
> > use device_create_drvdata() -- didn't I already send in
> > a patch like that? -- but the other stuff is completely
> > backwards-incompatible.
> > 
> 
> beats me ididntdoitnobodysawmedoit.

I hope you got the T-shirt while you weren't doing all that!  :)


> But what I am repeatedly seeing is people cheerfully raising 2.6.27
> patches against the 2.6.26 tree when we have a nice 2.6.27 tree for
> developing against.  Those days are over, guys.
 
In this case, the contract seems to have changed.  Previously,
it was that folk doing the API changes would change everyone
using the APIs ... in this case, that's not happened.  (And I
can sort of understand why.  No matter how it's done, someone
is going to get extra work because of those changes.)
 
 
> I'm also seeing obvious signs that developers aren't _testing_ their
> new code within the context of the 2.6.27 tree.  They're obviously
> testing their stuff against 2.6.26

As they most certainly should.  That's already a lot of
variables in the test process, and anyone wanting to
actually *USE* that code right now will probably not want
all the added turnover and variables of the -next tree.


> and then hoping and praying, only it 
> doesn't always work out for them.

The new "-next" process is still working out.  Backwards-incompatible
changes will *always* make problems.  In this case there seem to
have been three such changes:

	- device_create() vanishing, even for users which did the
	  locking correctly ... this was at least something of a
	  graceful migration, although it would have been better
	  if it were deprecated first.  Change can work against
	  the current (2.6.26) code base.

	- class.devices vanishing ... what I really needed was
	  more of a "is this class initialized yet" call, so
	  testing for class->devices.next non-null can be replaced
	  by a test for class->p non-null.  (Or maybe this should
	  be viewed as needing a "real" driver model call, so that
	  code which must run before driver model init can more
	  easily cooperate with driver model stuff that has to
	  run much later, after the guts are initialized.)

	- Extra parameter to class_find_device().  This could
	  have been done in a backwards-compatible manner, like
	  device_create() was, but ... it wasn't.

When I finish pulling linux-next, I'll make an updated patch.
And probably send in an updated version of Michaels patch;
though I imagine the update will be no more than a s-o-b.

- dave
