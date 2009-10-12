Return-Path: <linux-kernel-owner+w=401wt.eu-S1755283AbZJLJJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbZJLJJd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbZJLJJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:09:32 -0400
Received: from smtp.ispras.ru ([83.149.198.201]:45983 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755191AbZJLJJa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:09:30 -0400
Date: Mon, 12 Oct 2009 13:11:49 +0000
From: iceberg <iceberg@ispras.ru>
Subject: [BUG] hidraw.c: double mutex_lock
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
X-Mailer: Balsa 2.3.26
Message-Id: <1255353109.13239.0@pamir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	KERNEL_VERSION: 2.6.31
	DESCRIBE:
	In driver ./drivers/hid/hidraw.c in function hidraw_read may be 
double mutex_lock:

Path:
1. line 50: begin first iteration of "while(ret==0)"
2. line 52: first call to mutex_lock
3. inner loop "while (list->head == list->tail)" does not change state 
of mutex, because mutex_lock immediatelly follows mutex_unlock
4. if we go to the second iteration of "while(ret == 0)" in 
line 50 then there are second call to mutex_lock in line 52 (mutex 
aquired twice).

Second iteration of loop "while(ret==0)" is possible if local variable 
ret is not changed at line 94: ret+=len - i.e. len==0;
Variable len may be zero if hidraw_read is called with count==0 or 
list->buffer[list->tail].len == 0.

static ssize_t hidraw_read(struct file *file, char __user *buffer, 
size_t count, loff_t *ppos)
  44{
  45        struct hidraw_list *list = file->private_data;
  46        int ret = 0, len;
  47        char *report;
  48        DECLARE_WAITQUEUE(wait, current);
  49
  50        while (ret == 0) {
  51
  52                mutex_lock(&list->read_mutex);
  53
  54                if (list->head == list->tail) {
  55                        add_wait_queue(&list->hidraw->wait, &wait);
  56                        set_current_state(TASK_INTERRUPTIBLE);
  57
  58                        while (list->head == list->tail) {
  59                                if (file->f_flags & O_NONBLOCK) {
  60                                        ret = -EAGAIN;
  61                                        break;
  62                                }
  63                                if (signal_pending(current)) {
  64                                        ret = -ERESTARTSYS;
  65                                        break;
  66                                }
  67                                if (!list->hidraw->exist) {
  68                                        ret = -EIO;
  69                                        break;
  70                                }
  71
  72                                /* allow O_NONBLOCK to work well 
from other threads */
  73                                mutex_unlock(&list->read_mutex);
  74                                schedule();
  75                                mutex_lock(&list->read_mutex);
  76                                set_current_state
(TASK_INTERRUPTIBLE);
  77                        }
  78
  79                        set_current_state(TASK_RUNNING);
  80                        remove_wait_queue(&list->hidraw->wait, 
&wait);
  81                }
  82
  83                if (ret)
  84                        goto out;
  85
  86                report = list->buffer[list->tail].value;
  87                len = list->buffer[list->tail].len > count ?
  88                        count : list->buffer[list->tail].len;
  89
  90                if (copy_to_user(buffer, list->buffer[list-
>tail].value, len)) {
  91                        ret = -EFAULT;
  92                        goto out;
  93                }
  94                ret += len;
  95
  96                kfree(list->buffer[list->tail].value);
  97                list->tail = (list->tail + 1) & (HIDRAW_BUFFER_SIZE 
- 1);
  98        }
  99out:
 100        mutex_unlock(&list->read_mutex);
 101        return ret;
 102}



