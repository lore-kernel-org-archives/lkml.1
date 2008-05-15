Return-Path: <linux-kernel-owner+w=401wt.eu-S1764752AbYEOUOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764752AbYEOUOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbYEOUOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:14:31 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34279 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbYEOUOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:14:30 -0400
Date: Thu, 15 May 2008 14:14:13 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Lameter <clameter@sgi.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
Message-ID: <20080515201413.GT9921@parisc-linux.org>
References: <Pine.LNX.4.64.0805141100110.15633@schroedinger.engr.sgi.com> <1210822002.3177.121.camel@ymzhang> <Pine.LNX.4.64.0805151002420.18354@schroedinger.engr.sgi.com> <20080515174953.GN9921@parisc-linux.org> <Pine.LNX.4.64.0805151054250.18991@schroedinger.engr.sgi.com> <20080515181356.GP9921@parisc-linux.org> <Pine.LNX.4.64.0805151141510.19915@schroedinger.engr.sgi.com> <20080515185130.GR9921@parisc-linux.org> <Pine.LNX.4.64.0805151153440.20201@schroedinger.engr.sgi.com> <20080515192959.GS9921@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080515192959.GS9921@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2008 at 01:29:59PM -0600, Matthew Wilcox wrote:
> On Thu, May 15, 2008 at 12:09:06PM -0700, Christoph Lameter wrote:
> > Assumptions may be the issue. My own "reproducer" for remote frees is 
> > available from my git tree and I usually prefer to run my own. We 
> 
> No doubt you prefer to run a test which fails to show a problem with
> your code.  How about you try running a test which does show a problem?

This is rather interesting.  Since Christoph refuses to, here's my
results with 8f40f67, first with slab:

willy@piggy:~$ sudo ./io-gen -d /dev/sda -j4
CPU 0 completed 1000000 ops in 52.817 seconds; 18933 ops per second
CPU 2 completed 1000000 ops in 56.391 seconds; 17733 ops per second
CPU 3 completed 1000000 ops in 57.009 seconds; 17541 ops per second
CPU 1 completed 1000000 ops in 57.591 seconds; 17363 ops per second
willy@piggy:~$ sudo taskset -p 1 941
pid 941's current affinity mask: f
pid 941's new affinity mask: 1
willy@piggy:~$ sudo ./io-gen -d /dev/sda -j4
CPU 2 completed 1000000 ops in 46.740 seconds; 21394 ops per second
CPU 0 completed 1000000 ops in 48.716 seconds; 20527 ops per second
CPU 3 completed 1000000 ops in 59.255 seconds; 16876 ops per second
CPU 1 completed 1000000 ops in 60.473 seconds; 16536 ops per second

(the pid is that of scsi_ram_0)

Now, change the config to slub:

--- 64-slab/.config     2008-05-15 15:21:31.000000000 -0400
+++ 64-slub/.config     2008-05-15 15:37:45.000000000 -0400
-# Thu May 15 15:21:31 2008
+# Thu May 15 15:37:45 2008
-CONFIG_SLAB=y
-# CONFIG_SLUB is not set
+CONFIG_SLUB_DEBUG=y
+# CONFIG_SLAB is not set
+CONFIG_SLUB=y
-# CONFIG_DEBUG_SLAB is not set
+# CONFIG_SLUB_DEBUG_ON is not set
+# CONFIG_SLUB_STATS is not set

and we get slightly better results:

willy@piggy:~$ sudo ./io-gen -d /dev/sda -j4
CPU 0 completed 1000000 ops in 45.848 seconds; 21811 ops per second
CPU 2 completed 1000000 ops in 50.789 seconds; 19689 ops per second
CPU 3 completed 1000000 ops in 55.876 seconds; 17896 ops per second
CPU 1 completed 1000000 ops in 56.941 seconds; 17562 ops per second
willy@piggy:~$ sudo taskset -p 1 1001
pid 1001's current affinity mask: f
pid 1001's new affinity mask: 1
willy@piggy:~$ sudo ./io-gen -d /dev/sda -j4
CPU 2 completed 1000000 ops in 45.713 seconds; 21875 ops per second
CPU 0 completed 1000000 ops in 47.020 seconds; 21267 ops per second
CPU 3 completed 1000000 ops in 58.692 seconds; 17038 ops per second
CPU 1 completed 1000000 ops in 60.389 seconds; 16559 ops per second

Slub's clearly in the lead, right?  Maybe.  Here's the results we get
with 2.6.25+slab:

willy@piggy:~$ sudo ./io-gen -d /dev/sda -j4
CPU 3 completed 1000000 ops in 48.709 seconds; 20530 ops per second
CPU 1 completed 1000000 ops in 50.181 seconds; 19927 ops per second
CPU 0 completed 1000000 ops in 53.511 seconds; 18687 ops per second
CPU 2 completed 1000000 ops in 54.169 seconds; 18460 ops per second
willy@piggy:~$ sudo taskset -p 1 930
pid 930's current affinity mask: f
pid 930's new affinity mask: 1
willy@piggy:~$ sudo ./io-gen -d /dev/sda -j4
CPU 2 completed 1000000 ops in 40.568 seconds; 24649 ops per second
CPU 0 completed 1000000 ops in 47.986 seconds; 20839 ops per second
CPU 3 completed 1000000 ops in 55.944 seconds; 17875 ops per second
CPU 1 completed 1000000 ops in 56.180 seconds; 17799 ops per second

I think I'm going to try backing out some of the recent patches that
have gone into /slab/ and see if it's been regressing.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
