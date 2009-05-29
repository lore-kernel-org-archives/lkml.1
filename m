Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbZE2Ny5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbZE2Ny5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 09:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759349AbZE2Nyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 09:54:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41475 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758842AbZE2Nyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 09:54:50 -0400
Date: Fri, 29 May 2009 09:54:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: "K.Prasad" <prasad@linux.vnet.ibm.com>, David Gibson <dwg@au1.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>, <maneesh@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [Patch 06/12] Use the new wrapper routines to access debug
 registers in process/thread code
In-Reply-To: <20090529104901.GA5997@nowhere>
Message-ID: <Pine.LNX.4.44L0.0905290946520.2882-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009, Frederic Weisbecker wrote:

> On Fri, May 29, 2009 at 02:31:46PM +0530, K.Prasad wrote:
> > On Thu, May 28, 2009 at 04:42:38PM +1000, David Gibson wrote:
> > > On Mon, May 11, 2009 at 05:23:44PM +0530, K.Prasad wrote:
> > > > From: Alan Stern <stern@rowland.harvard.edu>
> > > > 
> > > > This patch enables the use of abstract debug registers in
> > > > process-handling routines.
> > > 
> > > [snip]
> > > >  
> > > > +	p->thread.io_bitmap_ptr = NULL;
> > > 
> > > Why is manipulating the io_bitmap_ptr relevant to debug register
> > > handling?
> > 
> > I *re-read* the patch but was unable to find how this change had sneaked
> > in. It shouldn't be there although it is harmless.
> 
> 
> When I reviewed this patch, I also ended stucked on it.
> But actually I guess I found the sense, this is only for
> convenience.
> 
> Look at the current copy_thread() in arch/x86/kernel/process32.c
> 
> If p->thread.io_bitmap_ptr fails to be duplicated, we set
> p->thread.io_bitmap_max = 0 and return -ENOMEM
> 
> Now look at the patch.
> If we fail to copy the hardware thread virtual registers we
> want to exit with io_bitmap_ptr = NULL
> If we fail to copy the io_bitmap, we want to free the breakpoint
> and exit.
> If we fail further, we want to free breakpoints and io_bitmap_ptr
> 
> The out section then tries to:
> 
> -free the breakpoints
> -free p->thread.io_bitmap_ptr
> 
> 
> So it's important to set io_bitmap_ptr to NULL so that
> we know whether we have to release it or not.

That's exactly why I wrote it.

Now, if we could guarantee that io_bitmap_ptr was always NULL upon
entry to copy_thread(), the statement could of course be removed.  In
fact it probably is NULL, since otherwise the current code wouldn't
work properly.

Alan Stern

