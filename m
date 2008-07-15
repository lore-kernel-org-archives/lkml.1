Return-Path: <linux-kernel-owner+w=401wt.eu-S1761096AbYGOS2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761096AbYGOS2e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbYGOS2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:28:25 -0400
Received: from cobra.newdream.net ([66.33.216.30]:50704 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142AbYGOS2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:28:24 -0400
Date: Tue, 15 Jul 2008 11:28:22 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ceph-devel@lists.sourceforge.net
Subject: Recursive directory accounting for size, ctime, etc.
Message-ID: <Pine.LNX.4.64.0806192313530.7379@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All-

Ceph is a new distributed file system for Linux designed for scalability 
(terabytes to exabytes, tens to thousands of storage nodes), reliability, 
and performance.  The latest release (v0.3), aside from xattr support and 
the usual slew of bugfixes, includes a unique (?) recursive accounting 
infrastructure that allows statistics about all metadata nested beneath a 
point in the directory hierarchy to be efficiently propagated up the tree.  
Currently this includes a file and directory count, total bytes (summation 
over file sizes), and most recent inode ctime.  For example, for a 
directory like /home, Ceph can efficiently report the total number of 
files, directories, and bytes contained by that entire subtree of the 
directory hierarchy.

The file size summation is the most interesting, as it effectively gives 
you directory-based quota space accounting with fine granularity.  In many 
deployments, the quota _accounting_ is more important than actual 
enforcement.  Anybody who has had to figure out what has filled/is filling 
up a large volume will appreciate how cumbersome and inefficient 'du' can 
be for that purpose--especially when you're in a hurry.

There are currently two ways to access the recursive stats via a standard 
shell.  The first simply sets the directory st_size value to the 
_recursive_ bytes ('rbytes') value (when the client is mounted with -o 
rbytes).  For example (watch the directory sizes),

$ tar jxf linux-2.6.24.3.tar.bz2
$ ls -l
total 8
drwxr-xr-x 1 root root         0 Jul 10 05:30 .
drwxr-xr-x 8 root root      4096 Jul  9 18:21 ..
drwxrwxr-x 1 root root 254025660 Feb 26 00:20 linux-2.6.24.3
$ du -s linux-2.6.24.3/
254237  linux-2.6.24.3/
$ ls -al linux-2.6.24.3/
total 281
drwxrwxr-x 1 root root 254025660 Feb 26 00:20 .
drwxr-xr-x 1 root root         0 Jul 10 05:30 ..
-rw-rw-r-- 1 root root       628 Feb 26 00:20 .gitignore
-rw-rw-r-- 1 root root      3657 Feb 26 00:20 .mailmap
-rw-rw-r-- 1 root root     18693 Feb 26 00:20 COPYING
-rw-rw-r-- 1 root root     92230 Feb 26 00:20 CREDITS
drwxrwxr-x 1 root root   8984828 Feb 26 00:20 Documentation
-rw-rw-r-- 1 root root      1596 Feb 26 00:20 Kbuild
-rw-rw-r-- 1 root root     93957 Feb 26 00:20 MAINTAINERS
-rw-rw-r-- 1 root root     53162 Feb 26 00:20 Makefile
-rw-rw-r-- 1 root root     16930 Feb 26 00:20 README
-rw-rw-r-- 1 root root      3119 Feb 26 00:20 REPORTING-BUGS
drwxrwxr-x 1 root root  44216036 Feb 26 00:20 arch
drwxrwxr-x 1 root root    349137 Feb 26 00:20 block
drwxrwxr-x 1 root root    959654 Feb 26 00:20 crypto
drwxrwxr-x 1 root root 118578205 Feb 26 00:20 drivers
drwxrwxr-x 1 root root  21526882 Feb 26 00:20 fs
drwxrwxr-x 1 root root  27456604 Feb 26 00:20 include
drwxrwxr-x 1 root root     99077 Feb 26 00:20 init
drwxrwxr-x 1 root root    170827 Feb 26 00:20 ipc
drwxrwxr-x 1 root root   2189735 Feb 26 00:20 kernel
drwxrwxr-x 1 root root    679502 Feb 26 00:20 lib
drwxrwxr-x 1 root root   1213804 Feb 26 00:20 mm
drwxrwxr-x 1 root root  12562134 Feb 26 00:20 net
drwxrwxr-x 1 root root      3940 Feb 26 00:20 samples
drwxrwxr-x 1 root root   1105977 Feb 26 00:20 scripts
drwxrwxr-x 1 root root    740395 Feb 26 00:20 security
drwxrwxr-x 1 root root  12888682 Feb 26 00:20 sound
drwxrwxr-x 1 root root     16269 Feb 26 00:20 usr

Note that st_blocks is _not_ recursively defined, so 'du' still behaves as 
expected.  If mounted with -o norbytes instead, the directory st_size is 
the number of entries in the directory.

The second interface takes advantage of the fact (?) that read() on a 
directory is more or less undefined.  (Okay, that's not really true, but 
it used to return encoded dirents or something similar, and more recently 
returns -EISDIR.  As far as I know, no sane application expects meaningful 
data from read() on a directory...)  So, assuming Ceph is mounted with -o 
dirstat,

$ cat linux-2.6.24.3/
entries:                     27
 files:                       9
 subdirs:                    18
rentries:                 24418
 rfiles:                  23062
 rsubdirs:                 1356
rbytes:               254025660
rctime:    1215668428.051898000

Fields prefixed with 'r' are recursively defined, while 
entries/files/subdirs is just for the one directory.  'rctime' is the most 
recent ctime within the hierarchy, which should be useful for backup 
software or anything else scanning the hierarchy for recent changes.

Naturally, there are a few caveats:

 - There is some built-in delay before statistics fully propagate up 
toward the root of the hierarchy.  Changes are propagated 
opportunistically when lock/lease state allows, with an upper bound of (by 
default) ~30 seconds for each level of directory nesting.

 - Ceph internally distinguishes between multiple links to the same file 
(there is a single 'primary' link, and then zero or more 'remote' links).  
Only the primary link contributes toward the 'rbytes' total.

 - The 'rbytes' summation is over i_size, not blocks used.  That means 
sparse files "appear" larger than the storage space they actually consume.

 - Directories don't yet contribute anything to the 'rbytes' total.  They
should probably include an estimate of the storage consumed by directory 
metadata.  For this reason, and because the size isn't rounded up to the 
block size, the 'rbytes' total will usually be slightly smaller than what 
you get from 'du'.

 - Currently no stats for the root directory itself.


I'm extremely interested in what people think of overloading the file 
system interface in this way.  Handy?  Crufty?  Dangerous?  Does anybody 
know of any applications that rely on or expect meaningful values for a 
directory's i_size?  Or read() a directory?


More information on the recursive accounting at

	http://ceph.newdream.net/wiki/Recursive_accounting

and Ceph itself at

	http://ceph.newdream.net/

Cheers-
sage
