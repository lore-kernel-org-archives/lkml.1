Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbXD0Sbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbXD0Sbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 14:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbXD0Sbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:31:31 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48057 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757000AbXD0Sba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:31:30 -0400
Date: Fri, 27 Apr 2007 11:31:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when FS
 is under heavy write load (massive starvation)
Message-Id: <20070427113117.98c4f88b.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	<alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007 08:18:34 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 	echo 5 > /proc/sys/vm/dirty_background_ratio
> 	echo 10 > /proc/sys/vm/dirty_ratio

That'll help a lot.

ext3's problem here is that a single fsync() requires that ext3 sync the
whole filesystem.  Because

- a journal commit can contain metadata from multiple files, and if we
  want to journal one file's metadata via fsync(), we unavoidably journal
  all the other file's metadata at the same time.

- ordered mode requires that we write a file's data blocks prior to
  journalling the metadata which refers to those blocks.

net result: syncing anything syncs the whole world.

There are a few areas in which this could conceivably be tuned up: if a
particular file doesn't currently have any metadata in the commit, we don't
actually need to sync its data blocks: we could just transfer them into
next commit.  Hard, unlikely to be of benefit.

Arguably, we could get away without syncing overwritten data blocks.  Users
would occasionally see older data than they otherwise would have after a
crash.  Could help a bit in some circumstances.

But none of this explains a 20-minute hang, unless a *lot* of fsyncs are
being performed, perhaps.

