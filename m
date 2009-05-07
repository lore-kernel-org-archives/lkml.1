Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbZEGP6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbZEGP6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754190AbZEGP6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:58:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33363 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202AbZEGP6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:58:33 -0400
Date: Thu, 7 May 2009 08:55:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Miklos Szeredi <miklos@szeredi.hu>
cc: jens.axboe@oracle.com, Max Kellermann <max@duempel.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] make splice more generic
In-Reply-To: <20090507133734.450612199@szeredi.hu>
Message-ID: <alpine.LFD.2.01.0905070845590.4983@localhost.localdomain>
References: <20090507133734.450612199@szeredi.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 May 2009, Miklos Szeredi wrote:
> 
> One more generalization would be to allow splice to work on two
> non-pipes, using an internal intermediate pipe, a-la do_splice_direct().

You can't do that without some painful issues.

Or rather, you can only do it trivially for the one case where we 
_already_ do that, namely "sendfile()". That's exactly what sendfile() is 
now.

What is so painful about it in general?

Reading from a source may _destroy_ that data, and you may not be able to 
push it back to the source. And what happens if the destination cannot 
take it?

Now, we could do a totally blocking version that simply refuses to return 
until the destination has taken all the splice data, and maybe it would be 
worth it as a simplified interface. But it does sound like a really ripe 
place for deadlocks etc (set up some trivial circular thing of everybody 
trying to pipe to each other, and all of them getting blocked on the 
receiver, and now they are unkillable).

Now, the reason it works for sendfile() is that when the source is known 
to be in the page cache, then if the receiver doesn't take the data, we 
know we can just drop it. But what if the source is some character device 
driver? We can't just drop the data on a signal.

So the reason splice does that pipe buffer is that the pipe itself then 
acts as a long-term buffer _across_ the kernel returning to user space, 
and thus allows the whole process to be interruptible.

That said, maybe we could allow it in a few more cases. Or maybe people 
think the simplification in user interfaces is worth making the IO be 
non-interruptible (but still killable, for example, at which point the 
buffered data really is dropped - but that's not different from having 
the buffers in user space, so at that point it's ok).

So I'm certainly willing to be convinced that it's a good idea after all, 
it just worries me, and I wanted to point out the painful issues that 
caused me to not allow it in general.

			Linus
