Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbZHZO1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbZHZO1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 10:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZHZO1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 10:27:39 -0400
Received: from mail-ew0-f227.google.com ([209.85.219.227]:50192 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbZHZO1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 10:27:38 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Aug 2009 10:27:34 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DTinz+/5WAeiNXEv+TXwZKKViVAAvtjTcHTDps+teB8sojyf5VB801Xg/3uG6i3UNZ
         It0akE121mcVn1KXFtlwFm9I05htZ+prpiZfAy5xN4hdrFaULJSTIly0k1x+8+nFWfcH
         UjF+mr7ziyl/KFwYsBjjQ1ypMeLX7ObL9YE+s=
Date: Wed, 26 Aug 2009 16:27:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090826142732.GA6304@nowhere>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090826123550.GD6009@nowhere> <20090826125943.GA5946@osiris.boeblingen.de.ibm.com> <20090826133019.GE6009@nowhere> <20090826141052.GB5946@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826141052.GB5946@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 04:10:52PM +0200, Heiko Carstens wrote:
> On Wed, Aug 26, 2009 at 03:30:22PM +0200, Frederic Weisbecker wrote:
> > On Wed, Aug 26, 2009 at 02:59:43PM +0200, Heiko Carstens wrote:
> > > > Yeah, and as told before, syscalls tracing from kernel thread is
> > > > an interesting point but we can't do it that way.
> > > > 
> > > > I'm queuing this patch for .32, but I need you Signed-off-by to apply it :)
> > > 
> > > That won't always work as pointed out in the other example:
> > > - Process doing sys_init_module then scheduled away
> > > - User enables syscall tracing -> TIF_SYSCALL_FTRACE gets set
> > > - init function of the module gets called and is doing kernel_thread()
> > >   (old API) -> kernel thread inherits TIF_SYSCALL_FTRACE.
> > > 
> > > I don't think that's what you want. You might want to clear the flag for
> > > new processes during fork (only for kernel threads I would guess).
> > > 
> > > At least the current patch leaves a hole.
> > 
> > Ah, there are callsites that use kernel_thread() directly?
> > Does it means that t->mm could be non NULL for such resulting
> > kernel threads, in that case it would be hard to hook on
> > do_fork() to check that.
> 
> Oh yes, you are right. kernel threads created with kernel_thread()
> have t->mm != NULL if the forking process has an mm too.
> 
> There are very few callsites left which still use kernel_thread().
> (the last one in s390 driver code will be gone after the next
> merge window).
> 
> As far as I can there are only four callsites left
> (excluding staging): jffs2 and three in net/bluetooth/*


In that case, I'd suggest to pick the patch that checks for
kernel threads while setting the TIF_FLAGS.

The check for invalid syscall numbers in another patch should be
sufficient to not crash.

We might have rare inaccurate result because of the remaining
buggy callsites but instead of working around on it, these
should be fixed.

