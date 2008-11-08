Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbYKHOOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbYKHOOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 09:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbYKHOO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 09:14:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52954 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077AbYKHOO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 09:14:27 -0500
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: smfrench@austin.rr.com, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] cifs: fix oopses and mem corruption with concurrent mount/umount (try #5)
Date: Sat,  8 Nov 2008 09:14:11 -0500
Message-Id: <1226153656-7741-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is intended to fix the oopses, memory corruption and mount
failures when using the reproducer detailed here:

https://bugzilla.samba.org/show_bug.cgi?id=5720

This is the fifth attempt at this. Since the fourth attempt, I've
changed the socket handling cleanup patch to also fix some problems with
IPv6 mounts, and have added a patch to change the tcon->tidStatus from
an enum to a bitfield.

The other main difference is that I've moved from the more granular
locking scheme in the earlier patches to one where all of the new lists
and refcounts are protected by the cifs_tcp_session_lock. That lock has
also been converted to a r/w spinlock.

The patch is a little larger than it really needs to be simply because
I've also taken this opportunity to move areas of the code that I was
touching to more closely resemble standard kernel coding style. There
are still style problems with it -- several lines are over 80 chars.
Fixing them will mean restructuring the code further however, and there
are already concerns about the size of this patchset. I've decided to
draw the line here...

This patchset is based on Steve French's cifs-2.6 git tree and should
apply cleanly to its current head.

There's still some remaining cleanup work that can be done here. The
cifs_mount code could stand to be broken up into smaller functions.
cifs_debug_data_proc_show could also stand to be reorganized to better
reflect the heirarchy of server->session->tcon. It also needs to be
updated to handle IPv6 addresses correctly. Those changes are probably
more suitable in follow-on patches. I'd like to see these go in before I
spend time working on them.

I've been able to run the reproducer in the above BZ overnight on this
patchset. Without it, it usually crashes within a few minutes.

Jeff Layton (5):
  cifs: clean up server protocol handling for TCP_Server_Info
  cifs: convert tcon->tidStatus to a bitfield
  cifs: disable sharing session and tcon and add new TCP sharing code
  cifs: reinstate sharing of SMB sessions sans races
  cifs: reinstate sharing of tree connections

 fs/cifs/cifs_debug.c  |  277 +++++++++++++++++--------------
 fs/cifs/cifs_spnego.c |    4 +-
 fs/cifs/cifsfs.c      |   37 +++--
 fs/cifs/cifsglob.h    |   33 ++--
 fs/cifs/cifssmb.c     |   68 ++------
 fs/cifs/connect.c     |  439 ++++++++++++++++++++++++-------------------------
 fs/cifs/file.c        |    2 +-
 fs/cifs/misc.c        |   89 +++++------
 8 files changed, 464 insertions(+), 485 deletions(-)

