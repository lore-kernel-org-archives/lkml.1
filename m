Return-Path: <linux-kernel-owner+w=401wt.eu-S1760397AbZJMPoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760397AbZJMPoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 11:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760330AbZJMPoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 11:44:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760290AbZJMPoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 11:44:21 -0400
Date: Tue, 13 Oct 2009 17:43:44 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: iceberg <strakh@ispras.ru>, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Dmitry Torokhov <dtor@mail.ru>,
       Linux Kernlel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [BUG] ati_remote2.c: possible mutex_lock without mutex_unlock
In-Reply-To: <1255456327.22233.0@pamir>
Message-ID: <alpine.LSU.2.00.0910131736571.8582@wotan.suse.de>
References: <1255456327.22233.0@pamir>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009, iceberg wrote:

> 	In driver ./drivers/input/input.c possible call to mutex_lock from 
> function input_devices_seq_start without mutex_unlock.
> 
> 	After calling input_devices_seq_start we can't know whether 
> mutex was locked or not. 

> Case 1. If mutex_lock_interruptible was not locked due to interrupt then 
> input_devices_seq_start returns NULL.
> Case 2. If mutex was successfuly locked but seq_list_start returned NULL 
> then input_devices_seq_start returns NULL too. The last case occurs if 
> seq_list_start is called with pos>size of input_dev_list or pos<0.
> Hence, after calling input_devices_seq_start we can not simply check 
> that result is not NULL and call input_devices_seq_stop function 
> which unlocks the mutex. Because in case 2 the mutex will stay locked.
> void * ret = input_devices_seq_start(...);
> if(ret!=NULL) {
> 	//mutex is acquired for sure
> 	input_devices_seq_stop(...);//unlocks the mutex
> } else {
> 	//mutex may be acquired or not
> }

Plus, we should return EAGAIN rather than failing silently when 
input_handlers_seq_start() has been interrupted by signal, right?

Dmitry, how about the fix below?



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] Input: make input_handlers_seq_start() signal safe

input_devices_seq_start() uses mutex_lock_interruptible() to acquire the 
input_mutex, but doesn't properly handle the situation if 
mutex_lock_interruptible() really gets interrupted. In such scenario, 
input_handlers_seq_start() returns NULL, which ambiguous, as 
seq_list_start() could return NULL as well. This could lead to the 
situation in which input_handlers_seq_stop() will try to unlock mutex that 
hasn't been locked.

Plus, in such situations, the code fails silently, rather than returning 
EAGAIN.

Reported-by: iceberg <strakh@ispras.ru>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
--- 
 drivers/input/input.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index c6f88eb..ef4d5c1 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -882,7 +882,7 @@ static const struct file_operations input_devices_fileops = {
 static void *input_handlers_seq_start(struct seq_file *seq, loff_t *pos)
 {
 	if (mutex_lock_interruptible(&input_mutex))
-		return NULL;
+		return ERR_PTR(-EAGAIN);
 
 	seq->private = (void *)(unsigned long)*pos;
 	return seq_list_start(&input_handler_list, *pos);
@@ -896,6 +896,10 @@ static void *input_handlers_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 
 static void input_handlers_seq_stop(struct seq_file *seq, void *v)
 {
+	/* seq_start could get interrupted by signal before acquiring mutex */
+	if (IS_ERR(v) && ERR_PTR(v) == -EAGAIN)
+		return;
+
 	mutex_unlock(&input_mutex);
 }
 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
