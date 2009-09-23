Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbZIWPit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbZIWPit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 11:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbZIWPit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 11:38:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38661 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbZIWPis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 11:38:48 -0400
Date: Wed, 23 Sep 2009 17:38:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch] introduce TRACE_EVENT_ABI (was Re: TRACE_EVENT_ABI ?)
Message-ID: <20090923153834.GA6105@elte.hu>
References: <20090923124340.GA6093@infradead.org> <1253714632.4498.3.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253714632.4498.3.camel@frodo>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 2009-09-23 at 08:43 -0400, Christoph Hellwig wrote:

> > I'm not sure we can support any as an ABI yet.  The text format 
> > seems to volatile in general - not just the output of the individual 
> > trace events but also the common file format, and for the binary 
> > format we need to figure a good way to tag the output yet.  Also 
> > when we define one as one ABI we should make very clear what that 
> > means, e.g. does it have to stay exactly as is?  Or can we add new 
> > fields but not remove old one?
> 
> I had this discussion with people in Portland. We seem to agree that 
> this should just lock the old fields in, but you can add new ones at 
> the end.

Yeah, that's the sanest approach i was thinking about when i suggested 
TRACE_EVENT_ABI() to Arjan and Peter.

The raw record is opaque, comes with a length field and goes into the 
ring-buffer so it's nicely extensible. Existing bits shouldnt change.

User-space that relies on a record can define a structure of that and 
copy that over from the ring-buffer - and ignore any new bits.

What i'd also like to see is the use of typical ABI-safe type fields in 
the trace definitions themselves: u8, u32, u64, etc. 'long' is obviously 
not good. Could we do some automation for that perhaps? I.e. emit a 
warning (boot time or so) if TRACE_EVENT_ABI() is used with unsafe type 
fields.

( Endianness is another detail, if perf.data is shipped to a
  different-endian system. Best is probably to define a new perf.data
  attribute extension with the endianness of the generator system
  included. That way the perf.data parser can convert endianness if it 
  wants/needs to. )

	Ingo
