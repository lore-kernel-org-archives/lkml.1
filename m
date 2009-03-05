Return-Path: <linux-kernel-owner+w=401wt.eu-S1753906AbZCEV1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906AbZCEV1W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 16:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751190AbZCEV1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 16:27:13 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52387 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZCEV1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 16:27:12 -0500
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       containers <containers@lists.linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090305210840.GA2499@x200.localdomain>
References: <20090305163857.0C18F3FD@kernel>
	 <20090305174037.GA2274@x200.localdomain> <1236280567.22399.99.camel@nimitz>
	 <20090305210840.GA2499@x200.localdomain>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 13:27:07 -0800
Message-Id: <1236288427.22399.122.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 00:08 +0300, Alexey Dobriyan wrote:
> On Thu, Mar 05, 2009 at 11:16:07AM -0800, Dave Hansen wrote:
> > On Thu, 2009-03-05 at 20:40 +0300, Alexey Dobriyan wrote:
> > > * without recalculating "checkpointable" property on fs_struct
> > >   on every C/R=y kernel.
> > 
> > Yeah, this is certainly less than ideal.  Although, I haven't seen your
> > proposal for where to tie your code into the kernel.  Do you suggest
> > that we do nothing during normal kernel runtime and all the checking at
> > sys_checkpoint() time?
> 
> Of course!
> 
> C/R won't be used by majority of users, so it shouldn't bring any
> overhead. ->f_op->checkpoint (not ->checkpointable!) is probably
> acceptable. Recalculating flags is not, sorry.

Yeah, what I'm doing in dup_fd() is certainly suboptimal.  It introduces
extra overhead in fork() (with the config option turned on) which sucks
big time.  But, I'm *sure* we can optimize it, especially if we can push
it out to only occurring at "container fork()" time.  Whatever container
fork ends up being.  

> Imagine, unsupported file is opened between userspace checks
> for /proc/*/checkpointable and /proc/*/fdinfo/*/checkpointable
> and whatever, you stil have to do all the checks inside checkpoint(2).

Alexey, we have two problems here.  I completely agree that we have to
do complete and thorough checks of each file descriptor at
sys_checkpoint().  Any checks made at other times should not be trusted.

The other side is what Ingo has been asking for.  How do we *know* when
we are checkpointable *before* we call (and without calling)
sys_checkpoint()?  You are yet to acknowledge that this is a valid use
case, but it is exactly what Ingo is asking for, I believe.

If nice printk()s are sufficient to cover what Ingo wants, I'm quite
happy to remove the /proc files.  

> > > It may lack some printk, but printks are trivial to insert including
> > > using d_path for precise info.
> > 
> > This is definitely workable approach.  However, could you show how you
> > would support /dev/null and, say, /proc/$$/stat?  I've shown what it
> > takes to do that in my patches, and I think it would show a lot about
> > your approach.  
> 
> I haven't yet written code for /dev/null, but it would be:
> * at checkpoint(2)
> 	** see it's block device
> 	** see it's 1:3 => supported
> 	** dump "1:3", dump "/dev/null" as filename

Can we see code, please?  With my approach, it is a single line added to
a structure definition.  Your approach sounds like it may be more than a
single line of code.  It sounds like you would like to have some kind of
device number to c/r mapping.  I'm curious what form that would take.

> * at restore(2)
> 	** read CR_OBJ_FILE
> 	** open filename or -E
> 	** if not block device return -E
> 	** if not 1:3 return -E
> 	** save "struct file *" where needed
> 
> (all of this is modulo unlinked case)

/dev/null is a character device, btw. :)

This sanity checking on the sys_restore() side is also definitely a good
idea.  But, in the interests of keeping our patch size down, I think it
is safe to say that we require userspace to get the fs back into a state
consistent with sys_checkpoint() time.  

-- Dave

