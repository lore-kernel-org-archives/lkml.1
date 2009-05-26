Return-Path: <linux-kernel-owner+w=401wt.eu-S1754272AbZEZDXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbZEZDXK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 23:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbZEZDW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 23:22:58 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:48472 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbZEZDW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 23:22:57 -0400
Date: Tue, 26 May 2009 08:52:52 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Message-ID: <20090526032252.GA7466@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090515105133.629980476@prasadkr_t60p.in.ibm.com> <20090516002552.GC16792@in.ibm.com> <20090525183627.GB7879@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525183627.GB7879@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 08:36:36PM +0200, Frederic Weisbecker wrote:
> On Sat, May 16, 2009 at 05:55:52AM +0530, K.Prasad wrote:
> > This patch introduces the generic Hardware Breakpoint interfaces for both user
> > and kernel space requests.
> > 
> > Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
> > ---
> >  arch/Kconfig           |    4 
> >  kernel/Makefile        |    1 
> >  kernel/hw_breakpoint.c |  369 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 374 insertions(+)
> > 
> > +/**
> > + * register_kernel_hw_breakpoint - register a hardware breakpoint for kernel space
> > + * @bp: the breakpoint structure to register
> > + *
> > + * @bp.info->name or @bp.info->address, @bp.info->len, @bp.info->type and
> > + * @bp->triggered must be set properly before invocation
> > + *
> > + */
> > +int register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
> > +{
> > +	int rc;
> > +
> > +	rc = arch_validate_hwbkpt_settings(bp, NULL);
> > +	if (rc)
> > +		return rc;
> > +
> > +	spin_lock_bh(&hw_breakpoint_lock);
> > +
> > +	rc = -EINVAL;
> > +	/* Check if we are over-committing */
> > +	if ((hbp_kernel_pos > 0) && (!hbp_user_refcount[hbp_kernel_pos-1])) {
> 
> 
> 
> If hbp_kernel_pos == 0, shouldn't it return -ENOSPC ?
> If several kernel users try to register a breakpoint, and there is no
> more room for one of them, then we know it has failed not because
> of an error in the breakpoint instance but because of a lack of
> resources.
> 
> Frederic.
>

Agreed. It's done correctly in the case of register_user_hw_breakpoint()
but not here. Here's a tiny patch that corrects it.

 
Modify the return code in register_kernel_hw_breakpoint()

Modify the return code in register_kernel_hw_breakpoint() to return -ENOSPC
if we are error-returning due to lack of free HW breakpoint registers.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 kernel/hw_breakpoint.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/kernel/hw_breakpoint.c
+++ linux-2.6-tip.hbkpt/kernel/hw_breakpoint.c
@@ -312,7 +312,7 @@ int register_kernel_hw_breakpoint(struct
 
 	spin_lock_bh(&hw_breakpoint_lock);
 
-	rc = -EINVAL;
+	rc = -ENOSPC;
 	/* Check if we are over-committing */
 	if ((hbp_kernel_pos > 0) && (!hbp_user_refcount[hbp_kernel_pos-1])) {
 		hbp_kernel_pos--;
