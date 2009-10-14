Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbZJNJ7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbZJNJ7O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 05:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758226AbZJNJ7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 05:59:13 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:19328 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910AbZJNJ7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 05:59:11 -0400
From: Joel Becker <joel.becker@oracle.com>
To: ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@infradead.org, torvalds@linux-foundation.org
Subject: [PATCH 0/2] [RFC] Adding the MAY_CREATE flag to ->permission()
Date: Wed, 14 Oct 2009 02:57:39 -0700
Message-Id: <1255514261-25823-1-git-send-email-joel.becker@oracle.com>
X-Mailer: git-send-email 1.5.6.5
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4AD5A09E.00CC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,
	Ran into a fun problem in ocfs2.  ocfs2, being a cluster
filesystem, has cluster locks.  Being nice to our users, we allow
signals to interrupt the cluster locking layer if it hasn't gotten too
far yet (sleeping on local locking rather than the cluster).
	Now, system calls are only allowed to return -ERESTARTSYS if
they can be safely restarted.  In ocfs2_mknod(), which underlies
mkdir(2), mknod(2), and creat(2), we allow signals to interrupt us while
we gather our locks, but once we start changing things, there's no going
back.  Everyone else does the same thing.
	The problem is open(O_CREAT|O_EXCL).  See, ocfs2_mknod() will
successfully create the file.  Then we get back to
__open_namei_create(), which promptly calls may_open().  This is
backended by ocfs2_permission(), and it needs the cluster lock to
check the new inode's permissions.  Send a signal here, and the ocfs2
code will return -ERESTARTSYS.  (This is easily verified via
'git-checkout').  When entry.S restarts the open(O_CREAT|O_EXCL), it
gets -EEXIST.  Ouch!
	We can't naively block signals in ocfs2_permission().  The
majority of calls are not for O_CREAT|O_EXCL.  So how do we let
ocfs2_permission() know about this case?
	Christoph's suggestion was a new flag to ->permission().  I've
picked MAY_CREATE, but I'm totally open to a better name.  I'm open to a
better solution too.
	Following this are the MAY_CREATE patch and the ocfs2 patch to
make use of it.

Joel




