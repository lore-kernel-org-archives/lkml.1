Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbYLEBRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbYLEBRP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 20:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbYLEBQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 20:16:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbYLEBQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 20:16:59 -0500
Date: Thu, 4 Dec 2008 20:16:23 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       Alasdair G Kergon <agk@redhat.com>,
       Andi Kleen <andi-suse@firstfloor.org>, Milan Broz <mbroz@redhat.com>
Subject: Re: Device loses barrier support (was: Fixed patch for simple
 barriers.)
In-Reply-To: <20081205004849.GX6703@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0812041948400.14114@hs20-bc2-1.build.redhat.com>
References: <20081204100050.GN6703@one.firstfloor.org>
 <Pine.LNX.4.64.0812040836480.6118@hs20-bc2-1.build.redhat.com>
 <20081204142015.GQ6703@one.firstfloor.org> <Pine.LNX.4.64.0812040913510.6118@hs20-bc2-1.build.redhat.com>
 <20081204145810.GR6703@one.firstfloor.org> <Pine.LNX.4.64.0812041139200.2434@hs20-bc2-1.build.redhat.com>
 <20081204174838.GS6703@one.firstfloor.org>
 <Pine.LNX.4.64.0812041401210.23079@hs20-bc2-1.build.redhat.com>
 <20081204221551.GV6703@one.firstfloor.org>
 <Pine.LNX.4.64.0812041756550.29638@hs20-bc2-1.build.redhat.com>
 <20081205004849.GX6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Dec 2008, Andi Kleen wrote:

> > And if barriers fail at random points, the user can't turn on disk cache 
> > anyway (he would get data corruption if barrier write failed and hardware 
> 
> I think we already established earlier in the thread that there is no disk
> corruption

So, the facts are:

* barrier support in md-raid1 deviates from the specification at 
Documentation/block/barrier.txt. The specification says that requests 
submitted after the barrier request hit the media after the barrier 
request hits the media. The reality is that the barrier request can be 
randomly aborted and the requests submitted after it hit the media before 
the barrier request.

* the filesystems developed hacks to work around this issue, the hacks 
involve not submitting more requests after the barrier request, 
synchronously waiting for the barrier request and eventually retrying it. 
These hacks suppress any performance advantage barriers could bring.

* you submit a patch that makes barriers even more often deviate from the 
specification and you argue that the patch is correct because filesystems 
handle this deviation.

This is runaway logic that will eventually turn Linux into unmaintainable 
mess. What do you think we'll be doing when we'll be implementing barriers 
into other dm targets? Do you really think it'll be fun to write code to 
double-submit all metadata writes just because you and some person at 
md-raid1 provided an unreliable interface?

I am again repeating: either make barriers consistent with the 
specification, or remove them at all.

Mikulas
