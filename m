Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934046Ab0BQE3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 23:29:39 -0500
Received: from wdscexfe01.sc.wdc.com ([129.253.170.53]:39097 "EHLO
	wdscexfe01.sc.wdc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934026Ab0BQE3i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 23:29:38 -0500
X-Greylist: delayed 909 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Feb 2010 23:29:38 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: 4K disk block and disks larger than 2TiB bugs
Date: Tue, 16 Feb 2010 20:14:27 -0800
Message-ID: <3E0C3AE547FA504DA5E89EA5A24AC85803E2BD0A@wdscexbe01.sc.wdc.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 4K disk block and disks larger than 2TiB bugs
Thread-Index: Acqvh7JBqPoa/Q2qRcuqX2n3Op4cug==
From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 Feb 2010 04:14:28.0824 (UTC) FILETIME=[B2C5E580:01CAAF87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to use disks larger than 2TiB on Windows XP, it is necessary to
use 4096-byte logical sectors in an MBR.

When this MBR is presented to Linux, as from a USB-attached disk shared
with an XP system, Linux cannot recognise the partition if the disk is
very large.  The problem is that, while the storage for partition size
is properly 64-bit, in fs/partitions/msdos.c, among other places, there
are 32-bit intermediate variables, so the size is truncated.  I can fix
the MBR case myself (and will submit a patch when I learn the format and
protocol from watching the list).

The larger problem is for EFI.  There is a significant amount of hard-coded
assumption that LBAs are 512 bytes.  It would help if I could work with the
designer to make (and test) the changes in a way that abstracts away the
size (I do know that the kernel always thinks of disks in units of 512-byte
blocks).  I have seen attempts in the past to fix this problem, but the
patches
were rejected with erroneous comments about fixing it in user space.  If the
kernel will not recognise the partitions, or assigns incorrect values to the
starting block and/or number of blocks, there is nothing that user space can
do with the disk, except notice the EINVAL responses.

I have not, yet, worked my way through the Apple partition to see what
state it is in.

Comments?
