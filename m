Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbZD2MbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbZD2MbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752379AbZD2MbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:31:05 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:58255 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbZD2MbD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:31:03 -0400
Message-ID: <49F84833.5000908@cosmosbay.com>
Date: Wed, 29 Apr 2009 14:29:39 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       cl@linux.com, jesse.brandeburg@intel.com, netdev@vger.kernel.org,
       haoki@redhat.com, mchan@broadcom.com, davidel@xmailserver.org
Subject: Re: [PATCH] poll: Avoid extra wakeups in select/poll
References: <alpine.DEB.1.10.0904241554100.29995@qirst.com> <49F3308B.1030507@cosmosbay.com> <20090426.020411.157511269.davem@davemloft.net> <49F43B8F.2050907@cosmosbay.com> <87ab60rh8t.fsf@basil.nowhere.org> <49F71B63.8010503@cosmosbay.com> <20090429091637.GA29874@elte.hu> <49F81FB9.50504@cosmosbay.com> <20090429102734.GC2373@elte.hu>
In-Reply-To: <20090429102734.GC2373@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 29 Apr 2009 14:29:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> 
>> Ingo Molnar a écrit :
>>> * Eric Dumazet <dada1@cosmosbay.com> wrote:
>>>
>>>> @@ -418,8 +429,16 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
>>>>  				if (file) {
>>>>  					f_op = file->f_op;
>>>>  					mask = DEFAULT_POLLMASK;
>>>> -					if (f_op && f_op->poll)
>>>> +					if (f_op && f_op->poll) {
>>>> +						if (wait) {
>>>> +							wait->key = POLLEX_SET;
>>>> +							if (in & bit)
>>>> +								wait->key |= POLLIN_SET;
>>>> +							if (out & bit)
>>>> +								wait->key |= POLLOUT_SET;
>>>> +						}
>>>>  						mask = (*f_op->poll)(file, retval ? NULL : wait);
>>>> +					}
>>>>  					fput_light(file, fput_needed);
>>>>  					if ((mask & POLLIN_SET) && (in & bit)) {
>>>>  						res_in |= bit;
>>> Please factor this whole 'if (file)' branch out into a helper. 
>>> Typical indentation levels go from 1 to 3 tabs - 4 should be avoided 
>>> if possible and 5 is pretty excessive already. This goes to eight.
>>>
>> Thanks Ingo,
>>
>> Here is v3 of patch, with your Acked-by included :)
>>
>> This is IMHO clearer since helper immediatly follows POLLIN_SET / POLLOUT_SET /
>> POLLEX_SET defines.
>>
>> [PATCH] poll: Avoid extra wakeups in select/poll
>>
>> After introduction of keyed wakeups Davide Libenzi did on epoll, we
>> are able to avoid spurious wakeups in poll()/select() code too.
>>
>> For example, typical use of poll()/select() is to wait for incoming
>> network frames on many sockets. But TX completion for UDP/TCP 
>> frames call sock_wfree() which in turn schedules thread.
>>
>> When scheduled, thread does a full scan of all polled fds and
>> can sleep again, because nothing is really available. If number
>> of fds is large, this cause significant load.
>>
>> This patch makes select()/poll() aware of keyed wakeups and
>> useless wakeups are avoided. This reduces number of context
>> switches by about 50% on some setups, and work performed
>> by sofirq handlers.
>>
>> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
>> Acked-by: David S. Miller <davem@davemloft.net>
>> Acked-by: Andi Kleen <ak@linux.intel.com>
>> Acked-by: Ingo Molnar <mingo@elte.hu>
> 
>> ---
>>  fs/select.c          |   40 ++++++++++++++++++++++++++++++++++++----
>>  include/linux/poll.h |    3 +++
>>  2 files changed, 39 insertions(+), 4 deletions(-)
>>
>> diff --git a/fs/select.c b/fs/select.c
>> index 0fe0e14..ba068ad 100644
>> --- a/fs/select.c
>> +++ b/fs/select.c
>> @@ -168,7 +168,7 @@ static struct poll_table_entry *poll_get_entry(struct poll_wqueues *p)
>>  	return table->entry++;
>>  }
>>  
>> -static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
>> +static int __pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
>>  {
>>  	struct poll_wqueues *pwq = wait->private;
>>  	DECLARE_WAITQUEUE(dummy_wait, pwq->polling_task);
>> @@ -194,6 +194,16 @@ static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
>>  	return default_wake_function(&dummy_wait, mode, sync, key);
>>  }
>>  
>> +static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
>> +{
>> +	struct poll_table_entry *entry;
>> +
>> +	entry = container_of(wait, struct poll_table_entry, wait);
>> +	if (key && !((unsigned long)key & entry->key))
>> +		return 0;
>> +	return __pollwake(wait, mode, sync, key);
>> +}
>> +
>>  /* Add a new entry */
>>  static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
>>  				poll_table *p)
>> @@ -205,6 +215,7 @@ static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
>>  	get_file(filp);
>>  	entry->filp = filp;
>>  	entry->wait_address = wait_address;
>> +	entry->key = p->key;
>>  	init_waitqueue_func_entry(&entry->wait, pollwake);
>>  	entry->wait.private = pwq;
>>  	add_wait_queue(wait_address, &entry->wait);
>> @@ -362,6 +373,18 @@ get_max:
>>  #define POLLOUT_SET (POLLWRBAND | POLLWRNORM | POLLOUT | POLLERR)
>>  #define POLLEX_SET (POLLPRI)
>>  
>> +static void wait_key_set(poll_table *wait, unsigned long in,
>> +			 unsigned long out, unsigned long bit)
>> +{
>> +	if (wait) {
>> +		wait->key = POLLEX_SET;
>> +		if (in & bit)
>> +			wait->key |= POLLIN_SET;
>> +		if (out & bit)
>> +			wait->key |= POLLOUT_SET;
>> +	}
>> +}
> 
> should be inline perhaps?

