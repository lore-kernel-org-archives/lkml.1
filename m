Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbXL1J2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbXL1J2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 04:28:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbXL1J2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 04:28:36 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:52990 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781AbXL1J2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 04:28:35 -0500
Date: Fri, 28 Dec 2007 10:27:06 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, autofs@linux.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 1/4] fs/autofs: Use time_before, time_before_eq, etc.
In-Reply-To: <4772BD6C.1010502@zytor.com>
Message-ID: <Pine.LNX.4.64.0712281016290.15274@ask.diku.dk>
References: <Pine.LNX.4.58.0712261621000.1185@pc-041.diku.dk>
 <2c0942db0712261158q34cddebeifceef6ceda683320@mail.gmail.com>
 <4772BD6C.1010502@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2007, H. Peter Anvin wrote:

> Ray Lee wrote:
> > On Dec 26, 2007 7:21 AM, Julia Lawall <julia@diku.dk> wrote:
> > > -               if (jiffies - ent->last_usage < timeout)
> > > +               if (time_before(jiffies, ent->last_usage + timeout))
> > 
> > I don't think this is a safe change? subtraction is always safe (if
> > you think about it as 'distance'), addition isn't always safe unless
> > you know the range. The time_before macro will expand that out to
> > (effectively):
> > 
> >   if ( (long)(ent->last_usage + timeout) - (long)(jiffies) < 0 )
> > 
> > which seems to introduce an overflow condition in the first term.
> > 
> > Dunno, I may be wrong (happens often), but at the very least what
> > you've transformed it into is no longer obviously correct, and so it's
> > not a great change.
> 
> Indeed.  The bottom form will have overflow issues at time
> jiffies_wraparound/2, whereas the top form will have overflow issues only near
> jiffies_wraparound/1.

Isn't this only the case if timeout is a potentially large number? In this 
case, timeout may ultimately depend on a value that come from the user 
level, so I don't know what ranges are expected, but in many other cases 
one of the summands is a constant multiplied by HZ.  If the constant is 
small, then I guess that the likelihood that jiffies overflows and the 
likelihood that the sum overflows are essentially the same.  One then has 
to consider whether:

overflowed - correct </>/<=/>= small constant

is more or less desirable than

time_before/after/before_eq/after_eq(correct, overflowed_by_small_constant)

julia

