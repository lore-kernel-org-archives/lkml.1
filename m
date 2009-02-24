Return-Path: <linux-kernel-owner+w=401wt.eu-S1758580AbZBXPx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580AbZBXPx1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 10:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbZBXPxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 10:53:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756544AbZBXPxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 10:53:14 -0500
Date: Tue, 24 Feb 2009 07:52:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <nickpiggin@yahoo.com.au>
cc: Salman Qazi <sqazi@google.com>, davem@davemloft.net,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: Performance regression in write() syscall
In-Reply-To: <200902242002.37555.nickpiggin@yahoo.com.au>
Message-ID: <alpine.LFD.2.00.0902240744500.3111@localhost.localdomain>
References: <20090224020304.GA4496@google.com> <200902241510.33911.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0902232021310.3111@localhost.localdomain> <200902242002.37555.nickpiggin@yahoo.com.au>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 24 Feb 2009, Nick Piggin wrote:
>
> > it does make some kind of sense to try to avoid the noncached versions for
> > small writes - because small writes tend to be for temp-files.
> 
> I don't see the significance of a temp file. If the pagecache is truncated,
> then the cachelines remain dirty and so you can't avoid an eventual store
> back to RAM? 

No, because many small files end up being used as scratch-pads (think 
shell script sequences etc), and get read back immediately again. Doing 
non-temporal stores might just be bad simply because trying to play games 
with caching may simply do the wrong thing.


> > I don't know if PAGE_SIZE is the right thing to test, and I also don't
> > know if this is necessarily the best place to test it in, but I don't
> > think it's necessarily wrong to do something like this.
> 
> No, but I think it should be in arch code, and the "_nocache" suffix
> should just be a hint to the architecture that the destination is not
> so likely to be used.

Yes. Especially since arch code is likely to need various arch-specific 
checks anyway (like the x86 code does about aligning the destination).

> It would have been nice to have had some numbers to justify
> 0812a579c92fefa57506821fa08e90f47cb6dbdd in the first place, so you have
> a point of reference to see what happens to your speed-up-case when you
> change things like this. Sigh.

Well, there were no performance numbers for that commit, since it didn't 
actually tie it into anything, but I'm pretty sure we saw several 
performance numbers for the change.

Yes, and they are in the commit logs. See "x86: cache pollution aware 
__copy_from_user_ll()", commit c22ce143d15eb288543fe9873e1c5ac1c01b69a1.

But notice how that is iozone numbers. Very much about _big_ writes.

		Linus
