Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZJNGaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZJNGaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbZJNGaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:30:17 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:55488 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbZJNGaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:30:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jyeidjOd44MiHYlJIgEJqj/IJXtoo3axjbIf2BPCgy5B9DQW7191PC9bfCgA9rAdf8
         k7VJi1bBKPVcq6TDAAfXK19BCaBHsNvX/xzdT+wj+4sw3WXA1XSgurAR4rTJHV28QO53
         WKhtHxYmeTY9cWVj8w7ZEYWg5UlABIOy8TKD0=
Date: Tue, 13 Oct 2009 23:29:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: iceberg <strakh@ispras.ru>, Vojtech Pavlik <vojtech@suse.cz>,
       Linux Kernlel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [BUG] ati_remote2.c: possible mutex_lock without mutex_unlock
Message-ID: <20091014062902.GA2971@core.coreip.homeip.net>
References: <1255456327.22233.0@pamir> <alpine.LSU.2.00.0910131736571.8582@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0910131736571.8582@wotan.suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Tue, Oct 13, 2009 at 05:43:44PM +0200, Jiri Kosina wrote:
> On Tue, 13 Oct 2009, iceberg wrote:
> 
> > 	In driver ./drivers/input/input.c possible call to mutex_lock from 
> > function input_devices_seq_start without mutex_unlock.
> > 
> > 	After calling input_devices_seq_start we can't know whether 
> > mutex was locked or not. 
> 
> > Case 1. If mutex_lock_interruptible was not locked due to interrupt then 
> > input_devices_seq_start returns NULL.
> > Case 2. If mutex was successfuly locked but seq_list_start returned NULL 
> > then input_devices_seq_start returns NULL too. The last case occurs if 
> > seq_list_start is called with pos>size of input_dev_list or pos<0.
> > Hence, after calling input_devices_seq_start we can not simply check 
> > that result is not NULL and call input_devices_seq_stop function 
> > which unlocks the mutex. Because in case 2 the mutex will stay locked.
> > void * ret = input_devices_seq_start(...);
> > if(ret!=NULL) {
> > 	//mutex is acquired for sure
> > 	input_devices_seq_stop(...);//unlocks the mutex
> > } else {
> > 	//mutex may be acquired or not
> > }
> 
> Plus, we should return EAGAIN rather than failing silently when 
> input_handlers_seq_start() has been interrupted by signal, right?
> 
> Dmitry, how about the fix below?
> 

Umm, I don't like assuming that EAGAIN can only mean that
mutex_lock_interruptible() failed, seq_file core may theoretically return
-EAGAIN too. In fact, looking through seq_file.c traverse() does return
-EAGAIN in certain cases...

Plus input_devices_seq_start() needs the same treatment (you fixed
input_handlers_seq_start() only).

HOw about this one instead?

-- 
Dmitry


Input: fix locking issue in /proc/bus/input/ handlers

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

input_devices_seq_start() uses mutex_lock_interruptible() to acquire
the input_mutex, but doesn't properly handle the situation when the
call fails (for example due to interrupt). Instead of returning NULL
(which indicates that there is no more data) we should return
ERR_PTR()-encoded error.

We also need explicit flag indicating whether input_mutex was acquired
since input_devices_seq_stop() is called whether input_devices_seq_start()
was successful or not.

The same applies to input_handlers_seq_start().

Reported-by: iceberg <strakh@ispras.ru>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/input.c |   65 ++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 48 insertions(+), 17 deletions(-)


diff --git a/drivers/input/input.c b/drivers/input/input.c
index c6f88eb..cc763c9 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -782,10 +782,29 @@ static unsigned int input_proc_devices_poll(struct file *file, poll_table *wait)
 	return 0;
 }
 
+union input_seq_state {
+	struct {
+		unsigned short pos;
+		bool mutex_acquired;
+	};
+	void *p;
+};
+
 static void *input_devices_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	if (mutex_lock_interruptible(&input_mutex))
-		return NULL;
+	union input_seq_state *state = (union input_seq_state *)&seq->private;
+	int error;
+
+	/* We need to fit into seq->private pointer */
+	BUILD_BUG_ON(sizeof(union input_seq_state) != sizeof(seq->private));
+
+	error = mutex_lock_interruptible(&input_mutex);
+	if (error) {
+		state->mutex_acquired = false;
+		return ERR_PTR(error);
+	}
+
+	state->mutex_acquired = true;
 
 	return seq_list_start(&input_dev_list, *pos);
 }
@@ -795,9 +814,12 @@ static void *input_devices_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 	return seq_list_next(v, &input_dev_list, pos);
 }
 
-static void input_devices_seq_stop(struct seq_file *seq, void *v)
+static void input_seq_stop(struct seq_file *seq, void *v)
 {
-	mutex_unlock(&input_mutex);
+	union input_seq_state *state = (union input_seq_state *)&seq->private;
+
+	if (state->mutex_acquired)
+		mutex_unlock(&input_mutex);
 }
 
 static void input_seq_print_bitmap(struct seq_file *seq, const char *name,
@@ -861,7 +883,7 @@ static int input_devices_seq_show(struct seq_file *seq, void *v)
 static const struct seq_operations input_devices_seq_ops = {
 	.start	= input_devices_seq_start,
 	.next	= input_devices_seq_next,
-	.stop	= input_devices_seq_stop,
+	.stop	= input_seq_stop,
 	.show	= input_devices_seq_show,
 };
 
@@ -881,40 +903,49 @@ static const struct file_operations input_devices_fileops = {
 
 static void *input_handlers_seq_start(struct seq_file *seq, loff_t *pos)
 {
-	if (mutex_lock_interruptible(&input_mutex))
-		return NULL;
+	union input_seq_state *state = (union input_seq_state *)&seq->private;
+	int error;
+
+	/* We need to fit into seq->private pointer */
+	BUILD_BUG_ON(sizeof(union input_seq_state) != sizeof(seq->private));
+
+	error = mutex_lock_interruptible(&input_mutex);
+	if (error) {
+		state->mutex_acquired = false;
+		return ERR_PTR(error);
+	}
+
+	state->mutex_acquired = true;
+	state->pos = *pos;
 
-	seq->private = (void *)(unsigned long)*pos;
 	return seq_list_start(&input_handler_list, *pos);
 }
 
 static void *input_handlers_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	seq->private = (void *)(unsigned long)(*pos + 1);
-	return seq_list_next(v, &input_handler_list, pos);
-}
+	union input_seq_state *state = (union input_seq_state *)&seq->private;
 
-static void input_handlers_seq_stop(struct seq_file *seq, void *v)
-{
-	mutex_unlock(&input_mutex);
+	state->pos = *pos + 1;
+	return seq_list_next(v, &input_handler_list, pos);
 }
 
 static int input_handlers_seq_show(struct seq_file *seq, void *v)
 {
 	struct input_handler *handler = container_of(v, struct input_handler, node);
+	union input_seq_state *state = (union input_seq_state *)&seq->private;
 
-	seq_printf(seq, "N: Number=%ld Name=%s",
-		   (unsigned long)seq->private, handler->name);
+	seq_printf(seq, "N: Number=%u Name=%s", state->pos, handler->name);
 	if (handler->fops)
 		seq_printf(seq, " Minor=%d", handler->minor);
 	seq_putc(seq, '\n');
 
 	return 0;
 }
+
 static const struct seq_operations input_handlers_seq_ops = {
 	.start	= input_handlers_seq_start,
 	.next	= input_handlers_seq_next,
-	.stop	= input_handlers_seq_stop,
+	.stop	= input_seq_stop,
 	.show	= input_handlers_seq_show,
 };
 
