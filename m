Return-Path: <linux-kernel-owner+w=401wt.eu-S1753127AbZFDXfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbZFDXfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 19:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbZFDXfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 19:35:25 -0400
Received: from plexity.net ([206.123.115.38]:41030 "EHLO plexity.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbZFDXfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 19:35:25 -0400
Date: Thu, 4 Jun 2009 23:33:49 +0000
From: Deepak Saxena <dsaxena@plexity.net>
To: Pierre Ossman <pierre@ossman.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Add 400ms to CAFE SD controller resume path
Message-ID: <20090604233349.GA2545@plexity.net>
Reply-To: dsaxena@plexity.net
References: <20090513200556.GA7882@plexity.net> <20090522135150.7e0716d6@mjolnir.ossman.eu> <20090528013629.0173522b.akpm@linux-foundation.org> <20090528104823.0a551ecb@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528104823.0a551ecb@mjolnir.ossman.eu>
Organization: Plexity, LLC
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 28 2009, at 10:48, Pierre Ossman was caught saying:
> On Thu, 28 May 2009 01:36:29 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 22 May 2009 13:51:50 +0200 Pierre Ossman <pierre@ossman.eu> wrote:
> > 
> > > 
> > > Reading through that report, I don't believe you properly worked around
> > > the bug. You only avoid bug 1339, but that's only mildly related.
> > > 
> > > What this workaround does is to make sure that MMC_UNSAFE_RESUME
> > > actually works. But if you change cards during suspend, the VFS bug
> > > should reappear and you'll corrupt the partition table.
> > 
> > What do you think the VFS did wrong here?
> > 
> 
> Might be the block layer as well. Somehow requests associated with an
> old block device end up on the queue of a new block device. I don't
> see how this can happen given Linux' device model, but somehow it does.

The request is not ending up in the queue of the new device.  If I 
recall correctyl What is happening is that userspace does an unmount on the 
old device when it receives the notification that it is gone (since it is not 
redected and a new entry is created). By the time that unmount is called, the 
various data structures for the device has been zeroed out but the various 
operation pointers are !NULL, so when we go back to write the superblock for 
the mounted partition, we overwrite the device's partition table as the
partition offset is now 0. The main issue here is that the kernel is allowing 
an I/O to a device that is technically still there but not from the kernel's
POV.
 
~Deepak

-- 
In the end, they will not say, "those were dark times,"  they will ask
"why were their poets silent?" - Bertold Brecht

