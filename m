Return-Path: <linux-kernel-owner+w=401wt.eu-S1763994AbZEASEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763994AbZEASEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 14:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756054AbZEASEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 14:04:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:25340 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbZEASEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 14:04:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=NCdrE9HglFrvBYKgFRGaVqLSBWYHrGHk2nuFNgs961LOo6dBuqfQDxSfXPcylrSuGi
         6AUKBpRSMFyL7V4EDGzO78qaBId0EToujM/B6sbJLNppop3gOhTZUMAdJJET50NgMMiQ
         2OCGtpp8EjjOCKQ4B5F58F0jW150q/EQp7eVQ=
MIME-Version: 1.0
In-Reply-To: <49FB01C1.6050204@redhat.com>
References: <20090428044426.GA5035@eskimo.com> <1240987349.4512.18.camel@laptop> 
	<20090429114708.66114c03@cuia.bos.redhat.com> <20090430072057.GA4663@eskimo.com> 
	<20090430174536.d0f438dd.akpm@linux-foundation.org> <20090430205936.0f8b29fc@riellaptop.surriel.com> 
	<20090430181340.6f07421d.akpm@linux-foundation.org> <20090430215034.4748e615@riellaptop.surriel.com> 
	<20090430195439.e02edc26.akpm@linux-foundation.org> <49FB01C1.6050204@redhat.com>
From: Ray Lee <ray-lk@madrabbit.org>
Date: Fri, 1 May 2009 11:04:03 -0700
X-Google-Sender-Auth: 04fb062663a6cdf7
Message-ID: <2c0942db0905011104u4e6df9ap9d95fa30b1284294@mail.gmail.com>
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

On Fri, May 1, 2009 at 7:05 AM, Rik van Riel <riel@redhat.com> wrote:
>
> Andrew Morton wrote:
>
>>> When we implement working set protection, we might as well
>>> do it for frequently accessed unmapped pages too.  There is
>>> no reason to restrict this protection to mapped pages.
>>
>> Well.  Except for empirical observation, which tells us that biasing
>> reclaim to prefer to retain mapped memory produces a better result.
>
> That used to be the case because file-backed and
> swap-backed pages shared the same set of LRUs,
> while each following a different page reclaim
> heuristic!
>
> Today:
> 1) file-backed and swap-backed pages are separated,
> 2) the majority of mapped pages are on the swap-backed LRUs
> 3) the accessed bit on active pages no longer means much,
>   for good scalability reasons, and
> 4) because of (3), we cannot really provide special treatment
>   to any individual page any more, however
>
> This means we need to provide our working set protection
> on a per-list basis, by tweaking the scan rate or avoiding
> scanning of the active file list alltogether under certain
> conditions.
>
> As a side effect, this will help protect frequently accessed
> file pages (good for ftp and nfs servers), indirect blocks,
> inode buffers and other frequently used metadata.

Just an honest question: Who does #3 help? All normal linux users, or
large systems for some definition of large? (Helping large systems is
good; historically it eventually helps everyone. But the point I'm
driving at is that the minority of systems which tend to use one
kernel for a while and stick with it -- ie, embedded or large iron --
can and are tuned for specific workloads. The majority of systems that
upgrade the kernel frequently, such as desktop systems needing support
for new hardware, tend to rely more upon the kernel defaults.)

Also, not all the above items are equal from a latency point of view.
The latency impact of an inode needing to be fetched from disk is
budgeted for already in most userspace design. Opening a file can be
slow, news at 11. Try not to open as many files, solution at 11:01.

The latency impact of jumping to a different part of your own
executable, however, is something most userspace programmers likely
never think of. This hurts even more in this modern age of web
browsers, where firefox has to act as a layout engine, video player,
parser and compiler, etc. Not every web page uses every feature, which
means clicking a random URL can suddenly stop the whole shebang while
a previously-unreferenced page is swapped back in. With executables,
past usage doesn't presage future need.

Said a different way, executables are not equivalent to a random
collection of mapped pages. A collection of inodes may or may not have
any causal links between them. A collection of pages for an executable
are linked via function calls, and the compiler and linker already
took a first pass at evicting unnecessary baggage.

Said way #3: We desktop users really want a way to say "Please don't
page my executables out when I'm running a system with 3gig of RAM." I
hate knobs, but I'm willing to beg for one in this case. 'cause
mlock()ing my entire working set into RAM seems pretty silly.

Does any of that make sense, or am I talking out of an inappropriate orifice?
