Return-Path: <linux-kernel-owner+w=401wt.eu-S934145AbYETVUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934145AbYETVUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761536AbYETVUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:20:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39041 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759997AbYETVUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:20:21 -0400
Date: Tue, 20 May 2008 17:20:18 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Remy Bohmer <linux@bohmer.net>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Subject: Re: Compile warning rtmutex code on 2.6.24.7-rt8 (CC:LKML added)
In-Reply-To: <3efb10970805201356x4552859bof5f3f4f56f2ba676@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0805201718530.21440@gandalf.stny.rr.com>
References: <3efb10970805201356x4552859bof5f3f4f56f2ba676@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 May 2008, Remy Bohmer wrote:

> Hello Steven,
>
>  Do you recognise these warnings? I do not know (yet) if these are ARM
>  specific...
>
>   CC      kernel/rtmutex.o
>  kernel/rtmutex.c: In function 'rt_write_fastlock':
>  kernel/rtmutex.c:1582: warning: initialization makes pointer from
>  integer without a cast
>  kernel/rtmutex.c: In function 'rt_write_fasttrylock':
>  kernel/rtmutex.c:1622: warning: initialization makes pointer from
>  integer without a cast
>
>  If so, do you have a fix for it?

Remy,

Can you see if this helps,

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

---
 kernel/rtmutex.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.24.7-rt9/kernel/rtmutex.c
===================================================================
--- linux-2.6.24.7-rt9.orig/kernel/rtmutex.c	2008-05-20 17:11:29.000000000 -0400
+++ linux-2.6.24.7-rt9/kernel/rtmutex.c	2008-05-20 17:13:18.000000000 -0400
@@ -1577,7 +1577,7 @@ rt_write_fastlock(struct rw_mutex *rwm,
 		  void fastcall (*slowfn)(struct rw_mutex *rwm, int mtx),
 		  int mtx)
 {
-	unsigned long val = (unsigned long)current | RT_RWLOCK_WRITER;
+	struct task_struct *val = (void *)((unsigned long)current | RT_RWLOCK_WRITER);

 	if (likely(rt_rwlock_cmpxchg(rwm, NULL, val)))
 		rt_mutex_deadlock_account_lock(&rwm->mutex, current);
@@ -1617,7 +1617,7 @@ static inline int
 rt_write_fasttrylock(struct rw_mutex *rwm,
 		     int fastcall (*slowfn)(struct rw_mutex *rwm, int mtx), int mtx)
 {
-	unsigned long val = (unsigned long)current | RT_RWLOCK_WRITER;
+	struct task_struct *val = (void *)((unsigned long)current | RT_RWLOCK_WRITER);

 	if (likely(rt_rwlock_cmpxchg(rwm, NULL, val))) {
 		rt_mutex_deadlock_account_lock(&rwm->mutex, current);
@@ -1902,7 +1902,7 @@ rt_write_fastunlock(struct rw_mutex *rwm
 					    int mtx),
 		    int mtx)
 {
-	unsigned long val = (unsigned long)current | RT_RWLOCK_WRITER;
+	struct task_struct *val = (void *)((unsigned long)current | RT_RWLOCK_WRITER);

 	WARN_ON(rt_rwlock_owner(rwm) != current);
 	if (likely(rt_rwlock_cmpxchg(rwm, (struct task_struct *)val, NULL)))
