Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbYDHLOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbYDHLOT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYDHLOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:14:08 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:46234 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683AbYDHLOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:14:07 -0400
Date: Tue, 8 Apr 2008 13:14:05 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Helge Hafting <helge.hafting@aitel.hist.no>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>, agk@redhat.com,
       mingo@redhat.com, neilb@suse.de
Subject: Re: Data corruption on software RAID
In-Reply-To: <47FB477E.40502@aitel.hist.no>
Message-ID: <Pine.LNX.4.64.0804081308080.27869@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0804080033430.13352@artax.karlin.mff.cuni.cz>
 <47FB477E.40502@aitel.hist.no>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > But with RAID (since 2.6.13), it can produce corruption because when the
> > buffer is modified while being written, different versions of data can be
> > written to devices in the RAID array. For example:
> >
> > 1. pdflush turns off a dirty bit on Ext2 bitmap buffer and starts writing
> > the buffer to RAID-1
> > 2. the kernel allocates some blocks in that Ext2 bitmap. One of RAID-1
> > devices writes new data, the other one gets old data.
> > 3. The kernel turns on the buffer dirty bit, so this buffer is scheduled for
> > next write.
> > 4. RAID-1 subsystem sees that both writes finished, it thinks that this
> > region is in-sync, turns off its dirty bit in its region bitmap and writes
> > the bitmap to disk.
> >   
> Would this help:
> RAID-1 sees that both writes finished. It checks the dirty bits on all
> relevant buffers/pages. If none got re-dirtied, then it is ok to
> turn off the dirty bit in the region bitmap and write that. Otherwise, it is
> not!
> 
> Or is such a check too time-consuming?

That is impossible. The page cache can answer questions like "where is 
page 0x1234 from inode 0x5678 located on disk?" But it can't answer the 
reverse question: "which inode and which page is using disk block 
0x12345678?"

Furthermore, with device mapper you can stack several mapping tables each 
on other --- and again --- device mapper can't solve the reverse problem 
it can't tell you which filesystem is using block X.

Mikulas

> Helge Hafting
