Return-Path: <linux-kernel-owner+w=401wt.eu-S1754317AbZBWHgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbZBWHgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 02:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbZBWHgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 02:36:12 -0500
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:39448 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbZBWHgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 02:36:10 -0500
From: hooanon05@yahoo.co.jp
Subject: [RFC 4/8] Aufs2: branch
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <7558.1235374266@jrobl>
References: <7558.1235374266@jrobl>
Date: Mon, 23 Feb 2009 16:36:08 +0900
Message-ID: <7793.1235374568@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This is my second trial to ask incorporating aufs into mainline.


Branch Manipulation

Since aufs supports dynamic branch manipulation, ie. add/remove a branch
and changing its permission/attribute, there are a lot of works to do.


Add a Branch
----------------------------------------------------------------------
o Confirm the adding dir exists outside of aufs, including loopback
  mount.
- and other various attributes...
o Initialize the xino file and whiteout bases if necessary.
  See struct.txt.

o Check the owner/group/mode of the directory
  When the owner/group/mode of the adding directory differs from the
  existing branch, aufs issues a warning because it may impose a
  security risk.
  For example, when a upper writable branch has a world writable empty
  top directory, a malicious user can create any files on the writable
  branch directly, like copy-up and modify manually. If something like
  /etc/{passwd,shadow} exists on the lower readonly branch but the upper
  writable branch, and the writable branch is world-writable, then a
  malicious guy may create /etc/passwd on the writable branch directly
  and the infected file will be valid in aufs.
  I am afraid it can be a security issue, but nothing to do except
  producing a warning.


Delete a Branch
----------------------------------------------------------------------
o Confirm the deleting branch is not busy
  To be general, there is one merit to adopt "remount" interface to
  manipulate branches. It is to discard caches. At deleting a branch,
  aufs checks the still cached (and connected) dentries and inodes. If
  there are any, then they are all in-use. An inode without its
  corresponding dentry can be alive alone (for example, inotify case).

  For the cached one, aufs checks whether the same named entry exists on
  other branches.
  If the cached one is a directory, because aufs provides a merged view
  to users, as long as one dir is left on any branch aufs can show the
  dir to users. In this case, the branch can be removed from aufs.
  Otherwise aufs rejects deleting the branch.

  If any file on the deleting branch is opened by aufs, then aufs
  rejects deleting.


Modify the Permission of a Branch
----------------------------------------------------------------------
o Re-initialize or remove the xino file and whiteout bases if necessary.
  See struct.txt.

o rw --> ro: Confirm the modifying branch is not busy
  Aufs rejects the request if any of these conditions are true.
  - a file on the branch is mmap-ed.
  - a regular file on the branch is opened for write and there is no
    same named entry on the upper branch.
