Return-Path: <linux-kernel-owner+w=401wt.eu-S1755014AbZBINIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbZBINIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753723AbZBINHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:07:53 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:30502 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753623AbZBINHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:07:52 -0500
Message-ID: <49902A9E.3070002@panasas.com>
Date: Mon, 09 Feb 2009 15:07:42 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCHSET 0/8 version 3] exofs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2009 13:07:47.0247 (UTC) FILETIME=[673D03F0:01C98AB7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exofs is a file system that uses an OSD device as it's back store.

OSD is a new T10 command set that views storage devices not as a large/flat
array of sectors but as a container of objects, each having a length, quota,
time attributes and more. Each object is addressed by a 64bit ID, and is
contained in a 64bit ID partition. Each object has associated attributes
attached to it, which are integral part of the object and provide metadata about
the object. The standard defines some common obligatory attributes, but user
attributes can be added as needed.

What's new since last iteration:
Lots and lots of changes the actual diff is big.

- mkexofs is removed from Kernel code
    Open-osd has a user-mode library now. It is the exact same API (and source) as
    the Kernel library. Commands are issued through (patched) bsg.ko. If anyone
    is interested see URLs below, patches will be sent to the open-osd-mailing-list.
    Horay.

- Incorporate changes made to ext2 since exofs was first derived.
    Thanks to Andrew Morton, I've referred to the git-log of fs/ext2 and
    have incorporated all relevant changes into exofs. Lots of bug fixes
    and short comings where fixed this way.

- Made everything LE safe.
    All on disk types are now using proper Endian types, and properly converted
    back and forth. exofs is an LE filesystem just as ext2.

- Completely got rid of IBM API
    Previous version was using IBM API for osd commands and those API where implemented
    over open-osd in osd.c. open-osd API is now used directly and osd.c is reduced to
    a few exofs internal helpers.

- A sleep forever Bug fix, related to async object creation.

- Cleaned up some usage of types, naming conventions, code organization.
    Lots of cleanups, and reorganization.

And the regular information for first comers

Our intention with exofs is to make it exportable by Linux
pNFS server, as reference implementation for pNFS-object-layout
server. A pNFS-objects client implementation is also in the works
(See all about pNFS in Linux at:
http://wiki.linux-nfs.org/wiki/index.php/PNFS_prototype_design)

exofs was originally developed by Avishay Traeger <avishay@gmail.com>
from IBM. A very old version of it is hosted on sourceforge as the osdfs
project. The Original code was based on ext2 of the 2.6.10 Kernel and ran
over the old IBM's osd-initiator Linux driver.
Since then it was picked by us, open-osd, and was both forward ported to
current Kernel, as well as converted to run over open-osd Kernel Library.

I have mechanically divided the code in parts, each introducing a
group of vfs function vectors, all tied at the end into a full filesystem.
Each patch can be compiled but it will only run at the very end.
This was done for the hope of easier reviewing.

Here is the list of patches
[PATCH 1/8] exofs: Kbuild, Headers and osd utils
[PATCH 2/8] exofs: file and file_inode operations
[PATCH 3/8] exofs: symlink_inode and fast_symlink_inode operations
[PATCH 4/8] exofs: address_space_operations
[PATCH 5/8] exofs: dir_inode and directory operations
[PATCH 6/8] exofs: super_operations and file_system_type
[PATCH 7/8] exofs: Documentation
[PATCH 8/8] fs: Add exofs to Kernel build

This patchset is also available on:
  git-clone git://git.open-osd.org/linux-open-osd.git linux-next
or on the web at:
  http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=refs/heads/linux-next

(Above tree is based on Linus 2.6.29-rc4)

If anyone wants to actually run this code and test it
then please start reading at:
    http://open-osd.org
You will need to checkout the out-of-tree git (below) for the user-mode utilities.
Also the exofs.txt file in patch 7/8 should help

If you want to review the user-mode library and supporting plumbings,
patches will be sent to this mailing-list:
http://www.open-osd.org/bin/view/Main/MailingList

And code is on this git-tree:
  git-clone git://git.open-osd.org/open-osd.git
or on the web at:
  http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=summary

Thank you all for the very useful comments, suggestions, and banging me on the
head about the user-mode API.

Boaz
