Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbZIWQQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbZIWQQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751955AbZIWQQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:16:33 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:39283 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751698AbZIWQQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:16:32 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArsFAM7juUpMROOX/2dsb2JhbACBUtYIhBsF
Date: Wed, 23 Sep 2009 12:16:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] introduce TRACE_EVENT_ABI (was Re: TRACE_EVENT_ABI ?)
Message-ID: <20090923161634.GA4854@Krystal>
References: <20090923124340.GA6093@infradead.org> <1253714632.4498.3.camel@frodo> <20090923153834.GA6105@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090923153834.GA6105@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 12:12:51 up 36 days,  3:02,  3 users,  load average: 0.28, 0.23,
	0.19
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Wed, 2009-09-23 at 08:43 -0400, Christoph Hellwig wrote:
> 
> > > I'm not sure we can support any as an ABI yet.  The text format 
> > > seems to volatile in general - not just the output of the individual 
> > > trace events but also the common file format, and for the binary 
> > > format we need to figure a good way to tag the output yet.  Also 
> > > when we define one as one ABI we should make very clear what that 
> > > means, e.g. does it have to stay exactly as is?  Or can we add new 
> > > fields but not remove old one?
> > 
> > I had this discussion with people in Portland. We seem to agree that 
> > this should just lock the old fields in, but you can add new ones at 
> > the end.
> 
> Yeah, that's the sanest approach i was thinking about when i suggested 
> TRACE_EVENT_ABI() to Arjan and Peter.
> 
> The raw record is opaque, comes with a length field and goes into the 
> ring-buffer so it's nicely extensible. Existing bits shouldnt change.
> 
> User-space that relies on a record can define a structure of that and 
> copy that over from the ring-buffer - and ignore any new bits.
> 
> What i'd also like to see is the use of typical ABI-safe type fields in 
> the trace definitions themselves: u8, u32, u64, etc. 'long' is obviously 
> not good. Could we do some automation for that perhaps? I.e. emit a 
> warning (boot time or so) if TRACE_EVENT_ABI() is used with unsafe type 
> fields.
> 
> ( Endianness is another detail, if perf.data is shipped to a
>   different-endian system. Best is probably to define a new perf.data
>   attribute extension with the endianness of the generator system
>   included. That way the perf.data parser can convert endianness if it 
>   wants/needs to. )
> 

You can ship sizeof(long) along with the endianness information to
access "long" typed variables from the parser too. If we export this
information, then I don't see how exporting a 'long' variable would be
obviously not good. It would become as portable as u32 or u64, yet more
efficient when only the space for a 'long' record is required. Same
applies to pointers, obviously.

All we need is a small "accessor" library to deal with the type size and
endianness issues.

Mathieu

> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
