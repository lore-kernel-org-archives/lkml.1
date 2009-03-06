Return-Path: <linux-kernel-owner+w=401wt.eu-S1751897AbZCFOfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbZCFOfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 09:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbZCFOez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 09:34:55 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44400 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbZCFOey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 09:34:54 -0500
Date: Fri, 6 Mar 2009 08:34:25 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
Message-ID: <20090306143425.GA31250@us.ibm.com>
References: <20090305163857.0C18F3FD@kernel> <20090305174037.GA2274@x200.localdomain> <1236280567.22399.99.camel@nimitz> <20090305210840.GA2499@x200.localdomain> <1236288427.22399.122.camel@nimitz> <20090305220044.GA2819@x200.localdomain> <1236291865.22399.139.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236291865.22399.139.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> On Fri, 2009-03-06 at 01:00 +0300, Alexey Dobriyan wrote:
> > On Thu, Mar 05, 2009 at 01:27:07PM -0800, Dave Hansen wrote:
> > > > Imagine, unsupported file is opened between userspace checks
> > > > for /proc/*/checkpointable and /proc/*/fdinfo/*/checkpointable
> > > > and whatever, you stil have to do all the checks inside checkpoint(2).
> > > 
> > > Alexey, we have two problems here.  I completely agree that we have to
> > > do complete and thorough checks of each file descriptor at
> > > sys_checkpoint().  Any checks made at other times should not be trusted.
> > > 
> > > The other side is what Ingo has been asking for.  How do we *know* when
> > > we are checkpointable *before* we call (and without calling)
> > 
> > This "without calling checkpoint(2)" results in much complications
> > as demonstrated.
> 
> I'll let you take that up with Ingo. :)
> 
> > task_struct and file are not like other structures because they are exposed
> > in /proc.
> 
> Very true.  But, we can always use the task as a proxy to say whether
> any of this tasks's *resources* are uncheckpointable.  Is this task's
> ipc_namespace checkpointable, etc...
> 
> > For PROC_FS=n kernels, one can't even check.
> 
> Definitely.  I'd be happy to make this check require PROC=y or even
> DEBUGFS=y.  I just want to make the mechanism usable for developers so
> they're more motivated to find and fix checkpoint issues.
> 
> > You can do checkpoint(2) without actual dump. You pass, you're most
> > certainly checkpointable (with inevitable race condition in mind).
> 
> OK, so you envision this as maybe calling sys_checkpoint() with a -1 fd
> or something?  I'm generally OK with that.  If the /proc stuff is really
> the sticking point here, I'd be happy to stick it at the end of the
> series so we can throw it away more easily.

Yeah thing is I definately like what Alexey is suggesting.

The only reason for going the route of Dave's patches is to implement
the pain Ingo wants to inflict to push us to faster support the
resources which users actually want/need.  As Alexey says that's
a temporary gain and therefore not worth permanent code.

Oh, right, there's the second reason:

> > With time the amount of stuff C/R won't support will approach zero,
> > but the infrastructure for "checkpointable" will stay constant.
> > If it's too much right now, it will be way too much in future.
> 
> What have you seen in OpenVZ?  Do new things that are not checkpointable
> pop up very often?

Realistically, do you think the uncheckpointable stuff would catch a
brand-new unsupported feature?  If it has a file interface then I
suppose it would.  Well, might.  I wouldn't be surprised if the authors
would cut and paste enough code to paste the .checkpoint =
generic_file_checkpoint line :)

-serge
