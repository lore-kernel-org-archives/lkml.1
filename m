Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYCQMI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYCQMI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 08:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYCQMIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 08:08:19 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43090 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751874AbYCQMIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 08:08:18 -0400
Date: Mon, 17 Mar 2008 11:53:24 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Phillips <phillips@phunq.net>
Cc: Willy Tarreau <w@1wt.eu>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080317115324.3db4ccba@core>
In-Reply-To: <200803161639.12555.phillips@phunq.net>
References: <200803092346.17556.phillips@phunq.net>
	<200803161536.20128.phillips@phunq.net>
	<20080316224633.140a5c99@core>
	<200803161639.12555.phillips@phunq.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You did not explain how your proposal will avoid dropping the transaction

I did but I've attached a much more complete explanation below.

> throughput down to disk speed, whereas I have explained how my existing
> design can be made to achieve enterprise-grade data safety.

Here is a simple but high physical storage using approach (but hey disks
are cheap)

You walk across the ram dirty table writing out chunks to backing
store 0.

At some point in time you want a consistent snapshot so you pick the next
write barrier point after this time and begin committing blocks dirtied
after that moment to store 1 (with blocks before that moment being
written to both). You don't permit more than one snapshot to be in
progress at once so at some point you clear all the blocks for store 0.
Your snapshotting interval is bounded by the time to write out the store,
nor do you have to throttle writes to the ramdisk.

You now have a consistent snapshot in store 0. At the next time interval
we finish off store 1 and spew new blocks to store 2, after 2 is complete
we go with 2, 0 and then 1 as the stable store.

The only other real trick needed then is metadata, but you don't have to
update that on disk too often and you only need two bits for each of the
page in RAM.

For any page it is either

00	Clean on stable store
01	Clean on current writing snapshot
10	Dirty on stable store (and thus both)
11	Dirty on current writing snapshot (but clean, old on stable)

Pages go 00->11 or 01->11 when they are touched, 11->01 or 10->01 when
they are written back.

At the point we freeze a snapshot we move 01->00 11->10 00->11 and there
are no pages in 10. And of course we don't update the big tables at this
instant instead we store the page state as

		(value - cycle_count)&3

with each freeze moment doing

		cycle_count++;

The 00->11 is perhaps not obvious but the logic is fairly simple. The
snapshot we are building does not magically contain the stable data from
a previous snapshot.

Say 0 is our stable snapshot
	snapshot 0 page 0 contains the stable copy of a page
	snapshot 1 is currently being updated

if we touched the page during the lifetime of snapshot 1 the newer data
will be written to snapshot 1, if not then snapshot 1 does not contain
useful data (it is stale). What we must not do is permit a situation to
occur where snapshot 0 is overwritten and holds the last stable copy of a
block. If we move from "clean on stable" store to "dirty on stable store"
then we know our worst case is
	
	Written on snapshot 0         (01)
	Not written to snapshot 1     (00)
	Dirty on current snapshot     (11)
	Written on snapshot 2	      (01)

The page sweeping algorithm is

00 -> do nothing (it may be cheaper to write the blocks and go to 01)
01 -> do nothing (ditto)
10 -> write to both stable and current snapshot, move to 01
11 -> write to current snapshot move to 01

adjust dirty counts, check if ready to flip.

The recovery algorithm is

	Read state snapshot number
	Read blocks from stable snapshot if written to it
	From previous snapshot if not

Thus we need to write a 'written this snapshot' table as we update a
snapshot - but it can lag and needs only be completed when we decide the
snapshot is 'done'. Until the point we switch stable snapshots the
metadata and data for the current writeout are not used so not relevant.

And there are far more elegant ways to do this, although some I suspect
may still be patented.

> I do not think you have set out to solve the same problem I have, which
> is 

"to attain the highest possible transaction throughput with enterprise
scale reliability.

Well that is the problem I am interested in solving, but not the one you
seem to be working on.

Alan
