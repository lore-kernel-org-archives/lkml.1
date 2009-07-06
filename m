Return-Path: <linux-kernel-owner+w=401wt.eu-S1756785AbZGFA4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785AbZGFA4R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 20:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756255AbZGFA4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 20:56:05 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:49517 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbZGFA4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 20:56:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hdlbVVTrlOxe5QJykTvMp1CGe7xEK60jFTPFK0NOrM9hTw8n0JBzxEcL2Lv/SDnooc
         rvtEziVUn0qoV8j27FQ9w8xuIdriC0L0M9TrSaDZftlVCZk7Oe/4X28oFbjBxsaGmkxG
         hOkEyOhxXvUXe5iIpJYLI9YVa0Oipfqq0wCcY=
Date: Mon, 6 Jul 2009 02:56:02 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: use hash table to simulate the sparse array
Message-ID: <20090706005600.GA20897@nowhere>
References: <4A3F2E38.7030604@cn.fujitsu.com> <4A49D12A.9040901@cn.fujitsu.com> <20090630115949.GB5249@nowhere> <4A4ACA67.8000002@cn.fujitsu.com> <20090701192514.GA5740@nowhere> <4A4C0D8F.20005@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4C0D8F.20005@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 09:29:51AM +0800, Lai Jiangshan wrote:
> Frederic Weisbecker wrote:
> > 
> > Hmm, I'm confused.
> > When you map a new pid, you do the following:
> > 
> > +static void do_map_cmdline_index(unsigned int idx, unsigned int pid)
> > +{
> > +	unsigned int hash = hash_32(pid, SAVED_CMDLINES_SHIFT);
> > +
> > +	if (map_cmdline_to_pid(idx) != NO_CMDLINE_MAP)
> > +		hlist_del(&indexes[idx].node);
> > +	indexes[idx].pid = pid;
> > +	hlist_add_head(&indexes[idx].node, &map_head[hash]);
> > +}
> > 
> > Then if there was a pid that had the same hash, it is deleted
> > from the hashlist and the new one steal his place, which
> > lead me to think you won't have more than one entry per hash.
> > 
> > 
> 
> indexes[idx] is deleted, not "indexes[hash]".
> idx is chosen by the FIFO algorithm(which I did not change).
> It is the earliest mapped item, its place is replaced by new item.
> 
> So map_head[hash] may have 2 or more entries(with different idx).
> 
> The whole patch do one thing only:
> implement map_pid_to_cmdline(pid), and make it equals to
> original map_pid_to_cmdline[pid] always.


Aah ok, I understand now.

So, I retry a review:

+
+struct cmdline_index {
+	struct hlist_node node;
+	unsigned int pid;
+};
+
+struct hlist_head map_head[SAVED_CMDLINES];


map_head is too generic as a name.
We are in trace.c which is quite overloaded (about 4300 lines)
Then global variables names, even static (should be static, right?)
should be chosen carefully.

May be pid_to_cmdline_hashlist ?



+struct cmdline_index indexes[SAVED_CMDLINES];



I would suggest to actually rename this "indexes" to
map_cmdline_to_pid.

- indexes is too much generic. While reading what follows below,
  I have been confused multiple times with this name.

- the function map_cmdline_to_pid() only deref indexes.

It means that we could reduce it to map_cmdline_to_pid[], that
would provide a more readable code.

Also, it seems it should it be static too.


+
+static unsigned int map_pid_to_cmdline(unsigned int pid)
+{
+	struct cmdline_index *index;
+	struct hlist_node *n;
+	unsigned int hash = hash_32(pid, SAVED_CMDLINES_SHIFT);
+
+	hlist_for_each_entry(index, n, &map_head[hash], node) {
+		if (index->pid == pid)
+			return index - indexes;
+	}
+
+	return NO_CMDLINE_MAP;
+}
+
+static unsigned int map_cmdline_to_pid(unsigned int idx)
+{
+	return indexes[idx].pid;
+}
+
+static void do_map_cmdline_index(unsigned int idx, unsigned int pid)
+{
+	unsigned int hash = hash_32(pid, SAVED_CMDLINES_SHIFT);
+
+	if (map_cmdline_to_pid(idx) != NO_CMDLINE_MAP)
+		hlist_del(&indexes[idx].node);
+	indexes[idx].pid = pid;
+	hlist_add_head(&indexes[idx].node, &map_head[hash]);
+}
+


