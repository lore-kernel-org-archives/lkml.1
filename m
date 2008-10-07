Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbYJGDhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbYJGDhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 23:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYJGDha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 23:37:30 -0400
Received: from mail.lang.hm ([64.81.33.126]:55131 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbYJGDha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 23:37:30 -0400
Date: Mon, 6 Oct 2008 20:37:59 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Mikulas Patocka <mpatocka@redhat.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: application syncing options (was Re: [PATCH] Memory management
 livelock)
In-Reply-To: <Pine.LNX.4.64.0810052332040.3074@hs20-bc2-1.build.redhat.com>
Message-ID: <alpine.DEB.1.10.0810062025301.19471@asgard.lang.hm>
References: <20080911101616.GA24064@agk.fab.redhat.com> <20080923154905.50d4b0fa.akpm@linux-foundation.org> <200810031232.23836.nickpiggin@yahoo.com.au> <200810031254.29121.nickpiggin@yahoo.com.au> <alpine.DEB.1.10.0810030845070.14680@asgard.lang.hm>
 <Pine.LNX.4.64.0810052002520.5798@hs20-bc2-1.build.redhat.com> <alpine.DEB.1.10.0810051714330.17288@asgard.lang.hm> <Pine.LNX.4.64.0810052332040.3074@hs20-bc2-1.build.redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2008, Mikulas Patocka wrote:

> On Sun, 5 Oct 2008, david@lang.hm wrote:
>
>> On Sun, 5 Oct 2008, Mikulas Patocka wrote:
>>
>>> On Fri, 3 Oct 2008, david@lang.hm wrote:
>>>
>>>> I've also seen discussions of how the
>>>> kernel filesystem code can do ordered writes without having to wait for
>>>> them
>>>> with the use of barriers, is this capability exported to userspace? if so,
>>>> could you point me at documentation for it?
>>>
>>> It isn't. And it is good that it isn't --- the more complicated API, the
>>> more maintenance work.
>>
>> I can understand that most software would not want to deal with complications
>> like this, but for things thta have requirements similar to journaling
>> filesystems (databases for example) it would seem that there would be
>> advantages to exposing this capabilities.
>>
>> David Lang
>
> If you invent new interface that allows submitting several ordered IOs
> from userspace, it will require excessive maintenance overhead over long
> period of time. So it should be only justified, if the performance
> improvement is excessive as well.
>
> It should not be like "here you improve 10% performance on some synthetic
> benchmark in one application that was rewritten to support the new
> interface" and then create a few more security vulnerabilities (because of
> the complexity of the interface) and damage overall Linux progress,
> because everyone is catching bugs in the new interface and checking it for
> correctness.

the same benchmarks that show that it's far better for the in-kernel 
filesystem code to use write barriers should apply for FUSE filesystems.

this isn't a matter of a few % in performance, if an application is 
sync-limited in a way that can be converted to write-ordered the potential 
is for the application to speed up my many times.

programs that maintain indexes or caches of data that lives in other files 
will be able to write data && barrier && write index && fsync and double 
their performance vs write data && fsync && write index && fsync

databases can potentially do even better, today they need to fsync data to 
disk before they can update their journal to indicate that the data has 
been written, with a barrier they could order the writes so that the write 
to the journal doesn't happen until the writes of the data. they would 
neve need to call an fsync at all (when emptying the journal)

for systems without solid-state drives or battery-backed caches, the 
ability to eliminate fsyncs by being able to rely on the order of the 
writes is a huge benifit.

David Lang
