Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZFIAmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZFIAmz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 20:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbZFIAms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 20:42:48 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42580 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZFIAmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 20:42:47 -0400
Date: Tue, 9 Jun 2009 09:41:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Matthew Von Maszewski <matthew@thehive.com>
Cc: linux-kernel@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: huge mem mmap eats all CPU when multiple processes
Message-Id: <20090609094117.8226c0ca.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <8FDBF172-AAA8-4737-A6C6-50B468CA0CBF@thehive.com>
References: <8FDBF172-AAA8-4737-A6C6-50B468CA0CBF@thehive.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009 10:27:49 -0400
Matthew Von Maszewski <matthew@thehive.com> wrote:

> [note: not on kernel mailing list, please cc author]
> 
> Symptom:  9 processes mmap same 2 Gig memory section for a shared C  
> heap (lots of random access).  All process begin extreme CPU load in  
> top.
> 
> - Same code works well when only single process access huge mem.
Does this "huge mem" means HugeTLB(2M/4Mbytes) pages ?

> - Code works well with standard vm based mmap file and 9 processes.
> 

What is sys/user ratio in top ? Almost all cpus are used by "sys" ?

> Environment:
> 
> - Intel x86_64:  Dual core Xeon with hyperthreading (4 logical  
> processors)
> - 6 Gig ram, 2.5G allocated to huge mem
by boot option ?

> - tried with kernels 2.6.29.4 and 2.6.30-rc8
> - following mmap() call has base address as NULL on first process,  
> then returned address passed to subsequent processes (not threads,  
> processes)
> 
>             m_MemSize=((m_MemSize/(2048*1024))+1)*2048*1024;
>              m_BaseAddr=mmap(m_File->GetFixedBase(), m_MemSize,
>                              (PROT_READ | PROT_WRITE),
>                              MAP_SHARED, m_File->GetFileId(), m_Offset);
> 
> 
> I am not a kernel hacker so I have not attempted to debug.  Will be  
> able to spend time on a sample program for sharing later today or  
> tomorrow.  Sending this note now in case this is already known.
> 

IIUC, all page faults to hugetlb are serialized by system's mutex. Then, touching
in parallel doesn't do fast job..
Then, I wonder touching all necessary maps by one thread is good, in general.



> Don't suppose this is as simple as a Copy-On-Write flag being set wrong?
> 
I don't think, so.

> Please send notes as to things I need to capture to better describe  
> this bug.  Happy to do the work.
> 
Add cc to linux-mm.

Thanks,
-Kame


> Thanks,
> Matthew
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

