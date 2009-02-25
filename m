Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbZBYDYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbZBYDYt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 22:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbZBYDYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 22:24:38 -0500
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:27590 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754006AbZBYDYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 22:24:37 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=PSttQF31+xR/exDMyj+kWCuHAY8L2DFHtoujuFR+I3NxDvraXQQ3SPKCUWp37oN2Ybrss5DdT6VVXjSux7fKCKKyTKKCInqhIQn0OG3h5X/njpG3455IK1JgHcEErOsddXXhd4BEuvz5eRp7G7Zg9/0zzWPphnny9naaT8r66ZU=  ;
X-YMail-OSG: 9Itj5cIVM1muzzb3UpjWnkwWIU6Ts57bzOD_CZYYvRgg88Mczh9Vtsg7ldqj_lcGMNJ41PvMG7PpYWY0zT9erKcQ5ZC29s3UOX3Ic4910iMxDcFSTpZ9Obm0slpqyfcKJPQz8.duVZlQzh4K1Rz63jKG.8SJuQX2Wqos64yt4wCkqP39Kv9hJWDnhDujLg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Performance regression in write() syscall
Date: Wed, 25 Feb 2009 14:23:57 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Salman Qazi <sqazi@google.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
References: <20090224020304.GA4496@google.com> <200902242002.37555.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0902240744500.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902240744500.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902251423.58861.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 February 2009 02:52:34 Linus Torvalds wrote:
> On Tue, 24 Feb 2009, Nick Piggin wrote:
> > > it does make some kind of sense to try to avoid the noncached versions
> > > for small writes - because small writes tend to be for temp-files.
> >
> > I don't see the significance of a temp file. If the pagecache is
> > truncated, then the cachelines remain dirty and so you can't avoid an
> > eventual store back to RAM?
>
> No, because many small files end up being used as scratch-pads (think
> shell script sequences etc), and get read back immediately again. Doing
> non-temporal stores might just be bad simply because trying to play games
> with caching may simply do the wrong thing.

OK, for that angle it could make sense. Although as has been noted earlier,
at this point of the copy, we don't have much idea about the length of the
write passed into the vfs (and obviously will never know the higher level
intention of userspace).

I don't know if we can say a 1 page write is nontemporal, but anything
smaller is temporal. And having these kinds of behavioural cutoffs I
would worry will create strange performance boundary conditions in code.


> > > I don't know if PAGE_SIZE is the right thing to test, and I also don't
> > > know if this is necessarily the best place to test it in, but I don't
> > > think it's necessarily wrong to do something like this.
> >
> > No, but I think it should be in arch code, and the "_nocache" suffix
> > should just be a hint to the architecture that the destination is not
> > so likely to be used.
>
> Yes. Especially since arch code is likely to need various arch-specific
> checks anyway (like the x86 code does about aligning the destination).
>
> > It would have been nice to have had some numbers to justify
> > 0812a579c92fefa57506821fa08e90f47cb6dbdd in the first place, so you have
> > a point of reference to see what happens to your speed-up-case when you
> > change things like this. Sigh.
>
> Well, there were no performance numbers for that commit, since it didn't
> actually tie it into anything, but I'm pretty sure we saw several
> performance numbers for the change.
>
> Yes, and they are in the commit logs. See "x86: cache pollution aware
> __copy_from_user_ll()", commit c22ce143d15eb288543fe9873e1c5ac1c01b69a1.
>
> But notice how that is iozone numbers. Very much about _big_ writes.

Yeah I see, thanks.

