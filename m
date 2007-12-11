Return-Path: <linux-kernel-owner+w=401wt.eu-S1756410AbXLKWs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbXLKWs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757458AbXLKWsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:48:07 -0500
Received: from smtp-dmz-232-tuesday.dmz.nerim.net ([195.5.254.232]:51967 "EHLO
	kellthuzad.dmz.nerim.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757174AbXLKWsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:48:05 -0500
X-Greylist: delayed 1808 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2007 17:48:05 EST
Date: Tue, 11 Dec 2007 23:16:08 +0100
From: Andre Majorel <aym-xunil@teaser.fr>
To: linux-kernel@vger.kernel.org
Subject: readlink(), the pause that refreshes
Message-ID: <20071211221608.GA21366@aym.net2.nerim.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 2.6.22.14. Create a tree of directories containing tens or
hundreds of thousands of symlinks and run

  find linkfarm | program-that-readlinks-the-file-names-in-its-stdin

Memory usage will grow and grow until the system starts to swap,
after which you are SOL. The combined effects of thrashing and the
OOM killer will render your system catatonic for a long time and
if it finally recovers, you probably won't be able to log in. With
1 GB of RAM, the tipping point is somewhere above 700,000
symlinks.

So you kill the pipe before it starts to swap. Memory usage does
not go down. Try "sync" or "umount /linkfarm". They will block for
minutes, during which memory usage goes down slowly, on the order
of 1 MB per second. All the while, iostat indicates several
hundred transactions per second on the disk where the link farm
resides.

All this crap appears to be related to the updating of the atimes
after a readlink. I understand that the problem could be
alleviated by mounting the file system noatime or relatime, but
this not just a performance problem. You should not be able to
make your system unusable with just one process making readlink()
calls.

As a stop gap, is there an equivalent of O_NOATIME for readlink() ?

-- 
André Majorel <URL:http://www.teaser.fr/~amajorel/>
Do not use this account for regular correspondence.
See the URL above for contact information.
