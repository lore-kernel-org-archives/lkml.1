Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbYCMJoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbYCMJoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 05:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbYCMJnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 05:43:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:16790 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897AbYCMJnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 05:43:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=UxkGksbrZlE73kJ6Ym7ptX19XRVS3umUbwhdiOIGeSW22hU7DH/MV2LwiFMAkxbzUtjaf8Aaaf39eMukZRYzRaspHTtZwN1fWRAIH+r6MZRofMVyjeeHQz9/3v5y20zgYk8I4G64B0ELDAAmMicp6dWFwleCPNCh0XCkC2RHrok=
Message-ID: <47D8F73F.4090501@gmail.com>
Date: Thu, 13 Mar 2008 10:43:27 +0100
From: Richard Genoud <richard.genoud@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: bzolnier@gmail.com
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUG] PLEXTOR DVDR PX-740A drive not ready for command
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
On ubuntu bug tracker, there's some bug reports about DVD drives that don't respond anymore.

The affected drives are:
PLEXTOR DVDR PX-740A
BENQ DVD DD DW1620
PHILIPS DVDR14P
SS-SAMSUNG SCR-3232
Matsushita SR-8584-B
(for now)

the error message is :
hda: status error: error=0x00 { }
ide: failed opcode was: unknown
hda: drive not ready for command
hda: status error: status 0x59 { DriveReady SeekComplete DataRequest Error }

more details on the ubuntu bug-tracker:
https://bugs.launchpad.net/bugs/179336
https://bugs.launchpad.net/bugs/182996
https://bugs.launchpad.net/bugs/181561

I bisect to find out where the bug was and I found that this commit is:

b140b99c413ce410197cfcd4014e757cd745226a is first bad commit
commit b140b99c413ce410197cfcd4014e757cd745226a
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sat Oct 13 17:47:51 2007 +0200

    ide: change master/slave IDENTIFY order
    
    Need to probe slave device first to make it release PDIAG-
    (this is required for correct device side cable detection).
    
    Based on libata commit f31f0cc2f0b7527072d94d02da332d9bb8d7d94c.
    
    Thanks to Craig for testing this patch.
    
    Cc: Craig Block <chblock3@yahoo.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

:040000 040000 fa17f9e66a6e551184b1ec00049cea6fb87f7a1c 89a175312afe235fbdb04a3a593a4b981bdd9188 M      drivers



The bisect log is:

git-bisect start
# good: [bbf25010f1a6b761914430f5fca081ec8c7accd1] Linux 2.6.23
git-bisect good bbf25010f1a6b761914430f5fca081ec8c7accd1
# bad: [c9927c2bf4f45bb85e8b502ab3fb79ad6483c244] Linux 2.6.24-rc1
git-bisect bad c9927c2bf4f45bb85e8b502ab3fb79ad6483c244
# bad: [9ac52315d4cf5f561f36dabaf0720c00d3553162] sched: guest CPU accounting: add guest-CPU /proc/<pid>/stat fields
git-bisect bad 9ac52315d4cf5f561f36dabaf0720c00d3553162
# good: [038a5008b2f395c85e6e71d6ddf3c684e7c405b0] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
git-bisect good 038a5008b2f395c85e6e71d6ddf3c684e7c405b0
# good: [782e3b3b3804c38d5130c7f21d7ec7bf6709023f] Fix up more bio fallout
git-bisect good 782e3b3b3804c38d5130c7f21d7ec7bf6709023f
# good: [1b9778dae71dc64d3678d766c0f1fbed79c80f9f] KVM: Keep track of missed timer irq injections
git-bisect good 1b9778dae71dc64d3678d766c0f1fbed79c80f9f
# bad: [bcd11eaa222fce31d0b59cdbfdf9b8c47067f15a] Merge git://git.kernel.org/pub/scm/linux/kernel/git/bart/ide-2.6
git-bisect bad bcd11eaa222fce31d0b59cdbfdf9b8c47067f15a
# good: [c5d6471ff9172e4d8f7a5b484b459c56904ae1f0] fallout from DECLARE_MAC_BUF patches
git-bisect good c5d6471ff9172e4d8f7a5b484b459c56904ae1f0
# good: [59d8235be2ab38ddaffbe9137385095a5e8b0a77] [JFFS2] Fix unpoint length
git-bisect good 59d8235be2ab38ddaffbe9137385095a5e8b0a77
# good: [3749c66c67fb5c257771815c186bc32290cacf44] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm
git-bisect good 3749c66c67fb5c257771815c186bc32290cacf44
# bad: [b9d9e61abb85ecf4e4aa55328b21eac17840a3fb] sgiioc4: add missing ->dma_base check
git-bisect bad b9d9e61abb85ecf4e4aa55328b21eac17840a3fb
# good: [aedea5910ce44fea79e2c517bb22e0006372156f] ide-pmac: remove pmac_ide_do_setfeature() (take 2)
git-bisect good aedea5910ce44fea79e2c517bb22e0006372156f
# good: [249aa4ff1778b318346d8ba4a7fa62c169a29410] cs5535: check ide_config_drive_speed() return value
git-bisect good 249aa4ff1778b318346d8ba4a7fa62c169a29410
# bad: [b140b99c413ce410197cfcd4014e757cd745226a] ide: change master/slave IDENTIFY order
git-bisect bad b140b99c413ce410197cfcd4014e757cd745226a
# good: [88b2b32babd46cd54d2de4d17eb869aea3383e11] ide: move ide_config_drive_speed() calls to upper layers (take 2)
git-bisect good 88b2b32babd46cd54d2de4d17eb869aea3383e11

If you need me to do some more tests, just ask.

regards,

Richard Genoud.


