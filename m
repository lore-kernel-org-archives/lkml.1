Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYJ1Vil@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYJ1Vil (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 17:38:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYJ1Vi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 17:38:28 -0400
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:55413 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbYJ1Vi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 17:38:27 -0400
Date: Tue, 28 Oct 2008 15:38:05 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] improve jbd fsync batching
In-reply-to: <20081028201614.GA21600@unused.rdu.redhat.com>
To: Josef Bacik <jbacik@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, rwheeler@redhat.com
Message-id: <20081028213805.GC3184@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <20081028201614.GA21600@unused.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 28, 2008  16:16 -0400, Josef Bacik wrote:
> I also have a min() check in there to make sure we don't sleep longer than
> a jiffie in case our storage is super slow, this was requested by Andrew.

Is there a particular reason why 1 jiffie is considered the "right amount"
of time to sleep, given this is a kernel config parameter and has nothing
to do with the storage?  Considering a seek time in the range of ~10ms
this would only be right for HZ=100 and the wait would otherwise be too
short to maximize batching within a single transaction.

> type	threads		with patch	without patch
> sata	2		24.6		26.3
> sata	4		49.2		48.1
> sata	8		70.1		67.0
> sata	16		104.0		94.1
> sata	32		153.6		142.7

In the previous patch where this wasn't limited it had better performance
even for the 2 thread case.  With the current 1-jiffie wait it likely
isn't long enough to batch every pair of operations and every other
operation waits an extra amount before giving up too soon.  Previous patch:

type    threads       patch     unpatched
sata    2              34.6     26.2
sata    4              58.0     48.0
sata    8              75.2     70.4
sata    16            101.1     89.6

I'd recommend changing the patch to have a maximum sleep time that has a
fixed maximum number of milliseconds (15ms should be enough for even very
old disks).


That said, this would be a minor enhancement and should NOT be considered
a reason to delay this patch's inclusion into -mm or the ext4 tree.

PS - it should really go into jbd2 also

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

