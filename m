Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995Ab0AJDTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab0AJDTE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 22:19:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242Ab0AJDTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 22:19:03 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:63612 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab0AJDTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 22:19:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZEn16F6vi5OKQXNQfbepsreI8oNjCyDLmukh0uF3s3rAdgxK2qPYq+Plp40i//dWf7
         pW825ys6lhWp7Ja751Kjq74ZHZ9CkAGb8V4POrKz8JENZBkc6mZSDk3m4ngTmtf8vgVm
         Ia1ZxFG2ar2uRRu25NQFO9yxc4gGnZV5R0gh0=
Date: Sun, 10 Jan 2010 04:18:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC Patch 2/2][Bugfix][x86][hw-breakpoint] Fix return-code to
	notifier chain in hw_breakpoint_handler
Message-ID: <20100110031857.GB15195@nowhere>
References: <20091226175533.149765731@linux.vnet.ibm.com> <20091226182833.GC9494@in.ibm.com> <20091231003808.GC23808@nowhere> <20091231190217.GC3676@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091231190217.GC3676@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 01, 2010 at 12:32:17AM +0530, K.Prasad wrote:
> On Thu, Dec 31, 2009 at 01:38:09AM +0100, Frederic Weisbecker wrote:
> > On Sat, Dec 26, 2009 at 11:58:33PM +0530, K.Prasad wrote:
> > > The hw-breakpoint handler will return NOTIFY_DONE for user-space breakpoints
> > > to generate SIGTRAP signal (and not for kernel-space addresses). 
> > > 
> > > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > > ---
> > >  arch/x86/kernel/hw_breakpoint.c |    9 +++++++--
> > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > > 
> > > Index: linux-2.6-tip/arch/x86/kernel/hw_breakpoint.c
> > > ===================================================================
> > > --- linux-2.6-tip.orig/arch/x86/kernel/hw_breakpoint.c
> > > +++ linux-2.6-tip/arch/x86/kernel/hw_breakpoint.c
> > > @@ -502,8 +502,6 @@ static int __kprobes hw_breakpoint_handl
> > >  		rcu_read_lock();
> > >  
> > >  		bp = per_cpu(bp_per_reg[i], cpu);
> > > -		if (bp)
> > > -			rc = NOTIFY_DONE;
> > >  		/*
> > >  		 * Reset the 'i'th TRAP bit in dr6 to denote completion of
> > >  		 * exception handling
> > > @@ -517,6 +515,13 @@ static int __kprobes hw_breakpoint_handl
> > >  			rcu_read_unlock();
> > >  			break;
> > >  		}
> > > +		/*
> > > +		 * Further processing in do_debug() is needed for a) user-space
> > > +		 * breakpoints (to generate signals) and b) when the system has
> > > +		 * taken exception due to multiple causes
> > > +		 */
> > > +		if (bp->attr.bp_addr < TASK_SIZE)
> > > +			rc = NOTIFY_DONE;
> > >  
> > >  		perf_bp_event(bp, args->regs);
> > >  
> > > 
> > 
> > 
> > Oh and now that I see this patch, the previous one indeed makes sense
> > with this check:
> > 
> > if (dr6 & (~DR_TRAP_BITS))
> > 	rc = NOTIFY_DONE;
> > 
> > That said, it means thread.debugreg6 won't get the reserved bits anymore.
> > I see some use of them from kvm (it restores the reserved bits on guest<->host
> > switch). Not sure if this inconsistency could affect kvm...
> > 
> 
> Can you point me to the relevant code?


I see various uses of DR6_VOLATILE and DR6_FIXED_1 in arch/x86/kvm/,
DR6_FIXED_1 being the fixed unused bits in dr6. Not sure how
this patch would affect what's set there.

I'll wait for Jan's answer.

Thanks.

