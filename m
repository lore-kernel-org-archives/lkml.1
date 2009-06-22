Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbZFVHIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbZFVHIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 03:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbZFVHHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 03:07:54 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64223 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751002AbZFVHHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 03:07:53 -0400
Message-ID: <4A3F2E38.7030604@cn.fujitsu.com>
Date: Mon, 22 Jun 2009 15:09:44 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: rewrite trace_save_cmdline()
Content-Type: multipart/mixed;
 boundary="------------040500020506080906020804"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040500020506080906020804
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The attachment for this mail is a optimized patch when
SAVED_CMDLINE_COLLISION_WINDOW = 1. It has the best probe time(zero),
but it has a worst replacement-when-collision behavior.

I'm not surprise if you guys like the one in attachment:
It's not the end of the world if we do a bad replacement sometimes.

-------------------

Subject: [PATCH] tracing: rewrite trace_save_cmdline()

I found the sparse array map_pid_to_cmdline[PID_MAX_DEFAULT+1]
wastes too much memory, so I remove it.

The old FIFO algorithm is replaced with a new one:
Open address hash table with double hash + tick-LRU.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 076fa6f..a0b163f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -36,6 +36,7 @@
 #include <linux/poll.h>
 #include <linux/gfp.h>
 #include <linux/fs.h>
+#include <linux/hash.h>
 
 #include "trace.h"
 #include "trace_output.h"
@@ -649,24 +650,19 @@ void tracing_reset_current_online_cpus(void)
 	tracing_reset_online_cpus(&global_trace);
 }
 
-#define SAVED_CMDLINES 128
-#define NO_CMDLINE_MAP UINT_MAX
-static unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
+#define SAVED_CMDLINE_SHIFT		8
+#define SAVED_CMDLINE_COLLISION_WINDOW	4 /* 4 is enough! */
+#define SAVED_CMDLINES			(1 << SAVED_CMDLINE_SHIFT)
+#define SAVED_CMDLINE_IDX(hash)		((hash) & (SAVED_CMDLINES - 1))
+static unsigned map_cmdline_to_tick[SAVED_CMDLINES];
 static unsigned map_cmdline_to_pid[SAVED_CMDLINES];
 static char saved_cmdlines[SAVED_CMDLINES][TASK_COMM_LEN];
-static int cmdline_idx;
+static u32 cmdlines_tick;
 static raw_spinlock_t trace_cmdline_lock = __RAW_SPIN_LOCK_UNLOCKED;
 
 /* temporary disable recording */
 static atomic_t trace_record_cmdline_disabled __read_mostly;
 
-static void trace_init_cmdlines(void)
-{
-	memset(&map_pid_to_cmdline, NO_CMDLINE_MAP, sizeof(map_pid_to_cmdline));
-	memset(&map_cmdline_to_pid, NO_CMDLINE_MAP, sizeof(map_cmdline_to_pid));
-	cmdline_idx = 0;
-}
-
 static int trace_stop_count;
 static DEFINE_SPINLOCK(tracing_start_lock);
 
@@ -753,13 +749,28 @@ void tracing_stop(void)
 
 void trace_stop_cmdline_recording(void);
 
