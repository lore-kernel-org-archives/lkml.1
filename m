Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab0CGSeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 13:34:12 -0500
Received: from tenax.loup.net ([209.169.16.66]:40547 "EHLO tenax.loup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab0CGSeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 13:34:11 -0500
Date: Sun, 7 Mar 2010 11:22:03 -0700
Message-Id: <201003071822.o27IM3Hq000646@alien.loup.net>
From: Mike Hayward <hayward@loup.net>
To: linux-kernel@vger.kernel.org
Subject: Is SG the only way to flush a disk cache from userspace?
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am writing userspace code that needs to work against any vanilla
kernel, so the question is, is the scsi generic interface the only way
to flush a volatile cache on a disk drive from userspace?

I've written a fault tolerant, distributed storage application that
runs under linux and would like to utilize the volatile caches found
on disk drives to improve performance and mtbf.  This of course
absolutely requires the ability to synchronize the disk cache.

I've tried using scsi generic for actual io.  Although my code runs
successfully against the nonblocking sg character mode device, it has
serious performance issues so far.

I note that fio doesn't even seem to work as it's source code intends
if pointed at an sg character device on recent kernels.  Furthermore,
after running it, it leaves the device in a "slow" state where it runs
at roughly one quarter the iops which I resolved by rebooting.  Even
sync io is "slow" afterward, but libaio still works at normal speed.

This seems to be a kernel defect; can anyone else reproduce these same
results?  As evidence, consider the following three fio runs to the
same usb flash drive.

  # fio --name=/dev/sdd --ioengine=sg --buffered=0 --rw=randread --bs=1k --iodepth=64
  /dev/sdd: (g=0): rw=randread, bs=1K-1K/1K-1K, ioengine=sg, iodepth=64
  Starting 1 process
  bs: 1 (f=1): [r] [0.1% done] [1,803K/0K /s] [2K/0 iops] [eta 01h:26m:05s]
  fio: terminating on signal 2

  # fio --name=/dev/sg3 --ioengine=sg --buffered=0 --rw=randread --bs=1k --iodepth=64
  /dev/sg3: (g=0): rw=randread, bs=1K-1K/1K-1K, ioengine=sg, iodepth=64
  Starting 1 process
  /dev/sg3: you need to specify size=
  fio: pid=0, err=22/file:filesetup.c:549, func=total_file_size, error=Invalid argument

  Run status group 0 (all jobs):

  # fio --name=/dev/sdd --ioengine=sg --buffered=0 --rw=randread --bs=1k --iodepth=64
  /dev/sdd: (g=0): rw=randread, bs=1K-1K/1K-1K, ioengine=sg, iodepth=64
  Starting 1 process
  bs: 1 (f=1): [r] [0.0% done] [607K/0K /s] [593/0 iops] [eta 04h:27m:49s]
  fio: terminating on signal 2

If I must use another mechanism to perform nonblocking io
(e.g. libaio) it will be quite a hack to run both libaio and sg to the
same drive just to be able to flush it, but that seems like the only
way to get non blocking performance on a vanilla kernel.

Does anyone (Jens?) know how Oracle or any other fault tolerant
database flushes a drive cache?  Is Oracle using libaio+sg or do they
supply a custom kernel module?

- Mike
