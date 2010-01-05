Return-Path: <linux-kernel-owner+w=401wt.eu-S1755615Ab0AEUJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615Ab0AEUJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 15:09:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754764Ab0AEUJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 15:09:01 -0500
Received: from kroah.org ([198.145.64.141]:50047 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab0AEUGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 15:06:23 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan  5 12:03:02 2010
Message-Id: <20100105200302.748557705@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 05 Jan 2010 12:02:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, stable-review@kernel.org
Cc: Roland McGrath <roland@redhat.com>
Subject: [29/39] x86/ptrace: make genregs[32]_get/set more robust
In-Reply-To: <20100105195007.GA23952@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 04a1e62c2cec820501f93526ad1e46073b802dc4 upstream.

The loop condition is fragile: we compare an unsigned value to zero, and
then decrement it by something larger than one in the loop.  All the
callers should be passing in appropriately aligned buffer lengths, but
it's better to just not rely on it, and have some appropriate defensive
loop limits.

Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/ptrace.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -417,14 +417,14 @@ static int genregs_get(struct task_struc
 {
 	if (kbuf) {
 		unsigned long *k = kbuf;
-		while (count > 0) {
+		while (count >= sizeof(*k)) {
 			*k++ = getreg(target, pos);
 			count -= sizeof(*k);
 			pos += sizeof(*k);
 		}
 	} else {
 		unsigned long __user *u = ubuf;
-		while (count > 0) {
+		while (count >= sizeof(*u)) {
 			if (__put_user(getreg(target, pos), u++))
 				return -EFAULT;
 			count -= sizeof(*u);
@@ -443,14 +443,14 @@ static int genregs_set(struct task_struc
 	int ret = 0;
 	if (kbuf) {
 		const unsigned long *k = kbuf;
-		while (count > 0 && !ret) {
+		while (count >= sizeof(*k) && !ret) {
 			ret = putreg(target, pos, *k++);
 			count -= sizeof(*k);
 			pos += sizeof(*k);
 		}
 	} else {
 		const unsigned long  __user *u = ubuf;
-		while (count > 0 && !ret) {
+		while (count >= sizeof(*u) && !ret) {
 			unsigned long word;
 			ret = __get_user(word, u++);
 			if (ret)
@@ -1223,14 +1223,14 @@ static int genregs32_get(struct task_str
 {
 	if (kbuf) {
 		compat_ulong_t *k = kbuf;
-		while (count > 0) {
+		while (count >= sizeof(*k)) {
 			getreg32(target, pos, k++);
 			count -= sizeof(*k);
 			pos += sizeof(*k);
 		}
 	} else {
 		compat_ulong_t __user *u = ubuf;
-		while (count > 0) {
+		while (count >= sizeof(*u)) {
 			compat_ulong_t word;
 			getreg32(target, pos, &word);
 			if (__put_user(word, u++))
@@ -1251,14 +1251,14 @@ static int genregs32_set(struct task_str
 	int ret = 0;
 	if (kbuf) {
 		const compat_ulong_t *k = kbuf;
-		while (count > 0 && !ret) {
+		while (count >= sizeof(*k) && !ret) {
 			ret = putreg32(target, pos, *k++);
 			count -= sizeof(*k);
 			pos += sizeof(*k);
 		}
 	} else {
 		const compat_ulong_t __user *u = ubuf;
-		while (count > 0 && !ret) {
+		while (count >= sizeof(*u) && !ret) {
 			compat_ulong_t word;
 			ret = __get_user(word, u++);
 			if (ret)


