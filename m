Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1759881AbYLQAQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbYLQAQk (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754284AbYLQAQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:16:28 -0500
Received: from eazy.amigager.de ([213.239.192.238]:45691 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYLQAQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:16:28 -0500
Date: Wed, 17 Dec 2008 01:16:25 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Very slow header cache in mutt if the maildir is on ext3
Message-ID: <20081217001625.GA3250@x61>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I suffered from very long delays (like one minute) when opening
maildirs with a few thousand mails on my laptop.  I did some testing on
my desktop in a very similar environment (LVM, dm-crypt, 2,5" hard
disk, identical mutt configuration), which worked as quick as expected. 
However, I tested with the maildir on XFS.  When I switched to ext3,
things got slow again.  Then I discovered that the mutt header cache
file is the culprit.  I already made a backup and restore, so the file
system is in a fresh state.  I also removed the old header cache before
testing.

In strace, I see that during the delay read() and lseek() were called
to read the header cache.  If I flush all caches, and then read only
the header cache back into the cache using dd, it works as quick as
expected (only a few seconds).

The strange thing is that in both cases (maildir on ext3 and maildir on
XFS), the header cache file is stored on a separate file system on a
different hard disk on an XFS file system.  I don't get the point why
reading the header cache from this XFS file system is so slow when the
maildir is on ext3, and fast when the maildir is on XFS.

Here are strace excerpts for XFS and ext3, taken with "strace -f -s0
-tt" after doing "echo 7 > /proc/sys/vm/drop_caches":

http://tikei.de/mutt_hcache_xfs.txt
http://tikei.de/mutt_hcache_ext3.txt

Note the start and end times. The ext3 case took nearly 18 seconds, the
XFS case took 3 seconds.

Regards,
Tino
