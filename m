Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbYBZGyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbYBZGyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 01:54:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYBZGyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 01:54:12 -0500
Received: from smtp-out.google.com ([216.239.45.13]:26515 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYBZGyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 01:54:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=qrI9B/M/g4cq+8FBtn+/HMVw0vsf3kz9EsdS7mH0HDeELQgqpNDqs+GtbjvWRWm1V
	gmMd2urbXxfhZoE6GcW0g==
Date: Mon, 25 Feb 2008 22:53:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Jackson <pj@sgi.com>
cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/6] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <20080225234616.777d534c.pj@sgi.com>
Message-ID: <alpine.DEB.1.00.0802252248400.9390@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com> <alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com> <20080225234616.777d534c.pj@sgi.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, Paul Jackson wrote:

>     $ grep mpol_store_user_nodemask mm/mempolicy.c
>     static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
>         if (mpol_store_user_nodemask(policy))
>         if (!mpol_store_user_nodemask(a))
>         if (!mpol_store_user_nodemask(pol) &&
> 
> So I see no need to waste the instructions needed (in the three copies
> of this code, since it's static inline) to convert a non-zero value to
> exactly the value 1.
> 

Done, thanks.

> Hmmm ... speaking of static inline ... I can knock 600 bytes (that's
> IA64 bytes, so equivalent to about 300 x86 bytes) off the kernel text
> size by not inlining the mm/mempolicy.c routines check_pgd_range() and
> interleave_nid().  I wonder if that would be worth doing.  Perhaps
> those two routines are in sufficiently tight corners that the duplicate
> copies of them is needed.
> 

It seems like a worthwhile change to me even though gcc will pass the 
actuals to check_pgd_range() on the stack.  The callers to check_range() 
shouldn't be in any fast paths: migrate_to_node() can take a long time 
depending on the length of the page list and do_mbind() sleeps on 
mmap_sem.

   text	   data	    bss	    dec	    hex	filename
  11695	     24	     24	  11743	   2ddf	mm/mempolicy.o.before
  11215	     24	     24	  11263	   2bff	mm/mempolicy.o.after
