Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbXL1OWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbXL1OWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 09:22:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbXL1OVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 09:21:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbXL1OVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 09:21:50 -0500
Date: Fri, 28 Dec 2007 12:21:09 -0200
From: Fabio Olive Leite <fleite@redhat.com>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Julia Lawall <julia@diku.dk>, autofs@linux.kernel.org,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [autofs] [PATCH 1/4] fs/autofs: Use time_before, time_before_eq, etc.
Message-ID: <20071228142109.GA3801@sleipnir.redhat.com>
Mail-Followup-To: Ray Lee <ray-lk@madrabbit.org>,
	Julia Lawall <julia@diku.dk>, autofs@linux.kernel.org,
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
	hpa@zytor.com
References: <Pine.LNX.4.58.0712261621000.1185@pc-041.diku.dk> <2c0942db0712261158q34cddebeifceef6ceda683320@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2c0942db0712261158q34cddebeifceef6ceda683320@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2007 at 11:58:56AM -0800, Ray Lee wrote:
> 
> On Dec 26, 2007 7:21 AM, Julia Lawall <julia@diku.dk> wrote:
> > -               if (jiffies - ent->last_usage < timeout)
> > +               if (time_before(jiffies, ent->last_usage + timeout))
> 
> I don't think this is a safe change? subtraction is always safe (if
> you think about it as 'distance'), addition isn't always safe unless
> you know the range.

This thinking is wrong, and is exactly the kind of wrong thinking that
led to the time_{before,after}{,_eq} macros. If jiffies just wrapped,
your safe subtraction will underflow, and you'll be comparing very
different unsigned values.

This is only a concern for 32bit architectures, of course. With 64bit
jiffies, even if HZ is set to 1000000 in the far future, this
civilization will still not outlive the jiffies counter (insert
shocking soundtrack!) as it will wrap in half a million years.

Sadly with 32bit jiffies it currently wraps every 50 days, and the
sign (if cast to signed) changes every 25 days.

> The time_before macro will expand that out to
> (effectively):
> 
>   if ( (long)(ent->last_usage + timeout) - (long)(jiffies) < 0 )

After contemplating this for a very long time (for an NFS fix at the
time) I _think_ the magic is in the casts to signed. The construct
manages to compare correctly any given jiffie values within 2^31 of
each other (on 32bit arches) even with wraps, assuming you really have
timestamps where the second one is taken less than 2^31 jiffies after
the first.

Of course, if the highest jiffies bit wraps twice between the first
and second timestamps, you'll be comparing apples and oranges. If the
timing is right this can happen if you compare two timestamps i.e. 26
days from each other, but I think only NFS is wicked enough to produce
such long living (and stale) kernel data structures.

So in summary: don't question time_after and friends. Not without a
very good analysis and testing with a matrix of timestamps. :)

Cheers!
Fábio Olivé
-- 
ex sed lex awk yacc, e pluribus unix, amem