Well, I thought current practice was not using inline for such trivial functions,
as gcc already inlines them anyway.

Quoting Documentation/CodingStyle :
  Often people argue that adding inline to functions that are static and used
  only once is always a win since there is no space tradeoff. While this is
  technically correct, gcc is capable of inlining these automatically without
  help, and the maintenance issue of removing the inline when a second user
  appears outweighs the potential value of the hint that tells gcc to do
  something it would have done anyway.

Anyway :

[PATCH] poll: Avoid extra wakeups in select/poll

After introduction of keyed wakeups Davide Libenzi did on epoll, we
are able to avoid spurious wakeups in poll()/select() code too.

For example, typical use of poll()/select() is to wait for incoming
network frames on many sockets. But TX completion for UDP/TCP 
frames call sock_wfree() which in turn schedules thread.

When scheduled, thread does a full scan of all polled fds and
can sleep again, because nothing is really available. If number
of fds is large, this cause significant load.

This patch makes select()/poll() aware of keyed wakeups and
useless wakeups are avoided. This reduces number of context
switches by about 50% on some setups, and work performed
by sofirq handlers.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Acked-by: David S. Miller <davem@davemloft.net>
Acked-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 fs/select.c          |   40 ++++++++++++++++++++++++++++++++++++----
 include/linux/poll.h |    3 +++
 2 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 0fe0e14..ba068ad 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -168,7 +168,7 @@ static struct poll_table_entry *poll_get_entry(struct poll_wqueues *p)
 	return table->entry++;
 }
 
-static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
+static int __pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
 {
 	struct poll_wqueues *pwq = wait->private;
 	DECLARE_WAITQUEUE(dummy_wait, pwq->polling_task);
@@ -194,6 +194,16 @@ static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
 	return default_wake_function(&dummy_wait, mode, sync, key);
 }
 
