Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbYAKIEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbYAKIEc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbYAKIEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:04:23 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:60962 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbYAKIEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:04:22 -0500
X-Greylist: delayed 1504 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jan 2008 03:04:22 EST
Date: Fri, 11 Jan 2008 08:39:16 +0100 (CET)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org, chris.mason@oracle.com,
       linux-fsdevel@vger.kernel.org, "Bryn M. Reeves" <breeves@redhat.com>
Subject: Re: [PATCH][RFC] fast file mapping for loop
In-Reply-To: <20080110084206.GR6258@kernel.dk>
Message-ID: <Pine.LNX.4.64.0801110831020.29298@artax.karlin.mff.cuni.cz>
References: <20080109085231.GE6650@kernel.dk> <20080109231628.GB4039@agk.fab.redhat.com>
 <20080110083130.GP6258@kernel.dk> <20080110084206.GR6258@kernel.dk>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I looked at the code - it seems you build a full extent of the blocks
> in the file, filling holes as you go along. I initally did that as well,
> but that is to slow to be usable in real life.
> 
> You also don't support sparse files, falling back to normal fs
> read/write paths. Supporting sparse files properly is a must, people
> generally don't want to prealloc a huge disk backing.

How would you do sparse file support with passthrough loopback that 
doesn't use pagecache?

Holes are allocated at get_block function provided by each filesystem and 
the function gets a buffer that is supposed to be in the pagecache. Now if 
you want to allocate holes without pagecache, there's a problem --- new 
interface to all filesystems is needed.

It could be possible to use pagecache interface for filling holes and 
passthrough interface for other requests --- but get_block is allowed to 
move other blocks on the filesystem (and on UFS it really does), so 
calling get_block to fill a hole could move other unrelated blocks which 
would result in desychronized block map and corruption of both 
filesystems.

Mikulas
