Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbYJ3PRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbYJ3PRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 11:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756059AbYJ3PQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 11:16:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41935 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756029AbYJ3PQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 11:16:40 -0400
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: smfrench@austin.rr.com, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] cifs: fix oopses and mem corruption with concurrent mount/umount (try #4)
Date: Thu, 30 Oct 2008 11:16:29 -0400
Message-Id: <1225379793-23283-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is intended to fix the oopses, memory corruption and mount
failures when using the reproducer detailed here:

https://bugzilla.samba.org/show_bug.cgi?id=5720

This is the fourth attempt at this. Since the third attempt, Steve
French has committed the patch to handle the server->tsk pointer more
atomically so that patch is ommitted here. While that patch helps ensure
that the shutdown of the demux thread happens cleanly, there are still
other races.

Andrew Morton has also taken the patch to clean up the server protocol
handling for -mm. I've included this patch in the set since Steve has
not yet taken it, and I've had to modify it slightly for changes that
have gone into Steve's tree.

This patchset is based on Steve French's cifs-2.6 git tree and should
apply cleanly to its current state.

The main differences in this patchset are that it fixes some bugs in
list handling in the earlier patchsets. It also reenables the sharing
of tree connects. With this, any structures that were previously
shared should remain so (no loss of functionality).

There's still some remaining cleanup work that can be done here. The
cifs_mount code could stand to be broken up into smaller functions.
cifs_debug_data_proc_show could also stand to be reorganized to better
reflect the heirarchy of server->session->tcon. Those changes are
probably more suitable in follow-on patches. I'd like to know whether
these are acceptible before I spend time working on them.

I've been able to run the reproducer in the above BZ overnight on this
patchset. Without it, it usually crashes within a few minutes.

Jeff Layton (4):
  cifs: clean up server protocol handling for TCP_Server_Info
  cifs: disable sharing session and tcon and add new TCP sharing code
  cifs: reinstate sharing of SMB sessions
  cifs: reinstate sharing of tree connections

 fs/cifs/cifs_debug.c |  286 +++++++++++++++++++---------------
 fs/cifs/cifsfs.c     |   33 +++--
 fs/cifs/cifsglob.h   |   28 ++--
 fs/cifs/cifssmb.c    |   54 +------
 fs/cifs/connect.c    |  426 +++++++++++++++++++++++++-------------------------
 fs/cifs/misc.c       |   93 +++++------
 6 files changed, 456 insertions(+), 464 deletions(-)

