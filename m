Return-Path: <linux-kernel-owner+w=401wt.eu-S1757597AbYBEStI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597AbYBEStI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:49:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756118AbYBESsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:48:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbYBESsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:48:54 -0500
Message-ID: <47A8AF1F.5060402@redhat.com>
Date: Tue, 05 Feb 2008 19:46:55 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
CC: axboe@kernel.dk, "Ed L. Cashin" <ecashin@coraid.com>
Subject: [Patch 7/6] Enhanced partition statistics: documentation update
References: <47A3616F.20305@redhat.com> <20080201223317.GD8529@kroah.com>
In-Reply-To: <20080201223317.GD8529@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the documentation to reflect the change in userspace interface.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 Documentation/ABI/testing/procfs-diskstats |   22 ++++++++++++++
 Documentation/ABI/testing/sysfs-block      |   28 +++++++++++++++++++
 Documentation/iostats.txt                  |   15 +++++++++-
 3 files changed, 64 insertions(+), 1 deletion(-)
diff -urNp linux-2.6.orig/Documentation/ABI/testing/procfs-diskstats linux-2.6/Documentation/ABI/testing/procfs-diskstats
--- linux-2.6.orig/Documentation/ABI/testing/procfs-diskstats	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6/Documentation/ABI/testing/procfs-diskstats	2008-02-05 19:29:10.000000000 +0100
@@ -0,0 +1,22 @@
+What:		/proc/diskstats
+Date:		February 2008
+Contact:	Jerome Marchand <jmarchan@redhat.com>
+Description:
+		The /proc/diskstats file displays the I/O statistics
+		of block devices. Each line contains the following 14
+		fields:
+		 1 - major number
+		 2 - minor mumber
+		 3 - device name
+		 4 - reads completed succesfully
+		 5 - reads merged
+		 6 - sectors read
+		 7 - time spent reading (ms)
+		 8 - writes completed
+		 9 - writes merged
+		10 - sectors written
+		11 - time spent writing (ms)
+		12 - I/Os currently in progress
+		13 - time spent doing I/Os (ms)
+		14 - weighted time spent doing I/Os (ms)
+		For more details refer to Documentation/iostats.txt
diff -urNp linux-2.6.orig/Documentation/ABI/testing/sysfs-block linux-2.6/Documentation/ABI/testing/sysfs-block
--- linux-2.6.orig/Documentation/ABI/testing/sysfs-block	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6/Documentation/ABI/testing/sysfs-block	2008-02-05 19:32:02.000000000 +0100
@@ -0,0 +1,28 @@
+What:		/sys/block/<disk>/stat
+Date:		February 2008
+Contact:	Jerome Marchand <jmarchan@redhat.com>
+Description:
+		The /sys/block/<disk>/stat files displays the I/O
+		statistics of disk <disk>. They contain 11 fields:
+		 1 - reads completed succesfully
+		 2 - reads merged
+		 3 - sectors read
+		 4 - time spent reading (ms)
+		 5 - writes completed
+		 6 - writes merged
+		 7 - sectors written
+		 8 - time spent writing (ms)
+		 9 - I/Os currently in progress
+		10 - time spent doing I/Os (ms)
+		11 - weighted time spent doing I/Os (ms)
+		For more details refer Documentation/iostats.txt
+
+
+What:		/sys/block/<disk>/<part>/stat
+Date:		February 2008
+Contact:	Jerome Marchand <jmarchan@redhat.com>
+Description:
+		The /sys/block/<disk>/<part>/stat files display the
+		I/O statistics of partition <part>. The format is the
+		same as the above-written /sys/block/<disk>/stat
+		format.
diff -urNp linux-2.6.orig/Documentation/iostats.txt linux-2.6/Documentation/iostats.txt
--- linux-2.6.orig/Documentation/iostats.txt	2008-02-05 19:29:44.000000000 +0100
+++ linux-2.6/Documentation/iostats.txt	2008-02-05 19:29:10.000000000 +0100
@@ -58,7 +58,7 @@ they should not wrap twice before you no
 Each set of stats only applies to the indicated device; if you want
 system-wide stats you'll have to find all the devices and sum them all up.
 
-Field  1 -- # of reads issued
+Field  1 -- # of reads completed
     This is the total number of reads completed successfully.
 Field  2 -- # of reads merged, field 6 -- # of writes merged
     Reads and writes which are adjacent to each other may be merged for
@@ -132,6 +132,19 @@ words, the number of reads for partition
 of queuing for partitions, and at completion for whole disks.  This is
 a subtle distinction that is probably uninteresting for most cases.
 
+More significant is the error induced by counting the numbers of
+reads/writes before merges for partitions and after for disks. Since a
+typical workload usually contains a lot of successive and adjacent requests,
+the number of reads/writes issued can be several times higher than the
+number of reads/writes completed.
+
+In 2.6.25, the full statistic set is again available for partitions and
+disk and partition statistics are consistent again. Since we still don't
+keep record of the partition-relative address, an operation is attributed to
+the partition which contains the first sector of the request after the
+eventual merges. As requests can be merged across partition, this could lead
+to some (probably insignificant) innacuracy.
+
 Additional notes
 ----------------
 
