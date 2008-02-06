Return-Path: <linux-kernel-owner+w=401wt.eu-S1755515AbYBFRBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515AbYBFRBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 12:01:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbYBFRBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 12:01:16 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:13514 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbYBFRBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 12:01:15 -0500
From: Chris Mason <chris.mason@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
Subject: [ANNOUNCE] Btrfs v0.12 released
Date: Wed, 6 Feb 2008 12:00:13 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802061200.14690.chris.mason@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I wasn't planning on releasing v0.12 yet, and it was supposed to have some 
initial support for multiple devices.  But, I have made a number of 
performance fixes and small bug fixes, and I wanted to get them out there 
before the (destabilizing) work on multiple-devices took over.

So, here's v0.12.  It comes with a shiny new disk format (sorry), but the gain 
is dramatically better random writes to existing files.  In testing here, the 
random write phase of tiobench went from 1MB/s to 30MB/s.  The fix was to 
change the way back references for file extents were hashed.

Other changes:

Insert and delete multiple items at once in the btree where possible.  Back 
references added more tree balances, and it showed up in a few benchmarks.  
With v0.12, backrefs have no real impact on performance.

Optimize bio end_io routines.  Btrfs was spending way too much CPU time in the 
bio end_io routines, leading to lock contention and other problems.

Optimize read ahead during transaction commit.  The old code was trying to 
read far too much at once, which made the end_io problems really stand out.

mount -o ssd option, which clusters file data writes together regardless of 
the directory the files belong to.  There are a number of other performance 
tweaks for SSD, aimed at clustering metadata and data writes to better take 
advantage of the hardware.

mount -o max_inline=size option, to override the default max inline file data 
size (default is 8k).  Any value up to the leaf size is allowed (default 
16k).

Simple -ENOSPC handling.  Emphasis on simple, but it prevents accidentally 
filling the disk most of the time.  With enough threads/procs banging on 
things, you can still easily crash the box.

-chris
