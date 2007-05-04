Return-Path: <linux-kernel-owner+w=401wt.eu-S1767873AbXEDKxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767873AbXEDKxW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 06:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767878AbXEDKxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 06:53:22 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:46775 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1767873AbXEDKxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 06:53:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=XftIU5OlClkhfDMtgFf5ap32YLiPWvSS8Z31Pblw7xID++Sxa0Qs7uM9YhvEY0WEiB4/WJGJjHtzuPuK5eNAZa0vdQJJ49QbdcjK+QVM7Zdl+m1PrpyIhWr//pbr7wGAIGy2iJVY8ucyDLFqXPC9WkJP3jDbSA3elXPBlCD60yg=  ;
X-YMail-OSG: cOJqtoQVM1lzhFqhWXFb6xiFX1s0Xjc1KMp3qUOXZmRpdheWWG3bzhNwVjZO0KAzg_dGA1.TIQ--
Message-ID: <463B108C.10602@yahoo.com.au>
Date: Fri, 04 May 2007 20:53:00 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] MM: implement MADV_FREE lazy freeing of anonymous memory
References: <4632D0EF.9050701@redhat.com>
In-Reply-To: <4632D0EF.9050701@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> With lazy freeing of anonymous pages through MADV_FREE, performance of
> the MySQL sysbench workload more than doubles on my quad-core system.

OK, I've run some tests on a 16 core Opteron system, both sysbench with
MySQL 5.33 (set up as described in the freebsd vs linux page), and with
ebizzy.

What I found is that, on this system, MADV_FREE performance improvement
was in the noise when you look at it on top of the MADV_DONTNEED glibc
and down_read(mmap_sem) patch in sysbench.

In ebizzy it was slightly up at low loads and slightly down at high loads,
though I wouldn't put as much stock in ebizzy as the real workload,
because the numbers are going to be highly dependand on access patterns.

Now these numbers are collected under best-case conditions for MADV_FREE,
ie. no page reclaim going on. If you consider page reclaim, then you would
think there might be room for regressions.

So far, I'm not convinced this is a good use of a page flag or the added
complexity. There are lots of ways we can improve performance using a page
flag (my recent PG_waiters, PG_mlock, PG_replicated, etc.) to improve
performance, so I think we need some more numbers.

(I'll be away for the weekend...)


LHS is # threads, numbers are +/- 99.9% confidence.

sysbench transactions per sec (higher is better)

2.6.21
1,   453.092000 +/-  7.089284
2,   831.722000 +/- 13.138541
4,  1468.590000 +/- 40.160654
8,  2139.822000 +/- 62.223220
16, 2118.802000 +/- 83.247076
32, 1051.596000 +/- 62.455236
64,  917.078000 +/- 21.086954

new glibc
1,   466.376000 +/-   9.018054
2,   867.020000 +/-  26.163901
4,  1535.880000 +/-  25.784081
8,  2261.856000 +/-  53.350146
16, 2249.020000 +/- 120.361138
32, 1521.858000 +/- 110.236781
64, 1405.262000 +/-  85.260624

mmap_sem
1,   476.144000 +/- 15.865284
2,   871.778000 +/- 12.736486
4,  1529.348000 +/- 21.400517
8,  2235.590000 +/- 54.192125
16, 2177.422000 +/- 27.416498
32, 2120.986000 +/- 58.499708
64, 1949.362000 +/- 51.177977

madv_free
1,   475.056000 +/-  6.943168
2,   861.438000 +/- 22.101826
4,  1564.782000 +/- 55.190110
8,  2211.792000 +/- 59.843995
16, 2163.232000 +/- 46.031627
32, 2100.544000 +/- 86.744497
64, 1947.058000 +/- 62.392049


ebizzy elapsed time (lower is better)

mmap_sem
1,   45.544000 +/-  3.538529
4,   78.492000 +/-  8.881464
16, 224.538000 +/-  7.762784
64, 913.466000 +/- 53.506338

madv_free
1,   43.350000 +/-  0.778292
4,   68.190000 +/-  8.623731
16, 225.568000 +/- 14.940109
64, 899.136000 +/- 56.153209

-- 
SUSE Labs, Novell Inc.
