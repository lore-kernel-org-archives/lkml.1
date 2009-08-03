Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbZHCG7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbZHCG7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 02:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZHCG7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 02:59:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63614 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbZHCG7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 02:59:48 -0400
Message-ID: <4A768A87.6090800@cn.fujitsu.com>
Date: Mon, 03 Aug 2009 14:58:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 5/5] tracing/filters: Provide support for char *
 pointers
References: <1249111408-8657-1-git-send-email-fweisbec@gmail.com> <1249111408-8657-6-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1249111408-8657-6-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Provide support for char * pointers in the filtering framework.
> Usually, char * entries are dangerous in traces because the string
> can be released whereas a pointer to it can still wait to be read from
> the ring buffer. But sometimes we can assume it's safe, like in case
> of RO data (eg: __file__ or __line__, used in bkl trace event). If
> these RO data are in a module and so is the call to the trace event,
> then it's safe, because the ring buffer will be flushed once this
> module get unloaded.
> 

The problem is we don't distinguish dangerous char * from
safe char *... They are both defined as:
	__field(char *, str)

So for those dangerous ones, a string filter still can be applied,
which will dereference those pointers.

> Now the bkl events becomes more useful. Say that you want to trace
> only the bkl use in reiserfs:
> 
> cd /debug/tracing/events/bkl/lock_kernel
> echo "file == fs/reiserfs*" > filter_regex
> cat /debug/tracing/trace
> 
> syslogd-3658  [001]  1874.661878: lock_kernel: depth: 1, fs/reiserfs/super.c:563 reiserfs_dirty_inode()
> syslogd-3658  [001]  1874.662266: lock_kernel: depth: 0, fs/reiserfs/inode.c:2695 reiserfs_write_end()
> syslogd-3658  [001]  1874.662268: lock_kernel: depth: 1, fs/reiserfs/super.c:563 reiserfs_dirty_inode()
> syslogd-3658  [001]  1874.662291: lock_kernel: depth: 0, fs/reiserfs/inode.c:2695 reiserfs_write_end()
