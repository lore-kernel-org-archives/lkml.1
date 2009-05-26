Return-Path: <linux-kernel-owner+w=401wt.eu-S1754716AbZEZKTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbZEZKTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 06:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754330AbZEZKTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 06:19:23 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:51908 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252AbZEZKTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 06:19:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JBrFgEFDv1+z9NDfjT4UZjwz8uPM0GIzHsJ3i2XYwHNSQXqeenPUtVjYdRusLm0ozT
         kzc0PeDwuHv/ns5b4RX0IoJvUrmPUiMGUAVaN5ELpRbpGSJGep8yqonSosqXWr/tAuHU
         bcQodd3jWsK1Hoq6rOtvk5rQFy/ZVX3AtGruU=
Date: Tue, 26 May 2009 12:19:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [Patch 02/12] Introducing generic hardware breakpoint handler
	interfaces
Message-ID: <20090526101914.GA5988@nowhere>
References: <20090515105133.629980476@prasadkr_t60p.in.ibm.com> <20090516002552.GC16792@in.ibm.com> <20090525183627.GB7879@nowhere> <20090526032252.GA7466@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526032252.GA7466@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 08:52:52AM +0530, K.Prasad wrote:
> On Mon, May 25, 2009 at 08:36:36PM +0200, Frederic Weisbecker wrote:
> > On Sat, May 16, 2009 at 05:55:52AM +0530, K.Prasad wrote:
> > > This patch introduces the generic Hardware Breakpoint interfaces for both user
> > > and kernel space requests.
> > > 
> > > Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
> > > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > > Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
> > > ---
> > >  arch/Kconfig           |    4 
> > >  kernel/Makefile        |    1 
> > >  kernel/hw_breakpoint.c |  369 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 374 insertions(+)
> > > 
> > > +/**
> > > + * register_kernel_hw_breakpoint - register a hardware breakpoint for kernel space
> > > + * @bp: the breakpoint structure to register
> > > + *
> > > + * @bp.info->name or @bp.info->address, @bp.info->len, @bp.info->type and
> > > + * @bp->triggered must be set properly before invocation
> > > + *
> > > + */
> > > +int register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
> > > +{
> > > +	int rc;
> > > +
> > > +	rc = arch_validate_hwbkpt_settings(bp, NULL);
> > > +	if (rc)
> > > +		return rc;
> > > +
> > > +	spin_lock_bh(&hw_breakpoint_lock);
> > > +
> > > +	rc = -EINVAL;
> > > +	/* Check if we are over-committing */
> > > +	if ((hbp_kernel_pos > 0) && (!hbp_user_refcount[hbp_kernel_pos-1])) {
> > 
> > 
> > 
> > If hbp_kernel_pos == 0, shouldn't it return -ENOSPC ?
> > If several kernel users try to register a breakpoint, and there is no
> > more room for one of them, then we know it has failed not because
> > of an error in the breakpoint instance but because of a lack of
> > resources.
> > 
> > Frederic.
> >
> 
> Agreed. It's done correctly in the case of register_user_hw_breakpoint()
> but not here. Here's a tiny patch that corrects it.


Thanks. I will apply this one too.

Frederic.


> 
>  
> Modify the return code in register_kernel_hw_breakpoint()
> 
> Modify the return code in register_kernel_hw_breakpoint() to return -ENOSPC
> if we are error-returning due to lack of free HW breakpoint registers.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  kernel/hw_breakpoint.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/kernel/hw_breakpoint.c
> +++ linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
> @@ -312,7 +312,7 @@ int register_kernel_hw_breakpoint(struct
>  
>  	spin_lock_bh(&hw_breakpoint_lock);
>  
> -	rc = -EINVAL;
> +	rc = -ENOSPC;
>  	/* Check if we are over-committing */
>  	if ((hbp_kernel_pos > 0) && (!hbp_user_refcount[hbp_kernel_pos-1])) {
>  		hbp_kernel_pos--;

