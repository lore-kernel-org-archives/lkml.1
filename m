Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYLJEwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYLJEwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 23:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYLJEwh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 23:52:37 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:58664 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbYLJEwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 23:52:37 -0500
Message-ID: <493F4A5B.6090009@cn.fujitsu.com>
Date: Wed, 10 Dec 2008 12:49:31 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ftrace: support binary record
References: <493F35F3.5020000@cn.fujitsu.com> <alpine.DEB.1.10.0812092307040.25755@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0812092307040.25755@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> 
> 
> On Wed, 10 Dec 2008, Lai Jiangshan wrote:
> 
>> Binary record will save memory in trace buffer, and more events
>> can be recorded in buffer.
>>
>> This patch add infrastructure for supporting binary record.
>>
>> This infrastructure records events by binary and shows events
>> by human readable text.
> 
> Hmm, interesting. But could you show an example of its use. It is quite a 
> lot of code, and looks a little complex.
consider ftrace_struct_printk() as ftrace_printk(), but the
first parameter is "struct ftrace_struct *fmt"

new file: kernel/trace/trace_struct.c : this infrastructure's code

lib/vsprintf.c : formator
other files add ftrace_struct_printk()

> 
>> And add a API ftrace_struct_printk() using this infrastructure.
>> (it's like ftrace_printk(), but it record the date by binary)
>>


example:
...
           <...>-3246  [000]  1243.166054: sys_read: sys_read by ftrace_printk, 3, asdfuuuuu
           <...>-3246  [000]  1243.166057: sys_read: sys_read by ftrace_struct_printk, 3, asdfuuuuu
           <...>-3246  [000]  1243.166490: sys_read: sys_read by ftrace_printk, 9, asdfuuuuu
           <...>-3246  [000]  1243.166491: sys_read: sys_read by ftrace_struct_printk, 9, asdfuuuuu
...
diff --git a/fs/read_write.c b/fs/read_write.c
index 969a6d9..0d9fbed 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -17,7 +17,7 @@
 #include <linux/pagemap.h>
 #include <linux/splice.h>
 #include "read_write.h"
-
+#include <linux/ftrace.h>
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
 
@@ -356,12 +356,15 @@ static inline void file_pos_write(struct file *file, loff_t pos)
 	file->f_pos = pos;
 }
 
+struct ftrace_struct test = {"ixxs", "sys_read by ftrace_struct_printk, %d, %s\n"};
 asmlinkage ssize_t sys_read(unsigned int fd, char __user * buf, size_t count)
 {
 	struct file *file;
 	ssize_t ret = -EBADF;
 	int fput_needed;
 
+	ftrace_printk("sys_read by ftrace_printk, %d, %s\n", fd, "asdfuuuuu");
+	ftrace_struct_printk(&test, fd, "asdfuuuuu");
 	file = fget_light(fd, &fput_needed);
 	if (file) {
 		loff_t pos = file_pos_read(file);

