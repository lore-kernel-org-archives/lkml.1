Return-Path: <linux-kernel-owner+w=401wt.eu-S1754118AbYCMJxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbYCMJxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 05:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbYCMJxK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 05:53:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751756AbYCMJxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 05:53:08 -0400
Date: Thu, 13 Mar 2008 02:52:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Christoph Lameter <clameter@sgi.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: hackbench regression since 2.6.25-rc
Message-Id: <20080313025244.f7accc31.akpm@linux-foundation.org>
In-Reply-To: <1205400538.3215.148.camel@ymzhang>
References: <1205394417.3215.85.camel@ymzhang>
	<20080313014808.f8d25c2a.akpm@linux-foundation.org>
	<1205400538.3215.148.camel@ymzhang>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 17:28:58 +0800 "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:

> On Thu, 2008-03-13 at 01:48 -0700, Andrew Morton wrote:
> > On Thu, 13 Mar 2008 15:46:57 +0800 "Zhang, Yanmin" <yanmin_zhang@linux.intel.com> wrote:
> > 
> > > Comparing with 2.6.24, on my 16-core tigerton, hackbench process mode has about
> > > 40% regression with 2.6.25-rc1, and more than 20% regression with kernel
> > > 2.6.25-rc4, because rc4 includes the reverting patch of scheduler load balance.
> > > 
> > > Command to start it.
> > > #hackbench 100 process 2000
> > > I ran it for 3 times and sum the values.
> > > 
> > > I tried to investiagte it by bisect.
> > > Kernel up to tag 0f4dafc0563c6c49e17fe14b3f5f356e4c4b8806 has the 20% regression.
> > > Kernel up to tag 6e90aa972dda8ef86155eefcdbdc8d34165b9f39 hasn't regression.
> > > 
> > > Any bisect between above 2 tags cause kernel hang. I tried to checkout to a point between
> > > these 2 tags for many times manually and kernel always paniced.
> > > 
> > > All patches between the 2 tags are on kobject restructure. I guess such restructure
> > > creates more cache miss on the 16-core tigerton.
> > > 
> > 
> > That's pretty surprising - hackbench spends most of its time in userspace
> > and zeroing out anonymous pages.
> No. vmstat showed hackbench spends almost 100% in sys.

ah, I got confused about which test that is.

> >   It shouldn't be fiddling with kobjects
> > much at all.
> > 
> > Some kernel profiling might be needed here..
> Thanks for your kind reminder. I don't know why I forgot it.
> 
> 2.6.24 oprofile data:
> CPU: Core 2, speed 1602 MHz (estimated)
> Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit mask of 0x00 (Unhalted core cycles) count 100000
> samples  %        image name               app name                 symbol name
> 40200494 43.3899  linux-2.6.24             linux-2.6.24             __slab_alloc
> 35338431 38.1421  linux-2.6.24             linux-2.6.24             add_partial_tail
> 2993156   3.2306  linux-2.6.24             linux-2.6.24             __slab_free
> 1365806   1.4742  linux-2.6.24             linux-2.6.24             sock_alloc_send_skb
> 1253820   1.3533  linux-2.6.24             linux-2.6.24             copy_user_generic_string
> 1141442   1.2320  linux-2.6.24             linux-2.6.24             unix_stream_recvmsg
> 846836    0.9140  linux-2.6.24             linux-2.6.24             unix_stream_sendmsg
> 777561    0.8393  linux-2.6.24             linux-2.6.24             kmem_cache_alloc
> 587127    0.6337  linux-2.6.24             linux-2.6.24             sock_def_readable
> 
> 
> 
> 
> 2.6.25-rc4 oprofile data:
> CPU: Core 2, speed 1602 MHz (estimated)
> Counted CPU_CLK_UNHALTED events (Clock cycles when not halted) with a unit mask of 0x00 (Unhalted core cycles) count 100000
> samples  %        image name               app name                 symbol name
> 46746994 43.3801  linux-2.6.25-rc4         linux-2.6.25-rc4         __slab_alloc
> 45986635 42.6745  linux-2.6.25-rc4         linux-2.6.25-rc4         add_partial
> 2577578   2.3919  linux-2.6.25-rc4         linux-2.6.25-rc4         __slab_free
> 1301644   1.2079  linux-2.6.25-rc4         linux-2.6.25-rc4         sock_alloc_send_skb
> 1185888   1.1005  linux-2.6.25-rc4         linux-2.6.25-rc4         copy_user_generic_string
> 969847    0.9000  linux-2.6.25-rc4         linux-2.6.25-rc4         unix_stream_recvmsg
> 806665    0.7486  linux-2.6.25-rc4         linux-2.6.25-rc4         kmem_cache_alloc
> 731059    0.6784  linux-2.6.25-rc4         linux-2.6.25-rc4         unix_stream_sendmsg
> 

So slub got a litle slower?

(Is slab any better?)

Still, I don't think there are any kobject operations in these codepaths
are there?  Maybe some related to the network device, but I doubt it -
networking tends to go it alone on those things, mainly for performance
reasons.