Note that the algorithm change is not without side effect.
We are switching from an amortized constant access to another
unamortized one (or at least, not as much).

This function is executed in some hot paths.
I guess having more than one pid mapped in the same map_head[hash]
should be rare, but it would be better to have an Ack from Steve
before applying this patch.

Thanks,
Frederic.



 static char saved_cmdlines[SAVED_CMDLINES][TASK_COMM_LEN];
 static int cmdline_idx;
 static raw_spinlock_t trace_cmdline_lock = __RAW_SPIN_LOCK_UNLOCKED;
@@ -661,8 +699,7 @@ static atomic_t trace_record_cmdline_disabled __read_mostly;
 
 static void trace_init_cmdlines(void)
 {
-	memset(&map_pid_to_cmdline, NO_CMDLINE_MAP, sizeof(map_pid_to_cmdline));
-	memset(&map_cmdline_to_pid, NO_CMDLINE_MAP, sizeof(map_cmdline_to_pid));
+	memset(&indexes, NO_CMDLINE_MAP, sizeof(indexes));
 	cmdline_idx = 0;
 }
 
@@ -754,9 +791,9 @@ void trace_stop_cmdline_recording(void);
 
 static void trace_save_cmdline(struct task_struct *tsk)
 {
-	unsigned pid, idx;
+	unsigned int idx;
 
-	if (!tsk->pid || unlikely(tsk->pid > PID_MAX_DEFAULT))
+	if (!tsk->pid)
 		return;
 
 	/*
@@ -768,22 +805,11 @@ static void trace_save_cmdline(struct task_struct *tsk)
 	if (!__raw_spin_trylock(&trace_cmdline_lock))
 		return;
 
-	idx = map_pid_to_cmdline[tsk->pid];
+	idx = map_pid_to_cmdline(tsk->pid);
 	if (idx == NO_CMDLINE_MAP) {
 		idx = (cmdline_idx + 1) % SAVED_CMDLINES;
 
-		/*
-		 * Check whether the cmdline buffer at idx has a pid
-		 * mapped. We are going to overwrite that entry so we
-		 * need to clear the map_pid_to_cmdline. Otherwise we
-		 * would read the new comm for the old pid.
-		 */
-		pid = map_cmdline_to_pid[idx];
-		if (pid != NO_CMDLINE_MAP)
-			map_pid_to_cmdline[pid] = NO_CMDLINE_MAP;
-
-		map_cmdline_to_pid[idx] = tsk->pid;
-		map_pid_to_cmdline[tsk->pid] = idx;
+		do_map_cmdline_index(idx, tsk->pid);
 
 		cmdline_idx = idx;
 	}
@@ -802,14 +828,9 @@ void trace_find_cmdline(int pid, char comm[])
 		return;
 	}
 
-	if (pid > PID_MAX_DEFAULT) {
-		strcpy(comm, "<...>");
-		return;
-	}
-
 	preempt_disable();
 	__raw_spin_lock(&trace_cmdline_lock);
-	map = map_pid_to_cmdline[pid];
+	map = map_pid_to_cmdline(pid);
 	if (map != NO_CMDLINE_MAP)
 		strcpy(comm, saved_cmdlines[map]);
 	else
@@ -2458,7 +2479,7 @@ tracing_saved_cmdlines_read(struct file *file, char __user *ubuf,
 	for (i = 0; i < SAVED_CMDLINES; i++) {
 		int r;
 
-		pid = map_cmdline_to_pid[i];
+		pid = map_cmdline_to_pid(i);
 		if (pid == -1 || pid == NO_CMDLINE_MAP)
 			continue;
 




