Return-Path: <linux-kernel-owner+w=401wt.eu-S1758236AbZCaNqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236AbZCaNqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757444AbZCaNpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:45:52 -0400
Received: from THUNK.ORG ([69.25.196.29]:50242 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157AbZCaNpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:45:52 -0400
Date: Tue, 31 Mar 2009 09:45:47 -0400
From: Theodore Tso <tytso@mit.edu>
To: Alberto Gonzalez <info@gnebu.es>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
Message-ID: <20090331134547.GJ13356@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alberto Gonzalez <info@gnebu.es>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200903291224.21380.info@gnebu.es> <20090331122540.GB13356@mit.edu> <200903311452.05210.info@gnebu.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903311452.05210.info@gnebu.es>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 31, 2009 at 02:52:05PM +0200, Alberto Gonzalez wrote:
> 
> You've proposed that in laptop mode, fsync's should be held until next write 
> cycle (say every 30 seconds) so that the disk is not spun up unnecessarily, 
> wasting battery and shortening it's lifespan too. I absolutely agree with 
> this, and as a trade-off I'm ok with losing my last paragraph even if I did hit 
> Ctrl+S to save it a few seconds before a crash. But again, with Ext4 will I 
> just lose that last paragraph or the whole book in this case?

Laptop mode is already set up such that the moment the disk spins up,
any pending writes are immediately flushed to disk --- the idea being
that if the disk is spinning, we might as well take advantage of it to
get everything pushed out to disk.  As long as we actually keep a
linked list of those fsync's which were "held up", and we make sure
all of the delayed allocation blocks are also allocated before we push
them out, the right thing will happen.  If we just ignore the fsync's,
then we might not allocate the delayed allocation blocks.  So
basically, we need to be careful about how we implement this addition
to laptop_mode.

Jeff Garzik has also pointed out that there are additional concerns
for databases which may have issued multiple fsync()'s while the disk
has been spun down, where we wouldn't want to mix writes between
fsync()'s.  This basically boils down to how much protection do we
want to give for the case where the system crashes while the disk
blocks are being pushed out to disk.  (Which isn't that farfetched;
consider the case where the laptop is very low on battery, and runs
out when the disk is woken up and crashes before all of the writes
could be processed.)

So there are some things that would be tricky in terms of implementing
this perfectly, and maybe we would disable the fsync suppression
machinery if the battery level isgetting critical --- and then do
either a clean shutdown or a suspend-to-disk (although here too there
had better be enough juice in the battery to write all of memory to
your swap partition).

The bottom line is that it *can* be implemented safely, but there are
some things that we would need to pay attention to in order to make
sure it *was* safe.

						- Ted
