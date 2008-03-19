Return-Path: <linux-kernel-owner+w=401wt.eu-S1161339AbYCTAIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161339AbYCTAIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937551AbYCSXRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:17:09 -0400
Received: from relay2.sgi.com ([192.48.171.30]:58617 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S941559AbYCSXRC (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:17:02 -0400
Date: Thu, 20 Mar 2008 10:16:54 +1100
From: David Chinner <dgc@sgi.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Buffered I/O to block device very slow and other SCSI issues...
Message-ID: <20080319231654.GA103321673@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

4p ia64, 24GB RAM, 2.6.25-rc3, qla1280, 15krpm scsi disk.

Direct I/O:

dgc@budgie:~/xfstests$ sudo dd if=/dev/zero of=/dev/sdb6 bs=1024k count=1024 oflag=direct
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 27.8974 s, 38.5 MB/s

Doing approximately 80 512k I/os per second (disk bandwidth).

Buffered I/O:

dgc@budgie:~/xfstests$ sudo dd if=/dev/zero of=/dev/sdb6 bs=1024k count=4096
4096+0 records in
4096+0 records out
4294967296 bytes (4.3 GB) copied, 427.872 s, 10.0 MB/s

Which was doing about 200 64k I/Os per second for the entire write.
Interactivity goes to hell, cpu usage is pretty much zero. I can
barely run anything, I can't ctrl-c out of running programs, etc.

It would appear that the block device is being flushed one sector at
a time:

  8,22   3     8757    26.699052800 12143  Q   W 9770471 + 1 [sync]
  8,22   3     8760    26.699058050 12143  Q   W 9770472 + 1 [sync]
  8,22   3     8763    26.699063300 12143  Q   W 9770473 + 1 [sync]
  8,22   3     8766    26.699068900 12143  Q   W 9770474 + 1 [sync]
  8,22   3     8769    26.699074150 12143  Q   W 9770475 + 1 [sync]
  8,22   3     8772    26.699079400 12143  Q   W 9770476 + 1 [sync]
  8,22   3     8775    26.699084650 12143  Q   W 9770477 + 1 [sync]
  8,22   3     8778    26.699090200 12143  Q   W 9770478 + 1 [sync]
  8,22   3     8781    26.699095600 12143  Q   W 9770479 + 1 [sync]
  8,22   3     8784    26.699100800 12143  Q   W 9770480 + 1 [sync]
  8,22   3     8787    26.699106100 12143  Q   W 9770481 + 1 [sync]
  8,22   3     8790    26.699111700 12143  Q   W 9770482 + 1 [sync]
  8,22   3     8793    26.699117000 12143  Q   W 9770483 + 1 [sync]
  8,22   3     8796    26.699122250 12143  Q   W 9770484 + 1 [sync]
  8,22   3     8799    26.699127500 12143  Q   W 9770485 + 1 [sync]
  8,22   3     8802    26.699133100 12143  Q   W 9770486 + 1 [sync]
  8,22   3     8805    26.699138450 12143  Q   W 9770487 + 1 [sync]

And it's only combining into 128 sector I/Os. Something wrong
with bio merging limiting the I/os to 128 elements? I'm using BSG
here, so maybe that's a factor.....

I also suspect that CTQ has not been set up correctly on this
kernel, because:

$ cat /sys/block/sdb/device/queue_depth
3
$ ls -l /sys/block/sdb/device/queue_depth
-r--r--r-- 1 root root 0 Mar 20 09:59 /sys/block/sdb/device/queue_depth
$

It appears to be hard coded to 3 and can't be changed....

Hmmm:

$ sudo sdparm -s WCE=1 /dev/sdb
SCSI INQUIRY command failed on /dev/sdb
$

Did I miss some new config option, or are things just generally broken?

Cheers,

Dave.

-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
