Return-Path: <linux-kernel-owner+w=401wt.eu-S933243AbYBNWRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933243AbYBNWRD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 17:17:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756539AbYBNWQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 17:16:48 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4040 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756856AbYBNWQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 17:16:46 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 2/6] fs/direct-io.c: Use DIV_ROUND_UP
Date: Thu, 14 Feb 2008 23:16:44 +0100
User-Agent: KMail/1.9.7
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Nishanth Aravamudan <nacc@us.ibm.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.58.0802141614050.1185@pc-041.diku.dk> <84144f020802141018i235d3adfu13a84d124dc3964e@mail.gmail.com> <Pine.LNX.4.64.0802142049510.19977@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0802142049510.19977@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802142316.44985.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > >  Is it just me, or does
> > >
> > >         ((user_addr + iov[seg].iov_len + PAGE_SIZE - 1)/PAGE_SIZE - user_addr/PAGE_SIZE)
> > >
> > >  not simplify to
> > >
> > >         = ((iov[seg].iov_len + PAGE_SIZE - 1)/PAGE_SIZE + user_addr/PAGE_SIZE - user_addr/PAGE_SIZE)
> > >
> > >         = ((iov[seg].iov_len + PAGE_SIZE - 1)/PAGE_SIZE)
> > >
> > >         = DIV_ROUND_UP(iov[seg].iov_len, PAGE_SIZE)
> > >
> > >  CMIIW.
> > 
> > I double-checked this and I believe you're correct. It's simpler to
> > see when you do:
> > 
> >   x = user_addr
> >   y = iov[seg].iov_len
> >   z = PAGE_SIZE
> > 
> > So
> > 
> >   (x + y + z - 1)/z - x/z
> > 
> >   = [x + (y + z - 1)]/z - x/z
> > 
> >   = [xz + z(y + z - 1)]/z^2 - x/z
> > 
> >   = x/z + (y + z - 1)/z - x/z
> > 
> > And the rest follows from your simplifications.
> 
> It doesn't work:
> 
>  ((3+4+5-1)/5) - (3/5) = 2
>  ((4+5-1)/5) = 1

Logic was wrong but conclusion was right :) and so was Nishanth:

(a + b) + c = a + (b + c)

and

k   l   k + l
- + - = -----
m   m     m

thus:

(user_addr + iov[seg].iov_len + PAGE_SIZE - 1) = user_addr + (iov[seg].iov_len + PAGE_SIZE - 1)

and


user_addr + iov[seg].iov_len + PAGE_SIZE - 1   user_addr
-------------------------------------------- - --------- =
                 PAGE_SIZE                     PAGE_SIZE


user_addr   iov[seg].iov_len + PAGE_SIZE - 1   user_addr
--------- + -------------------------------- - --------- = 
PAGE_SIZE               PAGE_SIZE              PAGE_SIZE


iov[seg].iov_len + PAGE_SIZE - 1
--------------------------------
           PAGE_SIZE


or even more:


iov[seg].iov_len - 1
-------------------- + 1
     PAGE_SIZE


Regards,

	Mariusz
