Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbXGBSJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbXGBSJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 14:09:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752427AbXGBSJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 14:09:51 -0400
Received: from 241-226.umostel.ru ([77.246.241.226]:56375 "EHLO mail.aknet.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbXGBSJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 14:09:50 -0400
Message-ID: <46893F97.7080200@aknet.ru>
Date: Mon, 02 Jul 2007 22:10:31 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: William Tambe <tambewilliam@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Concerning a post that you made about expandable anonymous shared
 mappings
References: <468562F6.4010604@gmail.com> <Pine.LNX.4.64.0707021619020.32337@blonde.wat.veritas.com>
In-Reply-To: <Pine.LNX.4.64.0707021619020.32337@blonde.wat.veritas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Hugh Dickins wrote:
> You've answered your own question: we did not make the change Stas
> suggested, IIRC because I remained a little uneasy with that change
> in behaviour, and nobody else spoke up for it.
IIRC your argument, that made sense to me,
was that with such an approach, you can only
expand the backing-store, but never shrink.
I agree this is a problem from some point of
view. I have no idea whether it is important
or not, but it definitely _looks_ not very good.

>>         //why does this failed. I am well in the interval [4096, 8192]
>>         *(unsigned int *)(ptr + 4096 + 8)= 10;
>> }
Well, this generates a bus error, while, for
example, doing the same trick with having a
/dev/mem as a backing-store, simply maps the
"enlarged" space with the anonymous memory,
and so does not generate a SIGBUS (not producing
a desired effect either, of course).
Why do we have it both ways? Shouldn't they
(i.e. /dev/zero and /dev/mem mapping) behave
the same after expanding with mremap?

> I haven't given it any thought since then:
I was thinking about it a bit, and I imagined
we need something like
    int mopen(void *addr, size_t len, unsigned int flags);
which will give you an fd for the memory area,
which you can then ftruncate() and mmap() (and
mremap).
It looks like vmsplice() is a very close one,
but unfortunately it involves pipe, which will
not give you an ability to ftruncate() I suppose.
I even asked Jens Axboe about the possibility
to have mopen(). He said it might be a good
optimization (having only one syscall whereas
now 2 are needed (pipe/vmsplice)), but not
worth an efforts.
Now, if maybe someone have a time and patience,
he can explain me what was an advantage of using
pipe with vmsplice() at all. Why it was not
possible to have something like the mopen() above,
that will give you an fd right away, without a
pipe, so that ftruncate/mmap/lseek etc can be
used on it? Well, I guess this was discussed
many times, but I failed to google anything
relevant...
Such a thing could solve that mremap() problem
that me and William Tambe have.

