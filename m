Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbZLUBX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbZLUBX2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756212AbZLUBXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:23:13 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58868 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZLUBXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:23:07 -0500
Date: Mon, 21 Dec 2009 02:23:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, ebiederm@xmission.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] SYSCTL: Print binary sysctl warnings (nearly) only once
Message-ID: <20091221012305.GB5143@basil.fritz.box>
References: <20091219358.549678091@firstfloor.org> <20091219145832.A0424B158A@basil.firstfloor.org> <alpine.LFD.2.00.0912190929180.3712@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912190929180.3712@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 19, 2009 at 09:40:56AM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 19 Dec 2009, Andi Kleen wrote:
> > 
> > Turn all the bin_tables from const to non-const. This is needed for the next
> > patch. Unfortunately there were a lot of them, so the patch is rather 
> > large, but it is completely mechanic. 
> 
> Ouch. I hate this.
> 
> I'd much rather have a constant sysctl bin_table.
> 
> If the _only_ thing you want to do is to do a "warn-on-once" logic, I 
> would seriously suggest you use a small hash-table instead of turning 
> bin_table non-const.

I played around with this. The standard name hash couldn't be used
because this is a string of ints, not chars. I ended up using
FNV32 hash which seemed to do bests when hashing all the possible
binary sysctls.

Tested patch appended.

-Andi

---

SYSCTL: Print binary sysctl warnings (nearly) only once

When printing legacy sysctls print the warning message
for each of them only once.  This way there is a guarantee
the syslog won't be flooded for any sane program.

The original attempt at this made the tables non const and stored
the flag inline.

Linus suggested using a separate hash table for this, this is based on a 
code snippet from him.

The hash implies this is not exact and can sometimes not print a 
new sysctl due to a hash collision, but in practice this should not 
be a problem

I used a FNV32 hash over the binary string with a 32byte bitmap. This
gives relatively little collisions when all the predefined binary sysctls
are hashed:

size 256
bucket
length      number
0:          [25] 
1:          [67] 
2:          [88] 
ak@linux.intel.com -- Speaking for myself only.
3:          [47] 
4:          [22] 
5:          [6] 
6:          [1] 

The worst case is a single collision of 6 hash values.


Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/sysctl_binary.c |   31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

Index: linux-2.6.33-rc1-ak/kernel/sysctl_binary.c
===================================================================
--- linux-2.6.33-rc1-ak.orig/kernel/sysctl_binary.c
+++ linux-2.6.33-rc1-ak/kernel/sysctl_binary.c
@@ -1417,6 +1417,35 @@ static void deprecated_sysctl_warning(co
 	return;
 }
 
+#define WARN_ONCE_HASH_BITS 8
+#define WARN_ONCE_HASH_SIZE (1<<WARN_ONCE_HASH_BITS)
+
+static DECLARE_BITMAP(warn_once_bitmap, WARN_ONCE_HASH_SIZE);
+
+#define FNV32_OFFSET 2166136261U
+#define FNV32_PRIME 0x01000193
+
+/*
+ * Print each legacy sysctl (approximately) only once.
+ * To avoid making the tables non-const use a external
+ * hash-table instead.
+ * Worst case hash collision: 6, but very rarely.
+ * NOTE! We don't use the SMP-safe bit tests. We simply
+ * don't care enough.
+ */
+static void warn_on_bintable(const int *name, int nlen)
+{
+	int i;
+	u32 hash = FNV32_OFFSET;
+
+	for (i = 0; i < nlen; i++)
+		hash = (hash ^ name[i]) * FNV32_PRIME;
+	hash %= WARN_ONCE_HASH_SIZE;
+	if (__test_and_set_bit(hash, warn_once_bitmap))
+		return;
+	deprecated_sysctl_warning(name, nlen);
+}
+
 static ssize_t do_sysctl(int __user *args_name, int nlen,
 	void __user *oldval, size_t oldlen, void __user *newval, size_t newlen)
 {
@@ -1431,7 +1460,7 @@ static ssize_t do_sysctl(int __user *arg
 		if (get_user(name[i], args_name + i))
 			return -EFAULT;
 
-	deprecated_sysctl_warning(name, nlen);
+	warn_on_bintable(name, nlen);
 
 	return binary_sysctl(name, nlen, oldval, oldlen, newval, newlen);
 }
