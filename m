Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbYI3DqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbYI3DqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 23:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYI3DqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 23:46:08 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:54568 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264AbYI3DqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 23:46:07 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuYEAHQ44UhMQWq+/2dsb2JhbACBZLobgWc
Date: Mon, 29 Sep 2008 23:46:03 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Martin Bligh <mbligh@google.com>,
       Christoph Hellwig <hch@infradead.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v10 Golden] Unified trace buffer
Message-ID: <20080930034603.GA13801@Krystal>
References: <alpine.DEB.1.10.0809261245420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261349400.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809261631420.21618@gandalf.stny.rr.com> <alpine.DEB.1.10.0809262148070.30105@gandalf.stny.rr.com> <alpine.DEB.1.10.0809270203270.1628@gandalf.stny.rr.com> <alpine.DEB.1.10.0809291202180.5493@gandalf.stny.rr.com> <20080929233539.GA31143@Krystal> <alpine.DEB.1.10.0809292000160.8145@gandalf.stny.rr.com> <20080930000307.GA2929@Krystal> <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0809292010530.8145@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 23:42:57 up 117 days,  8:23, 10 users,  load average: 1.88, 2.21,
	1.42
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Mon, 29 Sep 2008, Mathieu Desnoyers wrote:
> > > 
> > > Thanks! I must have been lucky some how not to trigger this :-/
> > > 
> > 
> > My guess is that you never free your buffers in your test cases. I don't
> > know if it was expected; probably not if your code is built into the
> > kernel.
> 
> Actually my resize does free the buffers and I did test this. I probably 
> never ran the trace when testing the freeing which means those pointers 
> could have luckily not have been changed.
> 
> -- Steve
> 

I also got some corruption of the offset field in the struct page I use.
I think it might be related to the fact that I don't set the PG_private
bit (slob does set it when the page is in its free pages list). However,
given I'd like to pass the buffer pages to disk I/O and for network
socket and still keep the ability to re-use it when the I/O has been
performed, I wonder where I should put my 

                       struct list_head list;  /* linked list of buf pages */
                       size_t offset;          /* page offset in the buffer */

fields ? Any ideas ?

They are currently in :

struct buf_page {
        union {
                struct {
                        unsigned long flags;    /* mandatory */
                        atomic_t _count;        /* mandatory */
                        union {                 /* mandatory */
                                atomic_t _mapcount;
                                struct {
                                        u16 inuse;
                                        u16 objects;
                                };
                        };
                        struct list_head list;  /* linked list of buf pages */
                        size_t offset;          /* page offset in the buffer */
                };
                struct page page;
        };
};

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
