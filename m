Return-Path: <linux-kernel-owner+w=401wt.eu-S1757778AbYDBBQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757778AbYDBBQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 21:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYDBBPy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 21:15:54 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:22839 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYDBBPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 21:15:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=nd1fScAfHwGfNrRqRJmIuiKIulxHwYDrh4kQ4tFscFnVuMOAzKZwpPAoKE+Sih1vorS2t7uJraAWwBeI+VsbWgWR+7BTnbdeOdGRAEx+/MZ7lfeSJD8LglAb1rpOwV74fXJZGKqYm4oEbTvHjrePTBUlkR55UOM+ZjocDhJZ2R0=
Message-ID: <3cb76b010804011815l52e69576x9ddb97c07ab38111@mail.gmail.com>
Date: Tue, 1 Apr 2008 21:15:52 -0400
From: "Sapan Bhatia" <sapan.bhatia@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: race leading to held mutexes, inode_cache corruption
Cc: daniel@hozac.com, akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

We've been trying to investigate a file-system corruption issue in our
kernel (http://svn.planet-lab.org/browser/linux-2.6/trunk) that
manifests itself both with ext3 and ext2. It appears to be happening
to due a contamination of the inode cache (we spent some time
monitoring our systems to arrive at this hypothesis), and can be
reproduced on a vanilla kernel as well.

The race that leads to this issue involves a process being terminated
when it is waiting for a mutex in __mutex_lock_common. eg. when it is
sent a SIGKILL, and the mutex is unlocked, causing the process to be
woken up and sent to exit while now holding the lock.

The way it contaminates the inode_cache slab is that inode->i_mutex is
only initialized once, and assumes that inodes coming back into the
cache are initialized. It seems that in our case such poisoned inodes
were leaking out of pipe.c.

This (www.cs.princeton.edu/~sapanb/mut.c) is the module we used to
test the condition, as follows. Writing to the char device locks a
mutex and reading from it unlocks it.
# echo 1 > /dev/mut
# cat /etc/passwd > /dev/mut &
[2] 6232
# kill -9 6232
# cat /dev/mut
[2]-  Killed                  cat /etc/passwd > /dev/mut
# echo 1 > /dev/mut
(goes to sleep)

I suppose that one could also construct an attack to proactively
corrupt inode_cache, but I haven't tried that as yet.

Our base kernel is 2.6.22.19.

Thank you,
Sapan