+static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
+{
+	struct poll_table_entry *entry;
+
+	entry = container_of(wait, struct poll_table_entry, wait);
+	if (key && !((unsigned long)key & entry->key))
+		return 0;
+	return __pollwake(wait, mode, sync, key);
+}
+
 /* Add a new entry */
 static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
 				poll_table *p)
@@ -205,6 +215,7 @@ static void __pollwait(struct file *filp, wait_queue_head_t *wait_address,
 	get_file(filp);
 	entry->filp = filp;
 	entry->wait_address = wait_address;
+	entry->key = p->key;
 	init_waitqueue_func_entry(&entry->wait, pollwake);
 	entry->wait.private = pwq;
 	add_wait_queue(wait_address, &entry->wait);
@@ -362,6 +373,18 @@ get_max:
 #define POLLOUT_SET (POLLWRBAND | POLLWRNORM | POLLOUT | POLLERR)
 #define POLLEX_SET (POLLPRI)
 
+static inline void wait_key_set(poll_table *wait, unsigned long in,
+				unsigned long out, unsigned long bit)
+{
+	if (wait) {
+		wait->key = POLLEX_SET;
+		if (in & bit)
+			wait->key |= POLLIN_SET;
+		if (out & bit)
+			wait->key |= POLLOUT_SET;
+	}
+}
+
 int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 {
 	ktime_t expire, *to = NULL;
@@ -418,20 +441,25 @@ int do_select(int n, fd_set_bits *fds, struct timespec *end_time)
 				if (file) {
 					f_op = file->f_op;
 					mask = DEFAULT_POLLMASK;
-					if (f_op && f_op->poll)
-						mask = (*f_op->poll)(file, retval ? NULL : wait);
+					if (f_op && f_op->poll) {
+						wait_key_set(wait, in, out, bit);
+						mask = (*f_op->poll)(file, wait);
+					}
 					fput_light(file, fput_needed);
 					if ((mask & POLLIN_SET) && (in & bit)) {
 						res_in |= bit;
 						retval++;
+						wait = NULL;
 					}
 					if ((mask & POLLOUT_SET) && (out & bit)) {
 						res_out |= bit;
 						retval++;
+						wait = NULL;
 					}
 					if ((mask & POLLEX_SET) && (ex & bit)) {
 						res_ex |= bit;
 						retval++;
+						wait = NULL;
 					}
 				}
 			}
@@ -685,8 +713,12 @@ static inline unsigned int do_pollfd(struct pollfd *pollfd, poll_table *pwait)
 		mask = POLLNVAL;
 		if (file != NULL) {
 			mask = DEFAULT_POLLMASK;
-			if (file->f_op && file->f_op->poll)
+			if (file->f_op && file->f_op->poll) {
+				if (pwait)
+					pwait->key = pollfd->events |
+							POLLERR | POLLHUP;
 				mask = file->f_op->poll(file, pwait);
+			}
 			/* Mask out unneeded events. */
 			mask &= pollfd->events | POLLERR | POLLHUP;
 			fput_light(file, fput_needed);
diff --git a/include/linux/poll.h b/include/linux/poll.h
index 8c24ef8..3327389 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -32,6 +32,7 @@ typedef void (*poll_queue_proc)(struct file *, wait_queue_head_t *, struct poll_
 
 typedef struct poll_table_struct {
 	poll_queue_proc qproc;
+	unsigned long key;
 } poll_table;
 
 static inline void poll_wait(struct file * filp, wait_queue_head_t * wait_address, poll_table *p)
@@ -43,10 +44,12 @@ static inline void poll_wait(struct file * filp, wait_queue_head_t * wait_addres
 static inline void init_poll_funcptr(poll_table *pt, poll_queue_proc qproc)
 {
 	pt->qproc = qproc;
+	pt->key   = ~0UL; /* all events enabled */
 }
 
 struct poll_table_entry {
 	struct file *filp;
+	unsigned long key;
 	wait_queue_t wait;
 	wait_queue_head_t *wait_address;
 };

