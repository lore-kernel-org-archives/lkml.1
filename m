Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887Ab0AEAoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab0AEAoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420Ab0AEAoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:44:17 -0500
Received: from kroah.org ([198.145.64.141]:34462 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398Ab0AEAfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:45 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 63/97] x86/ptrace: make genregs[32]_get/set more robust
Date: Mon,  4 Jan 2010 16:33:16 -0800
Message-Id: <1262651630-7354-63-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 7b058a2..c06acdd 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -408,14 +408,14 @@ static int genregs_get(struct task_struct *target,
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
@@ -434,14 +434,14 @@ static int genregs_set(struct task_struct *target,
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
@@ -1219,14 +1219,14 @@ static int genregs32_get(struct task_struct *target,
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
@@ -1247,14 +1247,14 @@ static int genregs32_set(struct task_struct *target,
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
-- 
1.6.6

