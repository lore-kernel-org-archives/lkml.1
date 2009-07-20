Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134AbZGTA5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbZGTA5g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 20:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZGTA5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 20:57:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58736 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbZGTA5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 20:57:34 -0400
Message-ID: <4A63C09A.80904@cn.fujitsu.com>
Date: Mon, 20 Jul 2009 08:55:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: dont reset set_ftrace_filter/notrace when	opened
 with r/w perm
References: <20090716165135.GA4739@jolsa.lab.eng.brq.redhat.com> <4A604654.1090303@cn.fujitsu.com> <20090717111025.GC2891@jolsa.lab.eng.brq.redhat.com>
In-Reply-To: <20090717111025.GC2891@jolsa.lab.eng.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa wrote:
> On Fri, Jul 17, 2009 at 05:37:24PM +0800, Li Zefan wrote:
>> Jiri Olsa wrote:
>>> If user setup set_ftrace_filter/set_ftrace_notrace files and then opens them
>>> with read&write permissions, the previous setup will be removed.
>>>
>> Currently:
>>
>>  # echo 'sys_open sys_close' > set_ftrace_filter
>>  # cat set_ftrace_filter
>>  sys_open
>>  sys_close
>>
>> After your patch:
>>
>>  # echo 'sys_open sys_close' > set_ftrace_filter
>>  # cat set_ftrace_filter
>>  sys_close
>>
> 
> oops, sry I missed this..
> 
> Following patch adds new FTRACE_ITER_RESET flag, as the decision needs
> to be taken in "open" and applied in "write".  I'm not sure whats the
> policy for adding new flags, but it looks ok to me.
> 

I have no strong opinion whether to do the reset in "open" or in first
"write".

All said, I think this is cleaner, without introducing a new flag:

@@ -2260,6 +2256,9 @@ ftrace_regex_write(struct file *file, const char __user *ubuf,
 		return 0;
 
 	mutex_lock(&ftrace_regex_lock);
+	if (file->f_pos == 0 &&
+	    (file->f_mode & FMODE_WRITE) && !(file->f_flags & O_APPEND))
+		ftrace_filter_reset(enable);
 
 	if (file->f_mode & FMODE_READ) {
 		struct seq_file *m = file->private_data;
