Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbZEKA0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbZEKA0x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 20:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbZEKA0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 20:26:43 -0400
Received: from smtp-out.google.com ([216.239.45.13]:15225 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZEKA0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 20:26:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=YdWz7dNeu7IxTxoKVg7CL58cG1kUbbs9culOF3IaECJLRvHKza6xvtCWrM4Xkqa29
	z8l6o523rDLljaS9WKFFw==
Date: Sun, 10 May 2009 17:26:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       Arve Hjonnevag <arve@android.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch 06/11 -mmotm] oom: move oom_adj value from task_struct
 to mm_struct
In-Reply-To: <20090511091640.B9B5.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0905101724400.31823@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101501270.18804@chino.kir.corp.google.com> <20090511091640.B9B5.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, KOSAKI Motohiro wrote:

> 
> > The per-task oom_adj value is a characteristic of its mm more than the
> > task itself since it's not possible to oom kill any thread that shares
> > the mm.  If a task were to be killed while attached to an mm that could
> > not be freed because another thread were set to OOM_DISABLE, it would
> > have needlessly been terminated since there is no potential for future
> > memory freeing.
> > 
> > This patch moves oomkilladj (now more appropriately named oom_adj) from
> > struct task_struct to struct mm_struct.  This requires task_lock() on a
> > task to check its oom_adj value to protect against exec, but it's already
> > necessary to take the lock when dereferencing the mm to find the total VM
> > size for the badness heuristic.
> > 
> > This fixes a livelock if the oom killer chooses a task and another thread
> > sharing the same memory has an oom_adj value of OOM_DISABLE.  This occurs
> > because oom_kill_task() repeatedly returns 1 and refuses to kill the
> > chosen task while select_bad_process() will repeatedly choose the same
> > task during the next retry.
> > 
> > Taking task_lock() in select_bad_process() to check for OOM_DISABLE and
> > in oom_kill_task() to check for threads sharing the same memory will be
> > removed in the next patch in this series where it will no longer be
> > necessary.
> > 
> > Writing to /proc/pid/oom_adj for a kthread will now return -EINVAL since
> > these threads are immune from oom killing already.  They simply report an
> > oom_adj value of OOM_DISABLE.
> 
> David, staging driver shold be standalone.
> Please don't change core kernel for staging.
> 
> if you merge it into mainline, I suggest to you help the driver graduate
> staging.
> 

Umm, all my patches apply fine against mainline since the Android 
lowmemorykiller is already in Linus' tree.  This patch moves oomkilladj 
from struct task_struct to struct mm_struct and since that's used for 
procfs, the oom killer, and the Android lowmemorykiller, I need to modify 
all of them so the kernel will compile with 
CONFIG_ANDROID_LOW_MEMORY_KILLER.
