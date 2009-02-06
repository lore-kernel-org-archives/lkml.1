Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbZBFBNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbZBFBNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbZBFBNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:13:24 -0500
Received: from tomts22-srv.bellnexxia.net ([209.226.175.184]:36563 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752719AbZBFBNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:13:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEAKsZi0lMQWt2/2dsb2JhbACBbs13hBYG
Date: Thu, 5 Feb 2009 20:13:20 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Nick Piggin <npiggin@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [BUGFIX][PATCH -rc/-mm] prevent kprobes from catching spurious
	page  faults
Message-ID: <20090206011320.GA7161@Krystal>
References: <497FC3B1.7050805@redhat.com> <497FE895.1080708@redhat.com> <20090128154824.GA6025@Krystal> <49808EEF.1020700@redhat.com> <20090128171331.GA9006@Krystal> <49809CCE.40409@redhat.com> <20090128181053.GC9908@Krystal> <498B6457.20302@redhat.com> <20090205235727.GA16040@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090205235727.GA16040@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:10:21 up 36 days,  1:08,  9 users,  load average: 0.31, 0.23,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Masami Hiramatsu <mhiramat@redhat.com> wrote:
> 
> > -	if (notify_page_fault(regs))
> > -		return;
> >  	if (unlikely(kmmio_fault(regs, address)))
> >  		return;
> > 
> > @@ -634,6 +632,9 @@ void __kprobes do_page_fault(struct pt_r
> >  		if (spurious_fault(address, error_code))
> >  			return;
> > 
> > +		/* kprobes don't want to hook the spurious faults. */
> > +		if (notify_page_fault(regs))
> > +			return;
> >  		/*
> >  		 * Don't take the mm semaphore here. If we fixup a prefetch
> >  		 * fault we could otherwise deadlock.
> > @@ -641,6 +642,9 @@ void __kprobes do_page_fault(struct pt_r
> >  		goto bad_area_nosemaphore;
> >  	}
> > 
> > +	/* kprobes don't want to hook the spurious faults. */
> > +	if (notify_page_fault(regs))
> > +		return;
> 
> I dont know - this spreads that callback to two places now. Any
> reason why kprobes cannot call spurious_fault(), if there's a
> probe active?
> 
> Also, moving that would remove the planned cleanup of merging these
> two into one call:
> 
>  	if (notify_page_fault(regs))
>  		return;
>   	if (unlikely(kmmio_fault(regs, address)))
>   		return;
> 
> We should reduce the probing cross section, not increase it,
> especially in such a critical codepath as the pagefault handler.
> 
> Btw., why cannot kprobes install a dynamic probe to the fault
> handler itself? That way the default path would have no such
> callbacks and checks at all.
> 

Or we could simply merge my 2 LTTng page fault handler tracepoints per
architecture and be done with it ?

I'd need to clean up the patchset a little bit to fold a few patches,
but that would be straightforward enough.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
