Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbXENIu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbXENIu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 04:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbXENIuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 04:50:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:63140 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075AbXENIuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 04:50:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=VJMtYalXQ3mluCN9B/gJDSbjoQRyxwcp74yWv8UKg8uO3VXvSxDEhj0AakBlB9Mcw+F7cqknW6MX0JykYOCD93VqIOlUfWbnQGomqTTUra7FC6gdjJgMyT4YMOtOAGrsAK6mx/XYMhe8cG9g9fP31nhTjjoikOBXbnRFckOAgG4=
Date: Mon, 14 May 2007 10:50:45 +0200 (CEST)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Esben Nielsen <nielsen.esben@googlemail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 0/2] convert mmap_sem to a scalable rw_mutex
In-Reply-To: <4645DCA2.80408@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0705141040050.20796@frodo.shire>
References: <20070511131541.992688403@chello.nl>  <Pine.LNX.4.64.0705121120210.26287@frodo.shire>
 <1178964103.6810.55.camel@twins> <Pine.LNX.4.64.0705121520210.2101@frodo.shire>
 <4645DCA2.80408@cosmosbay.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-22478338-1517368955-1179132645=:20796"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---22478338-1517368955-1179132645=:20796
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 12 May 2007, Eric Dumazet wrote:

> Esben Nielsen a =E9crit :
>>
>>
>>  On Sat, 12 May 2007, Peter Zijlstra wrote:
>>=20
>> >  On Sat, 2007-05-12 at 11:27 +0200, Esben Nielsen wrote:
>> > >=20
>> > >  On Fri, 11 May 2007, Peter Zijlstra wrote:
>> > >=20
>> > > >=20
>> > > >  I was toying with a scalable rw_mutex and found that it gives ~10=
%=20
>> > > >  reduction in
>> > > >  system time on ebizzy runs (without the MADV_FREE patch).
>> > > >=20
>> > >=20
>> > >  You break priority enheritance on user space futexes! :-(
>> > >  The problems is that the futex waiter have to take the mmap_sem. An=
d=20
>> > >  as
>> > >  your rw_mutex isn't PI enabled you get priority inversions :-(
>> >=20
>> >  Do note that rwsems have no PI either.
>> >  PI is not a concern for mainline - yet, I do have ideas here though.
>> >=20
>> >
>>  If PI wasn't a concern for mainline, why is PI futexes merged into the
>>  mainline?
>
> If you really care about futexes and mmap_sem, just use private futexes,=
=20
> since they dont use mmap_sem at all.
>

futex_wait_pi() takes mmap_sem. So does futex_fd(). I can't see a code=20
path into the PI futexes which doesn't use mmap_sem.

There is another way to avoid problems with mmap_sem:
Use shared memory for data you need to share with high priority tasks and
normal low priority tasks there. The high priority task(s) run(s) in=20
an isolated high priority process having its own mmap_sem. This high=20
priority process is mlock'ed and doesn't do any operations write locking=20
mmap_sem.

But it would be nice if you can avoid such a cumbersome workaround...

Esben
---22478338-1517368955-1179132645=:20796--
