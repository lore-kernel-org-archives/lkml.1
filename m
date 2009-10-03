Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbZJCDV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbZJCDV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 23:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbZJCDV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 23:21:58 -0400
Received: from dovecot.org ([82.118.211.50]:39313 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071AbZJCDV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 23:21:57 -0400
Cc: linux-kernel@vger.kernel.org, Ulrich Drepper <drepper@redhat.com>
Message-Id: <AEF3AB2A-3051-416C-88A1-960BC5B8B8E7@iki.fi>
From: Timo Sirainen <tss@iki.fi>
To: Bryan Donlan <bdonlan@gmail.com>
In-Reply-To: <3e8340490910021959n304e6870r6df97cfd637283c4@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
Date: Fri, 2 Oct 2009 23:21:57 -0400
References: <1254518602.5050.4.camel@hurina> <3e8340490910021901i35ba8a5v7647b1e02b054270@mail.gmail.com>  <3DB386D4-C03F-4F2A-B0DD-7F4236325B4B@iki.fi> <3e8340490910021959n304e6870r6df97cfd637283c4@mail.gmail.com>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 2, 2009, at 10:59 PM, Bryan Donlan wrote:

>> So if I'm setting the PR_SET_PROCTITLE_AREA initially to e.g. 1 kB  
>> memory
>> area, without the above code ps will show it entirely regardless of  
>> any \0
>> characters (because parameters are separated by \0).
>
> That makes sense - but note that it's not completely atomic still -
> with a syscall you could insert some kind of barrier (rwsem?) to
> ensure other processes don't see a halfway updated process name. With
> infrequent updates this isn't a problem, but if you're really
> intending to update it at a rate where syscall overhead becomes a
> problem, then you're also going to see these kinds of issues as well.

I'm not worried about atomicity. Typically programs (like mine) would  
still show their executable name first and then followed by human  
readable status text. If the human readable text is corrupted once in  
a while (and practically never), I doubt anyone cares. In my case it  
would be an IMAP server and I was just thinking of maybe updating the  
process title to show what command is being executed (or some other  
long running task is going on). Then if there's a load problem or  
something the admin could easily check what some process that's been  
stuck for several minutes is doing. So it's not important to show the  
process title for those that rapidly change it, but for those that  
have been stuck for a while.

>>> Might want to fix the bug later on in that function while you're in
>>> here - the second access_process_vm call is never checked for  
>>> errors,
>>> but (from my reading) it's possible that the page that the  
>>> environment
>>> is on could be unmapped between those two calls. The result could
>>> either be a short read (not the end of the world) or a negative  
>>> value
>>> (error code + small original argument length) passed to strnlen.
>>
>> Hmm. Originally I thought it would have returned only -1, but if  
>> it's -errno
>> then I'm beginning to wonder if this is a security hole. If the  
>> original res
>> is small enough, and it looks like it can be, that code could get  
>> res to
>> negative, i.e. unlimited. But I can't follow the code right now if  
>> it also
>> means that userspace can read tons of data or if it gets caught by  
>> some "<
>> 0" check.
>
> By the time we get to the second read, len is definitely between 0 and
> PAGE_SIZE, so that's not a problem. What I'm worried about mostly is
> whether strnlen would interpret its argument (negative error + small
> positive value = negative value) as a large positive value,

Right.

> go running
> off into the woods and cause an OOPS. Which I suppose is a denial of
> service issue.

I was more thinking that strnlen() would see \0, but not before it had  
returned some sensitive information that shouldn't have been returned  
to userspace.

> That said, I'm not really sure why it's written the way it is anyway.
> Why not just unconditionally try to load all the way from arg_start to
> env_end (or to arg_start + PAGE_SIZE), then just figure out where the
> \0 is and you're done? It would seem to have the same effect...

I guess some minor performance benefit, since typically programs won't  
change their process title so the second access is rare.
