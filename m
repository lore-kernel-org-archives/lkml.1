Return-Path: <linux-kernel-owner+w=401wt.eu-S1762485AbYAQWyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762485AbYAQWyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:54:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761489AbYAQWqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:46:47 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64424 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761486AbYAQWqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:46:45 -0500
Date: Thu, 17 Jan 2008 17:45:30 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Daniel Phillips <phillips@google.com>
Cc: Bryan Henderson <hbryan@us.ibm.com>, Al Boldi <a1426z@gawab.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Rik van Riel <riel@redhat.com>, Valerie Henson <val.henson@gmail.com>
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
	fsck)
Message-ID: <20080117224530.GH5547@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Daniel Phillips <phillips@google.com>,
	Bryan Henderson <hbryan@us.ibm.com>, Al Boldi <a1426z@gawab.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
	linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
	Rik van Riel <riel@redhat.com>,
	Valerie Henson <val.henson@gmail.com>
References: <4d47a5d10801151724m418e18efp9a0dd936e9a3584c@mail.gmail.com> <OFDB679999.9793D1C7-ON882573D2.00646D05-882573D2.0068FF85@us.ibm.com> <4d47a5d10801161802x2c24ef59pf8422c8d14d487aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d47a5d10801161802x2c24ef59pf8422c8d14d487aa@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 09:02:50PM -0500, Daniel Phillips wrote:
> 
> Have you observed that in the wild?  A former engineer of a disk drive
> company suggests to me that the capacitors on the board provide enough
> power to complete the last sector, even to park the head.
> 

The problem isn't with the disk drive; it's from the DRAM, which tend
to be much more voltage sensitive than the hard drives --- so it's
quite likely that you could end up DMA'ing garbage from the memory.
In fact the fact that the disk drives lasts longer due to capacitors
on the board, rotational inertia of the platters, etc., is part of the
problem.

It was observed in the wild by SGI, many years ago on their hardware.
They later added extra capacitors on the motherboard and a powerfail
interrupt which caused the Irix to run around frantically shutting
down DMA's for a controlled shutdown.  Of course, PC-class hardware
has none of this.  My source for this was Jim Mostek, one of the
original Linux XFS porters.  He had given me source code to a test
program that would show this; basically zeroed out a region of disk,
then started writing series of patterns on that part of the, and you
you kicked out the power cord, and then see if there was any garbage
on the disk.  If you saw something that wasn't one of the patterns
being written to the disk, then you knew you had a problem.  I can't
find the program any more, but it wouldn't be hard to write.  

I do know that I have seen reports from many ext2 users in the field
that could only be explained by the hard drive scribbling garbage onto
the inode table.  Ext3 solves this problem because of its physical
block journaling.

						- Ted
