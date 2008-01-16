Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbYAPXur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbYAPXur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 18:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751340AbYAPXuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 18:50:37 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:63068 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbYAPXug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 18:50:36 -0500
Date: Wed, 16 Jan 2008 18:50:26 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
In-Reply-To: <20080116233927.GB23895@Krystal>
Message-ID: <Pine.LNX.4.58.0801161845130.17781@gandalf.stny.rr.com>
References: <20080109233044.777564395@goodmis.org> <20080115214636.GD17439@Krystal>
 <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com> <20080115220824.GB22242@Krystal>
 <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com> <20080116031730.GA2164@Krystal>
 <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com> <20080116145604.GB31329@Krystal>
 <1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com>
 <1200523867.6127.5.camel@localhost.localdomain> <20080116233927.GB23895@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 16 Jan 2008, Mathieu Desnoyers wrote:
>
> > -	cycle_t offset = (now - cs->cycle_last) & cs->mask;
> > +	/* First update the monotonic base portion.
> > +	 * The dual array update method allows for lock-free reading.
> > +	 */
> > +	int num = !cs->base_num;
> > +	cycle_t offset = (now - cs->base[!num].cycle_base_last);
>
> !0 is not necessarily 1. This is why I use cpu_synth->index ? 0 : 1 in

How about simply "cpu_synth->index ^ 1"? Seems the best choice if you ask
me, if all you are doing is changing it from 1 to zero and back to 1.

-- Steve

> my code. The two previous lines seems buggy. (I did the same mistake in
> my first implementation) ;)
>
> > +	offset &= cs->mask;
> > +	cs->base[num].cycle_base = cs->base[!num].cycle_base + offset;
>
> Here too.
