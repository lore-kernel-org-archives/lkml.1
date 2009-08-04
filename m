Return-Path: <linux-kernel-owner+w=401wt.eu-S933022AbZHDQZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022AbZHDQZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932971AbZHDQZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:25:20 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57662 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932970AbZHDQZS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:25:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=T606jMCVHHRQo6nqGY4gBU2xGD6Yvn6nMt4oLfEZf+g+dt0Wk31wCEcD5YPCQvwzfP
         S6BQ4HrGQdgkBNCVwTQWpNAzf0UXtmomBiGS4jppA7P48yjjGEjJRfXfNA63eyzYFXx/
         vE2M2+l48/22j/dlnI0G8rusnAO/H/Qi8ZHnY=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0908041245260.17734@sister.anvils>
References: <c384c5ea0908030823y494ee8bei85aa62c1470fa3ec@mail.gmail.com>
	 <Pine.LNX.4.64.0908031724200.2296@sister.anvils>
	 <4A77FCFB.9020001@inria.fr>
	 <c384c5ea0908040259k4295c986wdd45fe9e1e4315b1@mail.gmail.com>
	 <4A780FE6.9050704@inria.fr>
	 <Pine.LNX.4.64.0908041245260.17734@sister.anvils>
Date: Tue, 4 Aug 2009 18:25:17 +0200
Message-ID: <c384c5ea0908040925u4763f02fy5baaf418f0ad8aa5@mail.gmail.com>
Subject: Re: [PATCH] mm: get_user_pages() stores ERR_PTR() in pages[i] on 
	failure
From: Leon Woestenberg <leon.woestenberg@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Brice Goglin <Brice.Goglin@inria.fr>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

thanks for looking along on this one.

On Tue, Aug 4, 2009 at 2:00 PM, Hugh Dickins<hugh.dickins@tiscali.co.uk> wrote:
> On Tue, 4 Aug 2009, Brice Goglin wrote:
>>
>> >> I wonder if we should change get_user_pages to store ERR_PTR(ret)
>> >> in page[i] when it fails to get page #i.
>> >>
>> > Yes, I would see that as an improvement in finding out why rc <
>> > nr_pages, in case rc > 0.
>> >
>> > Also I think it does not break existing users.
>> >
> ... some callers of get_user_pages() might expect it not to touch
> entries in the page array beyond the fail point: for example, they
> might start off with a zeroed array, then when they come to put_page
> on the array afterwards, would skip any NULL entries found - without
> having to have noted the returned number of pages.  I don't think
> that way of working is supported by any guarantee in documentation,
> but it's not unreasonable to expect it to behave in that way.
>
Thanks for checking this -- obviously me thinking it would not break
existing users is false.

> Of course we _could_ fix individual callers to work with it, but
> for me they sound a warning that it's too late to change now.
>
The alternative seems to be to describe a best practise of calling
get_user_pages() on the failing page to find out why it failed.
(and hoping it does not return rc > 0 on the second call.)

A better function API would be to return the number of succesfully
gotten pages in a pointer
rc = get_user_pages2(, nr_pages ,..., &nr_pages_gotten);
where rc ==0 iff (nr_pages == nr_pages_gotten).


BTW, in my case I'm hitting the (ret & VM_FAULT_SIGBUS) case. I
suspect I have a multithreading concurrency race, as I have DMA in
both directions to a ring buffer set of files. Seems one over runs the
other, thus the file gets mapped in with different protection, as well
as conflicting DMA directions.

-EBADUSER.
-- 
Leon
