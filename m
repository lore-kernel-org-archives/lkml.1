Return-Path: <linux-kernel-owner+w=401wt.eu-S1753170AbYKYHKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170AbYKYHKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 02:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYKYHJ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 02:09:59 -0500
Received: from tomts20.bellnexxia.net ([209.226.175.74]:40179 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752632AbYKYHJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 02:09:57 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsoEAC8yK0lMROB9/2dsb2JhbACBbdADgnw
Date: Tue, 25 Nov 2008 02:09:55 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@osdl.org>, ltt-dev@lists.casi.polymtl.ca,
       Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [ltt-dev] LTTng kernel integration roadmap, update
Message-ID: <20081125070955.GA24292@Krystal>
References: <20081124112842.GA15615@Krystal> <20081124114124.GA32459@infradead.org> <20081124122055.GA18626@Krystal> <alpine.DEB.1.10.0811241156030.20122@gandalf.stny.rr.com> <20081124204622.GA6229@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081124204622.GA6229@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 01:58:12 up 8 days,  7:38,  2 users,  load average: 0.69, 0.55,
	0.39
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (compudj@krystal.dyndns.org) wrote:
> * Steven Rostedt (rostedt@goodmis.org) wrote:
> > 
> > On Mon, 24 Nov 2008, Mathieu Desnoyers wrote:
> > > 
> > > The key idea behind this is to answer to Thomas Gleixner concerns, who
> > > supports that a tracer should output data in text-format only so it can
> > > be used with tools kernel developers have on their system, like "cat".
> > > 
> > > However, getting data out of the kernel efficiently simply cannot be
> > > done with such approach. Therefore, LTTng needs its own userspace tools
> > > to splice the data out of the kernel efficiently. Another tool is used
> > > to pretty-print the binary data into text.
> > > 
> > > Then the problem becomes : we have to make the userspace tool easy
> > > enough to deploy so even Linus can find and use it. ;)
> > > 
> > > But indeed, the trace buffers are versioned, so if the format changes
> > > between kernel versions, the userspace tools will detect it and the user
> > > will know it must update its tools. So it's not really a problem there.
> > > 
> > > The question that prevails is therefore : should we ship userspace
> > > binary with the kernel tree at all ? And if yes, how should the resuting
> > > executables be packaged and deployed ? Should it be installed in the
> > > system along with kernel modules or should it be populated into a
> > > filesystem populated by kernelspace ?
> > > 
> > > Or is it better to do as we have always done and keep the userspace
> > > tools separated from the kernel tree ?
> > 
> > I say keep the user space tools separate as much as possible.
> > 
> 
> I'd be in favor of that too. We should just document and package it so
> it's easy to find.
> 
> > What about having a meta-data file for all binary files. This meta-data 
> > could explain the format that is read. Big endian, little endian, the 
> > fields and offsets, the event ids etc.  This way we will not need a 
> > "version" file, which means absolutely nothing if you do not know what 
> > comes with that version. Any tool could look at the meta-data file and 
> > figure out what is in the buffers.
> > 
> > -- Steve
> 
> This is exactly what I do in LTTng, modulo the fact that I repeat this
> information also in other buffer headers, but only use the information
> located in the metadata buffer header. I duplicated the information to
> make sure all subbuffer headers looks the same, but I could easily
> change that.
> 
> I would however keep a small subbuffer header with a version number for
> each subbuffers though, just so the parser can "know" what file this is
> and what metadata should be expected with it. I think about the poor
> user who lost its metadata file and wonders what tool could open the
> other tracefiles he has... without a header containing at least a magic
> number and a version, those files won't be identified. But we can keep
> this information as minimalistic as possible.
> 

I now remember why I duplicate the endianness and the type size
information in the subbuffer header.

The main use-case for this is userspace tracing on a mixed 32/64-bits
system, where I'd like to be able to write from a 32-bits userspace
program directly into their own memory buffers. I would therefore have
one "channel" per process, or something like that. The thing is : I have
to know the pointer size so I know how the event headers are aligned in
the traces. However, with mixed 32/64-bits processes, I would happen to
have specific data types for specific channels (note that size_t is also
special : it changes depending on the compiling options for 32-bits
executables). Therefore, it seems to make sense to export this type of
information directly in the subbuffer headers.

I think we can still iterate on the userspace tracing aspects of tracing
later on, so we don't have to come up with a "perfect solution" right
now. I just want us to keep an open mind for the requirements that will
come with its implementation and try to plan a little bit ahead.

Mathieu

> Thanks for the feedback.
> 
> Mathieu
> 
> -- 
> Mathieu Desnoyers
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
