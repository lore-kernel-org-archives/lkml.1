Return-Path: <linux-kernel-owner+w=401wt.eu-S1751654AbZHZQPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbZHZQPs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751332AbZHZQPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:15:47 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:49783 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbZHZQPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:15:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OXKwvgbVd/exAaj5lZny9mvxsQD9aIer9+r9XFw+tqIdnWE/Rzkw7up1qYgHdJxsEr
         ps1xa/rNSWFxFnR6BWax43GCw8AecIHpseOZegUVSr9TLexRFaal08N1bh9m0enj7Cey
         vYH7MTgN7RW07cpAaHSIFwF4grk2MfuYfzJfk=
Date: Wed, 26 Aug 2009 18:14:52 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 08/12] add trace events for each syscall entry/exit
Message-ID: <20090826161449.GB6304@nowhere>
References: <20090825141547.GE6114@nowhere> <20090825160237.GG4639@cetus.boeblingen.de.ibm.com> <20090826123550.GD6009@nowhere> <20090826125943.GA5946@osiris.boeblingen.de.ibm.com> <20090826133019.GE6009@nowhere> <20090826141052.GB5946@osiris.boeblingen.de.ibm.com> <20090826142732.GA6304@nowhere> <alpine.DEB.2.00.0908261042250.23885@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908261042250.23885@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 10:43:01AM -0400, Steven Rostedt wrote:
> 
> On Wed, 26 Aug 2009, Frederic Weisbecker wrote:
> > > 
> > > Oh yes, you are right. kernel threads created with kernel_thread()
> > > have t->mm != NULL if the forking process has an mm too.
> > > 
> > > There are very few callsites left which still use kernel_thread().
> > > (the last one in s390 driver code will be gone after the next
> > > merge window).
> > > 
> > > As far as I can there are only four callsites left
> > > (excluding staging): jffs2 and three in net/bluetooth/*
> > 
> > 
> > In that case, I'd suggest to pick the patch that checks for
> > kernel threads while setting the TIF_FLAGS.
> > 
> > The check for invalid syscall numbers in another patch should be
> > sufficient to not crash.
> > 
> > We might have rare inaccurate result because of the remaining
> > buggy callsites but instead of working around on it, these
> > should be fixed.
> 
> Well, do these (buggy threads) call syscalls?
> 
> -- Steve
> 


That's not exactly what raises bugs because their syscalls
won't be traced. The problem occurs when the freshly created
kernel thread reaches ret_from_fork with its ->mm != NULL

It will take the trace_sys_exit() call and then will be traced
as a normal user thread.


