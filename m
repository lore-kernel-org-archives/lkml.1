Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852Ab0A0QL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab0A0QL7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557Ab0A0QL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:11:57 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45058 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab0A0QLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:11:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kMy+WdtnIBJCx1LPvokFOzNMOYKrWxVDzWCKvYgzjQXz9/Y4jsqdmws6BsLLYH3/Ur
         +C9U6nYLUtA69EoTxxyVFl3DBIO951zzjvaqrenSlPX7K86hajm7Gs2rOubghFAshdds
         SEjm6939HWyTeejEJIIfwLl1Lx1qDmzpWFCTw=
Date: Wed, 27 Jan 2010 17:11:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC Patch 2/2][Bugfix][x86][hw-breakpoint] Fix return-code to
	notifier chain in hw_breakpoint_handler
Message-ID: <20100127161146.GC22447@nowhere>
References: <20091226175533.149765731@linux.vnet.ibm.com> <20091226182833.GC9494@in.ibm.com> <20100125221101.GE5087@nowhere> <20100127102826.GA3460@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100127102826.GA3460@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 03:58:26PM +0530, K.Prasad wrote:
> On Mon, Jan 25, 2010 at 11:11:04PM +0100, Frederic Weisbecker wrote:
> > Is that < TASK_SIZE an accurate check? We want support for
> > userspace breakpoints on perf tools later, and those don't want
> > signals.
> > 
> 
> Well, signal generation for user-space breakpoints happened
> unconditionally for 'historical' reasons (guess that Alan Stern's
> original patch had it that way).
> 
> We could change that into a 'ptrace-only' signal generation now.



Yeah, now that we can have multiple-purpose concurrent breakpoints,
this is necessary.


 
> > We do this cleanup in the beginning of the breakpoint handler:
> > 
> > 	current->thread.debugreg6 &= ~DR_TRAP_BITS;
> > 
> > And from ptrace.c:ptrace_triggered():
> > 
> > 	thread->debugreg6 |= (DR_TRAP0 << i);
> > 
> > This is called on perf_bp_event().
> > Instead of checking if this is a userspace thread, we should actually
> > check if this is a ptrace breakpoint by looking at this
> > in the end of hw_breakpoint_handler().
> > 
> > 	current->thread.debugreg6 & DR_TRAP_BITS
> > 
> > Only ptrace breakpoints require signals.
> >
> 
> Yes, this does look like a clean way to limit signals to those requests
> that are interested (I was looking at round-about ways like doing a
> lookup based on callback functions).
> 
> I will send the next version of the patch with the above changes.


Thanks.

