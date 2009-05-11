Return-Path: <linux-kernel-owner+w=401wt.eu-S1761041AbZEKXJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761041AbZEKXJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757364AbZEKXIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:08:50 -0400
Received: from smtp-out.google.com ([216.239.33.17]:12402 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359AbZEKXIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:08:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=fzwUyDV2mQGxO8IZBi/vX3EU0UFTnabtuB+pXOkm7hEXlGtqdTcHaU4gP30d5Kllt
	eHGToa9NkqoD5UxfJZJ+w==
Date: Mon, 11 May 2009 16:08:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Greg Kroah-Hartman <gregkh@suse.de>, npiggin@suse.de, mel@csn.ul.ie,
       a.p.zijlstra@chello.nl, Christoph Lameter <cl@linux-foundation.org>,
       dave@linux.vnet.ibm.com, san@android.com, arve@android.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 10/11 -mmotm] oom: avoid oom kill if no interruptible
 tasks
In-Reply-To: <20090511143906.1cde5f6e.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0905111606030.5979@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905101458430.18804@chino.kir.corp.google.com> <alpine.DEB.2.00.0905101502470.18804@chino.kir.corp.google.com> <20090511143906.1cde5f6e.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009, Andrew Morton wrote:

> > If there are no interruptible system tasks other than kthreads,
> 
> It's unclear what the term "system task" means.  Just "task"?
> 

Yes.

> > no task
> > should be chosen for oom kill since they won't respond to the SIGKILL
> > anyway.  Instead, we choose to simply fail page allocations if reclaim
> > cannot free memory and hope for the best.
> 
> But plain old user processes enter and leave D state all the time.  The
> task may well just be sitting there waiting for a disk read to
> complete.  It will respond to the SIGKILL shortly after the IO
> completes, so an appropriate action here is to just wait for that to
> happen.
> 

Since current is in the oom killer, it's runnable.  So the only way this 
can fail an allocation is if a kthread is looking for memory and reclaim 
has failed and no user tasks are running.  It's not guaranteed that any 
memory will ever become available (for instance if all userspace tasks are 
waiting on mm->mmap_sem for an oom killed task that will never exit even 
after having been given TIF_MEMDIE), so the best course of action is to 
fail, if allowed.
