Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbZEQJae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbZEQJae (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 05:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbZEQJaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 05:30:13 -0400
Received: from mailout02.t-online.de ([194.25.134.17]:35645 "EHLO
	mailout02.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbZEQJaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 05:30:11 -0400
X-Greylist: delayed 1058 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 May 2009 05:30:10 EDT
Date: Sun, 17 May 2009 11:12:24 +0200
From: Martin Lottermoser <Martin.Lottermoser@t-online.de>
To: linux-kernel@vger.kernel.org
Subject: PATA DMA problem leading to kernel panic on reading movie DVDs
Message-ID: <20090517091224.GA8280@wanza.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ID: TJ0-RiZSohI5gE8IiFKaS-ro0JZxucsH2LtGWtSsONKCySP2SKGpzjjHeyuppK-gh8
X-TOI-MSGID: 164d97dd-73cd-4eb6-95ed-6fbe7f22f2c7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

newer versions of the Linux kernel overestimate my DVD drive's
DMA capabilities, leading either to DMA being disabled or a kernel
panic.

My setup is:

  Motherboard: ASUS P4C800-E Deluxe
    South bridge: ICH5R
      IDE Interface Controller (PATA): Intel 82801EB/ER (PCI: 8086:24db)
  DVD drive: Samsung SH-S202N, attached as hdc.
    There is also an older CD writer (Lite-On LTR-52327S) attached as
    hdd.
  Operating system: Debian 5.0.0 with security updates

On upgrading from Debian 4.0 (Linux 2.6.18) to 5.0 (Linux 2.6.26) I
found that trying to play movie DVDs with vlc (VideoLAN media player)
led to DMA being disabled:

  hdc: cdrom_decode_status: status=0x51 { DriveReady SeekComplete Error }
  hdc: cdrom_decode_status: error=0x40 { LastFailedSense=0x04 }
  ide: failed opcode was: unknown
  <4 more identical groups of these messages>
  hdc: DMA disabled
  hdc: ide_intr: huh? expected NULL handler on exit
  hdc: ATAPI reset complete

The resulting configuration is too slow to play movies. I booted the
older kernel and everything was fine.

I then tested various versions of the Linux kernel where I happened to
have the original sources. The most interesting results were:

  2.6.22.9      works, no errors visible in syslog
  2.6.23.14     works, but syslog shows an error (see below)
  2.6.24.3	DMA disabled
  2.6.29.3	Kernel panic: Fatal exception in interrupt (ide_intr)
                on trying to open the DVD with vlc

The error message with 2.6.23.14 was:

  hdc: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
  hdc: drive_cmd: error=0x04 { AbortedCommand }
  ide: failed opcode was: 0xec

This kernel as well as 2.6.22.9 also showed the following on booting:

  hdc: host side 80-wire cable detection failed, limiting max speed to UDMA33

This is correct: the drive is only capable of Ultra DMA mode 2 33.3 MB/s
(see manufacturer's documentation) and is attached with a standard 40-wire
ATA cable (black connectors for master and slave).

This led me to inspect other boot messages. With 2.6.18.3 I found:

  hdc: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache, UDMA(33)

2.6.24.3 showed:

  hdc: UDMA/66 mode selected
  ...
  hdc: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache

In contrast, the hdd drive shows up with "UDMA/33 mode selected" up to
and including 2.6.29.3.

I now use "hdparm -d1 -X udma2 /dev/hdc" with the Debian kernel 2.6.26
and the drive works as desired. However, when querying the drive's
capabilities with "hdparm -I", although the command terminates
successfully and without any error messages (it shows

  DMA: mdma0 mdma1 mdma2 udma0 udma1 *udma2 udma3 udma4

), on inspecting the syslog I find, on each invocation, a similar
error message as above with 2.6.23.14:

  hdc: task_in_intr: status=0x51 { DriveReady SeekComplete Error }
  hdc: task_in_intr: error=0x04 { AbortedCommand }
  ide: failed opcode was: 0xec

Interestingly enough, this happens also when calling "hdparm -I" on hdd.
There are also error messages

  hdc: set_drive_speed_status: status=0x51 { DriveReady SeekComplete Error }
  hdc: set_drive_speed_status: error=0x04 { AbortedCommand }
  ide: failed opcode was: unknown

from the boot phase.

Therefore there is still something wrong. Any suggestions on what that
is and how to fix it? (Answers preferably through "Cc:", but I'll also
try and follow the thread through list archives.)

Martin Lottermoser
--
Martin Lottermoser             Martin.Lottermoser at _REMOVE_t-online.de
Greifswaldstrasse 28
38124 Braunschweig             http://home.vrweb.de/martin.lottermoser
Germany
