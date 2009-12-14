Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbZLNOo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbZLNOo4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbZLNOoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:44:55 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:36872 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbZLNOoy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:44:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mmgV0JzRezLzZE5kgIR30F6l50HfwaHl1LX44fVBR8MepECC3y6hkqEdS3tEbK40LZ
         PNBucSNSoAzdOIDMxepcCO65rEwFJkFg9uiFoXGFwaj5uUC2Chb9b/KbdqHyPYf6utDb
         HwcJIrOucr7h+inEd4Tv4hhR5zwFyRvXybM70=
MIME-Version: 1.0
In-Reply-To: <20091214133014.GL5168@nowhere>
References: <1260691344-4724-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <20091214133014.GL5168@nowhere>
Date: Mon, 14 Dec 2009 23:44:53 +0900
X-Google-Sender-Auth: 59442eb204043b13
Message-ID: <a6b9f31a0912140644t50c8aa9y7b6c51339374bb94@mail.gmail.com>
Subject: Re: [PATCH][RFC] perf lock: Distribute numerical IDs for each lock 
	instances
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 22:30, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Sun, Dec 13, 2009 at 05:02:24PM +0900, Hitoshi Mitake wrote:
>> This patch implements distributing numerical IDs for each lock instances.
>>
>> Principle:
>> At first, kernel holds lock_idtable. It is an double dimension array
>> for each lock class with LOCK_IDTABLE_LENGTH of struct lock_instance_stat.
>>
>> struct lock_instance_stat can have many things for lock stats or something,
>> but it isn't important point.
>>
>> The important point is that index of lock_idtable is used as numerical ID.
>> And this patch makes lockdep_map have this ID. So searching stats data for
>> lock instances are O(1), very fast.
>>
>> And the second important point is that when numerical IDs are distributed
>> for each lock instances.
>> This patch makes lockdep_map have a new member, do_register. This is a pointer of function.
>> When initialized the lock instances (for example: SPIN_DEP_MAP_INIT in spinlock_types.h),
>> this member is initialized with
>> register_lockdep_id() in kernel/lockdep.c .
>> This function receives the adress of lockdep_map (it's owner),
>> and searches lock_idtable, then if unused ID (unused index) is found,
>> set the owner (spinlock_t, rwlock_t, etc. obtained with container_of) of lockdep_map
>> to lock_idtable's unit determined in above.
>>
>> When this do_register() called? lock_acquire() calls it.
>> And once initialize completed, nop_register_lockdep_id() will be
>> assigned to do_register(). It is a nop function.
>>
>> I believe this patch makes implementation of perf lock more easy
>> and precision, and may also help lock people.
>>
>> Benefit:
>>  * Low overhead
>>  * int type ID is easy to deal with
>>
>> Demerit:
>>  * What should kernel do when lock_idtable is exhausted?
>>    (But I think entire number of lock instances are not so many,
>>     and predicting upper limit of it is not hard)
>>  * instances before calling lock_acquire() with cannot be identified
>>  * end of instances cannot be determined
>>
>> This patch is a proof of concept version.
>> There are some rest todos, especially the statement in lock_acquire():
>>       if (lock->do_register)
>> this must be removed in future, this proves that
>> there's some lockdep_map I cannot initializing correctly.
>> For example, rcu_lock_map in kernel/rcupdate.c .
>>
>> And I implemented debugfs entry, lockdep_idtable
>> for dumping ID and name of instances like this,
>> % cat  lockdep_idtable
>>         --- spinlock ---
>> 0: logbuf_lock
>> 1: (console_sem).lock
>> 2: clockevents_lock
>> 3: set_atomicity_lock
>> 4: pgd_lock
>> 5: init_mm.page_table_lock
>> 6: index_init_lock
>> 7: ioapic_lock
>> 8: x86_mce_decoder_chain.lock
>> 9: pcpu_lock
>> 10: perf_resource_lock
>> ...
>>
>> But it is can be merged according to checkpatch.pl,
>> if you like it, could you merge it into perf/lock branch, Ingo?
>> And I really want to hear comments from people! :)
>>
>> Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>
>
>
> So if I understand well, this maps each lockdep_map
> into a unique index, right?

There's a slightly difference. This patch maps each lock instances
(spinlock_t, rwlock_t, etc) into a unique index.

>
> Then the goal is to be able to identify each lock instances from
> perf lock using a simple array of indexes.
>
> But adding the lockdep_map address from lock events would provide
> you a unique id for each lock instances already. Sure it would
> be addresses instead of indexes but I think a hashlist should do
> the trick already. I'm not sure we need to add more complexity
> inside in-kernel lock debugging while we already have the keys
> to make it scale well in userspace.

The usecase I assumed is (for example) that
dividing copying name of lock instances to userspace from lock trace events.

I think that copying name of lock at every trace event time is not efficient.
For example, ID <-> name table can be made in my way.
So each lock events only have to output it's ID.
Then, perf lock reads the table from file on debugfs.
Finally perf lock can refer the table and obtain name of each lock.
This may reduce the data transfer between kernel and userspace.

But... you are right. This effect can be also obtained by hashlist.
There's no requirement of implementing array.
And optimization should be done after implementation.
I'll back to coding of perf lock, sorry..

# But I think that this is useful to measure the overhead of hashlist! :)

Thanks
	Hitoshi
