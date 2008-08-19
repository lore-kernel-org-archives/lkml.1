Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbYHSR6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbYHSR6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYHSR6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:58:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60775 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753809AbYHSR6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:58:32 -0400
Date: Tue, 19 Aug 2008 10:56:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: rwheeler@redhat.com
Cc: Andreas Dilger <adilger@sun.com>, Josef Bacik <jbacik@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH 2/2] improve ext3 fsync batching
Message-Id: <20080819105638.aae4086f.akpm@linux-foundation.org>
In-Reply-To: <48AAA7F7.5090501@redhat.com>
References: <20080806190819.GH27394@unused.rdu.redhat.com>
	<20080806191536.GI27394@unused.rdu.redhat.com>
	<20080818213128.3a76d1e8.akpm@linux-foundation.org>
	<20080819054414.GM3392@webber.adilger.int>
	<48AAA7F7.5090501@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 07:01:11 -0400 Ric Wheeler <rwheeler@redhat.com> wrote:

> It would be great to be able to use this batching technique for faster 
> devices, but we currently sleep 3-4 times longer waiting to batch for an 
> array than it takes to complete the transaction.

Obviously, tuning that delay down to the minimum necessary is a good
thing.  But doing it based on commit-time seems indirect at best.  What
happens on a slower disk when commit times are in the tens of
milliseconds?  When someone runs a concurrent `dd if=/dev/zero of=foo'
when commit times go up to seconds?

Perhaps a better scheme would be to tune it based on how many other
processes are joining that transaction.  If it's "zero" then decrease
the timeout.  But one would need to work out how to increase it, which
perhaps could be done by detecting the case where process A runs an
fsync when a commit is currently in progress, and that commit was
caused by process B's fsync.

But before doing all that I would recommend/ask that the following be
investigated:

- How effective is the present code?

  - What happens when it is simply removed?

  - Add instrumentation (a counter and a printk) to work out how
    many other tasks are joining this task's transaction.

    - If the answer is "zero" or "small", work out why.

  - See if we can increase its effectiveness.

Because it could be that the code broke.  There might be issues with
higher-level locks which are preventing the batching.  For example, if
all the files which the test app is syncing are in the same directory,
perhaps all the tasks are piling up on that directory's i_mutex?
