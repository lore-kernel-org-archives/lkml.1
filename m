Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbYIOULc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbYIOULc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 16:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbYIOULW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 16:11:22 -0400
Received: from sh.osrg.net ([192.16.179.4]:44776 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769AbYIOULV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 16:11:21 -0400
Date: Tue, 16 Sep 2008 05:10:41 +0900 (JST)
Message-Id: <20080916.051041.110880811.ryusuke@osrg.net>
To: pavel@suse.cz
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/27] nilfs2: add document
From: konishi.ryusuke@lab.ntt.co.jp
In-Reply-To: <20080915095427.GA1861@elf.ucw.cz>
References: <1221419304-18572-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1221419304-18572-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<20080915095427.GA1861@elf.ucw.cz>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, 15 Sep 2008 11:54:27 +0200, Pavel Machek wrote:
> Hi!
> 
> > +NILFS2 is a log-structured file system (LFS) supporting continuous
> > +snapshotting.  In addition to versioning capability of the entire file
> > +system, users can even restore files mistakenly overwritten or
> 
> Hmm, undelete done right. Just one question... how slow/fast is it
> compared to conventional filesystems (ext3?)?
> 								Pavel

After my first submission, Szabolcs Szakacsits showed benchmark
results using compilebench.

On Thu, 21 Aug 2008 00:25:55 +0300 (MET DST)
Szabolcs Szakacsits <szaka@ntfs-3g.org> wrote:
> I ran compilebench on kernel 2.6.26 with freshly formatted volumes.
> The behavior of NILFS2 was interesting.
>
> Its peformance rapidly degrades to the lowest ever measured level
> (< 1 MB/s) but after a while it recovers and gives consistent numbers.
> However it's still very far from the current unstable btrfs performance.
> The results are reproducible.
>
>                     MB/s    Runtime (s)
>                    -----    -----------
>   btrfs unstable   17.09        572
>   ext3             13.24        877
>   btrfs 0.16       12.33        793
>   nilfs2 2nd+ runs 11.29        674
>   ntfs-3g           8.55        865
>   reiserfs          8.38        966
>   nilfs2 1st run    4.95       3800
>   xfs               1.88       3901

Accordint to his measurement, NILFS2 showed a very low performance
on the first measument, and it recovered after a while.

I still don't know the reason why NILFS2 shows such behaviour, and
I'm thinking to follow the benchmark.

A little while ago, I tried another benchmark on the kernel 2.6.27-rc6.
The iozone benchmark.  The result was as follows:

 Throughput in MB/s (buffer size = 8B, file size = 500MB)
      <write> <rewrite> <read> <reread> <rand-read> <rand-write>
 ext3    44.918  46.691  56.541  56.505  1.562   5.716
 nilfs2  56.076  43.703  41.364  41.356  1.231   37.650
 
 Throughput in MB/s (buffer size = 64KB, file size = 500MB)
        <write> <rewrite> <read> <reread> <rand-read> <rand-write>
 ext3     45.369  46.438  56.542  56.457 11.025  36.300
 nilfs2   56.119  43.630  41.330  41.498  8.572  37.671

(Here I used -e and -U option to measure true disk read performance
 not cache read performance)

As often said for LFS, NILFS2 showed high random write performance
for small writes, but the read throughput was lower.  It was about
-27% lower than ext3.

For sequential write, first write was good, but overwrite was slower
because it involves read of existing meta data.


Cheers,
Ryusuke
