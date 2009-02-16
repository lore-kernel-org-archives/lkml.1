Return-Path: <linux-kernel-owner+w=401wt.eu-S1755304AbZBPAF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbZBPAF6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 19:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbZBPAFs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 19:05:48 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:34770 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbZBPAFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 19:05:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=cvcR/5uv3y1Qhx8FTegtdQGfbSUE/lgwWD140yrKEnO27RFdUylRZVJIM8+rKhCkwQ
         +UcUeuWim6l0pmg4AfqMrlvQA32aQEP3cVn/IzZS3CpwhDAbgO/H0q09yRNI3Qu5wySg
         MiyUJ9obzEmEeAm0rqIUuG24u/oviUFFvcAf8=
MIME-Version: 1.0
Date: Mon, 16 Feb 2009 02:05:45 +0200
Message-ID: <8f53421d0902151605v56c92642ib8c2dcf34fd92ad1@mail.gmail.com>
Subject: [Bug 12713] Hang on resume from hibernation, apparently as result of 
	213d9417fec
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: pavel@suse.cz, rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       axboe@kernel.dk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary: seem to need to revert 213d9417fec62ef4c3675621b9364a667954d4dd
to fix resume from hibernation. Bugzilla entry created:
http://bugzilla.kernel.org/show_bug.cgi?id=12713

On kernel 2.6.29-rc3 and earlier, suspend/resume from disk
(hibernation) works fine on my T60p with dm crypt full disk encryption.

Starting with 2.6.29-rc4, I get hangs on resume from suspend to disk.
On resume, after a bit of regular activity, the disk LED lights up
with an unusual dull color and stays that way.
Pressing CTRL-ALT-DEL causes linux to print a message that it will
reboot, and reboot after a couple of seconds.

I bisected and got to the following commit:
commit 213d9417fec62ef4c3675621b9364a667954d4dd
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Tue Jan 6 09:16:05 2009 +0100

    block: seperate bio/request unplug and sync bits

    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

I reverted the commit 213d9417fec62ef4c3675621b9364a667954d4dd
on top of 2.6.29-rc5 (resolving a trivial conflict) and verified
that reverting this commit fixes hibernate for me.

Bisect log below:

git bisect start
# bad: [8e4921515c1a379539607eb443d51c30f4f7f338] Linux 2.6.29-rc4
git bisect bad 8e4921515c1a379539607eb443d51c30f4f7f338
# good: [18e352e4a73465349711a9324767e1b2453383e2] Linux 2.6.29-rc3
git bisect good 18e352e4a73465349711a9324767e1b2453383e2
# bad: [5c350d93ff4736086a1b08fef1d0b5e22138d2e0] Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc
git bisect bad 5c350d93ff4736086a1b08fef1d0b5e22138d2e0
# good: [bb9f113f5ca7d182256dee69bcaebd4c79062305] headers_check fix:
sound/hdsp.h
git bisect good bb9f113f5ca7d182256dee69bcaebd4c79062305
# bad: [2d2eca4d11933bd37a4944aae06e6122efffaea8] MIPS: Alchemy: time.c build
fix
git bisect bad 2d2eca4d11933bd37a4944aae06e6122efffaea8
# bad: [ae704e9f92f87b12c5938b07245792857c7c9c14] Merge branch 'for-linus' of
git://git.kernel.dk/linux-2.6-block
git bisect bad ae704e9f92f87b12c5938b07245792857c7c9c14
# good: [584dbe9475313e117abf9d2af88164edfd429c9a] netxen: fix memory leak in
drivers/net/netxen_nic_init.c
git bisect good 584dbe9475313e117abf9d2af88164edfd429c9a
# bad: [7598909e3ee2a08726276d6415b69dadb52d0d76] Mark mandatory elevator
functions in the biodoc.txt
git bisect bad 7598909e3ee2a08726276d6415b69dadb52d0d76
# good: [1308835ffffe6d61ad1f48c5c381c9cc47f683ec] block: export
SSD/non-rotational queue flag through sysfs
git bisect good 1308835ffffe6d61ad1f48c5c381c9cc47f683ec
# bad: [dbdac9b71dff5d27885f82eb2cfca310861fdf9e] block: Fix documentation for
blkdev_issue_flush()
git bisect bad dbdac9b71dff5d27885f82eb2cfca310861fdf9e
# bad: [1dfa17f4ab8543d82caf4d36636b93916a18f456] block: add bio_rw_flagged()
for testing bio->bi_rw
# Had trouble booting, booted second time after reset
git bisect bad 1dfa17f4ab8543d82caf4d36636b93916a18f456
# bad: [213d9417fec62ef4c3675621b9364a667954d4dd] block: seperate bio/request
unplug and sync bits
# Shows suspend progress nicely, some other commits tested don't
git bisect bad 213d9417fec62ef4c3675621b9364a667954d4dd


.config attached to bugzilla entry
