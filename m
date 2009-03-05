Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbZCEVCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbZCEVCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 16:02:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbZCEVB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 16:01:56 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:56836 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbZCEVBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 16:01:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iFLswJOqgl2T/TFYSHynI3BoQps6vU4Twb5ta/CdfxA1S6ZGwQ5PtxWA0d7GMOTL29
         e8ZYo1lmEEoIIAtlrAXvMrwOAvUpR8CPz3tRkSkmmr9ZGQaYf1oj7KkLSbnM0JR9MUFu
         VgOZC9Re96dUSf9yv2UunzoF/uYDdm7exJKgE=
Date: Fri, 6 Mar 2009 00:08:40 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH 00/11] track files for checkpointability
Message-ID: <20090305210840.GA2499@x200.localdomain>
References: <20090305163857.0C18F3FD@kernel> <20090305174037.GA2274@x200.localdomain> <1236280567.22399.99.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236280567.22399.99.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 11:16:07AM -0800, Dave Hansen wrote:
> On Thu, 2009-03-05 at 20:40 +0300, Alexey Dobriyan wrote:
> > On Thu, Mar 05, 2009 at 08:38:57AM -0800, Dave Hansen wrote:
> > > This takes a suggestion of Ingo's along with comments from lots of
> > > other people.  It can track whether a given file is able to be
> > > checkpointed.  It introduces a f_op to allow easy customization
> > > like the reset of the VFS.
> > 
> > Here is how alternative looks like
> > * without touching VFS at all
> > * without adding default handlers
> 
> Are these bad things?  If this was harmful to the VFS, I can bet
> Christoph would be speaking up.  As far as the default handlers, blame
> Christoph. :)

It's too much for too little and unreliable. See below.

> > * without duplicate code every ->checkpoint hook will have
> 
> Well, I had actually planned to break the generic function up into a
> "common" function that all of the handlers can call or could be called
> before each handler.  This is trivially fixable, but it would look kinda
> goofy without some code to use it.
> 
> > * without largely useless "special file" messages
> >   (what's so special about it?)
> 
> Very true.  I'll improve that one.
> 
> > * without adding userspace-visible /proc/*/checkpointable 
> 
> Ingo, could you weigh in on how you expected this "checkpointable" flag
> to get exposed to and checked by userspace?
> 
> > * without recalculating "checkpointable" property on fs_struct
> >   on every C/R=y kernel.
> 
> Yeah, this is certainly less than ideal.  Although, I haven't seen your
> proposal for where to tie your code into the kernel.  Do you suggest
> that we do nothing during normal kernel runtime and all the checking at
> sys_checkpoint() time?

Of course!

C/R won't be used by majority of users, so it shouldn't bring any
overhead. ->f_op->checkpoint (not ->checkpointable!) is probably
acceptable. Recalculating flags is not, sorry.

Imagine, unsupported file is opened between userspace checks
for /proc/*/checkpointable and /proc/*/fdinfo/*/checkpointable
and whatever, you stil have to do all the checks inside checkpoint(2).

> > It may lack some printk, but printks are trivial to insert including
> > using d_path for precise info.
> 
> This is definitely workable approach.  However, could you show how you
> would support /dev/null and, say, /proc/$$/stat?  I've shown what it
> takes to do that in my patches, and I think it would show a lot about
> your approach.  

I haven't yet written code for /dev/null, but it would be:
* at checkpoint(2)
	** see it's block device
	** see it's 1:3 => supported
	** dump "1:3", dump "/dev/null" as filename
* at restore(2)
	** read CR_OBJ_FILE
	** open filename or -E
	** if not block device return -E
	** if not 1:3 return -E
	** save "struct file *" where needed

(all of this is modulo unlinked case)

/proc/*/stat is much trickier (and BTW can very well ruin idea of piping
dumpfile to somewhere by introducing honest loops in restoration hierarchy)
