Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbXCCU3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbXCCU3i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 15:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932334AbXCCU3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 15:29:38 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45423 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203AbXCCU3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 15:29:37 -0500
Date: Sat, 3 Mar 2007 12:29:35 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Subject: userspace pagecache management tool
Message-Id: <20070303122935.f1ab0067.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I've uploaded to http://userweb.kernel.org/~akpm/pagecache-management/ a
little tool which permits the management of the pagecache usage of
arbitrary applications.  Effectively it prevents the targetted application
from using any pagecache at all.

It is to address the "waah, backups fill my memory with pagecache" and the
"waah, updatedb swapped everything out" and the "waah, copying a DVD
gobbled all my memory" problems.


Although it is little more than a proof-of-concept it seems to be fairly
useful.  When running

	pagecache-management.sh dd if=100-mb-file of=foo
	or
	pagecache-management.sh cp -a /usr/src/linux-2.6.20 /usr/src/foo

the amount of pagecache in the machine is pretty much unaltered.  Maybe a
megabyte of additional cache in the second case, because of ext3 indirect
blocks.


The tool uses an LD_PRELOAD hack to intercept glibc's read(), pread(),
write(), pwrite(), close() and dup2() functions.  pagecache control is done
via posix_fadvise() and sync_file_range().

btw, for a while I was using fdatasync() on close(), but it was slow,
because fdatasync() has to run an ext3 commit to commit the metadata. 
sync_file_range() doesn't do that, and the copy-a-kernel-tree testcase sped
up by a factor of five.  So sync_file_range() rocks, but the powerpc guys
haven't wired it up yet.


There is much more which could be done to make this code smarter, but I
think the lesson here is that we can produce a far, far better result doing
this work in userspace than we could ever hope to do with an in-kernel
implementation.  There are some enhancement suggestions in the
documentation file.


It would be good if someone could turn this into a real product, get it fed
into distros.  Once the design is settled we should look at moving all the
functionality into glibc itself, IMO, and get rid of the LD_PRELOAD trick.

It might help if the kernel offered APIs which permit userspace to query
the number of resident pages in a file (well, actually it already does,
kind-of: mincore()) and the ability to query the number of dirty pages in a
file, etc.  I'd be reluctant to tie the kernel ABI too closely to the
current pagecache implementation and data structures, but we can look at
these things.
