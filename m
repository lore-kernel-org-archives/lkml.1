Return-Path: <linux-kernel-owner+w=401wt.eu-S1755201AbYEaPjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201AbYEaPjZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 11:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYEaPiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 11:38:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:63635 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbYEaPiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 11:38:09 -0400
Message-Id: <200805311737.58991.arnd@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 31 May 2008 17:37:58 +0200
From: arnd@arndb.de
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hch@lst.de
Subject: [RFC 0/7] [RFC] cramfs: fake write support
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Provags-ID: V01U2FsdGVkX1/AzRMa5versxCFJmvGlxt3NXSqcRpZ4bFqNaw
 gXxRXPwsFQYe37izd9yBc5m7du6fopQZG0d0Yqy0OqmQ2o+lUP
 WIZEcaU78Ek1zzrVf8puw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inspired by a discussion with Christoph Hellwig, I tried to
recreate a patch that he did a few years ago to add support
for writing to a mounted cramfs file system. It still has
known problems (and likely unknown ones), but should be
good enough for practical use. I've been able to boot
a full Ubuntu installation from a cramfs image and work with
it normally.

The intention is to use it for instance on read-only root
file systems like CD-ROM, or on compressed initrd images.
In either case, no data is written back to the medium, but
remains in the page/inode/dentry cache, like ramfs does.

Many existing systems currently use unionfs or aufs for this
purpose, by overlaying a tmpfs over a read-only file
system like cramfs, squashfs or iso9660. IMHO, it would
be a much nicer solution to not require unionfs for a simple
case like this, but rather have support for it in the file
system. If people find this useful, we can do the same in
other read-only file system.

Writing to existing files is broken in at least two corner
cases, and I'm still looking for a solution here:

When you truncate an on-disk to make it larger, reading
beyond the old end of the file will make cramfs try to
read from disk instead of filling with zeroes. I'm not sure
if this can be solved without adding additional members to
the inode structure (using a private inode cache) to remember
the end of the on-disk file.

Deleting a preexisting file currently does not free the inode
and page cache for that file, which I assume is easy to fix.

Also, the i_nlink field of directories is always 1, and
has always been on cramfs. Getting the count right should
simplify the code a bit and make it more correct according
to posix, but will cost a bit of performance on 'stat'.

The patch series also lives on
git://git.kernel.org:/pub/scm/linux/kernel/git/arnd/playground.git cramfs

Comments?

	Arnd <><
