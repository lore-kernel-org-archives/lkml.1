Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbXEaXJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbXEaXJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 19:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758987AbXEaXIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 19:08:51 -0400
Received: from mail.gmx.net ([213.165.64.20]:43663 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758962AbXEaXIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 19:08:50 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX183Cusdqt43qlckf8ZzYkRQTQwVjK+g5vFWm7wmR9
	9VkdXnD990jvoX
Date: Fri, 1 Jun 2007 01:09:03 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Ian Kumlien <iank@bredband.net>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Thomas Gleixner <tglx@linutronix.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] Something goes wrong with timer statistics.
Message-ID: <20070531230903.GA19353@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	Ian Kumlien <iank@bredband.net>, Eric Dumazet <dada1@cosmosbay.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
	linux-kernel@vger.kernel.org
References: <6bffcb0e0705291524y2752d646p94b0bf6ca87af68f@mail.gmail.com> <1180478288.20546.39.camel@chaos> <20070530113825.GA5203@atjola.homenet> <20070530144449.36811a4d.dada1@cosmosbay.com> <20070530131458.GA5432@atjola.homenet> <20070531102047.GG19272@pomac.netswarm.net> <20070531142522.GA16690@atjola.homenet> <20070531171007.5780e5e6.dada1@cosmosbay.com> <20070531152709.GA18775@atjola.homenet> <1180652361.30698.11.camel@pi.pomac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1180652361.30698.11.camel@pi.pomac.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.06.01 00:59:11 +0200, Ian Kumlien wrote:
> On tor, 2007-05-31 at 17:27 +0200, Björn Steinbrink wrote:
> > On 2007.05.31 17:10:07 +0200, Eric Dumazet wrote:
> > > Well... :) , there is still a memory barrier missing it seems.
> > > 
> > > Another cpu might see a bad value if 'active=1' is set before tstat_hash_table is really cleared.
> > 
> > Hm, that even makes the assumption in my first try valid ;-)
> > Just for the record, this time I thought that the barrier from the
> > spinlock in timer_stats_update_stats (right before the check for active)
> > would be enough, but that's obviously running on the wrong cpu if we
> > race... *sigh*
> > 
> 
> Fix the comment below and you can add:
> Signed-off-by: Ian Kumlien <pomac@vapor.com>
> 
> It's currently been running for the longest period ever, ie, 11 minutes
> =)

Finally! :-)

> I'm gonna leave it running during the night and send a status update
> when the evil daystar reaches it's peak CET. (i haven't been able to
> stop since linus mentioned it... damn it... =))
> 
> > @@ -360,6 +364,7 @@ static ssize_t tstats_write(struct file *file, const char __user *buf,
> >  		if (!active) {
> >  			reset_entries();
> >  			time_start = ktime_get();
> > +			smb_mb();
> 
> smb? you mean smp =)

No idea how I managed to break that after test compiling it... :-/
Thanks for catching it :-)

So unless I messed up something again, here's the final patch.

Thanks,
Björn


Fix two races in the timer stats lookup code. One by ensuring that the
initialization of a new entry is finished upon insertion of that entry.
The other by cleaning up the hash table when the entries array is
cleared, so that we don't have any "pre-inserted" entries.

Thanks to Eric Dumazet for reminding me of the memory barriers.

Signed-off-by: Björn Steinbrink <B.Steinbrink@gmx.de>
Signed-off-by: Ian Kumlien <pomac@vapor.com>
---
diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index 868f1bc..fa3d380 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -117,21 +117,6 @@ static struct entry entries[MAX_ENTRIES];
 
 static atomic_t overflow_count;
 
-static void reset_entries(void)
-{
-	nr_entries = 0;
-	memset(entries, 0, sizeof(entries));
-	atomic_set(&overflow_count, 0);
-}
-
-static struct entry *alloc_entry(void)
-{
-	if (nr_entries >= MAX_ENTRIES)
-		return NULL;
-
-	return entries + nr_entries++;
-}
-
 /*
  * The entries are in a hash-table, for fast lookup:
  */
@@ -149,6 +134,22 @@ static struct entry *alloc_entry(void)
 
 static struct entry *tstat_hash_table[TSTAT_HASH_SIZE] __read_mostly;
 
+static void reset_entries(void)
+{
+	nr_entries = 0;
+	memset(entries, 0, sizeof(entries));
+	memset(tstat_hash_table, 0, sizeof(tstat_hash_table));
+	atomic_set(&overflow_count, 0);
+}
+
+static struct entry *alloc_entry(void)
+{
+	if (nr_entries >= MAX_ENTRIES)
+		return NULL;
+
+	return entries + nr_entries++;
+}
+
 static int match_entries(struct entry *entry1, struct entry *entry2)
 {
 	return entry1->timer       == entry2->timer	  &&
@@ -202,12 +203,15 @@ static struct entry *tstat_lookup(struct entry *entry, char *comm)
 	if (curr) {
 		*curr = *entry;
 		curr->count = 0;
+		curr->next = NULL;
 		memcpy(curr->comm, comm, TASK_COMM_LEN);
+
+		smp_mb(); /* Ensure that curr is initialized before insert */
+
 		if (prev)
 			prev->next = curr;
 		else
 			*head = curr;
-		curr->next = NULL;
 	}
  out_unlock:
 	spin_unlock(&table_lock);
@@ -360,6 +364,7 @@ static ssize_t tstats_write(struct file *file, const char __user *buf,
 		if (!active) {
 			reset_entries();
 			time_start = ktime_get();
+			smp_mb();
 			active = 1;
 		}
 		break;
