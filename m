Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZBXJDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZBXJDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 04:03:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbZBXJDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 04:03:16 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:44424 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753573AbZBXJDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 04:03:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=M0SxJCQaNxp7N8keqinEmcB1DzWQq7vmjNkLzjDBYS7prErFlHH+Cp+2wV1P/tNpy4D4S324YfeebTdeTLe6WOcDro1XjRXhZBMJrAwCn3NodlRFNzhIHLSV4G+DbS9LLP8yqxLCkehUA5+XZg6kWYxHHpu1oYEovl8UF360Co8=  ;
X-YMail-OSG: a9Djz8UVM1kz0FHwFXkStxp7ZRtwqzJWMzKAPFD0TV9VEJ9NQWJ9OLz5IxjcRSLizBlS3u8Mf4KsuYPhGvqvkypbYrnrqUi8U2r0O.rt9eE7tX7CZnepaMZR4BZprhk.5_fpTPo4P1sDr8jx0l3yg_yuzgoV5sFFdTy1ACxtgJDWduY0W78XDgZ513CB8A--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Performance regression in write() syscall
Date: Tue, 24 Feb 2009 20:02:36 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Salman Qazi <sqazi@google.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
References: <20090224020304.GA4496@google.com> <200902241510.33911.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0902232021310.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902232021310.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902242002.37555.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 February 2009 15:28:54 Linus Torvalds wrote:
> On Tue, 24 Feb 2009, Nick Piggin wrote:
> > What does unixbench's fstime test do? If it is just writing to the
> > pagecache, then this would be unexpected.
>
> Hmm. Not necessarily. Even just plain writes may be slowed down, since the
> nontemporal loads and stores are generally slower than the normal case. So

Well it does nontemporal stores only, ie. store into the pagecache without
doubling the cache footprint (source is possibly already in cache if we're
write(2)ing it anyway).

But yes I could see if it it fills up store queue and starts going
synchronous, then for sizes < CPU cache size, it will probably go slower.
On the other hand, for cached writes they still have to be sent back
to RAM at some point, but maybe that can be pipelined with other things.


> it does make some kind of sense to try to avoid the noncached versions for
> small writes - because small writes tend to be for temp-files.

I don't see the significance of a temp file. If the pagecache is truncated,
then the cachelines remain dirty and so you can't avoid an eventual store
back to RAM? 


> I don't know if PAGE_SIZE is the right thing to test, and I also don't
> know if this is necessarily the best place to test it in, but I don't
> think it's necessarily wrong to do something like this.

No, but I think it should be in arch code, and the "_nocache" suffix
should just be a hint to the architecture that the destination is not
so likely to be used.


> In fact, I think we might also just check alignment. Doing the nontemporal
> crud makes little sense for a non-8-byte-aligned destination, since it
> will have to do the alignment stores cached anyway - and mixing them
> across a cacheline is just crazy.

That is exactly the kind of thing that could probably be better optimised
in arch code IMO.

It would have been nice to have had some numbers to justify
0812a579c92fefa57506821fa08e90f47cb6dbdd in the first place, so you have
a point of reference to see what happens to your speed-up-case when you
change things like this. Sigh.

