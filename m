Return-Path: <linux-kernel-owner+w=401wt.eu-S1760163AbZFJQDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760163AbZFJQDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 12:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756663AbZFJQDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 12:03:45 -0400
Received: from thunk.org ([69.25.196.29]:55334 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553AbZFJQDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 12:03:45 -0400
Date: Wed, 10 Jun 2009 12:03:03 -0400
From: Theodore Tso <tytso@mit.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Christoph Hellwig <hch@infradead.org>, Rik van Riel <riel@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH 00/11] [GIT PULL] more updates for the tag format
Message-ID: <20090610160303.GA10240@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	=?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
	Christoph Hellwig <hch@infradead.org>,
	Rik van Riel <riel@redhat.com>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Peter Zijlstra <peterz@infradead.org>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	Lai Jiangshan <laijs@cn.fujitsu.com>,
	Zhaolei <zhaolei@cn.fujitsu.com>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	Jason Baron <jbaron@redhat.com>,
	Jiaying Zhang <jiayingz@google.com>,
	Tom Zanussi <tzanussi@gmail.com>,
	Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
References: <20090610054206.510574695@goodmis.org> <20090610092644.GA20889@elte.hu> <c62985530906100411o5a178352n53f7d247f6e9dba9@mail.gmail.com> <20090610130127.GA6647@mit.edu> <alpine.DEB.2.00.0906100911190.30552@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0906100911190.30552@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 09:49:29AM -0400, Steven Rostedt wrote:
> > 
> > Maybe I'm missing something, but looks like the this new format, while
> > simpler and easier to read, doesn't have support for using a more
> > complicated C expression as a printk argument.  For example:
> > 
> > 	TP_printk("dev %s ino %lu mode %d uid %u gid %u blocks %llu",
> > 		  jbd2_dev_to_name(__entry->dev), __entry->ino, __entry->mode,
> > 		  __entry->uid, __entry->gid, __entry->blocks)
> > 
> > How should I handle the "jbd2_dev_to_name(__entry->dev)" argument to
> > TP_printk?  The whole point of calling jbd2_dev_to_name() at TP_printk
> > time is to not bloat the ring buffer with a 32 byte devname.
> 
> Understood, and the example you just gave also has the flaw that a 
> userspace tool could not parse it, because it would not know what to do 
> with "jbd2_dev_to_name()".
> 
> This is why I suggested keeping the TP_printk, for cases like this. Since 
> it is also currently useless in userspace.
> 
> But we really should convert all cases, and I was toying with an idea to 
> dynamically make your own data type, and be able to make a way to print 
> it.

Yes, another approach for handling this case would be to take my
"jbd2_dev_to_name" function and support it as a first-class tagged
type; after all, I'm sure ext4 won't be the only place that would like
to take a dev_t and print the device name.  So this could certainly be
fixed by adding some kind of "<dev:xxx>" sort of tagged name.

But I think it would be good to keep TP_printk because otherwise I'll
have to scramble and change my marker->tracepoint patches during the
merge window, which would invalidate all of the testing to date.

I agree that the new tagged format is superior, but I'm wondering
whether it really makes sense to try to scramble and try to switch my
ext4/jbd2 users in the 36 hours or so before Linus opens the merge
window....

						- Ted
