Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbYFTIgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbYFTIgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 04:36:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbYFTIgX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 04:36:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:60534 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbYFTIgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 04:36:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,678,1204531200"; 
   d="py'?scan'208";a="292399"
Subject: [PATCH] lockdep: add lock_class information to lock_chain and
	output it
From: "Huang, Ying" <ying.huang@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-V2jOMWieqdC2gfZ5KFTi"
Date: Fri, 20 Jun 2008 16:39:21 +0800
Message-Id: <1213951161.29952.5.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 20 Jun 2008 08:36:04.0419 (UTC) FILETIME=[AD556130:01C8D2B0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-V2jOMWieqdC2gfZ5KFTi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=EF=BB=BFThis patch is not intended to be merged. Just hope it is useful fo=
r
somebody want to investigate kernel locking behavior. The simple
scripts attached with the mail can be used to draw class chain graph
via graphviz.

Best Regards,
Huang Ying
------------------------------------------------------------->
This patch records array of lock_class into lock_chain, and export
lock_chain information via /proc/lockdep_chains.

It is based on x86/master branch of git-x86 tree, and has been tested
on x86_64 platform.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 include/linux/lockdep.h    |    3 +
 kernel/lockdep.c           |   38 +++++++++++++++++-
 kernel/lockdep_internals.h |    6 ++
 kernel/lockdep_proc.c      |   91 ++++++++++++++++++++++++++++++++++++++++=
+++++
 4 files changed, 135 insertions(+), 3 deletions(-)

--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1463,7 +1463,14 @@ out_bug:
 }
=20
 unsigned long nr_lock_chains;
-static struct lock_chain lock_chains[MAX_LOCKDEP_CHAINS];
+struct lock_chain lock_chains[MAX_LOCKDEP_CHAINS];
+atomic_t nr_chain_hlocks;
+static u16 chain_hlocks[MAX_LOCKDEP_CHAIN_HLOCKS];
+
+struct lock_class *lock_chain_get_class(struct lock_chain *chain, int i)
+{
+	return lock_classes + chain_hlocks[chain->base + i];
+}
=20
 /*
  * Look up a dependency chain. If the key is not present yet then
@@ -1471,10 +1478,15 @@ static struct lock_chain lock_chains[MAX
  * validated. If the key is already hashed, return 0.
  * (On return with 1 graph_lock is held.)
  */
-static inline int lookup_chain_cache(u64 chain_key, struct lock_class *cla=
ss)
+static inline int lookup_chain_cache(struct task_struct *curr,
+				     struct held_lock *hlock,
+				     u64 chain_key)
 {
+	struct lock_class *class =3D hlock->class;
 	struct list_head *hash_head =3D chainhashentry(chain_key);
 	struct lock_chain *chain;
+	struct held_lock *hlock_curr, *hlock_next;
+	int i, j, n;
=20
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return 0;
@@ -1522,6 +1534,26 @@ cache_hit:
 	}
 	chain =3D lock_chains + nr_lock_chains++;
 	chain->chain_key =3D chain_key;
+	chain->irq_context =3D hlock->irq_context;
+	/* Find the first held_lock of current chain */
+	hlock_next =3D hlock;
+	for (i =3D curr->lockdep_depth - 1; i >=3D 0; i--) {
+		hlock_curr =3D curr->held_locks + i;
+		if (hlock_curr->irq_context !=3D hlock_next->irq_context)
+			break;
+		hlock_next =3D hlock;
+	}
+	i++;
+	chain->depth =3D curr->lockdep_depth + 1 - i;
+	n =3D atomic_add_return(chain->depth, &nr_chain_hlocks);
+	if (unlikely(n < MAX_LOCKDEP_CHAIN_HLOCKS)) {
+		chain->base =3D n - chain->depth;
+		for (j =3D 0; j < chain->depth - 1; j++, i++) {
+			int lock_id =3D curr->held_locks[i].class - lock_classes;
+			chain_hlocks[chain->base + j] =3D lock_id;
+		}
+		chain_hlocks[chain->base + j] =3D class - lock_classes;
+	}
 	list_add_tail_rcu(&chain->entry, hash_head);
 	debug_atomic_inc(&chain_lookup_misses);
 	inc_chains();
