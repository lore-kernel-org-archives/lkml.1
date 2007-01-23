Return-Path: <linux-kernel-owner+w=401wt.eu-S965256AbXAWVOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965256AbXAWVOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 16:14:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965452AbXAWVOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 16:14:03 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:41345 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965256AbXAWVOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 16:14:00 -0500
X-Originating-Ip: 74.109.98.130
Date: Tue, 23 Jan 2007 16:13:43 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: identifying CONFIG variable typoes in the source tree
Message-ID: <Pine.LNX.4.64.0701231559090.3014@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  because it's cold outside and i was bored, i put together the
following script, to be run from the top of the source tree:

======================================================B
#!/bin/sh

CV=$(grep -rh "^#.*if.* CONFIG_[A-Za-z0-9]" . | grep -v endif)
CVARS=$(echo "${CV}" | sed "s/.*\(CONFIG_[^	 =\)\*\/]*\).*/\1/" | sort -u | grep "^CONFIG_")

kcfiles=$(find . -name "Kconfig*")

for cv in ${CVARS} ; do
	# echo "cv = ${cv}"
	str=$(echo ${cv} | sed "s/^CONFIG_//")
	# echo "str = ${str}"
	grep -wq ${str} ${kcfiles} || echo ${str}
done
=======================================================

  what it does is scan the entire tree for lines of the form

...if... CONFIG_whatever...

collects all of those CONFIG variables and, one at a time, checks to
see if that variable even exists in any Kconfig file in the tree so
that it could possibly ever be set.  (i'm not guaranteeing that the
script is perfect, but it does generate some interesting results.)

  the first few lines of output:

53C700_BE_BUS
64_BIT
68328_SERIAL_UART2
...

  let's check these:

$ grep -r 53C700_BE_BUS .
./drivers/scsi/53c700.h:#ifdef CONFIG_53C700_BE_BUS

  in short, a variable that's being tested with no possibility of ever
being set in a Kconfig file.  moving on,

$ grep -rw CONFIG_64_BIT .
./include/asm-um/elf-ppc.h:#ifdef CONFIG_64_BIT
$ grep -rw 64_BIT .
$

  so CONFIG_64_BIT is similarly being tested, but it's not being set
anywhere.  i'm guessing this is a misspelling of "CONFIG_64BIT", which
*does* exist in the tree and is quite common.  next:

$ grep -r 68328_SERIAL_UART2 .
./drivers/serial/68328serial.h:#ifndef CONFIG_68328_SERIAL_UART2
./arch/m68knommu/platform/68VZ328/config.c:#ifdef CONFIG_68328_SERIAL_UART2

  again, something being tested with no possibility of it being set
anywhere.

  the script turns up 284 examples of this.

rday
