Return-Path: <linux-kernel-owner+w=401wt.eu-S1752553AbZFOAGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbZFOAGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 20:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbZFOAGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 20:06:01 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:56945 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbZFOAGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 20:06:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OxcaI676n77d8bHa3b3ESNx2VnSnswWjJ3twpnvZDZbFLWzDs8/H7focLjwj4Zsj/s
         e0BJ0aV259M3ZRQhBa5kSuoSKWojJajPDVeXXwOxVbaH+xFi+gxmVNN2paS/U7QvuHGb
         9Sa6htrdb7B1gSstXawlwokVZQCakkgeHSShE=
Date: Mon, 15 Jun 2009 02:05:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       Christoph Hellwig <hch@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 3/3] ring-buffer: add design document
Message-ID: <20090615000557.GB7918@nowhere>
References: <20090610195311.767699959@goodmis.org> <20090610195525.429316815@goodmis.org> <20090613015410.GB5234@nowhere> <alpine.DEB.2.00.0906122203100.16299@gandalf.stny.rr.com> <20090613223636.GB5986@nowhere> <alpine.DEB.2.00.0906140837370.16299@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906140837370.16299@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 08:39:03AM -0400, Steven Rostedt wrote:
> 
> On Sun, 14 Jun 2009, Frederic Weisbecker wrote:
> > > > > +
> > > > > +Now the writer can update the head page. This is also why the head page must
> > > > > +remain in UPDATE and only reset by the outer most writer. This prevents
> > > > > +the reader from seeing the incorrect head page.
> > > > > +
> > > > > +
> > > > > +(first writer)
> > > > > +
> > > > > +               A        B    tail page
> > > > > +               |        |        |
> > > > > +               v        v        v
> > > > > +    +---+    +---+    +---+    +---+
> > > > > +<---|   |--->|   |--->|   |--->|   |-H->
> > > > > +--->|   |<---|   |<---|   |<---|   |<---
> > > > > +    +---+    +---+    +---+    +---+
> > > > 
> > > > 
> > > > Even more tricky!
> > > > 
> > > > I just have a stupid question: why can't this be done
> > > > only through HEAD and NORMAL flags?
> > > > 
> > > > There is something certainly very obvious that I'm missing
> > > > with the point of the UPDATE flag.
> > > 
> > > If you can demonstrate how to do the above lockless with just HEAD and 
> > > NORMAL, then sure, I'm all ears ;-)
> > > 
> > > When we switch the HEAD to UPDATE, we stop the reader from moving forward 
> > > and being another thing to handle while we move the HEAD forward. A reader 
> > > does a cmpxchg to move the head too, and that cmpxchg will always fail if 
> > > the pointer is has UPDATE set. The reader will just spin until it 
> > > succeeds.
> > 
> > 
> > Aah, so it's here to protect against paralell readers from another cpu
> > reading the current cpu buffer, right?
> 
> Not readers, but reader. The reader side uses locks to serialize the
> accesses. The writer side is lockless.  But it is here to protect the 
> writers against a reader on another CPU.
> 
> -- Steve


Ok, my problem is that I've read this doc having in mind that the reader
we are talking about is always reading the buffer on the current cpu,
then a writer always preempt it. I forgot that a reader may also read
from another cpu.

Now I understand.

Thanks.

