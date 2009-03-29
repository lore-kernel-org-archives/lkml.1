Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbZC2TcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbZC2TcU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 15:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbZC2TcF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 15:32:05 -0400
Received: from monster.nessie.de ([84.200.20.120]:52170 "EHLO
	monster.nessie.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755753AbZC2TcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 15:32:03 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Mar 2009 15:32:03 EDT
Message-ID: <49CFCB2A.4020505@nessie.de>
Date: Sun, 29 Mar 2009 21:25:30 +0200
From: Michael Roth <mroth@nessie.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090321)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Bug in 2.6.29 ide-cd: Kernel freeze: bisected + unacceptable workaround
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

first, thank you for your great work on the kernel!

Second, I have an issue:

I tried 2.6.29 but my maschine is always freezing after 2 minutes
and about 10 seconds running.

So I bisected that beast and found the cause (?):


commit 1e91477aa335fc1c97eb15649ed1a1714cc758ec
Author: Borislav Petkov <petkovbb@gmail.com>
Date:   Tue Jan 6 17:20:57 2009 +0100

    ide-cd: start DMA before sending the actual packet command

    as it is done for all other IDE ATAPI devices.

    There should be no functionality change resulting from this patch.

    Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>


I tried to revert this patch in 2.6.29 but the revert produced a merge
conflict and I don't have the knowledge to resolve this conflict.


So as a quick workaround I disabled ide-cd in my kernel config:

# CONFIG_BLK_DEV_IDECD is not set

which does the trick but is of course no solution. (I'm writing
this email with 2.6.29 and disabled ide-cd.)


My CD is a ide dvd drive attached to an promise pci-controller:

$ /usr/sbin/lspci
00:00.0 Host bridge: VIA Technologies, Inc. VT8366/A/7 [Apollo KT266/A/333]
00:01.0 PCI bridge: VIA Technologies, Inc. VT8366/A/7 [Apollo KT266/A/333 AGP]
00:09.0 Ethernet controller: Intel Corporation 82540EM Gigabit Ethernet Controller (rev 02)
00:0a.0 Mass storage controller: Promise Technology, Inc. 20269 (rev 02)
00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80)
00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80)
00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller (rev 80)
00:10.3 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 82)
00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
00:11.1 IDE interface: VIA Technologies, Inc. VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
00:11.5 Multimedia audio controller: VIA Technologies, Inc. VT8233/A/8235/8237 AC97 Audio Controller (rev 50)
00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 74)
01:00.0 VGA compatible controller: ATI Technologies Inc RV280 [Radeon 9200 PRO] (rev 01)
01:00.1 Display controller: ATI Technologies Inc RV280 [Radeon 9200 PRO] (Secondary) (rev 01)


The git bisect log is:

# bad: [8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84] Linux 2.6.29
# good: [4a6908a3a050aacc9c3a2f36b276b46c0629ad91] Linux 2.6.28
git bisect start 'v2.6.29' 'v2.6.28'
# good: [2774de17ba65130165a2cbca92e5a685581f7916] Staging: benet: build is broken unless CONFIG_NETPOLL is enabled
git bisect good 2774de17ba65130165a2cbca92e5a685581f7916
# bad: [9219a3b9889dbc7dae68e472f239672ff48860b0] Merge branch 'upstream' of git://ftp.linux-mips.org/pub/scm/upstream-linus
git bisect bad 9219a3b9889dbc7dae68e472f239672ff48860b0
# bad: [97d61b8e3aef163a75f80f4762794c154572293d] Merge branch 'bkl-removal' of git://git.lwn.net/linux-2.6
git bisect bad 97d61b8e3aef163a75f80f4762794c154572293d
# bad: [06af15e086e39a5a2a2413973a64af8e10122f28] Blackfin arch: fix bug - BF527 0.2 silicon has different CPUID (DSPID) value
git bisect bad 06af15e086e39a5a2a2413973a64af8e10122f28
# bad: [40d7ee5d162203b40b5f4fbb312ab016edddb97f] Merge git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core-2.6
git bisect bad 40d7ee5d162203b40b5f4fbb312ab016edddb97f
# good: [51ca58dcc9f0d6b1e78954d08bd4954fb6a1421c] eCryptfs: Filename Encryption: Encoding and encryption functions
git bisect good 51ca58dcc9f0d6b1e78954d08bd4954fb6a1421c
# bad: [59e3af21e94bd56f6a31ba774786a2bfc753581b] Merge git://git.kernel.org/pub/scm/linux/kernel/git/bart/ide-2.6
git bisect bad 59e3af21e94bd56f6a31ba774786a2bfc753581b
# good: [e953ac2195659940d0d042f7ac962700a6a0f0e3] ipc: do not goto to the next line
git bisect good e953ac2195659940d0d042f7ac962700a6a0f0e3
# bad: [9600dcf1347d304cf4dff34ef50569d6584b6968] ide: make "paranoia" ->handler check in ide_intr() more strict
git bisect bad 9600dcf1347d304cf4dff34ef50569d6584b6968
# good: [7f3c868ba78e486bd9d7569f884dd46d8f59bb18] ide: remove ide_driver_t typedef
git bisect good 7f3c868ba78e486bd9d7569f884dd46d8f59bb18
# good: [a32296f93821497d794ab8e1312d677717479777] ide: NUMA aware allocation of host and port structures
git bisect good a32296f93821497d794ab8e1312d677717479777
# good: [744a82b004b0a08d55f579daa55e32d963353edc] ide: Fix drive's DWORD-IO handling
git bisect good 744a82b004b0a08d55f579daa55e32d963353edc
# bad: [1e91477aa335fc1c97eb15649ed1a1714cc758ec] ide-cd: start DMA before sending the actual packet command
git bisect bad 1e91477aa335fc1c97eb15649ed1a1714cc758ec
# good: [7a38f3cf019c4187d3d0e757e1c11b2b460e5b57] ide-cd: wait for DRQ to get set per default
git bisect good 7a38f3cf019c4187d3d0e757e1c11b2b460e5b57


