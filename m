Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbZAJSm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbZAJSm4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 13:42:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbZAJSmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 13:42:47 -0500
Received: from thunk.org ([69.25.196.29]:33367 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbZAJSmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 13:42:45 -0500
Date: Sat, 10 Jan 2009 13:42:40 -0500
From: Theodore Tso <tytso@mit.edu>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       ltt-dev@lists.casi.polymtl.ca,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [ltt-dev] Fw: [PATCH] ext4: Add markers for better
	debuggability
Message-ID: <20090110184240.GA31579@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Mathieu Desnoyers <compudj@krystal.dyndns.org>,
	KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
	ltt-dev@lists.casi.polymtl.ca,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>
References: <20090109170408.75C1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090109144901.GA7262@Krystal> <20090109185840.GD23869@mit.edu> <20090110161906.GB20526@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110161906.GB20526@Krystal>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2009 at 11:19:06AM -0500, Mathieu Desnoyers wrote:
> 
> I just ported LTTng to 2.6.28 yesterday and started doing the port of
> ext4/jbd2 to tracepoints. As you can see in my 0.74 announcement, the
> tracepoint work for both jbd2 and ext4 is done. I also did the lttng
> probe module for jbd2. Now I just have to create the probe module for
> ext4. I also want to create debugfs files to control per-probe module
> filtering, e.g. :
> 
> /mnt/debugfs/ltt/filter/jbd2/dev
> /mnt/debugfs/ltt/filter/ext4/dev
> 
> Where writing to it would add device names to the filter list. I would
> like a scheme where we can easily add/remove devices, list all
> devices... I think ftrace already has something similar for
> instrumentation activation.
> 
> The main question I am facing is : What interface semantic do we want
> for such filter control file ?

Hmm, we'll let's see.  The most common filtering restriction will be
by device, but I'll occasionally want to filter based on a single
inode; the next most common thing I could forsee wanting to do is to
filter on a based of inode numbers or on one or more block groups.
(This would be when trying to figure out what is going on with a
particular filesystem benchmark.)

Past a certain point, I recognize that I'll probably have to write a
custom probe module --- although I have to admit that's one of the
things that has spoiled me about SystemTap; it automates the job of
creating the custom probe modules, and allows me to create
turing-equivalent filtering and data collection.

So the question is where do we draw the line between the most common
filters that is worth putting into a probe module that goes into
mainline, versus what should be done via custome probe modules,
probably via modifying the probe module as an example.

If it's not too much trouble, being able to filter on a single device
(or report the data from all trace points) and filtering on a single
inode (or reporting all inodes) seems to make the most mount of sense.
Does tht seem reasonable to you?

The other question is how much data gets reported back; normally with
Systemtap I would report back to userspace only the bits that I needed
to debug whatever issue I was looking at.  However, with the LTTNG
approach, can we send back all of the bits of data tht was in the
markers?  It won't be needed for all problems, and I know that sending
too much data back will cause us to potentilly overflow the kernel
buffering, since there is a limited bandwidth of stuff we can send
back through the kernel<->user interface.  I'll have to admit to being
that well informed about LTTNG; what are the practical bandwidth
limitations that I should expect to see when it's in use?

Thanks, regards,

						- Ted

P.S.  At the kernel summit, there was some talk about a very
simplified interface that would allow us to extract text dumps from
tracepoints without having to download a huge userspace utility like
SystemTap --- or LTTng.  Has that been written yet, or is the only way
for me to use Tracepoints right now is to figure out how to use the
whole LTTng infrstructure?
