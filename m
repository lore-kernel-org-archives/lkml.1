Return-Path: <linux-kernel-owner+w=401wt.eu-S1763017AbXINNJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763017AbXINNJi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 09:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762802AbXINNJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 09:09:27 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48122 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762759AbXINNJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 09:09:23 -0400
Date: Fri, 14 Sep 2007 23:09:24 +1000
From: Greg Banks <gnb@sgi.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net, nfs@lists.sourceforge.net,
       linux-fsdevel@vger.kernel.org, unionfs@filesystems.org,
       linux-cifs-client@lists.samba.org
Subject: Re: [NFS] [PATCH 2/7] NFS: if ATTR_KILL_S*ID bits are set, then skip mode change
Message-ID: <20070914130924.GG21965@sgi.com>
References: <200709041437.l84Eb4lw010007@dantu.rdu.redhat.com> <20070914102545.GF21965@sgi.com> <20070914070258.8fccb40e.jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914070258.8fccb40e.jlayton@redhat.com>
User-Agent: Mutt/1.5.5.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 07:02:58AM -0400, Jeff Layton wrote:
> On Fri, 14 Sep 2007 20:25:45 +1000
> Greg Banks <gnb@sgi.com> wrote:
> 
> > I'm curious about the reasons behind this change.  You mention
> > credential issues; how exactly is it that you have the correct creds
> > to perform a WRITE rpc but not a SETATTR rpc?
> > 
> 
> Consider this case. user1 and user2 are both members of group
> "allusers":
> 
> user1$ echo foo > foo
> user1$ chgrp allusers foo
> user1$ chmod 04770 foo
> user2$ echo bar >> foo
> 
> On most local filesystems, this would work correctly. The end result
> would be a file with mode 0770 and the expected contents. On NFS
> though, the write by user2 fails. When the write is attempted, the
> kernel tries to squash the setuid bit using the credentials of user2,
> who's not allowed to change the mode. The write then fails because the
> setattr fails.

Ok, I ran an experiment and I see this failure mode.

So the SETATTR rpc is really a side effect of the client kernel's
behaviour and not an operation directly requested by the user process
on the client.  Is there any reason why that rpc needs to have user2's
creds?  Why not do the rpc with a fake set of creds with uid and gid
set to the uid and gid of the file, in this case user1/allusers ?
That way the rpc will most likely pass the server's permission check.

Greg.
-- 
Greg Banks, R&D Software Engineer, SGI Australian Software Group.
Apparently, I'm Bedevere.  Which MPHG character are you?
I don't speak for SGI.
