Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbYJOAmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbYJOAmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 20:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752493AbYJOAlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 20:41:20 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47534 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbYJOAlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 20:41:18 -0400
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: smfrench@austin.rr.com, linux-kernel@vger.kernel.org, niallain@gmail.com,
       linux-cifs-client@lists.samba.org
Subject: [PATCH 0/5] cifs: fix deadlocks, oopses and mem corruption with concurrent mount/umount (try #2 resend)
Date: Tue, 14 Oct 2008 20:41:02 -0400
Message-Id: <1224031267-17194-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending to wider distribution per Steve's request. I've also included
a patch that I previously sent separately since the last patch depends
on it...

This patchset is intended to fix the deadlocks, oopses, memory
corruption and mount failures when using the reproducer detailed here:

https://bugzilla.samba.org/show_bug.cgi?id=5720

This is the second attempt at this. Steve had reservations about the
first patchset since it would have broken multiuser mounts, and may have
had implications for the DebugData procfile.

It starts by disabling the sharing of server, session and tcon structs.
It then removes kthread_stop from the cifsd shutdown codepath. This
eliminates the deadlocks seen with it. It then adds some cleanup of the
cifsd shutdown code to close races there, and finally re-enables the
sharing of TCP sessions.

While I haven't tested it, this should allow the multiuser mount code to
continue working since that doesn't require sharing anything besides TCP
sessions. I've left the sharing of SMB sessions and tcons for another
day. It certainly wouldn't hurt to eventually put that back, but
cleaning up the refcounting there involves a substantial amount of code
change. It's probably prudent to draw a line here and build on top of
this patchset.

With this, I've been able to run the reproducer in the above BZ
overnight, whereas before it would regularly crash or hang after just a
few minutes.

Jeff Layton (5):
  cifs: disable sharing of server, session and tcon
  cifs: eliminate usage of kthread_stop for cifsd
  cifs: handle the TCP_Server_Info->tsk field more carefully
  cifs: clean up server protocol handling for TCP_Server_Info
  cifs: add global TCP session list and reenable TCP session sharing

 fs/cifs/cifs_debug.c |    2 +-
 fs/cifs/cifsfs.c     |    8 ++
 fs/cifs/cifsglob.h   |   13 +--
 fs/cifs/cifsproto.h  |    1 +
 fs/cifs/cifssmb.c    |   14 +--
 fs/cifs/connect.c    |  260 ++++++++++++++++++-------------------------------
 6 files changed, 115 insertions(+), 183 deletions(-)