+/* Is @x in the range [@a, @b] */
+static inline int in_range(u32 a, u32 b, u32 x)
+{
+	/*
+	 * let dist1 = x - a, dist2 = b - x, then
+	 * @x in the range [@a, @b] iff (dist1 + dist2) is not overflow
+	 * (dist1 + dist2) is not overflow iff dist1 <= ~dist2
+	 */
+	return (x - a) <= ~(b - x);
+}
+
 static void trace_save_cmdline(struct task_struct *tsk)
 {
-	unsigned pid, idx;
+	unsigned int hash, hash2, idx, map, i;
+	u32 tick, min_tick;
 
-	if (!tsk->pid || unlikely(tsk->pid > PID_MAX_DEFAULT))
+	if (!tsk->pid)
 		return;
 
+	hash = map = hash_32((u32)tsk->pid, SAVED_CMDLINE_SHIFT);
+	hash2 = (tsk->pid << 1) | 1; /* odd */
+
 	/*
 	 * It's not the end of the world if we don't get
 	 * the lock, but we also don't want to spin
@@ -769,52 +780,73 @@ static void trace_save_cmdline(struct task_struct *tsk)
 	if (!__raw_spin_trylock(&trace_cmdline_lock))
 		return;
 
-	idx = map_pid_to_cmdline[tsk->pid];
-	if (idx == NO_CMDLINE_MAP) {
-		idx = (cmdline_idx + 1) % SAVED_CMDLINES;
+	min_tick = map_cmdline_to_tick[map];
 
-		/*
-		 * Check whether the cmdline buffer at idx has a pid
-		 * mapped. We are going to overwrite that entry so we
-		 * need to clear the map_pid_to_cmdline. Otherwise we
-		 * would read the new comm for the old pid.
-		 */
-		pid = map_cmdline_to_pid[idx];
-		if (pid != NO_CMDLINE_MAP)
-			map_pid_to_cmdline[pid] = NO_CMDLINE_MAP;
+	/* apply tick-LRU algorithm on collision window */
+	for (i = 0; i < SAVED_CMDLINE_COLLISION_WINDOW; i++) {
+		idx = SAVED_CMDLINE_IDX(hash);
+
+		/* Is map_cmdline_to_pid[idx] unused? */
+		if (!map_cmdline_to_pid[idx]) {
+			map = idx;
+			break;
+		}
 
-		map_cmdline_to_pid[idx] = tsk->pid;
-		map_pid_to_cmdline[tsk->pid] = idx;
+		/* Has tsk->pid been saved at map_cmdline_to_pid[idx]? */
+		if (map_cmdline_to_pid[idx] == tsk->pid) {
+			map = idx;
+			break;
+		}
 
-		cmdline_idx = idx;
+		/* Is @tick less than @min_tick? */
+		tick = map_cmdline_to_tick[idx];
+		if (!in_range(min_tick, cmdlines_tick, tick)) {
+			min_tick = tick;
+			map = idx;
+		}
+
+		hash += hash2;
 	}
 
-	memcpy(&saved_cmdlines[idx], tsk->comm, TASK_COMM_LEN);
+	cmdlines_tick++;
+	map_cmdline_to_tick[map] = cmdlines_tick;
+	map_cmdline_to_pid[map] = tsk->pid;
+	memcpy(saved_cmdlines[map], tsk->comm, TASK_COMM_LEN);
 
 	__raw_spin_unlock(&trace_cmdline_lock);
 }
 
 void trace_find_cmdline(int pid, char comm[])
 {
-	unsigned map;
+	unsigned int hash, hash2, i, map;
+	const char *saved_comm = "<...>";
 
 	if (!pid) {
 		strcpy(comm, "<idle>");
 		return;
 	}
 
-	if (pid > PID_MAX_DEFAULT) {
-		strcpy(comm, "<...>");
-		return;
-	}
+	hash = hash_32((u32)pid, SAVED_CMDLINE_SHIFT);
+	hash2 = (pid << 1) | 1; /* odd */
 
 	preempt_disable();
 	__raw_spin_lock(&trace_cmdline_lock);
-	map = map_pid_to_cmdline[pid];
-	if (map != NO_CMDLINE_MAP)
-		strcpy(comm, saved_cmdlines[map]);
-	else
-		strcpy(comm, "<...>");
+
+	for (i = 0; i < SAVED_CMDLINE_COLLISION_WINDOW; i++) {
+		map = SAVED_CMDLINE_IDX(hash);
+
+		if (!map_cmdline_to_pid[map])
+			break;
+
+		if (map_cmdline_to_pid[map] == pid) {
+			saved_comm = saved_cmdlines[map];
+			break;
+		}
+
+		hash += hash2;
+	}
+
+	strcpy(comm, saved_comm);
 
 	__raw_spin_unlock(&trace_cmdline_lock);
 	preempt_enable();
@@ -2470,7 +2502,7 @@ tracing_saved_cmdlines_read(struct file *file, char __user *ubuf,
 		int r;
 
 		pid = map_cmdline_to_pid[i];
-		if (pid == -1 || pid == NO_CMDLINE_MAP)
+		if (!pid)
 			continue;
 
 		trace_find_cmdline(pid, buf_comm);
@@ -4332,8 +4364,6 @@ __init static int tracer_alloc_buffers(void)
 		max_tr.data[i] = &per_cpu(max_data, i);
 	}
 
-	trace_init_cmdlines();
-
 	register_tracer(&nop_trace);
 	current_trace = &nop_trace;
 #ifdef CONFIG_BOOT_TRACER


--------------040500020506080906020804
Content-Type: text/plain;
 name="hash_comm.diff"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="hash_comm.diff"

ZGlmZiAtLWdpdCBhL2tlcm5lbC90cmFjZS90cmFjZS5jIGIva2VybmVsL3RyYWNlL3RyYWNl
LmMKaW5kZXggMDc2ZmE2Zi4uZDU4M2JhNSAxMDA2NDQKLS0tIGEva2VybmVsL3RyYWNlL3Ry
YWNlLmMKKysrIGIva2VybmVsL3RyYWNlL3RyYWNlLmMKQEAgLTM2LDYgKzM2LDcgQEAKICNp
bmNsdWRlIDxsaW51eC9wb2xsLmg+CiAjaW5jbHVkZSA8bGludXgvZ2ZwLmg+CiAjaW5jbHVk
ZSA8bGludXgvZnMuaD4KKyNpbmNsdWRlIDxsaW51eC9oYXNoLmg+CiAKICNpbmNsdWRlICJ0
cmFjZS5oIgogI2luY2x1ZGUgInRyYWNlX291dHB1dC5oIgpAQCAtNjQ5LDI0ICs2NTAsMTUg
QEAgdm9pZCB0cmFjaW5nX3Jlc2V0X2N1cnJlbnRfb25saW5lX2NwdXModm9pZCkKIAl0cmFj
aW5nX3Jlc2V0X29ubGluZV9jcHVzKCZnbG9iYWxfdHJhY2UpOwogfQogCi0jZGVmaW5lIFNB
VkVEX0NNRExJTkVTIDEyOAotI2RlZmluZSBOT19DTURMSU5FX01BUCBVSU5UX01BWAotc3Rh
dGljIHVuc2lnbmVkIG1hcF9waWRfdG9fY21kbGluZVtQSURfTUFYX0RFRkFVTFQrMV07Cisj
ZGVmaW5lIFNBVkVEX0NNRExJTkVfU0hJRlQJOAorI2RlZmluZSBTQVZFRF9DTURMSU5FUwkJ
KDEgPDwgU0FWRURfQ01ETElORV9TSElGVCkKIHN0YXRpYyB1bnNpZ25lZCBtYXBfY21kbGlu
ZV90b19waWRbU0FWRURfQ01ETElORVNdOwogc3RhdGljIGNoYXIgc2F2ZWRfY21kbGluZXNb
U0FWRURfQ01ETElORVNdW1RBU0tfQ09NTV9MRU5dOwotc3RhdGljIGludCBjbWRsaW5lX2lk
eDsKIHN0YXRpYyByYXdfc3BpbmxvY2tfdCB0cmFjZV9jbWRsaW5lX2xvY2sgPSBfX1JBV19T
UElOX0xPQ0tfVU5MT0NLRUQ7CiAKIC8qIHRlbXBvcmFyeSBkaXNhYmxlIHJlY29yZGluZyAq
Lwogc3RhdGljIGF0b21pY190IHRyYWNlX3JlY29yZF9jbWRsaW5lX2Rpc2FibGVkIF9fcmVh
ZF9tb3N0bHk7CiAKLXN0YXRpYyB2b2lkIHRyYWNlX2luaXRfY21kbGluZXModm9pZCkKLXsK
LQltZW1zZXQoJm1hcF9waWRfdG9fY21kbGluZSwgTk9fQ01ETElORV9NQVAsIHNpemVvZiht
YXBfcGlkX3RvX2NtZGxpbmUpKTsKLQltZW1zZXQoJm1hcF9jbWRsaW5lX3RvX3BpZCwgTk9f
Q01ETElORV9NQVAsIHNpemVvZihtYXBfY21kbGluZV90b19waWQpKTsKLQljbWRsaW5lX2lk
eCA9IDA7Ci19Ci0KIHN0YXRpYyBpbnQgdHJhY2Vfc3RvcF9jb3VudDsKIHN0YXRpYyBERUZJ
TkVfU1BJTkxPQ0sodHJhY2luZ19zdGFydF9sb2NrKTsKIApAQCAtNzU1LDExICs3NDcsMTMg
QEAgdm9pZCB0cmFjZV9zdG9wX2NtZGxpbmVfcmVjb3JkaW5nKHZvaWQpOwogCiBzdGF0aWMg
dm9pZCB0cmFjZV9zYXZlX2NtZGxpbmUoc3RydWN0IHRhc2tfc3RydWN0ICp0c2spCiB7Ci0J
dW5zaWduZWQgcGlkLCBpZHg7CisJdW5zaWduZWQgaWR4OwogCi0JaWYgKCF0c2stPnBpZCB8
fCB1bmxpa2VseSh0c2stPnBpZCA+IFBJRF9NQVhfREVGQVVMVCkpCisJaWYgKCF0c2stPnBp
ZCkKIAkJcmV0dXJuOwogCisJaWR4ID0gaGFzaF8zMigodTMyKXRzay0+cGlkLCBTQVZFRF9D
TURMSU5FX1NISUZUKTsKKwogCS8qCiAJICogSXQncyBub3QgdGhlIGVuZCBvZiB0aGUgd29y
bGQgaWYgd2UgZG9uJ3QgZ2V0CiAJICogdGhlIGxvY2ssIGJ1dCB3ZSBhbHNvIGRvbid0IHdh
bnQgdG8gc3BpbgpAQCAtNzY5LDI3ICs3NjMsOCBAQCBzdGF0aWMgdm9pZCB0cmFjZV9zYXZl
X2NtZGxpbmUoc3RydWN0IHRhc2tfc3RydWN0ICp0c2spCiAJaWYgKCFfX3Jhd19zcGluX3Ry
eWxvY2soJnRyYWNlX2NtZGxpbmVfbG9jaykpCiAJCXJldHVybjsKIAotCWlkeCA9IG1hcF9w
aWRfdG9fY21kbGluZVt0c2stPnBpZF07Ci0JaWYgKGlkeCA9PSBOT19DTURMSU5FX01BUCkg
ewotCQlpZHggPSAoY21kbGluZV9pZHggKyAxKSAlIFNBVkVEX0NNRExJTkVTOwotCi0JCS8q
Ci0JCSAqIENoZWNrIHdoZXRoZXIgdGhlIGNtZGxpbmUgYnVmZmVyIGF0IGlkeCBoYXMgYSBw
aWQKLQkJICogbWFwcGVkLiBXZSBhcmUgZ29pbmcgdG8gb3ZlcndyaXRlIHRoYXQgZW50cnkg
c28gd2UKLQkJICogbmVlZCB0byBjbGVhciB0aGUgbWFwX3BpZF90b19jbWRsaW5lLiBPdGhl
cndpc2Ugd2UKLQkJICogd291bGQgcmVhZCB0aGUgbmV3IGNvbW0gZm9yIHRoZSBvbGQgcGlk
LgotCQkgKi8KLQkJcGlkID0gbWFwX2NtZGxpbmVfdG9fcGlkW2lkeF07Ci0JCWlmIChwaWQg
IT0gTk9fQ01ETElORV9NQVApCi0JCQltYXBfcGlkX3RvX2NtZGxpbmVbcGlkXSA9IE5PX0NN
RExJTkVfTUFQOwotCi0JCW1hcF9jbWRsaW5lX3RvX3BpZFtpZHhdID0gdHNrLT5waWQ7Ci0J
CW1hcF9waWRfdG9fY21kbGluZVt0c2stPnBpZF0gPSBpZHg7Ci0KLQkJY21kbGluZV9pZHgg
PSBpZHg7Ci0JfQotCi0JbWVtY3B5KCZzYXZlZF9jbWRsaW5lc1tpZHhdLCB0c2stPmNvbW0s
IFRBU0tfQ09NTV9MRU4pOworCW1hcF9jbWRsaW5lX3RvX3BpZFtpZHhdID0gdHNrLT5waWQ7
CisJbWVtY3B5KHNhdmVkX2NtZGxpbmVzW2lkeF0sIHRzay0+Y29tbSwgVEFTS19DT01NX0xF
Tik7CiAKIAlfX3Jhd19zcGluX3VubG9jaygmdHJhY2VfY21kbGluZV9sb2NrKTsKIH0KQEAg
LTgwMywxNSArNzc4LDE3IEBAIHZvaWQgdHJhY2VfZmluZF9jbWRsaW5lKGludCBwaWQsIGNo
YXIgY29tbVtdKQogCQlyZXR1cm47CiAJfQogCi0JaWYgKHBpZCA+IFBJRF9NQVhfREVGQVVM
VCkgeworCW1hcCA9IGhhc2hfMzIoKHUzMilwaWQsIFNBVkVEX0NNRExJTkVfU0hJRlQpOwor
CisJaWYgKG1hcF9jbWRsaW5lX3RvX3BpZFttYXBdICE9IHBpZCkgewogCQlzdHJjcHkoY29t
bSwgIjwuLi4+Iik7CiAJCXJldHVybjsKIAl9CiAKIAlwcmVlbXB0X2Rpc2FibGUoKTsKIAlf
X3Jhd19zcGluX2xvY2soJnRyYWNlX2NtZGxpbmVfbG9jayk7Ci0JbWFwID0gbWFwX3BpZF90
b19jbWRsaW5lW3BpZF07Ci0JaWYgKG1hcCAhPSBOT19DTURMSU5FX01BUCkKKworCWlmICht
YXBfY21kbGluZV90b19waWRbbWFwXSA9PSBwaWQpCiAJCXN0cmNweShjb21tLCBzYXZlZF9j
bWRsaW5lc1ttYXBdKTsKIAllbHNlCiAJCXN0cmNweShjb21tLCAiPC4uLj4iKTsKQEAgLTI0
NzAsNyArMjQ0Nyw3IEBAIHRyYWNpbmdfc2F2ZWRfY21kbGluZXNfcmVhZChzdHJ1Y3QgZmls
ZSAqZmlsZSwgY2hhciBfX3VzZXIgKnVidWYsCiAJCWludCByOwogCiAJCXBpZCA9IG1hcF9j
bWRsaW5lX3RvX3BpZFtpXTsKLQkJaWYgKHBpZCA9PSAtMSB8fCBwaWQgPT0gTk9fQ01ETElO
RV9NQVApCisJCWlmICghcGlkKQogCQkJY29udGludWU7CiAKIAkJdHJhY2VfZmluZF9jbWRs
aW5lKHBpZCwgYnVmX2NvbW0pOwpAQCAtNDMzMiw4ICs0MzA5LDYgQEAgX19pbml0IHN0YXRp
YyBpbnQgdHJhY2VyX2FsbG9jX2J1ZmZlcnModm9pZCkKIAkJbWF4X3RyLmRhdGFbaV0gPSAm
cGVyX2NwdShtYXhfZGF0YSwgaSk7CiAJfQogCi0JdHJhY2VfaW5pdF9jbWRsaW5lcygpOwot
CiAJcmVnaXN0ZXJfdHJhY2VyKCZub3BfdHJhY2UpOwogCWN1cnJlbnRfdHJhY2UgPSAmbm9w
X3RyYWNlOwogI2lmZGVmIENPTkZJR19CT09UX1RSQUNFUgo=
--------------040500020506080906020804--

