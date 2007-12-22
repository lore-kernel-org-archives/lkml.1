Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbXLVSCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbXLVSCq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 13:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbXLVSCh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 13:02:37 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55200 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbXLVSCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 13:02:37 -0500
Date: Sat, 22 Dec 2007 10:01:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <andi@firstfloor.org>, Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
In-Reply-To: <20071222100326.GF26157@elte.hu>
Message-ID: <alpine.LFD.0.9999.0712220937560.21557@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com> <20071221120908.GA15926@elte.hu> <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com> <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org>
 <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com> <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy> <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com> <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de>
 <20071222100326.GF26157@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 22 Dec 2007, Ingo Molnar wrote:
> > 
> > It's definitely not a stable ABI. slabtop tends to exit without any 
> > error message on any slabinfo version number increase and I've seen 
> > that happen several times in not so old kernels.
> 
> so because we sucked in the past we can continue to suck? ;)

Well, I do have to admit that I'm not a huge fan of /proc/slabinfo, and 
the fact that there hasn't been a lot of complaints about it going away 
does seem to imply that it wasn't a very important ABI.

I'm the first to stand up for backwards compatibility, but I also try to 
be realistic, and so far nobody has really complained about the fact that 
/proc/slabinfo went away on any grounds but on the general principle of 
"it was a user-visible ABI".

We've changed user-visible ABI's in the past in the hope that they weren't 
actually used. Sometimes it worked, sometimes it didn't. In this case, I 
think it still has the potential of working.

That said, I'm not a *huge* fan of /sys/slab/ either. I can get the info I 
as a developer tend to want from there, but it's really rather less 
convenient than I'd like. It is really quite hard, for example, to get any 
kind of "who actually uses the most *memory*" information out of there. 

You have to use something like this:

	for i in *
	do
		order=$(cat "$i/order")
		slabs=$(cat "$i/slabs")
		object_size=$(cat "$i/object_size")
		objects=$(cat "$i/objects")
		truesize=$(( $slabs<<($order+12) ))
		size=$(( $object_size*$objects ))
		percent=$(( $truesize/100 ))
		if [ $percent -gt 0 ]; then
			percent=$(( $size / $percent ))
		fi
		mb=$(( $size >> 10 ))
		printf "%10d MB %3d %s\n" $mb $percent $i
	done | sort -n | tail

which works fine, but while it's actually _much_ more readable than doing 
the same thing with /proc/slabinfo was, I worry about the lack of 
atomicity in getting the statistics.

I dunno. I do think /sys/slab/ is a better interface than /proc/slabinfo 
was. I just wonder if it could be better still.

			Linus
