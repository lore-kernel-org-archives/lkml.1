Return-Path: <linux-kernel-owner+w=401wt.eu-S1762318AbYGBIyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762318AbYGBIyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 04:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYGBIxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 04:53:49 -0400
Received: from smtp.nokia.com ([192.100.105.134]:22933 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbYGBIxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 04:53:47 -0400
Message-ID: <486B419F.7050407@nokia.com>
Date: Wed, 02 Jul 2008 11:51:43 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       Hunter Adrian <ext-Adrian.Hunter@nokia.com>
Subject: Is VFS behavior fine?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jul 2008 08:53:38.0694 (UTC) FILETIME=[1EAFFA60:01C8DC21]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Zoltan Sogor noticed the following VFS behavior while testing
UBIFS. He ran the following shell script:

mkdir xxx
cd xxx
rmdir ../xxx
touch tmp
cd /

The result of it was that the '->delete_inode()' operation for
the 'xxx' directory inode is not called. It is not called even
after 'cd /'. However, if we do not do the 'touch tmp' command
(which actually fails), '->delete_inode()' _is_ called for 'xxx'.

So 'touch tmp' has a side effect. You may notice this by watching
'cat /proc/slabinfo | grep dentry' while running the following
script:

while true; do
        echo live
        for i in `seq 1 1000`
        do
                mkdir $i
                cd $i
                rmdir ../$i
                touch tmp &> /dev/null
                cd - &> /dev/null
        done;
done;

Dentry cache will be growing. However, the same script but
without 'touch tmp' does not make dentry cache to grow.

For UBIFS this causes the problems because its orphan area
gets overflowed (orphans are added, but not removed because
'->delete_inode()' is not called).

==============================================================
I explored this some more. What happens  is:

1. Current directory is 'xxx', its 'i_nlink' is 0 (because of
   'rmdir ../xxx'), but because it is current directory, 'xxx'
   dentry has 'd_count' = 1, so 'iput_final()' is not called
   so far. If the script would just do 'cd /', the inode
   would be deleted. However, we are going to run
   'touch tmp'.

2. 'touch tmp' calls 'open(tmp, O_CREAT)'.

3. we are in 'do_filp_open()' function (see fs/namei.c).
   The situation is: xxx dentry 'd_count' is 1,
   'xxx' inode i_count is 1 as well.

4. 'path_lookup_create()' is called, which increases 'd_count'
   of 'xxx' direntry to 2 and succeeds.

5. 'do_filp_open()' calls 'lookup_hash()', which in turn calls
   'd_alloc()', which allocates a dentry object for 'tmp', sets
   its 'd_count' to 1, and also increases 'd_count' of 'xxx'
   dentry (the parent) to 3.

   So the situation is: 'xxx' dentry 'd_count' is 3
                        'tmp' dentry has d_count 1

6. '__lookup_hash()' calls 'inode->i_op->lookup()', which does
   not find the dentry, but calls 'd_splice_alias(NULL, dentry)'
   anyway, which makes 'tmp' hashed. Not sure, but AFAIU the idea
   is to make it "negative" dentry anyway, to optimize lookups.

7. Return to 'do_filp_open()', and '__open_namei_create()' is
   called, which in turn calls 'vfs_create()', which fails in
   the 'may_create()' check on the 'IS_DEADDIR(dir)' check.

   '__open_namei_create()' 'dput()'s 'xxx' direntry and returns
   error.

   So the situation is: 'xxx' dentry 'd_count' is 2
                        'tmp' dentry has d_count 1
                        'xxx' inode 'i_count' is still 1.

8. We do 'goto exit', which calls 'dput()' for 'tmp' dentry,
   (because 'd_alloc()' set it to 1). However, this _does not_
   decrease 'd_count' of the parent 'xxx' dentry (but it _did_
   increase it - see step 5.

   So the situation is: 'xxx' dentry 'd_count' is 2
                        'tmp' dentry d_count is 0
                        'xxx' inode 'i_count' is still 1.


9. The shell script does 'cd /', which causes 'xxx' dentry
   'd_count' to be decreased. However, 'd_count' stays 1,
   and 'xxx' inode 'i_count' stays 1. So the result is that
   '->delete_inode()' is not called for removed 'xxx' inode
   until unmount or memory pressure.

=============================================================

My understanding is that negative direntry 'tmp' keeps deleted
directory inode 'xxx'. However, I am not 100% sure I understand
the situation correctly.

The 'tmp' dentry is freed eventually because of unmount or
memory pressure, but not earlier than that. So the deleted
inodes may be kept for really long time. Is this OK?

I may just say that I fixed this in UBIFS by not calling
'd_splice_alias()' for not found dentries if the parent
directory inode has 'n_link' = 0. However, ext[23] always
call 'd_splice_alias()' for not found direntries (passing
NULL as the 'inode' parameter).

Again, I am not 100% sure this is the right fix, because
I suspect this should be "fixed" in VFS. I tried to do this
and I have a small VFS patch, but it is probably incorrect.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
