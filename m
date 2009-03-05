Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbZCEWYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbZCEWYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 17:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbZCEWYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 17:24:35 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:37713 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbZCEWYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 17:24:34 -0500
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090305220044.GA2819@x200.localdomain>
References: <20090305163857.0C18F3FD@kernel>
	 <20090305174037.GA2274@x200.localdomain> <1236280567.22399.99.camel@nimitz>
	 <20090305210840.GA2499@x200.localdomain>
	 <1236288427.22399.122.camel@nimitz>
	 <20090305220044.GA2819@x200.localdomain>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 14:24:25 -0800
Message-Id: <1236291865.22399.139.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 01:00 +0300, Alexey Dobriyan wrote:
> On Thu, Mar 05, 2009 at 01:27:07PM -0800, Dave Hansen wrote:
> > > Imagine, unsupported file is opened between userspace checks
> > > for /proc/*/checkpointable and /proc/*/fdinfo/*/checkpointable
> > > and whatever, you stil have to do all the checks inside checkpoint(2).
> > 
> > Alexey, we have two problems here.  I completely agree that we have to
> > do complete and thorough checks of each file descriptor at
> > sys_checkpoint().  Any checks made at other times should not be trusted.
> > 
> > The other side is what Ingo has been asking for.  How do we *know* when
> > we are checkpointable *before* we call (and without calling)
> 
> This "without calling checkpoint(2)" results in much complications
> as demonstrated.

I'll let you take that up with Ingo. :)

> task_struct and file are not like other structures because they are exposed
> in /proc.

Very true.  But, we can always use the task as a proxy to say whether
any of this tasks's *resources* are uncheckpointable.  Is this task's
ipc_namespace checkpointable, etc...

> For PROC_FS=n kernels, one can't even check.

Definitely.  I'd be happy to make this check require PROC=y or even
DEBUGFS=y.  I just want to make the mechanism usable for developers so
they're more motivated to find and fix checkpoint issues.

> You can do checkpoint(2) without actual dump. You pass, you're most
> certainly checkpointable (with inevitable race condition in mind).

OK, so you envision this as maybe calling sys_checkpoint() with a -1 fd
or something?  I'm generally OK with that.  If the /proc stuff is really
the sticking point here, I'd be happy to stick it at the end of the
series so we can throw it away more easily.

> With time the amount of stuff C/R won't support will approach zero,
> but the infrastructure for "checkpointable" will stay constant.
> If it's too much right now, it will be way too much in future.

What have you seen in OpenVZ?  Do new things that are not checkpointable
pop up very often?

-- Dave

