Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbZHDI5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbZHDI5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 04:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932414AbZHDI5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 04:57:35 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63431 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405AbZHDI5e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 04:57:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xq7zWh7d+O5gljZElTQ1BuSUFX/D580u092eQCG/tD9DVAjkwGxs7Z1hZQvkpszlwF
         cyIAMoRGFdcWSUIvfZElUUER4PNzIL95aHalKsWAUhUBIB4aQME4jfIAYSjNkkgSeTjr
         6k9+F3bqQQH25mq9xhgW93Fuo0MGnaBsjC+e8=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0908031724200.2296@sister.anvils>
References: <c384c5ea0908030823y494ee8bei85aa62c1470fa3ec@mail.gmail.com>
	 <Pine.LNX.4.64.0908031724200.2296@sister.anvils>
Date: Tue, 4 Aug 2009 10:57:33 +0200
Message-ID: <c384c5ea0908040157g222f5408o52dd10f02da5a07d@mail.gmail.com>
Subject: Re: get_user_pages() on an mmap()ed file allowed? What to do if 0 < 
	get_user_pages(..., nr_pages, ...) < nr_pages?
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello ,

On Mon, Aug 3, 2009 at 6:30 PM, Hugh Dickins<hugh.dickins@tiscali.co.uk> wrote:
> On Mon, 3 Aug 2009, Leon Woestenberg wrote:
>>
>> - is it allowed to have a PCI device DMA-read from memory pages, that
>> belong to a file mmap()'d by userspace?
>
> Yes.
>
>> - what are valid reasons for get_user_pages() to fail?
>
> I'd hesitate to give a complete answer to that: but main reasons
> would be SIGKILL, or running out of memory (-ENOMEM), or running
> off the end of a mapping or mapped object, or no permission to it
> (-EFAULT): with a short page count returned instead of error if
> some pages were successfully gotten before hitting the error.
>
Next step will be to see where it bails out.

>> - what should a driver do when get_user_pages() returns less pages
>> than requested?
>
> Probably put_page the pages gotten then report the surprise;
> perhaps, before putting the pages gotten, try get_user_pages
> on the next alone, to see what error code is returned for that.
>
> Unless it's happy to work with fewer pages than requested,
> in which case work with them and ignore the surprise.
>
I expect a certain amount of data to be DMA'd from the PCI device to
the file mmap, so I'ld rather map the complete file before I start
DMA.

>>     BUG_ON(rc < nr_pages);
>
> When that BUG triggers, is rc a positive number of pages,
> or a negative error code - which?  (or even 0, but it shouldn't be).
> I assume from your Subject that you've already seen a positive number
> of pages.
>
Correct, undeterministicly it sometimes return the requested amount,
sometimes some part of it, or sometimes errors out.

> Code doesn't look wrong to me (except you shouldn't BUG), though I am
>
Correct. I took a snippet

> having to assume that buffer and boe and start are all the same address,

Correct.

> and count fits within buffersize; or at least that the range to which you
> apply get_user_pages really does fit within the area you have mmap'ed.
>
Yes, the file is large enough, a multiple of PAGE_SIZE, as is the mmap length.

> (I'd advise against using 1 /* do force */, I don't think you need
> that: the force is mysterious, and should only be called upon in direst
> need.  But it shouldn't actually be causing you any problem here.)
>
Thanks. I found that force did not mean "force the mapping"  but
rather enforce read plus write permissions.

> Is the file you have mmap'ed big enough?  If it's not as long as the
> last page you're trying to get_user_pages on, or gets truncated, then
> indeed that will give -EFAULT or a short count - just as trying to
> access the end of the mapping in userspace would give you SIGBUS.
>
Thanks for all the pointers, I think I have all the conditions right.

I'll see what get_user_pages() internally fails on. It's one of the
API's that does not either fail or complete, it can say: "hey I did a
part of it, now buzz off!"
I still wonder if the function can at all be wrapped with a
all-or-nothing function?

Regards,
-- 
Leon
