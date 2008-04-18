Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbYDRQYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbYDRQYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 12:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbYDRQYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 12:24:30 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:60364 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbYDRQY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 12:24:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=EV4zbf5fE7EJn2zS5soXvJvBjiglTj5WUib+exWoWCdoTA0wKy1xCEJUHJ2I4txBijAJzkRl6HaOchjXaGYJ0YFTsGo/bce+/MDmWQJ2YkOPLg8dpTr/N4G8qSmLyJaKyOPcx/LS8COQy5Smiha4UDHwlSl9SFLTel6h2dv5824=
Message-ID: <2c0942db0804180924n2ee701e5w7166a203569fc669@mail.gmail.com>
Date: Fri, 18 Apr 2008 09:24:27 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: [PATCH 5/5] tun: vringfd xmit support.
Cc: "Andrew Morton" <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       "Max Krasnyansky" <maxk@qualcomm.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200804190115.15983.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804181433.48488.rusty@rustcorp.com.au>
	 <200804181443.24812.rusty@rustcorp.com.au>
	 <20080418043120.ff78eab5.akpm@linux-foundation.org>
	 <200804190115.15983.rusty@rustcorp.com.au>
X-Google-Sender-Auth: 66b5ed9625cd085b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2008 at 8:15 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> On Friday 18 April 2008 21:31:20 Andrew Morton wrote:
>  > On Fri, 18 Apr 2008 14:43:24 +1000 Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> > > +           /* How many pages will this take? */
>  > > +           npages = 1 + (base + len - 1)/PAGE_SIZE - base/PAGE_SIZE;
>  >
>  > Brain hurts.  I hope you got that right.
>
>  I tested it when I wrote it, but just wrote a tester again:
>
>  base            len     npages
>  0               1       1
>  0xfff           1       1
>  0x1000          1       1
>  0               4096    1
>  0x1             4096    2
>  0xfff           4096    2
>  0x1000          4096    1
>  0xfffff000      4096    1
>  0xfffff000      4097    4293918722

Picky, picky :-).

If base were always page aligned, we'd want

    npages = (len + PAGE_SIZE - 1) / PAGE_SIZE;

which is simply rounding len up to the next largest page size. So when
base is not page aligned, increase len by the left-over space at the
beginning, and then do the same calculation as above. (ie, pretend
base is page aligned, and instead count the excess at the beginning as
part of len.)

    npages = ( (base & PAGE_MASK) + len + PAGE_SIZE - 1) / PAGE_SIZE;

As long as len < PAGE_MASK - PAGE_SIZE, we're safe from overflows.

(The above gives a different answer when len=0, but you guard for that.)
