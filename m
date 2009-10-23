Return-Path: <linux-kernel-owner+w=401wt.eu-S1751395AbZJWVOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbZJWVOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 17:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbZJWVOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 17:14:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbZJWVOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 17:14:53 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: jens.axboe@oracle.com
Cc: czoccolo@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH/RFC 0/4] cfq: implement merging and breaking up of cfq_queues
Date: Fri, 23 Oct 2009 17:14:48 -0400
Message-Id: <1256332492-24566-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a follow-up patch to the original close cooperator support for
CFQ.  The problem is that some programs (NFSd, dump(8), iscsi target
mode driver, qemu) interleave sequential I/Os between multiple threads
or processes.  The result is that there are large delays due to CFQ's
idling logic that leads to very low throughput.  The original patch
partially addresses these problems by detecting close cooperators and
allowing them to jump ahead in the scheduling order.  This doesn't work
100% of the time, unfortunately, and you can have some processes in the
group getting way ahead (LBA-wise) of the others, leading to a lot of seeks.

This patch series addresses the problems in the current implementation by
merging cfq_queue's of close cooperators.  The results are encouraging:

read-test2 emulates the I/O patterns of dump(8).  The following results
are taken from 50 runs of patched, 16 runs of unpatched (I got impatient):

               Average   Std. Dev.
----------------------------------
Patched CFQ:   88.81773  0.9485
Vanilla CFQ:   12.62678  0.24535

Single streaming reader over NFS, results in MB/s are the average of 2
runs.

              |patched|
nfsd's|  cfq  |  cfq  | deadline
------+-------+-------+---------
  1   |  45   |  45   | 36
  2   |  57   |  60   | 60
  4   |  38   |  49   | 50
  8   |  34   |  40   | 49
  16  |  34   |  43   | 53

I've tested that sequential access patterns do trigger the merging of queues,
and that when the I/O becomes random, the cfq_queues are split apart.  Comments,
as always, are greatly appreciated.

Cheers,
Jeff
