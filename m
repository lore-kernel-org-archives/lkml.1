Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbZHCMxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbZHCMxV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754994AbZHCMxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:53:20 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:35979 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754959AbZHCMxT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:53:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=ouf7sN6m8n2HtvdZo/WkUSvMbuv48cz7npZm4pgN5D/AIlo//nVY+2YOXbS8Dd3JJB
         Uoyf4cYRzouYVZPLOlXVS0HfmV2jCFuoSpwOjNihhIylbCeOvC0ey5abBJlH78Rrz/+M
         pf1dgMFsET/T2v7dp1ql6lipyYNvtyMtzn24M=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20090731141122.a1939712.akpm@linux-foundation.org>
References: <7c86c4470907270951i48886d56g90bc198f26bb0716@mail.gmail.com>
	 <1248869948.6987.3083.camel@twins> <20090729221703.GA25368@redhat.com>
	 <1248953485.6391.41.camel@twins> <20090730192040.GA9503@redhat.com>
	 <1248984003.4164.0.camel@laptop> <20090730202804.GA13675@redhat.com>
	 <1249029320.6391.72.camel@twins>
	 <20090731141122.a1939712.akpm@linux-foundation.org>
Date: Mon, 3 Aug 2009 14:53:18 +0200
Message-ID: <7c86c4470908030553v5a0a4448p94ab612700d68066@mail.gmail.com>
Subject: Re: [RFC][PATCH] fcntl: F_[SG]ETOWN_TID
From: stephane eranian <eranian@googlemail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, oleg@redhat.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       robert.richter@amd.com, paulus@samba.org, andi@firstfloor.org,
       mpjohn@us.ibm.com, cel@us.ibm.com, cjashfor@us.ibm.com,
       mucci@eecs.utk.edu, terpstra@eecs.utk.edu,
       perfmon2-devel@lists.sourceforge.net, mtk.manpages@googlemail.com,
       roland@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Fri, Jul 31, 2009 at 11:11 PM, Andrew
Morton<akpm@linux-foundation.org> wrote:
> On Fri, 31 Jul 2009 10:35:20 +0200
> Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
>> In order to direct the SIGIO signal to a particular thread of a
>> multi-threaded application we cannot, like suggested by the manpage, put
>> a TID into the regular fcntl(F_SETOWN) call. It will still be send to
>> the whole process of which that thread is part.
>>
>> Since people do want to properly direct SIGIO we introduce F_SETOWN_TID,
>> which functions similarly to F_SETOWN, except positive arguments are
>> interpreted as TIDs and negative arguments are interpreted as PIDs.
>>
>> This extension is fully bug compatible with the old F_GETOWN
>> implementation in that F_GETOWN_TID will be troubled by the negative
>> return value for PIDs similarly to F_GETOWN's trouble with process
>> groups.
>
> I'd be interested in seeing a bit more explanation about the "people do
> want to properly direct SIGIO" thing - use cases, how the current code
> causes them problems, etc.  As it stands, it's a bit of a mystery-patch.
>
I have explained that  in my initial post on LKML. Here is a link to it:
http://lkml.org/lkml/2009/7/27/242

Basically, in the context of self-monitoring threads (which is very common),
you want the sample notification to be asynchronous and yet delivered to
a particular thread, i.e., the one in which the sample was recorded. The
asynchronous notification is required because you are monitoring yourself.
Asynchronous signals are normally delivered to any thread within the process.
In my message, I described the algorithm currently implemented by the kernel.
As Peter found out, the man page seems to indicate that if you specify a TID
instead a PID with F_SETOWN, then the kernel should interpret this as meaning
this particular thread, but this is not what is implemented right now.

Self-monitoring  has specific needs, you don't necessarily want SIGIO to
always be delivered to the thread in which it originated. That is why, I
have suggested a new code path. It is also important that backward
compatibility be maintained.

>> [ compile tested only so far ]
>
> I will continue to lurk :)
>
>> arch/parisc/include/asm/fcntl.h |    2 +
>> fs/fcntl.c                      |   64 +++++++++++++++++++++++++++++++++-----
>> include/asm-generic/fcntl.h     |    4 ++
>> include/linux/fs.h              |   11 +++++-
>> net/socket.c                    |    2 +-
>
> OK.
>
>
>
> Alpha has private definitions of F_SETSIG and F_GETSIG which are
> identical to the generic ones.  That's somewhat logical, given that
> alpha's F_SETOWN/F_GETOWN _differ_ from the asm-generic ones.
>
> Alpha appears to have made the decision to spell out _all_ the F_*
> flags, given that some of them are different.  That has some merit, I
> guess.
>
> But your patch broke that.
>
