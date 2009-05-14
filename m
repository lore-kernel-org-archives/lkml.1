Return-Path: <linux-kernel-owner+w=401wt.eu-S1762275AbZENCBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762275AbZENCBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 22:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753885AbZENCAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 22:00:54 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:56513 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbZENCAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 22:00:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=E8hXNfIS2RrZFxAwQOTXNoUPJ1woq1w5KZMe0Eitvj6isoMXExYZM6r/+yDcjSeNEb
         IBBxRJGyfY818402ufraenqBIhPhoYUPgSWaDFA6kT2uZK2b3dUie/RPksBSHn7rEtgX
         ZJHoRy+CZkzzhv0sp9OXAQ3NryzCc02MUM498=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Reiserfs <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Jeff Mahoney <jeffm@suse.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] kill-the-bkl/reiserfs: update
Date: Thu, 14 May 2009 04:00:48 +0200
Message-Id: <1242266449-21121-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a new patch which increases the performances with
reiserfs using a mutex instead of the bkl.

Now I've compared with dbench on a fresh and empty reiserfs
partition with 64 GB and the results are better with the mutex than with
the bkl.

Also this new patch increases the throughput a bit more.
Dbench on SMP (2 Cpus), Preempt and 100 threads during 400 seconds:

Bkl:		          37.6764 MB/sec
Mutex, before this patch: 39.4532 MB/sec
Mutex, after this patch:  40.3758 MB/sec

The following graph shows better the difference:
http://kernel.org/pub/linux/kernel/people/frederic/dbench.pdf

So it looks like on some cases, it is faster (fresh filesystem ?)
and sometimes slower (filesystem already well filled ?).

Of course it is also supposed to be faster on parallel multiple partitions
accesses but I have no benchmark yet to show that.

The following changes since commit 2989c5541d5ab1138e538f8c713f491f7b2416b1:
  Frederic Weisbecker (1):
        kill-the-bkl/reiserfs: use mutex_lock in reiserfs_mutex_lock_safe

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	kill-the-bkl/reiserfs

Frederic Weisbecker (1):
      kill-the-bkl/reiserfs: unlock only when needed in search_by_key

 fs/reiserfs/stree.c |   42 ++++++++++++++++++++++++++++++++++--------
 1 files changed, 34 insertions(+), 8 deletions(-)
