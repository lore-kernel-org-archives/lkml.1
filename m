Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbZCaOqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbZCaOqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 10:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZCaOpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 10:45:49 -0400
Received: from france.micfo.com ([92.48.68.3]:40033 "EHLO france.micfo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbZCaOpt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 10:45:49 -0400
From: Alberto Gonzalez <info@gnebu.es>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: Ext4 and the "30 second window of death"
Date: Tue, 31 Mar 2009 16:45:28 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.28-ARCH; KDE/4.2.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903291224.21380.info@gnebu.es> <200903311452.05210.info@gnebu.es> <20090331134547.GJ13356@mit.edu>
In-Reply-To: <20090331134547.GJ13356@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903311645.29038.info@gnebu.es>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - france.micfo.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - gnebu.es
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 March 2009 15:45:47 Theodore Tso wrote:
> On Tue, Mar 31, 2009 at 02:52:05PM +0200, Alberto Gonzalez wrote:
> > You've proposed that in laptop mode, fsync's should be held until next
> > write cycle (say every 30 seconds) so that the disk is not spun up
> > unnecessarily, wasting battery and shortening it's lifespan too. I
> > absolutely agree with this, and as a trade-off I'm ok with losing my last
> > paragraph even if I did hit Ctrl+S to save it a few seconds before a
> > crash. But again, with Ext4 will I just lose that last paragraph or the
> > whole book in this case?
>
> Laptop mode is already set up such that the moment the disk spins up,
> any pending writes are immediately flushed to disk --- the idea being
> that if the disk is spinning, we might as well take advantage of it to
> get everything pushed out to disk.  As long as we actually keep a
> linked list of those fsync's which were "held up", and we make sure
> all of the delayed allocation blocks are also allocated before we push
> them out, the right thing will happen.  If we just ignore the fsync's,
> then we might not allocate the delayed allocation blocks.  So
> basically, we need to be careful about how we implement this addition
> to laptop_mode.
>
> Jeff Garzik has also pointed out that there are additional concerns
> for databases which may have issued multiple fsync()'s while the disk
> has been spun down, where we wouldn't want to mix writes between
> fsync()'s.  This basically boils down to how much protection do we
> want to give for the case where the system crashes while the disk
> blocks are being pushed out to disk.  (Which isn't that farfetched;
> consider the case where the laptop is very low on battery, and runs
> out when the disk is woken up and crashes before all of the writes
> could be processed.)
>
> So there are some things that would be tricky in terms of implementing
> this perfectly, and maybe we would disable the fsync suppression
> machinery if the battery level isgetting critical --- and then do
> either a clean shutdown or a suspend-to-disk (although here too there
> had better be enough juice in the battery to write all of memory to
> your swap partition).
>
> The bottom line is that it *can* be implemented safely, but there are
> some things that we would need to pay attention to in order to make
> sure it *was* safe.
>
> 						- Ted

I see. Thanks for the explanation. Right now, laptop-mode (if you use laptop-
mode-tools) is disabled when battery reaches critical level. Anyway, 
regardless of corner cases, I think that what we "normal" users want is to 
have the choice between:

A - Writing data to disk immediately and lose no work at all, but get worse 
performance/battery life/HDD lifespan (this is what happens when an 
application uses fsync, right?). Or
B - Delay writes for X seconds (30, 60, 120,...) and get better 
performance/battery life/HDD lifespan, but risk to lose X seconds of work.

What is not acceptable is having to choose between A and:

C - Delay writes for X seconds and get better performance/battery life/HDD 
lifespan, but risk to lose _all_ your work (instead of just the last X 
seconds).

The problem I guess is that right now application writers targeting Ext4 must 
choose between using fsync and giving users the 'A' behaviour or not using 
fsync and giving them the 'C' behaviour. But what most users would like is 
'B', I'm afraid (at least, it's what I want, I might be an exception).

Regards,
Alberto.
