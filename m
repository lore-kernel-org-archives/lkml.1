Return-Path: <linux-kernel-owner+w=401wt.eu-S1765564AbXE2S5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765564AbXE2S5v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 14:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760348AbXE2S5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 14:57:38 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:46716 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763471AbXE2S5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 14:57:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=XpRnTZGnyjPp/o4FJ6+rCCfp55WHLwZ3R9CRQNCPWSnrmTH4JU8SKP9ir+Bm+x1RmwQIzCbWC/Ht1M8iL5k+ScW6NyM+PxAqdq4Zfk85yDe2NmlGCfpzoWFTuOA1fG83av9VIPJ0HKBW0/3uc5KNgEsewHeXR3aol1POregl0uc=
Message-ID: <84144f020705291157k465ec6c4sb81081844bb57514@mail.gmail.com>
Date: Tue, 29 May 2007 21:57:23 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Tero Roponen" <teanropo@jyu.fi>
Subject: Re: tty-related oops in latest kernel(s)?
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <Pine.LNX.4.64.0705291900001.32656@jalava.cc.jyu.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705271200360.4955@jalava.cc.jyu.fi>
	 <84144f020705280022lf3902caj1def02ed56e0bff@mail.gmail.com>
	 <84144f020705280234g39aa04b3hfe369f4477e6043d@mail.gmail.com>
	 <Pine.LNX.4.64.0705291900001.32656@jalava.cc.jyu.fi>
X-Google-Sender-Auth: 69cc62f12a83cfd6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tero,

On 5/29/07, Tero Roponen <teanropo@jyu.fi> wrote:
> FYI, I just tested 2.6.21.3. I couldn't reproduce the problem with
> that kernel.

Well, I went through all tty related patches that went in after 2.6.21
and didn't really find anything interesting, except this:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=543691a6cd70b606dd9bed5e77b120c5d9c5c506

But it does seem correct. You could try reverting that from 2.6.22-rc3
and see if you can trigger the bug.

Looking at the original report again:

> release_dev: driver.table[3] not tty for (tty4)

So tty from filp->private_data does not match
tty->driver->ttys[tty->index] and release_dev bails out (thus messing
up reference count).

> Warning: dev (tty4) tty->count(3) != #fd's(2) in release_dev
> release_dev: driver.table[3] not tty for (tty4)

Presumably someone tries to close the file again which is why we get a
new complaint that reference counting has gone bad.

Unfortunately, I have no idea why drivers->tty does not match. It
could be a race with release_tty() or real use-after-free but I am
unable to find anything obvious in 2.6.21 -> 2.6.22-rc3 that would
break it. Doing the git bisect dance here would really help...
