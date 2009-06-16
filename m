Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbZFPEY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbZFPEY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 00:24:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbZFPEYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 00:24:22 -0400
Received: from mx.binnacle.cx ([74.95.187.105]:7235 "EHLO mx.binnacle.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbZFPEYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 00:24:21 -0400
Message-Id: <6.2.5.6.2.20090616000017.05b5da70@binnacle.cx>
X-Mailer: QUALCOMM Windows Eudora Version 6.2.5.6
Date: Tue, 16 Jun 2009 00:12:14 -0400
To: Eric Dumazet <eric.dumazet@gmail.com>
From: starlight@binnacle.cx
Subject: Re: QUESTION: can netdev_alloc_skb() errors be reduced
  by  tuning?
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       linux-mm@kvack.org, hugh.dickins@tiscali.co.uk, Lee.Schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, ebmunson@us.ibm.com, agl@us.ibm.com,
       apw@canonical.com, wli@movementarian.org
In-Reply-To: <4A3702CF.9070303@gmail.com>
References: <1243422749-6256-1-git-send-email-mel@csn.ul.ie>
 <20090527131437.5870e342.akpm@linux-foundation.org>
 <20090527231949.GB30002@elte.hu>
 <6.2.5.6.2.20090615201713.05b5d408@binnacle.cx>
 <4A3702CF.9070303@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric,

Great thought--thank you.  Running a similar server with 
82571/e1000e and it does not exhibit the problem.  'e1000e' has 
default copybreak=256 while 'ixgbe' has no copybreak.  Rational 
given is

   http://osdir.com/ml/linux.drivers.e1000.devel/2008-01/msg00103.html

But the comparion is a bit apples-and-oranges since the 'e1000e' 
system is dual Opteron 2354 while the 'ixgbe' system is Xeon 
E5430 (a painful choice thus far).  Also 'e1000e' system passes 
data via a PACKET socket while the 'ixgbe' system passes data 
via UDP (a configurable option).

I'm not fully up on how this all works: am I to understand that 
the error could result from RX ring-queue buffers not freeing 
quickly enough because they have a use-count held non-zero as
the packet travels the stack?

I've just doubled some SLAB tuneables that seem relevant, but 
if the cause is the aforementioned, this won't help.  Will
have the answer on the tweaks by the end of Tuesday.

David



At 04:26 AM 6/16/2009 +0200, Eric Dumazet wrote:
>
>152691992335/724246449 = 210 bytes per rx packet in average
>
>It could make sense to add copybreak feature in this driver to 
>reduce memory needs, but that also would consume more cpu 
>cycles, and slow down forwarding setups.
>
>Maybe this packet trimming could be done generically in UDP 
>stack input path, before queueing packet into a receive queue, 
>if amount of available memory is under a given threshold.

