Return-Path: <linux-kernel-owner+w=401wt.eu-S1754524AbZJBWyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbZJBWyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753817AbZJBWyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:54:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753525AbZJBWyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:54:23 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: zach.brown@oracle.com
Cc: linux-aio <linux-aio@kvack.org>,
       Linux Kernel Mailing <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch v4 0/3] aio: implement request batching
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 02 Oct 2009 18:54:20 -0400
Message-ID: <x49zl8976g3.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In this, the 4th iteration of the patch set, I've addressed the concerns
of Jens and Zach as follows:

- In the O_DIRECT write path, we get rid of WRITE_ODIRECT in favor of
  WRITE_SYNC_PLUG
- request batching is only done for AIO operations that could
  potentially benefit from it
- Initialization of the hash table is done using the gcc array
  initialization syntax

Further, I got rid of a compiler warning that I had introduced in the
last patch set.  I'll continue to test this under a variety of loads,
but would certainly appreciate it if others could give it a spin.

Patch overview / reason for existence:

Some workloads issue batches of small I/Os, and the performance is poor
due to the call to blk_run_address_space for every single iocb.  Nathan
Roberts pointed this out, and suggested that by deferring this call
until all I/Os in the iocb array are submitted to the block layer, we
can realize some impressive performance gains.

For example, running against a simple SATA disk driving a queue depth of
128, we can improve the performance of O_DIRECT writes twofold for 4k
I/Os, and similarly impressive numbers for other I/O sizes:
  http://people.redhat.com/jmoyer/dbras/vanilla-vs-v4/metallica-single-sata/noop/io-depth-128-write-bw.png

For read workloads on somewhat faster storage, we see similar benefits
for batches of smaller I/Os as well:
  http://people.redhat.com/jmoyer/dbras/vanilla-vs-v4/thor-4-disk-lvm-stripe/noop/io-depth-16-read-bw.png
That's 230+MB/s for vanilla 4k reads, batches of 16 vs. 410MB/s for
patched.  When there are multiple threads competing for the disk, I
haven't witnessed such crazy numbers, however.

Cheers,
Jeff
