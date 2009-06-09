Return-Path: <linux-kernel-owner+w=401wt.eu-S1760224AbZFIKVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224AbZFIKVZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760538AbZFIKSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:18:35 -0400
Received: from kroah.org ([198.145.64.141]:54571 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760568AbZFIKSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:18:33 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:57 2009
Message-Id: <20090609094057.155281670@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 22/87] futex: setup writeable mapping for futex ops which modify user space data
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=futex-setup-writeable-mapping-for-futex-ops-which-modify-user-space-data.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit 64d1304a64477629cb16b75491a77bafe6f86963 upstream.

The futex code installs a read only mapping via get_user_pages_fast()
even if the futex op function has to modify user space data. The
eventual fault was fixed up by futex_handle_fault() which walked the
VMA with mmap_sem held.

After the cleanup patches which removed the mmap_sem dependency of the
futex code commit 4dc5b7a36a49eff97050894cf1b3a9a02523717 (futex:
clean up fault logic) removed the private VMA walk logic from the
futex code. This change results in a stale RO mapping which is not
fixed up.

Instead of reintroducing the previous fault logic we set up the
mapping in get_user_pages_fast() read/write for all operations which
modify user space data. Also handle private futexes in the same way
and make the current unconditional access_ok(VERIFY_WRITE) depend on
the futex op.

Reported-by: Andreas Schwab <schwab@linux-m68k.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/futex.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -192,6 +192,7 @@ static void drop_futex_key_refs(union fu
  * @shared: NULL for a PROCESS_PRIVATE futex,
  *	&current->mm->mmap_sem for a PROCESS_SHARED futex
  * @key: address where result is stored.
+ * @rw: mapping needs to be read/write (values: VERIFY_READ, VERIFY_WRITE)
  *
  * Returns a negative error code or 0
  * The key words are stored in *key on success.
@@ -204,7 +205,8 @@ static void drop_futex_key_refs(union fu
  * For other futexes, it points to &current->mm->mmap_sem and
  * caller must have taken the reader lock. but NOT any spinlocks.
  */
-static int get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
+static int
+get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
@@ -227,7 +229,7 @@ static int get_futex_key(u32 __user *uad
 	 *        but access_ok() should be faster than find_vma()
 	 */
 	if (!fshared) {
-		if (unlikely(!access_ok(VERIFY_WRITE, uaddr, sizeof(u32))))
+		if (unlikely(!access_ok(rw, uaddr, sizeof(u32))))
 			return -EFAULT;
 		key->private.mm = mm;
 		key->private.address = address;
@@ -236,7 +238,7 @@ static int get_futex_key(u32 __user *uad
 	}
 
 again:
-	err = get_user_pages_fast(address, 1, 0, &page);
+	err = get_user_pages_fast(address, 1, rw == VERIFY_WRITE, &page);
 	if (err < 0)
 		return err;
 
@@ -707,7 +709,7 @@ static int futex_wake(u32 __user *uaddr,
 	if (!bitset)
 		return -EINVAL;
 
-	ret = get_futex_key(uaddr, fshared, &key);
+	ret = get_futex_key(uaddr, fshared, &key, VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -753,10 +755,10 @@ futex_wake_op(u32 __user *uaddr1, int fs
 	int ret, op_ret, attempt = 0;
 
 retryfull:
-	ret = get_futex_key(uaddr1, fshared, &key1);
+	ret = get_futex_key(uaddr1, fshared, &key1, VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, fshared, &key2);
+	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out_put_key1;
 
@@ -859,10 +861,10 @@ static int futex_requeue(u32 __user *uad
 	int ret, drop_count = 0;
 
 retry:
-	ret = get_futex_key(uaddr1, fshared, &key1);
+	ret = get_futex_key(uaddr1, fshared, &key1, VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out;
-	ret = get_futex_key(uaddr2, fshared, &key2);
+	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out_put_key1;
 
@@ -1181,7 +1183,7 @@ static int futex_wait(u32 __user *uaddr,
 	q.bitset = bitset;
 retry:
 	q.key = FUTEX_KEY_INIT;
-	ret = get_futex_key(uaddr, fshared, &q.key);
+	ret = get_futex_key(uaddr, fshared, &q.key, VERIFY_READ);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1370,7 +1372,7 @@ static int futex_lock_pi(u32 __user *uad
 	q.pi_state = NULL;
 retry:
 	q.key = FUTEX_KEY_INIT;
-	ret = get_futex_key(uaddr, fshared, &q.key);
+	ret = get_futex_key(uaddr, fshared, &q.key, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out;
 
@@ -1630,7 +1632,7 @@ retry:
 	if ((uval & FUTEX_TID_MASK) != task_pid_vnr(current))
 		return -EPERM;
 
-	ret = get_futex_key(uaddr, fshared, &key);
+	ret = get_futex_key(uaddr, fshared, &key, VERIFY_WRITE);
 	if (unlikely(ret != 0))
 		goto out;
 


