Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbZDOKc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbZDOKc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZDOKcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:32:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34255 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007AbZDOKcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:32:19 -0400
Date: Wed, 15 Apr 2009 12:32:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <srostedt@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] ring_buffer: enlarge RB_MAX_SMALL_DATA
Message-ID: <20090415103210.GG6669@elte.hu>
References: <49E2AAB3.9010801@cn.fujitsu.com> <1239633781.21121.25.camel@localhost.localdomain> <49E5A593.6090605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E5A593.6090605@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Steven Rostedt wrote:
> > On Mon, 2009-04-13 at 11:00 +0800, Lai Jiangshan wrote:
> >> When I am writing userspace tools for ftrace, I found
> >> RB_MAX_SMALL_DATA is too small, some events waste an 'u32'
> >> to save the actually length.
> > 
> > Although I like the idea, I want to look at something else.
> > 
> > 2^27 is: 134,217,728
> > 2^26 is: 67,108,864
> > 
> > That is the count in nanoseconds. Thus we go from 134 millisecs to 67
> > millisecs before we must add an extended counter.
> > 
> > I guess that is not an issue, since 67ms is still quite big. For sparse
> > tracing, it could add more extended counters where none were needed. But
> > this I doubt this is an issue.
> 
> 67ms < 0.1sec, It sounds not very good.
> 
> > 
> >> This fix will break previous userspace tools,
> >> so complaints are also welcome.
> > 
> > Unfortunately, this changes the API to userspace. For those parsers that
> > do this in binary. I think the answer is, before we add this, we export
> > the format of the ring buffer headers just like we do for other formats.
> > This way, a user tool can default to the old way if the format file does
> > not exist, and can know the current format with the file.
> > 
> > I'll work on adding that format file sometime this week.
> >
> 
> I think ftrace is still in develop-circle, changing its API to 
> userspace is sometimes OK. Will you agreed this fix after you add 
> that format file? It saves about 0%-12%(depends on tracer) memory.

Yes, /debug APIs can be changed indeed.

And compressing tracer memory consumption is a high priority design 
target: lower memory consumption doesnt just mean less RAM footprint 
and less disk footprint, it also means less CPU cache footprint, 
less intrusive tracing, faster tracing, etc. etc.

So compression is a very important goal - and we only want to stop 
doing it when the direct CPU overhead or the compression complexity 
it introduces offsets the size win. In this particular case we are 
still far from that cutoff point IMHO.

	Ingo
