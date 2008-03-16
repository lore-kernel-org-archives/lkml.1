Return-Path: <linux-kernel-owner+w=401wt.eu-S1752818AbYCPWKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbYCPWKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 18:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbYCPWKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 18:10:32 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39275 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753438AbYCPWKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 18:10:31 -0400
Date: Sun, 16 Mar 2008 21:55:47 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Phillips <phillips@phunq.net>
Cc: Willy Tarreau <w@1wt.eu>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080316215547.07824de7@core>
In-Reply-To: <200803161457.04580.phillips@phunq.net>
References: <200803092346.17556.phillips@phunq.net>
	<200803151500.05993.phillips@phunq.net>
	<20080315230558.12e9c96c@the-village.bc.nu>
	<200803161457.04580.phillips@phunq.net>
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

> > That isn't anything to do with what was being proposed. *ORDERING* not
> > flush to media.
> 
> This is where you have made a fundamental mistake in your proposal.
> Suppose you have a steady, heavy write load onto ramback.  Eventually,
> the entire ramdisk will be dirty and you have to drop back to disk
> speed, right?  My design does not suffer from that problem, but your
> proposal does.

In your design the entire ramdisk goes bang and disappears on a crash.

> It gets worse than that.  Suppose somebody writes the same region
> twice, how do you order that?  Do you try to store that new data
> somewhere, keeping in mind that we are already at terabyte scale?  Is
> there a limit on how much overwrite data you may have to store?  (No.)

You only have to care about ordering if there is a store barrier between
the two (not usual). You only have to care about filling if you generate
enough dirty blocks at a very high rate (which is unusual for most
workloads). If you don't care about those then we have ramdisk already and
if you want to write a ramdisk driver for external ramdisk great. You'd
also fix the layering violations then by allowing device mapper to
implement things like snapshotting and writeback seperated from your
driver.

Even in the extreme case that you propose there are trivial ways of
getting coherency. Simple example - if you can sweep all the data out in
say 10 minutes then you can buy twice the physical media and ensure that
one of the two sets of disk backups is genuinely store barrier consistent
to some snapshot time (say every 30 minutes but obviously user tunable).
If you at least had some kind of credible snapshotting you'd find people
less hostile to your glorified ramdisk.

> > You have no guarantee of commit to stable storage so your use of the word
> > "transaction" is a bit farcical.
> 
> The UPS provides a guarantee of commit to stable storage.  No amount of

Stable storage to most people means "won't go away on a bad happening".
Transaction likewise has a specific meaning in terms of an event occuring
once only an either being recorded before or after the transaction
occurred.

Alan
