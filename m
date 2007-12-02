Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbXLBPzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbXLBPzr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 10:55:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbXLBPzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 10:55:39 -0500
Received: from smtp-out.google.com ([216.239.45.13]:50681 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbXLBPzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 10:55:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=gVOa6rsRoov6ucH6bJToDrQBWG5T+ytBqD4nI2Z/mvdgPKVi4LezEK6EnugXkSnI7
	WWHSPWsXVCxQWh5947+Ng==
Date: Sun, 2 Dec 2007 07:52:54 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Oeser <ioe-lkml@rameria.de>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [feature] automatically detect hung TASK_UNINTERRUPTIBLE tasks
In-Reply-To: <200712020155.00187.ioe-lkml@rameria.de>
Message-ID: <alpine.DEB.0.9999.0712012321150.7852@chino.kir.corp.google.com>
References: <20071201092037.GA32544@elte.hu> <alpine.DEB.0.9999.0712011036340.10996@chino.kir.corp.google.com> <20071201193643.GA10911@elte.hu> <200712020155.00187.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Dec 2007, Ingo Oeser wrote:

> > maybe, but we'd have to see how often this gets triggered. An OOM is 
> > something that could happen in any overloaded system - while a hung task 
> > is likely due to a kernel bug.
> 
> What about a client using hard mounted NFS shares here? That shouldn't be
> killed by the OOM killer in that situation, should it?
> 

That's orthogonal to the point I was making; the problem with the OOM 
killer right now is that it can easily enter an infinite loop in out of 
memory conditions if the task that it has selected to be killed fails to 
exit.  This only happens when the task hangs in TASK_UNINTERRUPTIBLE state 
and doesn't respond to the SIGKILL that the OOM killer has sent it.

That behavior is a consequence of trying to avoid needlessly killing tasks 
by giving already-killed tasks time to exit in subsequent OOM conditions.  
During the tasklist scan of eligible tasks to kill, if any task is found 
to have access to memory reserves that only the OOM killer can provide 
(signified by the TIF_MEMDIE thread flag) and it has not yet died, the OOM 
killer becomes a complete no-op.

This happens on occasion and completely deadlocks the system because the 
out of memory condition will never be alleviated.  With the hang detection 
addition to lockdep, it would be easy to correct this situation.  I 
understand the primary purpose of the patch is to identify potential 
kernel bugs that aren't hardware induced, but I think it has relevance to 
the OOM killer problem until such time as tasks hanging in 
TASK_UNINTERRUPTIBLE state becomes passe.

		David
