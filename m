Return-Path: <linux-kernel-owner+w=401wt.eu-S938046AbXG0XPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938046AbXG0XPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938307AbXG0XPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:15:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:57496 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S938253AbXG0XPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:15:07 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX18M7KRxbAUMGH0jSbxSLh/djRErzNc9Vg45S6ym30
	YHEEmtnCUqXQvy
Date: Sat, 28 Jul 2007 01:15:45 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Rene Herman <rene.herman@gmail.com>
Cc: Daniel Hazelton <dhazelton@enter.net>, Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
       ck list <ck@vds.kolivas.org>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge
	plans for 2.6.23]
Message-ID: <20070727231545.GA14457@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Rene Herman <rene.herman@gmail.com>,
	Daniel Hazelton <dhazelton@enter.net>,
	Mike Galbraith <efault@gmx.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Frank Kingswood <frank@kingswood-consulting.co.uk>,
	Andi Kleen <andi@firstfloor.org>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Ray Lee <ray-lk@madrabbit.org>, Jesper Juhl <jesper.juhl@gmail.com>,
	ck list <ck@vds.kolivas.org>, Paul Jackson <pj@sgi.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com> <20070727030040.0ea97ff7.akpm@linux-foundation.org> <1185531918.8799.17.camel@Homer.simpson.net> <200707271345.55187.dhazelton@enter.net> <46AA3680.4010508@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46AA3680.4010508@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.07.27 20:16:32 +0200, Rene Herman wrote:
> On 07/27/2007 07:45 PM, Daniel Hazelton wrote:
>
>> Updatedb or another process that uses the FS heavily runs on a users
>> 256MB P3-800 (when it is idle) and the VFS caches grow, causing memory
>> pressure that causes other applications to be swapped to disk. In the
>> morning the user has to wait for the system to swap those applications
>> back in.
>> Questions about it:
>> Q) Does swap-prefetch help with this? A) [From all reports I've seen (*)] 
>> Yes, it does. 
>
> No it does not. If updatedb filled memory to the point of causing swapping 
> (which noone is reproducing anyway) it HAS FILLED MEMORY and swap-prefetch 
> hasn't any memory to prefetch into -- updatedb itself doesn't use any 
> significant memory.
>
> Here's swap-prefetch's author saying the same:
>
> http://lkml.org/lkml/2007/2/9/112
>
> | It can't help the updatedb scenario. Updatedb leaves the ram full and
> | swap prefetch wants to cost as little as possible so it will never
> | move anything out of ram in preference for the pages it wants to swap
> | back in.
>
> Now please finally either understand this, or tell us how we're wrong.

Con might have been wrong there for boxes with really little memory.

My desktop box has not even 300k inodes in use (IIRC someone posted a df
-i output showing 1 million inodes in use). Still, the memory footprint
of the "sort" process grows up to about 50MB. Assuming that the average
filename length stays, that would mean 150MB for the 1 million inode
case, just for the "sort" process.

Now, sort cannot produce any output before its got all its input, so
that RSS usage exists at least as long as the VFS cache is growing due
to the ongoing search for files.

And then, all that memory that "sort" uses is required, because sort
needs to output its results. So if there's memory pressure, the VFS
cache is likely to be dropped, because "sort" needs its data, for
sorting and producing output. And then sort terminates and leaves that
whole lot of memory _unused_. The other actions of updatedb only touch
the locate db, which is just a few megs (4.5MB here) big so the cache
won't grow that much again.

OK, so we got about, say, at least 128MB of totally unused memory, maybe
even more. If you look at the vmstat output I sent, you see that I had
between 90MB and 128MB free, depending on the swappiness setting, with
increased inode usage, that could very well scale up.

Conclusion: updatedb does _not_ leave the RAM full. And for a box with
little memory (say 256MB) it might even be 50% or more memory that is
free after updatedb ran. Might that make swap prefetch kick in?


Any faults in that reasoning?

Thanks,
Björn
