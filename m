Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790AbXL1FDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790AbXL1FDW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 00:03:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbXL1FDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 00:03:13 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36671 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750762AbXL1FDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 00:03:12 -0500
X-Greylist: delayed 1733 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Dec 2007 00:03:11 EST
X-Sasl-enc: P2MGuI2hsuRG6g4xgIauZDpzAeb9RKmek17cfEzpmS2K 1198816456
Subject: Re: [autofs] [PATCH 1/4] fs/autofs: Use time_before,
	time_before_eq, etc.
From: Ian Kent <raven@themaw.net>
To: Julia Lawall <julia@diku.dk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ray Lee <ray-lk@madrabbit.org>,
       autofs@linux.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0712270805370.6952@ask.diku.dk>
References: <Pine.LNX.4.58.0712261621000.1185@pc-041.diku.dk>
	 <2c0942db0712261158q34cddebeifceef6ceda683320@mail.gmail.com>
	 <4772BD6C.1010502@zytor.com> <Pine.LNX.4.64.0712270805370.6952@ask.diku.dk>
Content-Type: text/plain
Date: Fri, 28 Dec 2007 13:34:10 +0900
Message-Id: <1198816450.3089.24.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-12-27 at 08:08 +0100, Julia Lawall wrote:
> On Wed, 26 Dec 2007, H. Peter Anvin wrote:
> 
> > Ray Lee wrote:
> > > On Dec 26, 2007 7:21 AM, Julia Lawall <julia@diku.dk> wrote:
> > > > -               if (jiffies - ent->last_usage < timeout)
> > > > +               if (time_before(jiffies, ent->last_usage + timeout))
> > > 
> > > I don't think this is a safe change? subtraction is always safe (if
> > > you think about it as 'distance'), addition isn't always safe unless
> > > you know the range. The time_before macro will expand that out to
> > > (effectively):

I don't see how subtraction is any different in this case as that could
just as easily underflow leading to the same issue.

> > > 
> > >   if ( (long)(ent->last_usage + timeout) - (long)(jiffies) < 0 )
> > > 
> > > which seems to introduce an overflow condition in the first term.
> > > 
> > > Dunno, I may be wrong (happens often), but at the very least what
> > > you've transformed it into is no longer obviously correct, and so it's
> > > not a great change.
> > 
> > Indeed.  The bottom form will have overflow issues at time
> > jiffies_wraparound/2, whereas the top form will have overflow issues only near
> > jiffies_wraparound/1.
> 
> OK, so it seems like it is not such a good idea.
> 
> There are, however, over 200 files that contain calls to the various time 
> functions that follow this pattern, eg:
> 
> arch/arm/kernel/ecard.c:563
> if (!last || time_after(jiffies, last + 5*HZ)) {

Including autofs4.

> 
> Perhaps they should be coverted to use a subtraction as well?

Thinking about the cases involved always makes my head ache.

Ian


