Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbXL1Bia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbXL1Bia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 20:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXL1BiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 20:38:21 -0500
Received: from yue.linux-ipv6.org ([203.178.140.15]:45052 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbXL1BiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 20:38:20 -0500
Date: Fri, 28 Dec 2007 10:39:01 +0900 (JST)
Message-Id: <20071228.103901.82434638.yoshfuji@linux-ipv6.org>
To: julia@diku.dk
Cc: hpa@zytor.com, ray-lk@madrabbit.org, autofs@linux.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       yoshfuji@linux-ipv6.org
Subject: Re: [PATCH 1/4] fs/autofs: Use time_before, time_before_eq, etc.
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <Pine.LNX.4.64.0712270805370.6952@ask.diku.dk>
References: <2c0942db0712261158q34cddebeifceef6ceda683320@mail.gmail.com>
	<4772BD6C.1010502@zytor.com>
	<Pine.LNX.4.64.0712270805370.6952@ask.diku.dk>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <Pine.LNX.4.64.0712270805370.6952@ask.diku.dk> (at Thu, 27 Dec 2007 08:08:53 +0100 (CET)), Julia Lawall <julia@diku.dk> says:

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
> 
> Perhaps they should be coverted to use a subtraction as well?

No, use time_after() etc., unless you have very good reason not using them.
And above is not a good reason at all.
Frequency is not a problem.  If we have longer timeout which could
result in wrap-around, we must use another method, e.g. 64bit jiffies,
anyway.

--yoshfuji
