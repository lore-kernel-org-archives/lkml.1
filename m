Return-Path: <linux-kernel-owner+w=401wt.eu-S1765784AbXHFRu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765784AbXHFRu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 13:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758380AbXHFRuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 13:50:44 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:53193 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754701AbXHFRum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 13:50:42 -0400
To: jlayton@redhat.com
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       codalist@TELEMANN.coda.cs.cmu.edu, cluster-devel@redhat.com,
       jfs-discussion@lists.sourceforge.net, mikulas@artax.karlin.mff.cuni.cz,
       zippel@linux-m68k.org, xfs@oss.sgi.com, joel.becker@oracle.com,
       wli@holomorphy.com, reiserfs-devel@vger.kernel.org, dhowells@redhat.com,
       fuse-devel@lists.sourceforge.net, jffs-dev@axis.com,
       user-mode-linux-user@lists.sourceforge.net,
       v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org,
       linux-cifs-client@lists.samba.org, ocfs2-devel@oss.oracle.com,
       bfennema@falcon.csc.calpoly.edu
In-reply-to: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com> (message from
	Jeff Layton on Mon, 6 Aug 2007 09:54:06 -0400)
Subject: Re: [fuse-devel] [PATCH 01/25] VFS: move attr_kill logic from
	notify_change into helper function
References: <200708061354.l76Ds6sq002260@dantu.rdu.redhat.com>
Message-Id: <E1II6cM-0004yj-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Aug 2007 19:43:46 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Separate the handling of the local ia_valid bitmask from the one in
> attr->ia_valid. This allows us to hand off the actual handling of the
> ATTR_KILL_* flags to the .setattr i_op when one is defined.
> 
> notify_change still needs to process those flags for the local ia_valid
> variable, since it uses that to decide whether to return early, and to pass
> a (hopefully) appropriate bitmask to fsnotify_change.

I agree with this change and fuse will make use of it as well.

Maybe instead of unconditionally moving attr_kill_to_mode() inside
->setattr() it could be made conditional based on an inode flag
similarly to S_NOCMTIME.  Advantages:

 - no need to modify a lot of in-tree filesystems
 - no silent breakage of out-of-tree fs

Actually I think the new flag would be used by exacly the same
filesystems as S_NOCMTIME, so maybe it would make sense to rename
S_NOCMTIME to something more generic (S_NOATTRUPDATE or whatever) and
use that.

But that could still break out-of-tree fs, so a separate flag is
probably better.

Miklos
