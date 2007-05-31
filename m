Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbXEaPKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbXEaPKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 11:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbXEaPKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 11:10:13 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:48247 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbXEaPKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 11:10:11 -0400
Date: Thu, 31 May 2007 17:10:07 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
To: =?ISO-8859-1?B?Qmr2cm4=?= Steinbrink <B.Steinbrink@gmx.de>
Cc: iank@bredband.net, Thomas Gleixner <tglx@linutronix.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] Something goes wrong with timer statistics.
Message-Id: <20070531171007.5780e5e6.dada1@cosmosbay.com>
In-Reply-To: <20070531142522.GA16690@atjola.homenet>
References: <1180474738.22497.25.camel@pi.pomac.com>
	<6bffcb0e0705291524y2752d646p94b0bf6ca87af68f@mail.gmail.com>
	<1180478288.20546.39.camel@chaos>
	<20070530113825.GA5203@atjola.homenet>
	<20070530144449.36811a4d.dada1@cosmosbay.com>
	<20070530131458.GA5432@atjola.homenet>
	<20070531102047.GG19272@pomac.netswarm.net>
	<20070531142522.GA16690@atjola.homenet>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 16:25:22 +0200
Björn Steinbrink <B.Steinbrink@gmx.de> wrote:

> On 2007.05.31 12:20:47 +0200, iank@bredband.net wrote:
> > On Wed, May 30, 2007 at 03:14:58PM +0200, Björn Steinbrink wrote:
> > > Initialize the "next" field of a timer stats entry before it is inserted
> > > into the list to avoid a race with the fastpath lookup.
> > 
> > Sorry to say... but this does not fix my problem, however, i can't reach
> > that machine at all atm, but i will post the oops later today.
> 
> Ok, three times is a charm, right? ;-) The previous patch did fix a
> race, but there's still one left. The hash table is never cleared, so it
> can still point into the entries array.
> 
> As long as we do not race with the insertion, that's not a directly
> visible problem as all fields are 0, so we get no match and the lookup
> finishes right away. We probably _can_ get weird results though, as the
> all-zero entry isn't marked as used, but is used as "head" and "prev" in
> this case and even multiple hash entries might point to it in some
> cases.  That would eventually lead to lost entries because the "next"
> field gets overwritten when alloc_entry() finally claims the entry.
> 
> But when we race, we can still end up between "*curr = *entry" (makes
> "next" contain garbage) and "curr->next = NULL", while we're doing the
> fastpath lookup, because the insertion basically already took place!
> Replacing "curr->next = NULL" with "entry->next = NULL" and moving it up
> is pointless, as "*curr = *entry" isn't atomic, so instead, we have to
> simply clean the hash table when the entries are cleared.
> 
> Björn
> 
> 
> Fix two races in the timer stats lookup code. One by ensuring that the
> initialization of a new entry is finished upon insertion of that entry.
> The other by cleaning up the hash table when the entries array is
> cleared, so that we don't have "pre-inserted" entries.
> 
> Thanks to Eric Dumazet for reminding me of the memory barrier.
> 
> Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
> ---
> diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
> index 868f1bc..611b844 100644
> --- a/kernel/time/timer_stats.c
> +++ b/kernel/time/timer_stats.c
> @@ -117,21 +117,6 @@ static struct entry entries[MAX_ENTRIES];
>  
>  static atomic_t overflow_count;
>  
> -static void reset_entries(void)
> -{
> -	nr_entries = 0;
> -	memset(entries, 0, sizeof(entries));
> -	atomic_set(&overflow_count, 0);
> -}
> -
> -static struct entry *alloc_entry(void)
> -{
> -	if (nr_entries >= MAX_ENTRIES)
> -		return NULL;
> -
> -	return entries + nr_entries++;
> -}
> -
>  /*
>   * The entries are in a hash-table, for fast lookup:
>   */
> @@ -149,6 +134,22 @@ static struct entry *alloc_entry(void)
>  
>  static struct entry *tstat_hash_table[TSTAT_HASH_SIZE] __read_mostly;
>  
> +static void reset_entries(void)
> +{
> +	nr_entries = 0;
> +	memset(entries, 0, sizeof(entries));
> +	memset(tstat_hash_table, 0, sizeof(tstat_hash_table));
> +	atomic_set(&overflow_count, 0);
> +}
> +
> +static struct entry *alloc_entry(void)
> +{
> +	if (nr_entries >= MAX_ENTRIES)
> +		return NULL;
> +
> +	return entries + nr_entries++;
> +}
> +
>  static int match_entries(struct entry *entry1, struct entry *entry2)
>  {
>  	return entry1->timer       == entry2->timer	  &&
> @@ -202,12 +203,15 @@ static struct entry *tstat_lookup(struct entry *entry, char *comm)
>  	if (curr) {
>  		*curr = *entry;
>  		curr->count = 0;
> +		curr->next = NULL;
>  		memcpy(curr->comm, comm, TASK_COMM_LEN);
> +
> +		smp_mb(); /* Ensure that curr is initialized before insert */
> +
>  		if (prev)
>  			prev->next = curr;
>  		else
>  			*head = curr;
> -		curr->next = NULL;
>  	}
>   out_unlock:
>  	spin_unlock(&table_lock);
> -

Well... :) , there is still a memory barrier missing it seems.

Another cpu might see a bad value if 'active=1' is set before tstat_hash_table is really cleared.


 diff -urp linux/kernel/time/timer_stats.c.orig linux/kernel/time/timer_stats.c
--- kernel/time/timer_stats.c.orig
+++ kernel/time/timer_stats.c
@@ -361,6 +361,7 @@ static ssize_t tstats_write(struct file 
                if (!active) {
                        reset_entries();
                        time_start = ktime_get();
+                       smp_mb();
                        active = 1;
                }
                break;


