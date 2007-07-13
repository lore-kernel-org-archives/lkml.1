Return-Path: <linux-kernel-owner+w=401wt.eu-S936630AbXGMJ23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936630AbXGMJ23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763298AbXGMJ2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:28:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:8660 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759312AbXGMJ2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:28:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=qaCeYKpMkVHCWWgEqnAm6foUGGuyIC5KiXShNQwg6PZiRROpAH9Eth982ebal3BhrR+pGAeWY9TQIar+BNGbsDkHAE7viDtEnwNmQQpMKbgx9TMBZzd0tpulW0UQ/pS+bMNP+xzSApNAM1lOM34oe/pn1IepmCfV/JGjRxUsyaA=
Message-ID: <469745A8.6010005@googlemail.com>
Date: Fri, 13 Jul 2007 11:28:08 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: On current git head webservers stopped working
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello ,

While doing some tests with 2.6.22-git2 ( at the time head
4eb6bf6bfb580afaf1e1a1d30cba17a078530cf4 ) all my webservers stopped
working.
I can't get any file using wget or whatever else , everything hangs
after 1% forever.

I bisected this and here the result:

534f2aaa6ab07cd71164180bc958a7dcde41db11 is first bad commit
commit 534f2aaa6ab07cd71164180bc958a7dcde41db11
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Fri Jun 1 14:52:37 2007 +0200

    sys_sendfile: switch to using ->splice_read, if available

    This patch makes sendfile prefer to use ->splice_read(), if it's
    available in the file_operations structure.

    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

:040000 040000 b19013793692eee0f632b3703dca0bd40cea753f
ed50576c0d3f0d3ce9f1a2ac9336d1164b45f63f M      fs


This is :

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blobdiff;f=fs/read_write.c;h=47da8a4a0fbecd1bbf00aaf29fd1fdc6dc7408d8;hp=4d03008f015b9ae6d2565cdbc179d034687c3d08;hb=534f2aaa6ab07cd71164180bc958a7dcde41db11;hpb=6a14b90bb6bc7cd83e2a444bf457a2ea645cbfe7

crazy@lara:/work/crazy/linux-git/linux-2.6$ git bisect log
git-bisect start
# bad: [4eb6bf6bfb580afaf1e1a1d30cba17a078530cf4] lots-of-architectures:
enable arbitary speed tty support
git-bisect bad 4eb6bf6bfb580afaf1e1a1d30cba17a078530cf4
# good: [7dcca30a32aadb0520417521b0c44f42d09fe05c] Linux 2.6.22
git-bisect good 7dcca30a32aadb0520417521b0c44f42d09fe05c
# good: [bf74b964775009071cf12f9d59d4dd5e388fbe0b] [MIPS] DEC: Fix
modpost warning.
git-bisect good bf74b964775009071cf12f9d59d4dd5e388fbe0b
# bad: [1b21f458ddbc8fb6fceeb68158e9e04b2571dabd] Merge
git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw
git-bisect bad 1b21f458ddbc8fb6fceeb68158e9e04b2571dabd
# bad: [01370f0603f8435d415a19f7e62d1bab826c3589] Merge branch
'splice-2.6.23' of git://git.kernel.dk/data/git/linux-2.6-block
git-bisect bad 01370f0603f8435d415a19f7e62d1bab826c3589
# good: [4f179f71607382888c5ce5385a4ee136e1a2002a] Input: serio_raw -
shut up errorneous warning
git-bisect good 4f179f71607382888c5ce5385a4ee136e1a2002a
# bad: [cac36bb06efe4880234524e117e0e712b10b1f16] pipe: change the
->pin() operation to ->confirm()
git-bisect bad cac36bb06efe4880234524e117e0e712b10b1f16
# bad: [cf8208d0eabd1d5d2625ec02a175a294c3f30d36] sendfile: convert nfsd
to splice_direct_to_actor()
git-bisect bad cf8208d0eabd1d5d2625ec02a175a294c3f30d36
# bad: [5ffc4ef45b3b0a57872f631b4e4ceb8ace0d7496] sendfile: remove
.sendfile from filesystems that use generic_file_sendfile()
git-bisect bad 5ffc4ef45b3b0a57872f631b4e4ceb8ace0d7496
# good: [6a14b90bb6bc7cd83e2a444bf457a2ea645cbfe7] vmsplice: add
vmsplice-to-user support
git-bisect good 6a14b90bb6bc7cd83e2a444bf457a2ea645cbfe7
# bad: [534f2aaa6ab07cd71164180bc958a7dcde41db11] sys_sendfile: switch
to using ->splice_read, if available
git-bisect bad 534f2aaa6ab07cd71164180bc958a7dcde41db11


Reverting 534f2aaa6ab07cd71164180bc958a7dcde41db11 from git2 solved that
problem for me.

I've compiled current git head and the problem still exists but I cannot
revert this commit while some conflicts.



Regards ,

Gabriel C
