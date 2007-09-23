Return-Path: <linux-kernel-owner+w=401wt.eu-S1756142AbXIWV0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142AbXIWV0Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 17:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753642AbXIWV0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 17:26:17 -0400
Received: from marcansoft.com ([80.68.93.119]:4576 "EHLO smtp.marcansoft.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbXIWV0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 17:26:16 -0400
X-Greylist: delayed 2096 seconds by postgrey-1.27 at vger.kernel.org; Sun, 23 Sep 2007 17:26:16 EDT
Message-ID: <46F6D1C3.2070208@marcansoft.com>
Date: Sun, 23 Sep 2007 16:51:15 -0400
From: Hector Martin <hector@marcansoft.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070821)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Coding FATX support for 2.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Most xbox-linux users are stuck using 2.4, since there is no FATX driver
for 2.6 and the 2.4 one is unmaintained. I've been thinking about
writing FATX support into 2.6, to finally end this problem (this is
basically the only thing holding up 2.6 for Xbox Linux distros). While I
have done a little kernel coding in the past, I've never messed with
filesystems in Linux and I'm not entirely sure what the best approach
would be here. I would like to do it in such a way that it can be
included in mainline once it is complete. This would also be beneficial
for PC Linux distros, as it enables access to Xbox memory cards (needed
to soft-mod an Xbox to run Linux - currently users have to either use
Windows or boot an Xbox-Linux distro on their PC)

Here's a quick rundown of the differences between FAT and FATX:
- The superblock is different. FATX hardcodes or calculates most of the
parameters. All that is left in the superblock is a magic string and a
few basic parameters. For example, FATX calculates the number of
clusters, and therefore the size of the FAT, from the size of the
device. There is also no free block count present - this is instead
calculated by scanning the FAT (which can be slow for large partitions).
- The FAT itself is mostly the same, except for a few details regarding
the first few entries. FATX is also available in FATX16 and FATX32
variants. Which is in use depends on the size of the device. FATX32
actually uses all 32 bits in the FAT entries, instead of 28 bits like
FAT32 does.
- Directory entries are 64 bytes long. Filenames are up to 42 characters
long. There is no stupid long filename overlay hack like VFAT uses. File
extensions have no special place - filenames are simple unformatted
42-byte strings. Date/Times are the same, but the epoch is different.

I see several options for implementing this:
- Add support to the standard FAT driver. This should probably be made a
configurable suboption.
- Add support that piggybacks onto the standard FAT driver, but
otherwise doesn't touch it. I don't know how feasible this is.
- Modify the FAT driver to allow the basic changes needed to support
FATX, then piggyback it for the actual implementation. See above.
- Fork the FAT driver and make it into a FATX driver.
- Start from scratch.

I'm unsure about what the best option would be. Obviously changes to FAT
should be made with care, as we don't want to cause a regression.
However, much of the code (allocation strategies, FAT handling, etc)
should be the same or very similar, so it seems stupid to start from
scratch.

Comments?


-- 
Hector Martin (hector@marcansoft.com)
Public Key: http://www.marcansoft.com/marcan.asc

