Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbYDHVzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbYDHVzB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbYDHVyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:54:50 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39984 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYDHVyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:54:50 -0400
Date: Tue, 8 Apr 2008 14:53:33 -0700
From: sukadev@us.ibm.com
To: linux-kernel@vger.kernel.org
Cc: Containers <containers@lists.osdl.org>, Pavel Emelyanov <xemul@openvz.org>,
       serue@us.ibm.com, clg@fr.ibm.com
Subject: [RFC][PATCH 0/7] Clone PTS namespace
Message-ID: <20080408215333.GA8799@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Devpts namespace patchset

In continuation of the implementation of containers in mainline, we need to
support multiple PTY namespaces so that the PTY index (ie the tty names) in
one container is independent of the PTY indices of other containers.  For
instance this would allow each container to have a '/dev/pts/0' PTY and
refer to different terminals.

	[PATCH 1/7]: Propagate error code from devpts_pty_new
	[PATCH 2/7]: Factor out PTY index allocation
	[PATCH 3/7]: Enable multiple mounts of /dev/pts
	[PATCH 4/7]: Allow mknod of ptmx and tty in devpts
	[PATCH 5/7]: Implement get_pts_ns() and put_pts_ns()
	[PATCH 6/7]: Determine pts_ns from a pty's inode
	[PATCH 7/7]: Enable cloning PTY namespaces

Todo:
	- This patchset depends on availability of additional clone flags.
	  and relies on on Cedric's clone64 patchset. See

		  http://marc.info/?l=linux-kernel&m=120272411925609&w=2
	
	- Needs some cleanup and more testing

	- Ensure patchset is bisect-safe

---
Changelogs from earlier posts to Containers@.

Changelog[v2]:

	 (Patches 4 and 6 differ significantly from [v1]. Others are mostly
	 the same)

	- [Alexey Dobriyan, Pavel Emelyanov] Removed the hack to check for
	  user-space mount.

	- [Serge Hallyn] Added rcu locking around access to sb->s_fs_info.

	- [Serge Hallyn] Allow creation of /dev/pts/ptmx and /dev/pts/tty
	  devices to simplify the process of finding the 'owning' pts-ns
	  of the device (specially when accessed from parent-pts-ns)
	  See patches 4 and 6 for details.

Changelog[v1]:
	- Fixed circular reference by not caching the pts_ns in sb->s_fs_info
	  (without incrementing reference count) and clearing the sb->s_fs_info
	  when destroying the pts_ns

	- To allow access to a child container's ptys from parent container,
	  determine the 'pts_ns' of a 'pty' from its inode.

	- Added a check (hack) to ensure user-space mount of /dev/pts is
	  done before creating PTYs in a new pts-ns.

	- Reorganized the patchset and removed redundant changes.
	
	- Ported to work wih Cedric Le Goater's clone64() system call now
	  that we are out of clone_flags.

Changelog[v0]:

	This patchset is based on earlier versions developed by Serge Hallyn
	and Matt Helsley.
