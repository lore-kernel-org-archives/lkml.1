Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbYJVOOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbYJVOOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYJVOOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:14:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56804 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337AbYJVOOG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:14:06 -0400
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org,
       smfrench@austin.rr.com
Subject: [PATCH 0/4] cifs: fix oopses and mem corruption with concurrent mount/umount (try #3)
Date: Wed, 22 Oct 2008 10:13:57 -0400
Message-Id: <1224684841-25546-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is intended to fix the oopses, memory corruption and mount
failures when using the reproducer detailed here:

https://bugzilla.samba.org/show_bug.cgi?id=5720

This is the third attempt at this. Since the second attempt, Steve has
committed the patch to remove kthread_stop from the cifsd shutdown
codepath. That will fix the deadlocks, but opens the window wider for
the oopses and memory corruption in this code. 

The main difference in the remaining patches is that this set combines
the patches that disable the structure sharing with the one that
re-enables the TCP session sharing. It also adds a new patch that
re-enables the sharing of SMB sessions. With this set, only tree
connections are no longer shared.

With this, I've been able to run the reproducer in the above BZ for
several hours, whereas before it would regularly crash after just a few
minutes.

Jeff Layton (4):
  cifs: clean up server protocol handling for TCP_Server_Info
  cifs: handle the TCP_Server_Info->tsk field more carefully
  cifs: disable sharing session and tcon and add new TCP sharing code
  cifs: reinstate sharing of SMB sessions

 fs/cifs/cifs_debug.c |   54 ++++----
 fs/cifs/cifsfs.c     |   25 +++--
 fs/cifs/cifsglob.h   |   20 +--
 fs/cifs/cifssmb.c    |   20 +---
 fs/cifs/connect.c    |  354 +++++++++++++++++++++++---------------------------
 fs/cifs/misc.c       |   15 +--
 6 files changed, 223 insertions(+), 265 deletions(-)

