Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbXLVKEM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbXLVKEM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 05:04:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbXLVKD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 05:03:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40169 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbXLVKD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 05:03:57 -0500
Date: Sat, 22 Dec 2007 11:03:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major regression on hackbench with SLUB (more numbers)
Message-ID: <20071222100326.GF26157@elte.hu>
References: <Pine.LNX.4.64.0712132010470.30903@schroedinger.engr.sgi.com> <20071221120908.GA15926@elte.hu> <Pine.LNX.4.64.0712210750510.29372@schroedinger.engr.sgi.com> <alpine.LFD.0.9999.0712210835440.21557@woody.linux-foundation.org> <Pine.LNX.4.64.0712211356220.3795@schroedinger.engr.sgi.com> <1198275391.30889.3.camel@lappy> <1198275453.30889.4.camel@lappy> <Pine.LNX.4.64.0712211422540.3795@schroedinger.engr.sgi.com> <20071221225413.GA26189@elte.hu> <p731w9ffu8c.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p731w9ffu8c.fsf@bingen.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > Christoph, /proc/slabinfo is an _ABI_. You HAVE to provide it. 
> > slabtop relies on it, people use it every day to monitor memory 
> > consumption.
> 
> It's definitely not a stable ABI. slabtop tends to exit without any 
> error message on any slabinfo version number increase and I've seen 
> that happen several times in not so old kernels.

so because we sucked in the past we can continue to suck? ;)

Why are we still arguing about this? We kernel developers are foxes 
amongst the hens and if a compatibility issue comes up we have to act 
_doubly_ conservatively.

You think it's reasonable to not offer /proc/slabinfo? You can fairly 
assume that a user considers it absolutely unreasonable. If other kernel 
developers tell you: "no, it's fine", then it's as if other foxes told 
you "no, it's fine to eat that hen, we do it all the time too!" ;-)

> Requiring just another slabtop update isn't really a big deal.

certainly. But consider this from the user's perspective who tries one 
of our devel kernels. He suspects a memory leak. Runs slabtop and 
gets:

 $ slabtop
 fopen /proc/slabinfo: No such file or directory

and would fairly conclude: "ok, this new Linux kernel looks quite 
apparently unfinished, i'm outta here".

We do this way too frequently and many silly details like this _do_ 
mount up.

> Also it's not that it's a critical functionality like udev.

Sure, we can argue about details that not all fields in /proc/slabinfo 
are relevant, and that slabtop should be a bit more careful, etc., but 
we've got what we've got because _we_ built the current code, so we 
might as well accept the consequences it brings. The most of the basic 
output of slabtop:

 Active / Total Objects (% used)    : 648754 / 747076 (86.8%)
 Active / Total Slabs (% used)      : 39394 / 39394 (100.0%)
 Active / Total Caches (% used)     : 103 / 143 (72.0%)
 Active / Total Size (% used)       : 138884.36K / 151075.96K (91.9%)
 Minimum / Average / Maximum Object : 0.01K / 0.20K / 128.00K

   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
 261928 239808  91%    0.13K   9032       29     36128K dentry_cache
 222048 174144  78%    0.05K   3084       72     12336K buffer_head
 187232 178929  95%    0.48K  23404        8     93616K ext3_inode_cache
  24416  17908  73%    0.27K   1744       14      6976K radix_tree_node

could be offered on SLUB too.

'top' isnt critical functionality either like udev, and the ABI does not 
only cover 'critical' functionality. A utility suddenly not working 
gives Linux a pretty amateurish feeling. Should we tell users/admins: 
"Hehe, gotcha! Didnt you know /proc/slabinfo was not an ABI? Poor sob. 
If you want your stuff to continue working, use Windows next time around 
or what. Sheesh, what do these people want!' ;-)

the rule is very simple: unless you have really, really, really, REALLY 
good reasons, just dont break stuff.

	Ingo
