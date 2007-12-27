Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbXL0HJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbXL0HJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 02:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbXL0HJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 02:09:14 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:38706 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbXL0HJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 02:09:13 -0500
Date: Thu, 27 Dec 2007 08:08:53 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, autofs@linux.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/4] fs/autofs: Use time_before, time_before_eq, etc.
In-Reply-To: <4772BD6C.1010502@zytor.com>
Message-ID: <Pine.LNX.4.64.0712270805370.6952@ask.diku.dk>
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

OK, so it seems like it is not such a good idea.

There are, however, over 200 files that contain calls to the various time 
functions that follow this pattern, eg:

arch/arm/kernel/ecard.c:563
if (!last || time_after(jiffies, last + 5*HZ)) {

Perhaps they should be coverted to use a subtraction as well?

julia

