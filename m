Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600Ab0ARXd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab0ARXd4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 18:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846Ab0ARXdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 18:33:55 -0500
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:35212 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab0ARXdy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 18:33:54 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Subject: Re: IO error semantics
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20100118140039.GA13909@laptop>
Date: Mon, 18 Jan 2010 23:33:10 +0000
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
       linux-fsdevel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <D65C918F-8CCD-4626-BA84-FD0410A5E81F@cam.ac.uk>
References: <4B4EB5B9.4020809@hitachi.com> <4B4EDE5C.8040600@hitachi.com> <4B4EEE86.7080807@hitachi.com> <20100114141803.GB3146@quack.suse.cz> <20100118051847.GA8678@laptop> <20100118060518.GA9151@laptop> <20100118122437.GF7264@discord.disaster> <20100118140039.GA13909@laptop>
To: Nick Piggin <npiggin@suse.de>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 18 Jan 2010, at 14:00, Nick Piggin wrote:
> For write errors, you could also do block re-allocation, which would be fun.

Yes it would.  (-:

FWIW, Windows does this with Microsoft's NTFS driver.  When a write fails due to a bad block, the block is marked as bad (recorded in the bad cluster list and marked as allocated in the in-use bitmap so no-one tries to allocate it), a new block is allocated, inode metadata is updated to reflect the change in the logical to physical block map of the file the block belongs to, and the write is then re-tried to its new location.

I have never bothered implementing it in NTFS on Linux partially because there doesn't seem any obvious way to do it inside the file system.  I think the VFS and/or the block layer would have to offer help there in some way.  What I mean for example is that if ->writepage fails then the failure is only detected inside the asynchronous i/o completion handler at which point the page is not locked any more, it is marked as being under writeback, and we are in IRQ context (or something) and thus it is not easy to see how we can from there get to doing all the above needed actions that require memory allocations, disk i/o, etc...  I suppose a separate thread could do it where we just schedule the work to be done.  But problem with that is that that work later on might fail so we can't simply pretend the block was written successfully yet we do not want to report an error or the upper layers would pick it up even though we hopefully will correct it in due course...

Best regards,

	Anton
-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

