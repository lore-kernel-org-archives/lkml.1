Return-Path: <linux-kernel-owner+w=401wt.eu-S1754972AbYKYBDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbYKYBDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 20:03:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbYKYBAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 20:00:41 -0500
Received: from smtp-out.google.com ([216.239.45.13]:53989 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbYKYBAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 20:00:38 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=rnXH6JoItY3+4p0UXGqDHRe86uNrCc9FT5P0mhqoVrRPbnNn01Yp8JpXj42XKDjHl
	aMCaq0UwBiShsQnQ/ja2g==
Date: Mon, 24 Nov 2008 17:00:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: peterz@infradead.org, david@fromorbit.com, cl@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] mm: add dirty_background_bytes and dirty_bytes
 sysctls
In-Reply-To: <20081124153843.d3c4782c.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0811241651370.1550@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0811230228070.11384@chino.kir.corp.google.com> <alpine.DEB.2.00.0811230228530.11384@chino.kir.corp.google.com> <20081124153843.d3c4782c.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Nov 2008, Andrew Morton wrote:

> > @@ -365,23 +429,29 @@ void
> >  get_dirty_limits(unsigned long *pbackground, unsigned long *pdirty,
> >  		 unsigned long *pbdi_dirty, struct backing_dev_info *bdi)
> >  {
> > -	int background_ratio;		/* Percentages */
> > -	int dirty_ratio;
> >  	unsigned long background;
> >  	unsigned long dirty;
> >  	unsigned long available_memory = determine_dirtyable_memory();
> >  	struct task_struct *tsk;
> >  
> > -	dirty_ratio = vm_dirty_ratio;
> > -	if (dirty_ratio < 5)
> > -		dirty_ratio = 5;
> > +	if (vm_dirty_bytes)
> > +		dirty = (vm_dirty_bytes + PAGE_SIZE) / PAGE_SIZE;
> 
> It would be conventional to use DIV_ROUND_UP() here.
> 

Ah, indeed.  I forgot about those.

> > +	else {
> > +		int dirty_ratio;
> 
> hm, I wonder why vm_dirty_ratio has a signed type.  
> 

vm_dirty_ratio only has an acceptable range between 0 and 100 since it 
uses proc_dointvec_minmax(), so it's not really important.  It could 
definitely be changed, however.

There's a limitation in the sysctl interface where we don't handle 
unsigned ints very well (ignore the reference to unsigned int in the 
proc_dointvec comment).  We lack an unsigned int handler, so all 
proc_dointvec() users are implicitly signed.

For example, if a sysctl's data object were declared with a type specifier 
of unsigned int and it uses proc_dointvec() as the handler, it would have 
a x86_64 max of 2147483648, that of a signed integer.

> > -	background_ratio = dirty_background_ratio;
> > -	if (background_ratio >= dirty_ratio)
> > -		background_ratio = dirty_ratio / 2;
> > +		dirty_ratio = vm_dirty_ratio;
> > +		if (dirty_ratio < 5)
> > +			dirty_ratio = 5;
> > +		dirty = (dirty_ratio * available_memory) / 100;
> > +	}
> > +
> > +	if (dirty_background_bytes)
> > +		background = (dirty_background_bytes + PAGE_SIZE) / PAGE_SIZE;
> 
> DIV_ROUND_UP()?
> 
> > +	else
> > +		background = (dirty_background_ratio * available_memory) / 100;
> >  
> > -	background = (background_ratio * available_memory) / 100;
> > -	dirty = (dirty_ratio * available_memory) / 100;
> > +	if (background >= dirty)
> > +		background = dirty / 2;
> >  	tsk = current;
> >  	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
> >  		background += background / 4;
> 
