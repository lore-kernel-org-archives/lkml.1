Return-Path: <linux-kernel-owner+w=401wt.eu-S1765220AbXHARve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765220AbXHARve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760178AbXHARvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:51:20 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:58761 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759962AbXHARvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:51:19 -0400
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Aug 2007 13:51:19 EDT
Date: Wed, 1 Aug 2007 19:44:31 +0200
From: Egmont Koblinger <egmont@uhulinux.hu>
To: linux-kernel@vger.kernel.org
Subject: number of blocks changes when file is synced to disk
Message-ID: <20070801174431.GA19492@uhulinux.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been facing the following interesting situation for years, but I only
took time to track it down now.

When building a glibc package for a distro, we perform the standard steps to
compile and install it including the locales, then do some random checks and
finally create a tar archive. Sometimes tar fails with this message:
tar: ./usr/lib/locale/locale-archive: file changed as we read it

tar checks for the file size and ctime before and after archiving it.
Adding some extra code showed that it's ctime that changes during the
compression of this file, despite the fact that no other processes are
tampering with this file at that time.

The "install-locales" phase of glibc consists of running localedef plenty of
times, each invocation slightly alters the locale-archive database and then
exits. After the last of such localedef processes exits, st_blocks of this
file is 129072 according to stat. At this moment I can interrupt the whole
package building procedure, so it's absolutely sure that there are no
processes lying around that could modify locale-archive. (Note that this is
under some chroot and destdir, so it's not the locale-archive the whole
system uses.)

I can query st_blocks again and again within several seconds, I still get
129072. If I either wait some time (a half minute or so), or I issue the
"sync" command, the number of blocks allocated increases to 129152, and at
the same time the ctime value of the inode is updated to the current time.
No other properties of the inode is modified, not even mtime, which yet
again proves that there's no userspace process modifying this file.

So to summarize: when the file is physically written to disk by some
background kernel activity, its st_blocks and st_ctime values change. This
in turn causes tar to go mad (if syncing the file happens to occur right
when tar is processing it). tar doesn't expect this situation. I wouldn't
expect it either if I were tar :-)

Is this a normal behavior (feature) or a bug? This sounds like a bug to me:
IMHO st_blocks and st_ctime shouldn't change when no userspace process
modifies the file.

Could this be somehow related to sparse files? I have a feeling that there
are some holes in locale-archive that are not written by any localedef
invocations. However, two copies created by "cp --sparse=always" and "cp
--sparse=never" both occupy 129152 blocks according to stat, which suggests
that there are no holes in the final file. Maybe the kernel is working with
smaller blocksize in memory than the file system, and thinks that some
blocks won't need to be written to disk, and then when it comes to actually
write them then it notices that they all have to be written? Just a stupid
idea...

I have ext3 with 4096-byte blocks. Currently the running kernel is 2.6.21,
glibc 2.6.1 and tar 1.18 are involved, but we also faced this bug a long
time ago, when we used to have kernel 2.4.24, glibc 2.3.2 and tar 1.13.25.



thanks,

Egmont
