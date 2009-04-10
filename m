Return-Path: <linux-kernel-owner+w=401wt.eu-S939210AbZDJR5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939210AbZDJR5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764624AbZDJR5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:57:20 -0400
Received: from smtp-out.google.com ([216.239.45.13]:26286 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758441AbZDJR5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:57:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=QTVjwyg2rMOUbDJ+5GZsIRJdKNd9d/YIMfkSbQFaq1pNXkoZhdntBOPnLTpcwoWSl
	8SIqnbluRdWP1wZCpetFg==
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0904100835150.4583@localhost.localdomain>
References: <604427e00904081302m7b29c538u7781cd8f4dd576f2@mail.gmail.com>
	 <20090409230205.310c68a7.akpm@linux-foundation.org>
	 <20090410073042.GB21149@localhost>
	 <alpine.LFD.2.00.0904100835150.4583@localhost.localdomain>
Date: Fri, 10 Apr 2009 10:57:12 -0700
Message-ID: <604427e00904101057o78868d84y58e3531ac8334505@mail.gmail.com>
Subject: Re: [PATCH][1/2]page_fault retry with NOPAGE_RETRY
From: Ying Han <yinghan@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Waychison <mikew@google.com>,
       Rohit Seth <rohitseth@google.com>, Hugh Dickins <hugh@veritas.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "H. Peter Anvin" <hpa@zytor.com>,
       =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/10 Linus Torvalds <torvalds@linux-foundation.org>:
>
>
> On Fri, 10 Apr 2009, Wu Fengguang wrote:
>
>> On Fri, Apr 10, 2009 at 02:02:05PM +0800, Andrew Morton wrote:
>>
>> > Can we please redo this as:
>> >
>> >
>> >     int write;
>> >     unsigned int flags;
>> >
>> >     /*
>> >      * Big fat comment explaining the next three lines goes here
>> >      */
>>
>> Basically it's doing a
>>         (is_write_access  | FAULT_FLAG_RETRY) =>
>>         (FAULT_FLAG_WRITE | FAULT_FLAG_RETRY)
>> by extracting the bool part:
>> >     write = write_access & ~FAULT_FLAG_RETRY;
>> convert bool to a bit flag:
>> >     unsigned int flags = (write ? FAULT_FLAG_WRITE : 0);

Fengguang: thank you for your comments. i agree this is confusing...
>
> The point is, we shouldn't do that.
>
> Your code is confused, because it uses "write_access" as if it had the old
> behaviour (boolean to say "write") _plus_ the new behavior (bitmask to say
> "retry"), and that's just wrong.
>
> Just get rid of "write_access" entirely, and switch it over to something
> that is a pure bitmask.
>
> Yes, it means a couple of new preliminary patches that switch all callers
> of handle_mm_fault() over to using the VM_FLAGS, but that's not a big
> deal.
>
> I'm following up this email with two _example_ patches. They are untested,
> but they look sane. I'd like the series to _start_ with these, and then
> you can pass FAULT_FLAGS_WRITE | FAULT_FLAGS_RETRY down to
> handle_mm_fault() cleanly.
>
> Hmm? Note the _untested_ part on the patches to follow. It was done very
> mechanically, and the patches look sane, but .. !!!

Thanks Linus for your comments. I will take Peter Zijlstra's patches
(the _untested_ part)
which basically replaces the write_access as a flag as you mentioned
and start from there.

My next step is to cleanup the patch with comments in the thread so
far and post the new version.
Anything else i missed, please let me know. thanks

--Ying
>
>                        Linus
>
