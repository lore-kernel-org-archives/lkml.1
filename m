Return-Path: <linux-kernel-owner+w=401wt.eu-S1759369AbYG0Vx4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbYG0Vx4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 17:53:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758297AbYG0Vxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 17:53:49 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:30468 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758151AbYG0Vxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 17:53:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding:sender;
        b=hAX92gVYu2HoADGLUjSoHOQfwPKEXM/tLV48XIWJus/DfrgRWFlTGyX9L8xkKr7ff3
         11u1VigdYKViFs6JJALdtmgIGVzHoYddPN0BobbSvpL7pNxxpcx6IOfVflRU4icD3lrU
         ELkxlSvMKbA5Mi82nyPHjsD69IseWzQsz+7Lo=
Message-ID: <488CEE68.2060102@users.sourceforge.net>
Date: Sun, 27 Jul 2008 23:53:44 +0200
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrea Righi <righi.andrea@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, matt@bluehost.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] task IO accounting: improve code readability
References: <1217172555-8335-1-git-send-email-righi.andrea@gmail.com> <20080727163323.GA1802@tv-sign.ru>
In-Reply-To: <20080727163323.GA1802@tv-sign.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 07/27, Andrea Righi wrote:
>> Put all i/o statistics in struct proc_io_accounting and use inline functions to
>> initialize and increment statistics, removing a lot of single variable
>> assignments.
> 
> Imho, the change like this is obviously good, but can't we simplify
> this a little bit? Just make
> 
> 	struct task_io_accounting
> 	{
> 	#ifdef CONFIG_TASK_XACCT
> 		/* bytes read */
> 		u64 rchar;
> 		/*  bytes written */
> 		u64 wchar;
> 		/* # of read syscalls */
> 		u64 syscr;
> 		/* # of write syscalls */
> 		u64 syscw;
> 	#endif /* CONFIG_TASK_XACCT */
> 
> 	#ifdef CONFIG_TASK_IO_ACCOUNTING
> 		/*
> 		 * The number of bytes which this task has caused to be read from
> 		 * storage.
> 		 */
> 		u64 read_bytes;
> 
> 		/*
> 		 * The number of bytes which this task has caused, or shall cause to be
> 		 * written to disk.
> 		 */
> 		u64 write_bytes;
> 
> 		/*
> 		 * A task can cause "negative" IO too.  If this task truncates some
> 		 * dirty pagecache, some IO which another task has been accounted for
> 		 * (in its write_bytes) will not be happening.  We _could_ just
> 		 * subtract that from the truncating task's write_bytes, but there is
> 		 * information loss in doing that.
> 		 */
> 		u64 cancelled_write_bytes;
> 	#endif
> 	};
> 
> This should make the patch much smaller with the same effect, no?
> 
> Oleg.
> 

Sounds good to me. This also makes sense because it merges *all* the i/o
statistics in "struct task_io_accounting", that is a reasonable thing
IMHO. A patch on-top-of the previous one will follow.

-Andrea
