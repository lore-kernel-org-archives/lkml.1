Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbZFVL4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbZFVL4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbZFVL4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:56:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34387 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbZFVL4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:56:09 -0400
Date: Mon, 22 Jun 2009 13:55:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.10 - Event buffer minimal useful size
Message-ID: <20090622115553.GK24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 10/ Event buffer minimal useful size
>
> As it stands, the buffer header occupies the first page, even
> though the buffer header struct is 32-byte long. That's a lot of
> precious RLIMIT_MEMLOCK memory wasted.
>
>  The actual buffer (data) starts at the next page (from builtin-top.c):
>
> static void mmap_read_counter(struct mmap_data *md)
> {
>	unsigned int head = mmap_read_head(md);
>	unsigned int old = md->prev;
>	unsigned char *data = md->base + page_size;
>
> Given that the buffer "full" notification are sent on page
> crossing boundaries, if the actual buffer payload size is 1 page,
> you are guaranteed to have your samples overwritten.
>
> This leads me to believe that the minimal buffer size to get
> useful data is 3 pages. This is per event group per thread. That
> puts a lot of pressure on RLIMIT_MEMLOCK which is ususally set
> fairly low by distros.

Regarding notifications: you can actually tell it to generate
wakeups every 'n' events instead of at page boundaries. (See:
attr.wakeup_events).

Regarding locked pags: there is an extra per user mlock limit for
perf counters found in sysctl_perf_counter_mlock so it can be
configured independently. Furthermore, the accounting is done on a
per struct user basis, not on a per task basis - which makes the use
of locked pages far less of an issue to distros.

Regarding using 4K for the sampling data header: we are making use
of that property. We recently extended the header to include more
fields and having it writable - so the 4K MMU separation between
data header and data pages very much paid off already - and it could
provide more advantages in the future.
