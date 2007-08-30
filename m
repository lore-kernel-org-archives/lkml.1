Return-Path: <linux-kernel-owner+w=401wt.eu-S1759505AbXH3PnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759505AbXH3PnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 11:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753982AbXH3PnN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 11:43:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58495 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbXH3PnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 11:43:12 -0400
Date: Thu, 30 Aug 2007 11:06:28 -0400
Message-Id: <200708301506.l7UF6Sad002128@dantu.rdu.redhat.com>
From: Jeff Layton <jlayton@redhat.com>
Subject: [PATCH 0/3] fix setuid/setgid clearing in networked filesystems (take 4)
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When an unprivileged process attempts to modify a file that has the
setuid or setgid bits set, the VFS will attempt to clear these bits. The
VFS will set the ATTR_KILL_SUID or ATTR_KILL_SGID bits in the ia_valid
mask, and then call notify_change to clear these bits and set the mode
accordingly.

With a networked filesystem (NFS and CIFS in particular but likely
others), the client machine or process may not have credentials that
allow for setting the mode. In some situations, this can lead to file
corruption, an operation failing outright because the setattr fails, or
to races that lead to a mode change being reverted.

In this situation, we'd like to just leave the handling of this to the
server and ignore these bits. The problem is that by the time the
setattr op is called, the VFS has already reinterpreted the ATTR_KILL_*
bits into a mode change and the setattr operation has no way to
know its intent.

The following patchset fixes this by making notify_change no longer
clear the ATTR_KILL_SUID and ATTR_KILL_SGID bits in the ia_valid before
handing it off to the setattr inode op. setattr can then check for the
presence of these bits, and if they're set it can assume that the mode
change was only for the purposes of clearing these bits.

This means that we now have an implicit assumption that notify_change is
never called with ATTR_MODE and either ATTR_KILL_S*ID bit set. Nothing
currently enforces that, so the patch also adds a BUG_ON() if that
occurs.

The other two patches in the set fix up NFS and CIFS to ignore
the mode change if either ATTR_KILL_S*ID bit is set.

Signed-off-by: Jeff Layton <jlayton@redhat.com>

