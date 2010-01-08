Return-Path: <linux-kernel-owner+w=401wt.eu-S1751993Ab0AHIeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0AHIeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 03:34:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488Ab0AHIeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 03:34:04 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62682 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab0AHIeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 03:34:01 -0500
Message-ID: <4B46EDF7.3040205@dcl.info.waseda.ac.jp>
Date: Fri, 08 Jan 2010 17:33:59 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] perf lock: Implement basic sorting function of perf lock
References: <1261277805-27023-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1261998064.7135.74.camel@laptop>
In-Reply-To: <1261998064.7135.74.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009年12月28日 20:01, Peter Zijlstra wrote:
> On Sun, 2009-12-20 at 11:56 +0900, Hitoshi Mitake wrote:
>> +static struct lock_stat *lock_stat_findnew(void *addr, const char *name)
>> +{
>> +       struct list_head *entry = lockhashentry(addr);
>> +       struct lock_stat *ret, *new;
>
>
> Right, so you use a hash table to match lock instances, I suppose that's
> faster than an rb-tree?

Maybe. But it is hard to determine which data structure is better.
This is a histogram from perf.data produced by "perf bench sched messaging",

(left is length of list, right is number of list whose length is value 
of left)
0: 3333
1: 153
2: 91
3: 114
4: 96
5: 75
6: 61
7: 43
8: 29
9: 32
10: 23
11: 15
12: 9
13: 5
14: 7
15: 3
16: 1
17: 3
18: 0
19: 3   # 19 means "longer than 19"

Total number of lock instances is 3459,
so if perf lock use rb-tree for storing info of lock instances,
average order of accessing stored node is lg 4096 == 12.
And the histogram above describes,
there are relatively very few lists with length over 12.
So I think hash list is better thing for storing info of lock instances 
than rb-tree.
(Sorting result is another issue, of course.)

>
> Do you also remove instances after a match to keep the hash relatively
> small?
>
>

No, I don't.
At the last phase of profiling,
perf lock makes rb-tree sorted by the key user specified.

static void sort_result(void)
{
	unsigned int i;
	struct lock_stat *st;

	for (i = 0; i < LOCKHASH_SIZE; i++) {
		list_for_each_entry(st, &lockhash_table[i], hash_entry) {
			insert_to_result(st, compare); # insert to rb-tree
		}
	}
}

As this code describes,
referencing the completed hash list is done only once.
So removing instances to keep the hash list relatively small
is not required, I think.