@@ -1543,7 +1575,7 @@ static int validate_chain(struct task_st
 	 * graph_lock for us)
 	 */
 	if (!hlock->trylock && (hlock->check =3D=3D 2) &&
-			lookup_chain_cache(chain_key, hlock->class)) {
+	    lookup_chain_cache(curr, hlock, chain_key)) {
 		/*
 		 * Check whether last held lock:
 		 *
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -182,6 +182,9 @@ struct lock_list {
  * We record lock dependency chains, so that we can cache them:
  */
 struct lock_chain {
+	u8				irq_context;
+	u8				depth;
+	u16				base;
 	struct list_head		entry;
 	u64				chain_key;
 };
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -178,6 +178,93 @@ static const struct file_operations proc
 	.release	=3D seq_release,
 };
=20
+static void *lc_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	struct lock_chain *chain;
+
+	(*pos)++;
+
+	if (v =3D=3D SEQ_START_TOKEN)
+		chain =3D m->private;
+	else {
+		chain =3D v;
+
+		if (*pos < nr_lock_chains)
+			chain =3D lock_chains + *pos;
+		else
+			chain =3D NULL;
+	}
+
+	return chain;
+}
+
+static void *lc_start(struct seq_file *m, loff_t *pos)
+{
+	if (*pos =3D=3D 0)
+		return SEQ_START_TOKEN;
+
+	if (*pos < nr_lock_chains)
+		return lock_chains + *pos;
+
+	return NULL;
+}
+
+static void lc_stop(struct seq_file *m, void *v)
+{
+}
+
+static int lc_show(struct seq_file *m, void *v)
+{
+	struct lock_chain *chain =3D v;
+	struct lock_class *class;
+	int i;
+
+	if (v =3D=3D SEQ_START_TOKEN) {
+		seq_printf(m, "all lock chains:\n");
+		return 0;
+	}
+
+	seq_printf(m, "irq_context: %d\n", chain->irq_context);
+
+	for (i =3D 0; i < chain->depth; i++) {
+		class =3D lock_chain_get_class(chain, i);
+		seq_printf(m, "[%p] ", class->key);
+		print_name(m, class);
+		seq_puts(m, "\n");
+	}
+	seq_puts(m, "\n");
+
+	return 0;
+}
+
+static const struct seq_operations lockdep_chains_ops =3D {
+	.start	=3D lc_start,
+	.next	=3D lc_next,
+	.stop	=3D lc_stop,
+	.show	=3D lc_show,
+};
+
+static int lockdep_chains_open(struct inode *inode, struct file *file)
+{
+	int res =3D seq_open(file, &lockdep_chains_ops);
+	if (!res) {
+		struct seq_file *m =3D file->private_data;
+
+		if (nr_lock_chains)
+			m->private =3D lock_chains;
+		else
+			m->private =3D NULL;
+	}
+	return res;
+}
+
+static const struct file_operations proc_lockdep_chains_operations =3D {
+	.open		=3D lockdep_chains_open,
+	.read		=3D seq_read,
+	.llseek		=3D seq_lseek,
+	.release	=3D seq_release,
+};
+
 static void lockdep_stats_debug_show(struct seq_file *m)
 {
 #ifdef CONFIG_DEBUG_LOCKDEP
@@ -294,6 +381,8 @@ static int lockdep_stats_show(struct seq
 #ifdef CONFIG_PROVE_LOCKING
 	seq_printf(m, " dependency chains:             %11lu [max: %lu]\n",
 			nr_lock_chains, MAX_LOCKDEP_CHAINS);
+	seq_printf(m, " dependency chain hlocks:       %11d [max: %lu]\n",
+			atomic_read(&nr_chain_hlocks), MAX_LOCKDEP_CHAIN_HLOCKS);
 #endif
=20
 #ifdef CONFIG_TRACE_IRQFLAGS
@@ -661,6 +750,8 @@ static const struct file_operations proc
 static int __init lockdep_proc_init(void)
 {
 	proc_create("lockdep", S_IRUSR, NULL, &proc_lockdep_operations);
+	proc_create("lockdep_chains", S_IRUSR, NULL,
+		    &proc_lockdep_chains_operations);
 	proc_create("lockdep_stats", S_IRUSR, NULL,
 		    &proc_lockdep_stats_operations);
=20
--- a/kernel/lockdep_internals.h
+++ b/kernel/lockdep_internals.h
@@ -23,6 +23,8 @@
 #define MAX_LOCKDEP_CHAINS_BITS	14
 #define MAX_LOCKDEP_CHAINS	(1UL << MAX_LOCKDEP_CHAINS_BITS)
=20
+#define MAX_LOCKDEP_CHAIN_HLOCKS (MAX_LOCKDEP_CHAINS*5)
+
 /*
  * Stack-trace: tightly packed array of stack backtrace
  * addresses. Protected by the hash_lock.
@@ -30,15 +32,19 @@
 #define MAX_STACK_TRACE_ENTRIES	262144UL
=20
 extern struct list_head all_lock_classes;
+extern struct lock_chain lock_chains[];
=20
 extern void
 get_usage_chars(struct lock_class *class, char *c1, char *c2, char *c3, ch=
ar *c4);
=20
 extern const char * __get_key_name(struct lockdep_subclass_key *key, char =
*str);
=20
+struct lock_class *lock_chain_get_class(struct lock_chain *chain, int i);
+
 extern unsigned long nr_lock_classes;
 extern unsigned long nr_list_entries;
 extern unsigned long nr_lock_chains;
+extern atomic_t nr_chain_hlocks;
 extern unsigned long nr_stack_trace_entries;
=20
 extern unsigned int nr_hardirq_chains;


--=-V2jOMWieqdC2gfZ5KFTi
Content-Disposition: attachment; filename=lockdep.py
Content-Type: text/x-python; name=lockdep.py; charset=UTF-8
Content-Transfer-Encoding: base64

IyEvdXNyL2Jpbi9weXRob24NCg0KaW1wb3J0IHN5cw0KaW1wb3J0IHJlDQoNCmRlZiBkb3RfbGFi
ZWwobGNfbmFtZSk6DQogICAgcmV0dXJuIGxjX25hbWUucmVwbGFjZSgnPicsIHInXD4nKQ0KDQpj
bGFzcyBsb2NrX2NsYXNzKG9iamVjdCk6DQogICAgZGVmIF9faW5pdF9fKHNlbGYsIG0pOg0KICAg
ICAgICBvYmplY3QuX19pbml0X18oc2VsZikNCiAgICAgICAgKGtleSwgbmZkLCBuYmQsIHVzYWdl
LCBuYW1lKSA9IG0uZ3JvdXBzKCkNCiAgICAgICAgc2VsZi5rZXkgPSBrZXkNCiAgICAgICAgc2Vs
Zi5uZmQgPSBpbnQobmZkKQ0KICAgICAgICBzZWxmLm5iZCA9IGludChuYmQpDQogICAgICAgIHNl
bGYudXNhZ2UgPSB1c2FnZQ0KICAgICAgICBzZWxmLm5hbWUgPSBuYW1lDQogICAgICAgIHNlbGYu
ZmRrcyA9IHNldCgpDQogICAgICAgIHNlbGYuZmRzID0gW10NCiAgICAgICAgc2VsZi5iZHMgPSBb
XQ0KICAgIGRlZiBhcHBlbmRfZmRrKHNlbGYsIGZkayk6DQogICAgICAgIHNlbGYuZmRrcy5hZGQo
ZmRrKQ0KICAgIGRlZiBhcHBlbmRfZmQoc2VsZiwgZmQpOg0KICAgICAgICBzZWxmLmZkcy5hcHBl
bmQoZmQpDQogICAgZGVmIGFwcGVuZF9iZChzZWxmLCBiZCk6DQogICAgICAgIHNlbGYuYmRzLmFw
cGVuZChiZCkNCiAgICBkZWYgcmVzb2x2ZV9mZChzZWxmLCBsY19tYXApOg0KICAgICAgICBmb3Ig
ZmRrIGluIHNlbGYuZmRrczoNCiAgICAgICAgICAgIGlmIG5vdCBsY19tYXAuaGFzX2tleShmZGsp
Og0KICAgICAgICAgICAgICAgIHByaW50ID4+IHN5cy5zdGRlcnIsICdXQVJOSU5HOiBub3QgbG9j
a19jbGFzcyBmb3IgJXMnICUgKGZkaywpDQogICAgICAgICAgICAgICAgY29udGludWUNCiAgICAg
ICAgICAgIGxjID0gbGNfbWFwW2Zka10NCiAgICAgICAgICAgIHNlbGYuYXBwZW5kX2ZkKGxjKQ0K
ICAgICAgICAgICAgbGMuYXBwZW5kX2JkKHNlbGYpDQoNCmNsYXNzIGxvY2tkZXAob2JqZWN0KToN
CiAgICByZV9sb2NrX2ZkID0gcmUuY29tcGlsZShyJ14gLT4gXFsoW2EtZjAtOV0rKVxdIChcUysp
XHMqJCcpDQogICAgcmVfbG9ja19jbGFzcyA9IHJlLmNvbXBpbGUocideKFthLWYwLTldKykgRkQ6
XHMqKFxkKykgJyArDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcidCRDpccyooXGQr
KSAoLi4uLik6IChcUyspXHMqJCcpDQogICAgZGVmIF9faW5pdF9fKHNlbGYpOg0KICAgICAgICBv
YmplY3QuX19pbml0X18oc2VsZikNCiAgICAgICAgc2VsZi5sb2NrX2NsYXNzZXMgPSB7fQ0KICAg
IGRlZiBwYXJzZShzZWxmLCBmKToNCiAgICAgICAgbGMgPSBOb25lDQogICAgICAgIGZvciBsIGlu
IGY6DQogICAgICAgICAgICBtbGMgPSBsb2NrZGVwLnJlX2xvY2tfY2xhc3MubWF0Y2gobCkNCiAg
ICAgICAgICAgIGlmIG1sYzoNCiAgICAgICAgICAgICAgICBsYyA9IGxvY2tfY2xhc3MobWxjKQ0K
ICAgICAgICAgICAgICAgIHNlbGYubG9ja19jbGFzc2VzW2xjLmtleV0gPSBsYw0KICAgICAgICAg
ICAgICAgIGNvbnRpbnVlDQogICAgICAgICAgICBtZmQgPSBsb2NrZGVwLnJlX2xvY2tfZmQubWF0
Y2gobCkNCiAgICAgICAgICAgIGlmIChtZmQpOg0KICAgICAgICAgICAgICAgIGxjLmFwcGVuZF9m
ZGsobWZkLmdyb3VwKDEpKQ0KICAgICAgICBmb3IgbGMgaW4gc2VsZi5sb2NrX2NsYXNzZXMudmFs
dWVzKCk6DQogICAgICAgICAgICBsYy5yZXNvbHZlX2ZkKHNlbGYubG9ja19jbGFzc2VzKQ0KICAg
IGRlZiBkdW1wX2RvdChzZWxmLCBmb3V0LCBsYyk6DQogICAgICAgIHRvdWNoZWQgPSBzZXQoKQ0K
ICAgICAgICBmb3V0LndyaXRlKCcnJ2RpZ3JhcGggTG9ja2RlcCB7DQpyYW5rZGlyID0gTFIgOw0K
bm9kZSBbIHNoYXBlID0gcmVjb3JkLCBmb250bmFtZSA9IENvdXJpZXIgXSA7DQonJycpDQogICAg
ICAgIGRlZiBkb19kdW1wKGxjKToNCiAgICAgICAgICAgIGZvdXQud3JpdGUoJyVzIFsgbGFiZWw9
IiVzJCVzIiBdIDtcbicgJSBcDQogICAgICAgICAgICAgICAgICAgICAgICAgICAobGMua2V5LCBk
b3RfbGFiZWwobGMubmFtZSksIGRvdF9sYWJlbChsYy51c2FnZSkpKQ0KICAgICAgICAgICAgdG91
Y2hlZC5hZGQobGMua2V5KQ0KICAgICAgICAgICAgZm9yIGZkIGluIGxjLmZkczoNCiAgICAgICAg
ICAgICAgICBmb3V0LndyaXRlKCciJXMiIC0+ICIlcyIgO1xuJyAlIChsYy5rZXksIGZkLmtleSkp
DQogICAgICAgICAgICAgICAgaWYgZmQua2V5IG5vdCBpbiB0b3VjaGVkOg0KICAgICAgICAgICAg
ICAgICAgICBkb19kdW1wKGZkKQ0KICAgICAgICBkb19kdW1wKGxjKQ0KICAgICAgICBmb3V0Lndy
aXRlKCd9XG4nKQ0KICAgIGRlZiBkdW1wX2RvdHMoc2VsZiwgcHJlZml4KToNCiAgICAgICAgbiA9
IDANCiAgICAgICAgZm9yIGxjIGluIHNlbGYubG9ja19jbGFzc2VzLnZhbHVlcygpOg0KICAgICAg
ICAgICAgaWYgbGVuKGxjLmJkcykgPT0gMDoNCiAgICAgICAgICAgICAgICBmb3V0ID0gZmlsZSgn
JXMtJWQuZG90JyAlIChwcmVmaXgsIG4pLCAndycpDQogICAgICAgICAgICAgICAgbiA9IG4gKyAx
DQogICAgICAgICAgICAgICAgc2VsZi5kdW1wX2RvdChmb3V0LCBsYykNCiAgICBkZWYgZHVtcF9j
aGFpbnMoc2VsZiwgZm91dCk6DQogICAgICAgIGRlZiBkb19kdW1wKGxjLCBzdGFjayk6DQogICAg
ICAgICAgICBpZiBsZW4obGMuZmRzKSA9PSAwOg0KICAgICAgICAgICAgICAgIGZvciBsIGluIHN0
YWNrOg0KICAgICAgICAgICAgICAgICAgICBmb3V0LndyaXRlKCclcyA6ICcgJSAobC5uYW1lLCkp
DQogICAgICAgICAgICAgICAgZm91dC53cml0ZSgnJXNcbicgJSAobGMubmFtZSwpKQ0KICAgICAg
ICAgICAgICAgIHJldHVybg0KICAgICAgICAgICAgc3RhY2suYXBwZW5kKGxjKQ0KICAgICAgICAg
ICAgZm9yIGZkIGluIGxjLmZkczoNCiAgICAgICAgICAgICAgICBkb19kdW1wKGZkLCBzdGFjaykN
CiAgICAgICAgICAgIGRlbCBzdGFja1stMV0NCiAgICAgICAgZm9yIGxjIGluIHNlbGYubG9ja19j
bGFzc2VzLnZhbHVlcygpOg0KICAgICAgICAgICAgaWYgbGVuKGxjLmJkcykgPT0gMDoNCiAgICAg
ICAgICAgICAgICBkb19kdW1wKGxjLCBbXSkNCiAgICBkZWYgZHVtcChzZWxmKToNCiAgICAgICAg
Zm9yIGxjIGluIHNlbGYubG9ja19jbGFzc2VzLnZhbHVlcygpOg0KICAgICAgICAgICAgcHJpbnQg
bGMubmFtZSwgbGMuZmRzDQoNCmNsYXNzIGxvY2tfY2hhaW4ob2JqZWN0KToNCiAgICBkZWYgX19p
bml0X18oc2VsZiwgaWMsIGxjcyk6DQogICAgICAgIG9iamVjdC5fX2luaXRfXyhzZWxmKQ0KICAg
ICAgICBzZWxmLmlycV9jb250ZXh0ID0gaWMNCiAgICAgICAgc2VsZi5jbGFzc19rZXlzID0gbGNz
WzpdDQogICAgICAgIHNlbGYuY2xhc3NlcyA9IFtdDQogICAgZGVmIHJlc29sdmVfY2xhc3Moc2Vs
ZiwgbGNfbWFwKToNCiAgICAgICAgZm9yIGsgaW4gc2VsZi5jbGFzc19rZXlzOg0KICAgICAgICAg
ICAgYyA9IGxjX21hcFtrXQ0KICAgICAgICAgICAgc2VsZi5jbGFzc2VzLmFwcGVuZChjKQ0KICAg
IGRlZiBhZGRfdG9fdHJlZShzZWxmLCB0cmVlcyk6DQogICAgICAgIGRlZiBjbGFzc2VzX2FkZF90
b190cmVlKGNsYXNzZXMsIHRyZWVfbm9kZSk6DQogICAgICAgICAgICBpZiBsZW4oY2xhc3Nlcykg
PT0gMDoNCiAgICAgICAgICAgICAgICByZXR1cm4NCiAgICAgICAgICAgIGxjID0gY2xhc3Nlc1sw
XQ0KICAgICAgICAgICAgaWYgbm90IHRyZWVfbm9kZS5jaGlsZHJlbi5oYXNfa2V5KGxjLmtleSk6
DQogICAgICAgICAgICAgICAgdHJlZV9ub2RlLmNoaWxkcmVuW2xjLmtleV0gPSBsY2hfdHJlZV9u
b2RlKGxjKQ0KICAgICAgICAgICAgY2xhc3Nlc19hZGRfdG9fdHJlZShjbGFzc2VzWzE6XSwgdHJl
ZV9ub2RlLmNoaWxkcmVuW2xjLmtleV0pDQogICAgICAgIGNsYXNzZXNfYWRkX3RvX3RyZWUoc2Vs
Zi5jbGFzc2VzLCB0cmVlcykNCiAgICBkZWYgZHVtcChzZWxmLCBmb3V0KToNCiAgICAgICAgZm91
dC53cml0ZSgnaWMgPSAlZDogJyAlIChzZWxmLmlycV9jb250ZXh0LCkpDQogICAgICAgIGZvciBj
IGluIHNlbGYuY2xhc3NlczoNCiAgICAgICAgICAgIGZvdXQud3JpdGUoJyVzLCcgJSAoYy5uYW1l
LCkpDQogICAgICAgIGZvdXQud3JpdGUoJ1xuJykNCg0KY2xhc3MgbGNoX3RyZWVfbm9kZShvYmpl
Y3QpOg0KICAgIG5leHRfaWQgPSAwDQoNCiAgICBkZWYgX19pbml0X18oc2VsZiwgbGMpOg0KICAg
ICAgICBvYmplY3QuX19pbml0X18oc2VsZikNCiAgICAgICAgc2VsZi5jbHMgPSBsYw0KICAgICAg
ICBzZWxmLmNoaWxkcmVuID0ge30NCiAgICAgICAgc2VsZi5pZCA9IGxjaF90cmVlX25vZGUubmV4
dF9pZA0KICAgICAgICBsY2hfdHJlZV9ub2RlLm5leHRfaWQgPSBsY2hfdHJlZV9ub2RlLm5leHRf
aWQgKyAxDQoNCmNsYXNzIGxvY2tfY2hhaW5zKG9iamVjdCk6DQogICAgcmVfbGNoX2hlYWQgPSBy
ZS5jb21waWxlKHInXmlycV9jb250ZXh0OiAoXGQpJCcpDQogICAgcmVfbGNoX2NsYXNzID0gcmUu
Y29tcGlsZShyJ1xbKFthLWYwLTldKylcXVxzKihcUyspXHMqJCcpDQoNCiAgICBkZWYgX19pbml0
X18oc2VsZiwgbG9ja2RlcCk6DQogICAgICAgIG9iamVjdC5fX2luaXRfXyhzZWxmKQ0KICAgICAg
ICBzZWxmLmxvY2tkZXAgPSBsb2NrZGVwDQogICAgICAgIHNlbGYuY2hhaW5zID0gW10NCiAgICAg
ICAgc2VsZi5sY2hfdHJlZXMgPSBsY2hfdHJlZV9ub2RlKE5vbmUpDQogICAgZGVmIHBhcnNlKHNl
bGYsIGYpOg0KICAgICAgICBpYyA9IDANCiAgICAgICAgbGNzID0gW10NCiAgICAgICAgZm9yIGwg
aW4gZjoNCiAgICAgICAgICAgIG1jID0gbG9ja19jaGFpbnMucmVfbGNoX2NsYXNzLm1hdGNoKGwp
DQogICAgICAgICAgICBpZiBtYzoNCiAgICAgICAgICAgICAgICBsY3MuYXBwZW5kKG1jLmdyb3Vw
KDEpKQ0KICAgICAgICAgICAgbWggPSBsb2NrX2NoYWlucy5yZV9sY2hfaGVhZC5tYXRjaChsKQ0K
ICAgICAgICAgICAgaWYgbWg6DQogICAgICAgICAgICAgICAgaWMgPSBpbnQobWguZ3JvdXAoMSkp
DQogICAgICAgICAgICAgICAgaWYgbGVuKGxjcykgIT0gMDoNCiAgICAgICAgICAgICAgICAgICAg
bGNoID0gbG9ja19jaGFpbihpYywgbGNzKQ0KICAgICAgICAgICAgICAgICAgICBzZWxmLmNoYWlu
cy5hcHBlbmQobGNoKQ0KICAgICAgICAgICAgICAgICAgICBsY3MgPSBbXQ0KICAgICAgICBsY19t
YXAgPSBzZWxmLmxvY2tkZXAubG9ja19jbGFzc2VzDQogICAgICAgIGZvciBjaCBpbiBzZWxmLmNo
YWluczoNCiAgICAgICAgICAgIGNoLnJlc29sdmVfY2xhc3MobGNfbWFwKQ0KICAgICAgICBzZWxm
LmJ1aWxkX3RyZWUoKQ0KICAgIGRlZiBidWlsZF90cmVlKHNlbGYpOg0KICAgICAgICB0cmVlcyA9
IHNlbGYubGNoX3RyZWVzDQogICAgICAgIGZvciBjaCBpbiBzZWxmLmNoYWluczoNCiAgICAgICAg
ICAgIGNoLmFkZF90b190cmVlKHRyZWVzKQ0KICAgIGRlZiBkdW1wKHNlbGYsIGZvdXQpOg0KICAg
ICAgICBmb3IgY2ggaW4gc2VsZi5jaGFpbnM6DQogICAgICAgICAgICBjaC5kdW1wKGZvdXQpDQog
ICAgZGVmIGR1bXBfdHJlZV9kb3Qoc2VsZiwgZm91dCwgcm9vdCk6DQogICAgICAgIGZvdXQud3Jp
dGUoJycnZGlncmFwaCBMb2NrZGVwIHsNCnJhbmtkaXIgPSBMUiA7DQpub2RlIFsgc2hhcGUgPSBy
ZWNvcmQsIGZvbnRuYW1lID0gQ291cmllciBdIDsNCicnJykNCiAgICAgICAgZGVmIGRvX2R1bXAo
bm9kZSwgcGFyZW50KToNCiAgICAgICAgICAgIGxjID0gbm9kZS5jbHMNCiAgICAgICAgICAgIGZv
dXQud3JpdGUoJyVkIFsgbGFiZWwgPSAiJXMiIF0gO1xuJyAlDQogICAgICAgICAgICAgICAgICAg
ICAgIChub2RlLmlkLCBkb3RfbGFiZWwobGMubmFtZSkpKQ0KICAgICAgICAgICAgaWYgcGFyZW50
Og0KICAgICAgICAgICAgICAgIGZvdXQud3JpdGUoJyIlZCIgLT4gIiVkIiA7XG4nICUgKHBhcmVu
dC5pZCwgbm9kZS5pZCkpDQogICAgICAgICAgICBjaGlsZHJlbiA9IHNvcnRlZChub2RlLmNoaWxk
cmVuLnZhbHVlcygpLCBOb25lLA0KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgbGFtYmRh
IG46IG4uY2xzLm5hbWUpDQogICAgICAgICAgICBmb3IgY2hpbGQgaW4gY2hpbGRyZW46DQogICAg
ICAgICAgICAgICAgZG9fZHVtcChjaGlsZCwgbm9kZSkNCiAgICAgICAgZG9fZHVtcChyb290LCBO
b25lKQ0KICAgICAgICBmb3V0LndyaXRlKCd9XG4nKQ0KICAgIGRlZiBkdW1wX3RyZWVzX2RvdChz
ZWxmLCBwcmVmaXgpOg0KICAgICAgICBuID0gMA0KICAgICAgICBmb3IgbGNoX3Jvb3QgaW4gc2Vs
Zi5sY2hfdHJlZXMuY2hpbGRyZW4udmFsdWVzKCk6DQogICAgICAgICAgICBmb3V0ID0gZmlsZSgn
JXMtJWQuZG90JyAlIChwcmVmaXgsIG4pLCAndycpDQogICAgICAgICAgICBuID0gbiArIDENCiAg
ICAgICAgICAgIHNlbGYuZHVtcF90cmVlX2RvdChmb3V0LCBsY2hfcm9vdCkNCg0KZGVmIHRlc3Qo
ZmluKToNCiAgICBsZCA9IGxvY2tkZXAoKQ0KICAgIGxkLnBhcnNlKGZpbikNCiAgICBsZC5kdW1w
X2RvdHMoJ291dC9sb2NrZGVwJykNCg0KZGVmIHRlc3QyKGZpbik6DQogICAgbGQgPSBsb2NrZGVw
KCkNCiAgICBsZC5wYXJzZShmaW4pDQogICAgbGMgPSBsZC5sb2NrX2NsYXNzZXNbJ2ZmZmY4MTAw
MDEwOGVhZTAnXQ0KICAgIGxkLmR1bXBfZG90KGZpbGUoJ291dC9hLmRvdCcsICd3JyksIGxjKQ0K
DQpkZWYgdGVzdDMoZmluLCBmb3V0KToNCiAgICBsZCA9IGxvY2tkZXAoKQ0KICAgIGxkLnBhcnNl
KGZpbikNCiAgICBsZC5kdW1wX2NoYWlucyhmb3V0KQ0KDQpkZWYgdGVzdDQoKToNCiAgICBsZCA9
IGxvY2tkZXAoKQ0KICAgIGxkLnBhcnNlKGZpbGUoJ2xvY2tkZXAnKSkNCiAgICBsY2hzID0gbG9j
a19jaGFpbnMobGQpDQogICAgbGNocy5wYXJzZShmaWxlKCdsb2NrZGVwX2NoYWlucycpKQ0KICAg
ICNsY2hzLmR1bXAoc3lzLnN0ZG91dCkNCiAgICBsY2hzLmR1bXBfdHJlZXNfZG90KCdvdXQvbGNo
JykNCg0KDQppZiBfX25hbWVfXyA9PSAnX19tYWluX18nOg0KICAgIHRlc3Q0KCkNCm==


--=-V2jOMWieqdC2gfZ5KFTi--
