Return-Path: <linux-kernel-owner+w=401wt.eu-S1751220AbXB1Rw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbXB1Rw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 12:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751193AbXB1Rw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 12:52:28 -0500
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:37215 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbXB1Rw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 12:52:27 -0500
To: staubach@redhat.com
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <45E5BA2E.8060003@redhat.com> (message from Peter Staubach on
	Wed, 28 Feb 2007 12:21:50 -0500)
Subject: Re: [patch 01/22] update ctime and mtime for mmaped write
References: <20070227231442.627972152@szeredi.hu> <20070227231544.519463073@szeredi.hu> <45E58EB8.6030502@redhat.com> <E1HMSGE-000886-00@dorka.pomaz.szeredi.hu> <45E5BA2E.8060003@redhat.com>
Message-Id: <E1HMSy2-0008F6-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 Feb 2007 18:51:54 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> While these entry points do not actually modify the file itself,
> as was pointed out, they are handy points at which the kernel gains
> control and could actually notice that the contents of the file are
> no longer the same as they were, ie. modified.
> 
>  From the operating system viewpoint, this is where the semantics of
> modification to file contents via mmap differs from the semantics of
> modification to file contents via write(2).
> 
> It is desirable for the file times to be updated as quickly as
> possible after the actual modification has occurred.

I disagree.

You don't worry about the timestamp being updated _during_ a large
write() call, even though the file is constantly being modified.

You think of write() as something instantaneous, while you think of
writing to a shared mapping, then doing msync() as something taking a
long time.  In actual fact both of these are basically equivalent
operations, the differences being, that you can easily modify
non-contiguous parts of a file with mmap, while you can't do that with
write.  The disadvantage from mmap comes from the cost of setting up
the page tables and handling the faults.

Think of it this way:

  shared mmap write + msync(MS_ASYNC)  ==  write()
  msync(MS_ASYNC) + fsync()  ==  msync(MS_SYNC)

> A better design for all of this would be to update the file times
> and mark the inode as needing to be written out when a page fault
> is taken for a page which either does not exist or needs to be made
> writable and that page is part of an appropriate style mapping.

I think this would just be a waste of CPU.

Miklos
