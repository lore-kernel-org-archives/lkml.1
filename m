Return-Path: <linux-kernel-owner+w=401wt.eu-S1759077AbZCTAeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759077AbZCTAeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 20:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbZCTAeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 20:34:14 -0400
Received: from smtp-out.google.com ([216.239.33.17]:60373 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065AbZCTAeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 20:34:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Qb9htUgx3LeCzRUrTqzoTQaeSovUXnoqe63XX8zUi4RafNNJ1DwcK+Yk20LZ8V/BE
	tPumRT4aql6/6SWX6UwBg==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0903181522570.3082@localhost.localdomain>
References: <604427e00903181244w360c5519k9179d5c3e5cd6ab3@mail.gmail.com>
	 <20090318151157.85109100.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.0903181522570.3082@localhost.localdomain>
Date: Thu, 19 Mar 2009 17:34:06 -0700
Message-ID: <604427e00903191734l42376eebsee018e8243b4d6f5@mail.gmail.com>
Subject: Re: ftruncate-mmap: pages are lost after writing to mmaped file.
From: Ying Han <yinghan@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, guichaz@gmail.com,
       Alex Khesin <alexk@google.com>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 3:40 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 18 Mar 2009, Andrew Morton wrote:
>
>> On Wed, 18 Mar 2009 12:44:08 -0700 Ying Han <yinghan@google.com> wrote:
>> >
>> > The "bad pages" count differs each time from one digit to 4,5 digit
>> > for 128M ftruncated file. and what i also found that the bad page
>> > number are contiguous for each segment which total bad pages container
>> > several segments. ext "1-4, 9-20, 48-50" (  batch flushing ? )
>
> Yeah, probably the batched write-out.
>
> Can you say what filesystem, and what mount-flags you use? Iirc, last time
> we had MAP_SHARED lost writes it was at least partly triggered by the
> filesystem doing its own flushing independently of the VM (ie ext3 with
> "data=journal", I think), so that kind of thing does tend to matter.
>
> See for example commit ecdfc9787fe527491baefc22dce8b2dbd5b2908d.
>
>> > (The failure is reproduced based on 2.6.29-rc8, also happened on
>> > 2.6.18 kernel. . Here is the simple test case to reproduce it with
>> > memory pressure. )
>>
>> Thanks.  This will be a regression - the testing I did back in the days
>> when I actually wrote stuff would have picked this up.
>>
>> Perhaps it is a 2.6.17 thing.  Which, IIRC, is when we made the changes to
>> redirty pages on each write fault.  Or maybe it was something else.
>
> Hmm. I _think_ that changes went in _after_ 2.6.18, if you're talking
> about Peter's exact dirty page tracking. If I recall correctly, that
> became then 2.6.19, and then had the horrible mm dirty bit loss that
> triggered in librtorrent downloads, which got fixed sometime after 2.6.20
> (and back-ported).
>
> So if 2.6.18 shows the same problem, then it's a _really_ old bug, and not
> related to the exact dirty tracking.
>
> The exact dirty accounting patch I'm talking about is d08b3851da41 ("mm:
> tracking shared dirty pages"), but maybe you had something else in mind?
>
>> Given the amount of time for which this bug has existed, I guess it isn't a
>> 2.6.29 blocker, but once we've found out the cause we should have a little
>> post-mortem to work out how a bug of this nature has gone undetected for so
>> long.
>
> I'm somewhat surprised, because this test-program looks like a very simple
> version of the exact one that I used to track down the 2.6.20 mmap
> corruption problems. And that one got pretty heavily tested back then,
> when people were looking at it (December 2006) and then when trying out my
> fix for it.
>
> Ying Han - since you're all set up for testing this and have reproduced it
> on multiple kernels, can you try it on a few more kernel versions? It
> would be interesting to both go further back in time (say 2.6.15-ish),
> _and_ check something like 2.6.21 which had the exact dirty accounting
> fix. Maybe it's not really an old bug - maybe we re-introduced a bug that
> was fixed for a while.

I tried 2.6.24 for couple of hours and the problem not happening yet. While
the same test on 2.6.25, the problem happen right away.

>
>                                Linus
>
