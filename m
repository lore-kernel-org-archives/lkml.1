Return-Path: <linux-kernel-owner+w=401wt.eu-S1762626AbZE2T7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626AbZE2T7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 15:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbZE2T7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 15:59:15 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:52370 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164AbZE2T7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 15:59:14 -0400
To: linux-kernel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org
Subject: 2.6.30rc7, ext4: 'inodes that were part of a corrupted orphan list found'
From: Nix <nix@esperi.org.uk>
Emacs: because one operating system isn't enough.
Date: Fri, 29 May 2009 20:59:13 +0100
Message-ID: <87eiu71y0e.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is with a brand new machine, atop a hardware RAID-5 array (Areca
1210 battery-backed with four 1Tb disks), running a 32-bit kernel and
userspace (albeit on a recent Xeon). After a clean shutdown of an ext4
filesystem mounted with "defaults,usrquota,grpquota,nodev,relatime,
journal_async_commit,commit=30,user_xattr,acl" and mkfsed with '-t ext4 -G 64',
I got this at restart:

src: recovering journal
src: Journal transaction 1442 was corrupt, replay was aborted.
src contains a file system with errors, check forced.
Inodes that were part of a corrupted orphan linked list found.

src: UNEXPECTED INCONSISTENCY; RUN fsck MANUALLY.
        (i.e., without -a or -p options)

Yesterday, I did a bunch of GCC bootstraps on this drive, culminating in
removing the objdirs; e2fsck gave us saw a heap of complaints:

Entry 'cd5011e.ada' in .../???/ada/???/tests/cd (933934) has deleted/unused inode 585817.
Entry 'cd5014k.ada' in .../???/ada/???/tests/cd (933934) has deleted/unused inode 585820.
Entry 'cd30004.a' in .../???/ada/???/tests/cd (933934) has deleted/unused inode 585814.

(and so on for several thousand files, most of the files in the deleted
objdir).

>From the nature of some of the files deleted, it looks like it was at
least the most recent objdir rm which didn't fully happen (possibly this
was the corrupted journal transaction?)

The machine has ECCRAM and the array is on PCIe, so I think we can
consider bad RAM or a messed-up bus transaction to be low probabilities.


(An image of this FS in corrupt state has been preserved, but it's
100Gb...)
