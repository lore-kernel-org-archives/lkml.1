Return-Path: <linux-kernel-owner+w=401wt.eu-S1754832AbZGON6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832AbZGON6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 09:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZGON6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 09:58:05 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:60179 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbZGON6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 09:58:04 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvYEAPJ2XUpMQWU3/2dsb2JhbACBUc8igkGBSAU
Date: Wed, 15 Jul 2009 09:57:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Robert Wisniewski <bob@watson.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: LTTng 0.146, adds extra read-side sub-buffer for flight
	recorder
Message-ID: <20090715135747.GA6972@Krystal>
References: <20090713071440.GA32730@Krystal> <alpine.DEB.2.00.0907141824200.32740@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0907141824200.32740@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:53:10 up 137 days, 10:19,  4 users,  load average: 0.83, 0.56,
	0.28
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> 
> On Mon, 13 Jul 2009, Mathieu Desnoyers wrote:
> 
> > Hi,
> > 
> > So, I needed a weekend break from writing my thesis (It's almost over!) ;)
> > and I had the great idea to try to come up with a way to ensure that
> > LTTng flight recorder mode permits to have a read-side that never sees
> > corrupted data.
> > 
> > Basically, this is the main thing Steven have been asking me for a
> > while. And it looks like I just figured out a way to do it.
> > 
> > So for flight recorder tracing, this new LTTng version allocates an
> > extra subbuffer which gets exchanged by the reader with the writer
> > subbuffer before it gets read.
> > 
> > Normal tracing does not need this extra subbuffer, because the
> > write-side just drops events when the buffer is full. So we don't
> > allocate it and we don't perform any exchange. The space
> > reservation/commit code plays nicely with both flight recorder and
> > normal tracing schemes.
> > 
> > Here is how I did it:
> > 
> > No modification was required to the buffer space reservation/commit
> > algorithm. I just had to do the following at the backend level
> > (responsible for writing data to/reader data from the buffer):
> > 
> > I am using an array of pointers (one pointer for each subbuffer), plus a
> > pointer to the reader subbuffer. Each of these pointers are pointing to
> > an array of pages, which are all the pages that constitute a subbuffer.
> > Reads/writes from/to the buffer are done by accessors which pick up the
> > right page location within this page table. By modifying the top-level
> > subbuffer pointer, we can swap a whole subbuffer in a single operation.
> > 
> > There is a trick to deal with concurrency between writer and reader.
> > When the top-level subbuffer pointers are not used (no writer is
> > currently writing into it, no reader is reading from its subbuffer), we
> > set a RCHAN_NOREF_FLAG (value: 0x1) which indicates that no reference is
> > currently taken to this subbuffer. As long as this flag is set in the
> > pointer, it is safe for the reader to exchange it. When the writer needs
> > to access this subbuffer for writing, it clears the flag, and sets it
> > back after committing the last piece of data to it.
> > 
> > When the reader figures out that the write-side subbuffer it is trying
> > to exchange has a reference, it fails with -EAGAIN.
> > 
> > Nice things about the way I do it here:
> > 
> > - I keep the separation between the space reservation layer and back-end
> >   buffer layer. The extra reader subbuffer exchange is done at the
> >   back-end layer. The reason why it took me so long to try to come up
> >   with something is that I tried to do it at the space reservation
> >   layer, which was not fitting well the space reservation semantics.
> > 
> > - Keeping space reservation and physical buffer management separate
> >   helps splitting complexity into sub-layers easier to verify.
> > 
> > - Given the space reservation/commit is separate from the subbuffer
> >   exchange per se, I don't need any special-cases for "if the tail
> >   pointer is in the reader page".... these things never happen because
> >   the reserve, commit and consumed counts are completely unrelated to
> >   the pointers to physical subbuffers.
> 
> I don't yet have time to read the patches (not this week, anyway), but I'm 
> assuming that you can only get the new page (swap) while a writer is not 
> writing to it. Thus if it is not a full page, then you must either copy 
> the data, or swap out a non full page. Not complaining here, just trying 
> to understand it :-)
> 
> Thus the trick is that you have a series of pointers to the data, and you 
> swap out the data and not the list?  Hmm, actually the ring buffer is 
> already like that and I probably could do the same.
> 
> Here's another thing that the ring buffer does (and makes things a little 
> complex too) is that it keeps track of the number of entries in the buffer 
> as well as the number of overruns. The number of entries in the page is 
> kept in the list data and not the data page itself.
> 
> Using a special flag to switch out the data instead of breaking the link 
> list may make things much simpler.
> 
> Hmm, I'll take a round to make the ring buffer closer to what you have 
> done. At this rate, we may finally merge the two to handle things that we 
> both need ;-)
> 

BTW, I just fixed a race I thought about in the commit path. Basically,
I had to find a way to make the subbuffer delivery happen only once per
subbuffer written without adding a local_add_return to the commit fast
path. I did it with a local_cmpxchg done only at potential subbuffer
delivery. It's detailed in the header of

lttng-relay-lockless-writer-use-noref-flag.patch

of LTTng 0.147.

Mathieu

> -- Steve
> 
> 
> > 
> > As always, the tree is available at:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/compudj/linux-2.6-lttng.git
> > git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-lttng.git
> > 
> > The commits implementing this the extra reader page for the lockless
> > scheme are:
> > 
> > lttng-relay-per-subbuffer-index.patch
> > lttng-relay-per-subbuffer-index-low-bit-noref.patch
> > lttng-relay-lockless-writer-use-noref-flag.patch
> > lttng-relay-default-sb-index-to-noref.patch
> > lttng-relay-lockless-exchange-reader-writer-pages.patch
> > 
> > Comments are welcome,
> > 
> > Thanks,
> > 
> > Mathieu
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
