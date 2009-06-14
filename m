Return-Path: <linux-kernel-owner+w=401wt.eu-S1758976AbZFNMjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976AbZFNMjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756606AbZFNMjF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:39:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:52305 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbZFNMjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:39:04 -0400
Date: Sun, 14 Jun 2009 08:39:03 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <20090613223636.GB5986@nowhere>
Message-ID: <alpine.DEB.2.00.0906140837370.16299@gandalf.stny.rr.com>
References: <20090610195311.767699959@goodmis.org> <20090610195525.429316815@goodmis.org> <20090613015410.GB5234@nowhere> <alpine.DEB.2.00.0906122203100.16299@gandalf.stny.rr.com> <20090613223636.GB5986@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 14 Jun 2009, Frederic Weisbecker wrote:
> > > > +
> > > > +Now the writer can update the head page. This is also why the head page must
> > > > +remain in UPDATE and only reset by the outer most writer. This prevents
> > > > +the reader from seeing the incorrect head page.
> > > > +
> > > > +
> > > > +(first writer)
> > > > +
> > > > +               A        B    tail page
> > > > +               |        |        |
> > > > +               v        v        v
> > > > +    +---+    +---+    +---+    +---+
> > > > +<---|   |--->|   |--->|   |--->|   |-H->
> > > > +--->|   |<---|   |<---|   |<---|   |<---
> > > > +    +---+    +---+    +---+    +---+
> > > 
> > > 
> > > Even more tricky!
> > > 
> > > I just have a stupid question: why can't this be done
> > > only through HEAD and NORMAL flags?
> > > 
> > > There is something certainly very obvious that I'm missing
> > > with the point of the UPDATE flag.
> > 
> > If you can demonstrate how to do the above lockless with just HEAD and 
> > NORMAL, then sure, I'm all ears ;-)
> > 
> > When we switch the HEAD to UPDATE, we stop the reader from moving forward 
> > and being another thing to handle while we move the HEAD forward. A reader 
> > does a cmpxchg to move the head too, and that cmpxchg will always fail if 
> > the pointer is has UPDATE set. The reader will just spin until it 
> > succeeds.
> 
> 
> Aah, so it's here to protect against paralell readers from another cpu
> reading the current cpu buffer, right?

Not readers, but reader. The reader side uses locks to serialize the
accesses. The writer side is lockless.  But it is here to protect the 
writers against a reader on another CPU.

-- Steve


> 
> 
> > Then, the rest of the moving of the header is just races with other 
> > writers that are always on the same CPU, and it becomes a recursive 
> > problem and not a parallel one.
