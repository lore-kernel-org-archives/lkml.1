Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbZHEXDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbZHEXDD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 19:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbZHEXDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 19:03:03 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:56967 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400AbZHEXDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 19:03:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H4YTLmxkBhirDM5Raz18QlEWeyJfU9g3E7Np4WUdWY5qOwaMaDv7Rr3zy5/cnmIarX
         wXSJbkQB7qPpTSjB0QoXrd4As2yi2vJErx4q5kzePTCYySZwD7RyGlzxtrw6bslQGmiY
         W09kVwmFGhCwe09NQtt3f56095UMXZ2K4CHj4=
Date: Thu, 6 Aug 2009 01:02:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH 5/5] tracing/filters: Provide support for char *
	pointers
Message-ID: <20090805230257.GI5025@nowhere>
References: <1249111408-8657-1-git-send-email-fweisbec@gmail.com> <1249111408-8657-6-git-send-email-fweisbec@gmail.com> <4A768A87.6090800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A768A87.6090800@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 03, 2009 at 02:58:15PM +0800, Li Zefan wrote:
> Frederic Weisbecker wrote:
> > Provide support for char * pointers in the filtering framework.
> > Usually, char * entries are dangerous in traces because the string
> > can be released whereas a pointer to it can still wait to be read from
> > the ring buffer. But sometimes we can assume it's safe, like in case
> > of RO data (eg: __file__ or __line__, used in bkl trace event). If
> > these RO data are in a module and so is the call to the trace event,
> > then it's safe, because the ring buffer will be flushed once this
> > module get unloaded.
> > 
> 
> The problem is we don't distinguish dangerous char * from
> safe char *... They are both defined as:
> 	__field(char *, str)
> 
> So for those dangerous ones, a string filter still can be applied,
> which will dereference those pointers.


Yeah, but only reviewing can distinguish them. It depends on the
context.
IMO, a __builtin_constant check would be wrong. I don't remember who
posted recently tracepoints with char * types that were safe although he
didn't use string constants.



> > Now the bkl events becomes more useful. Say that you want to trace
> > only the bkl use in reiserfs:
> > 
> > cd /debug/tracing/events/bkl/lock_kernel
> > echo "file == fs/reiserfs*" > filter_regex
> > cat /debug/tracing/trace
> > 
> > syslogd-3658  [001]  1874.661878: lock_kernel: depth: 1, fs/reiserfs/super.c:563 reiserfs_dirty_inode()
> > syslogd-3658  [001]  1874.662266: lock_kernel: depth: 0, fs/reiserfs/inode.c:2695 reiserfs_write_end()
> > syslogd-3658  [001]  1874.662268: lock_kernel: depth: 1, fs/reiserfs/super.c:563 reiserfs_dirty_inode()
> > syslogd-3658  [001]  1874.662291: lock_kernel: depth: 0, fs/reiserfs/inode.c:2695 reiserfs_write_end()

