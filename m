Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbYCKNc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbYCKNc1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 09:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbYCKNcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 09:32:20 -0400
Received: from mx12.go2.pl ([193.17.41.142]:44392 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750859AbYCKNcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 09:32:19 -0400
Message-ID: <47D689DF.10408@o2.pl>
Date: Tue, 11 Mar 2008 14:32:15 +0100
From: Artur Skawina <art_k@o2.pl>
User-Agent: Thunderbird 3.0a1pre (X11/2008030620)
MIME-Version: 1.0
To: Daniel Phillips <phillips@phunq.net>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
References: <200803092346.17556.phillips@phunq.net> <20080310092213.7ba878b3@core> <200803102050.40567.phillips@phunq.net>
In-Reply-To: <200803102050.40567.phillips@phunq.net>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Phillips wrote:
> 
> Right, and now with ramback you will be able to preserve that state and
> have the performance too.  It is a wonderful world.
> 
>>> If UPS power runs out while ramback still holds unflushed dirty data 
>>> then things get ugly.  Hopefully a fsck -f will be able to pull 
>>> something useful out of the mess.  (This is where you might want to be 
>>> running Ext3.)  The name of the game is to install sufficient UPS power 
>>> to get your dirty ramdisk data onto stable storage this time, every 
>>> time.
>> Ext3 is only going to help you if the ramdisk writeback respects barriers
>> and ordering rules ?

> extra programming to maintain cache consistency.  Then there is the
> issue of ramdisks on the way that exceed the 40 bit physical addressing
> of current generation processors.

>>>  * Per chunk locking is not feasible for a terabyte scale ramdisk.

> backing store is not expected to represent a consistent filesystem
> state during normal operation.  Only the ramdisk needs to maintain a
> consistent state, which I have taken care to ensure.  You just need
> to believe in your battery, Linux and the hardware it runs on.  Which
> of these do you mistrust?

expecting the hw to never fail is unreasonable - it will. it's just a
question what happens when (not if) it fails.
and it's not about the backing store being inconsistent during normal
operation - it's about what you are left with after an unclean shutdown.
With your scheme the only time you can trust the on-disk data is when
the device is off; when it fails for some reason (batteries do fail,
kernel bugs do happen, DOS, overheating etc etc) you can no longer
trust any of the data, and no - fsck doesn't help when you have a mix
of old data overwritten by new stuff in basically random order. i can't
see any scenario when it would make sense to trust the corrupted on-disk
fs instead of restoring from backup (or regenerating). So is it just
about avoiding repopulating the fs in the (likely) case of normal,
clean shutdown? This could be a reasonable application of ramback (OTOH
how often will this (shutdown) happen in practice...). IOW you get
a ramdisk-based (ie fast) device that is capable of surviving power loss,
but that's about it.

Now, if you add snapshots to the backing store it suddenly becomes much
more interesting -- you no longer need to put so much trust in all the
hw. Should the device fail for whatever reason then you just rollback to
the last good snapshot upon restart. No corrupted fs, no fsck; you lose
some newly written data (that you couldn't recover w/o a snapshot anyway),
but can trust the rest of it (assuming you trust the fs and storage hw,
but that's no different then w/o ramback).

artur
