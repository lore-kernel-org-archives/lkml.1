Return-Path: <linux-kernel-owner+w=401wt.eu-S1764844AbZEATpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764844AbZEATpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 15:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbZEATpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 15:45:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:23144 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064AbZEATpJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 15:45:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=thvaiD5NEfEf9AjckoXMO9U8rOosZTyzYmg1nwUBdun4TG8Joho3Pc8bFC8MYaggTC
         lbv57PoT9wm+Hxu7tyzAWyr7j8uYzOO+NkzCTmTLKKi7Q+1uzqZZ7E8nJ9Up7DID4YPD
         MhzqWCMEAIUAdb+EnwPmDZWXxvpgi5axtDDeA=
MIME-Version: 1.0
In-Reply-To: <49FB4EBB.3030404@redhat.com>
References: <20090428044426.GA5035@eskimo.com> <20090430072057.GA4663@eskimo.com> 
	<20090430174536.d0f438dd.akpm@linux-foundation.org> <20090430205936.0f8b29fc@riellaptop.surriel.com> 
	<20090430181340.6f07421d.akpm@linux-foundation.org> <20090430215034.4748e615@riellaptop.surriel.com> 
	<20090430195439.e02edc26.akpm@linux-foundation.org> <49FB01C1.6050204@redhat.com> 
	<2c0942db0905011104u4e6df9ap9d95fa30b1284294@mail.gmail.com> 
	<49FB4EBB.3030404@redhat.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Fri, 1 May 2009 12:44:48 -0700
X-Google-Sender-Auth: bbc9748d97f53639
Message-ID: <2c0942db0905011244v331273dfr2bb34953e42bebdf@mail.gmail.com>
Subject: Re: [PATCH] vmscan: evict use-once pages first (v2)
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, elladan@eskimo.com,
       peterz@infradead.org, linux-kernel@vger.kernel.org, tytso@mit.edu,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 1, 2009 at 12:34 PM, Rik van Riel <riel@redhat.com> wrote:
> Ray Lee wrote:
>
>> Said way #3: We desktop users really want a way to say "Please don't
>> page my executables out when I'm running a system with 3gig of RAM." I
>> hate knobs, but I'm willing to beg for one in this case. 'cause
>> mlock()ing my entire working set into RAM seems pretty silly.
>>
>> Does any of that make sense, or am I talking out of an inappropriate
>> orifice?
>
> The "don't page my executables out" part makes sense.
>
> However, I believe that kind of behaviour should be the
> default.  Desktops and servers alike have a few different
> kinds of data in the page cache:
> 1) pages that have been frequently accessed at some point
>   in the past and got promoted to the active list
> 2) streaming IO
>
> I believe that we want to give (1) absolute protection from
> (2), provided there are not too many pages on the active file
> list.  That way we will provide executables, cached indirect
> and inode blocks, etc. from streaming IO.
>
> Pages that are new to the page cache start on the inactive
> list.  Only if they get accessed twice while on that list,
> they get promoted to the active list.
>
> Streaming IO should normally be evicted from memory before
> it can get accessed again.  This means those pages do not
> get promoted to the active list and the working set is
> protected.
>
> Does this make sense?

Streaming IO should always be at the bottom of the list as it's nearly
always use-once. That's not the interesting case. (I'm glad you're
protecting everything from steaming IO, it's a good thing. And if it's
a media server and serving the same stream to many clients, if I
understood you correctly those streams will no longer be use-once, and
therefore be a normal citizen with the rest of the cache. That's great
too.)

The interesting case is an updatedb running in the background, paging
out firefox, or worse, parts of X. That sucks.
