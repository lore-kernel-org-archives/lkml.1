Return-Path: <linux-kernel-owner+w=401wt.eu-S1761918AbZEAR4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761918AbZEAR4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756028AbZEAR4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:56:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:37453 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757525AbZEAR4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:56:40 -0400
Date: Fri, 1 May 2009 13:56:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3] ring-buffer: make cpu buffer entries counter
 atomic
In-Reply-To: <20090501174228.GB9565@elte.hu>
Message-ID: <alpine.DEB.2.00.0905011351520.20374@gandalf.stny.rr.com>
References: <20090501022403.826182932@goodmis.org> <20090501115047.GA24706@elte.hu> <alpine.DEB.2.00.0905011016560.20374@gandalf.stny.rr.com> <alpine.DEB.2.00.0905011212130.20374@gandalf.stny.rr.com> <20090501162053.GA17915@elte.hu>
 <alpine.DEB.2.00.0905011230350.20374@gandalf.stny.rr.com> <20090501165258.GA26143@elte.hu> <alpine.DEB.2.00.0905011302150.20374@gandalf.stny.rr.com> <20090501171437.GA5932@elte.hu> <alpine.DEB.2.00.0905011335320.20374@gandalf.stny.rr.com>
 <20090501174228.GB9565@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 1 May 2009, Ingo Molnar wrote:
> > 
> > Ah, maybe there's confusion in my explanation. When I talk about 
> > writers and readers, I'm talking about those writers into the ring 
> > buffer and readers from the ring buffer. But both writers and 
> > readers write to the entries counter. Readers subtract and writers 
> > add. But writers can also subtract on overruns.
> 
> a solution for that would be to split it into two counts - for both 
> sides. Or to eliminate it if possible. We _really_ need to make the 
> ring-buffer _much_ cheaper than it is today.

I was thinking the same thing :-)

Actually we would have three counters. All incremental.

	entries
	overruns
	read

The writer when adding an entry would increment entries

The writer when overwriting will increment overruns

The reader would increment read.

We could even make it 64 bits (or more) on all archs. Heck, make it two 
longs (128 bits for 64 bit archs). Since we only need to worry about 
interrupts, we only increment the second counter if we wrapped the first. 
I doubt a single interrupt (or many) could wrap the first counter. If it 
could, we have more to worry about than counters.

Thus the number of entries in the buffer would be:

	(entries - overruns) - read

-- Steve

