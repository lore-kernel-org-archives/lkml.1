Return-Path: <linux-kernel-owner+w=401wt.eu-S1763622AbXINOki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763622AbXINOki (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbXINOk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:40:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45516 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752204AbXINOk0 (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:40:26 -0400
Date: Sat, 15 Sep 2007 00:40:33 +1000
From: Greg Banks <gnb@sgi.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net, nfs@lists.sourceforge.net,
       linux-fsdevel@vger.kernel.org, unionfs@filesystems.org,
       linux-cifs-client@lists.samba.org
Subject: Re: [NFS] [PATCH 2/7] NFS: if ATTR_KILL_S*ID bits are set, then skip mode change
Message-ID: <20070914144033.GD25610@sgi.com>
References: <200709041437.l84Eb4lw010007@dantu.rdu.redhat.com> <20070914102545.GF21965@sgi.com> <20070914070258.8fccb40e.jlayton@redhat.com> <20070914130924.GG21965@sgi.com> <20070914093846.7cdd89da.jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070914093846.7cdd89da.jlayton@redhat.com>
User-Agent: Mutt/1.5.5.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 09:38:46AM -0400, Jeff Layton wrote:
> On Fri, 14 Sep 2007 23:09:24 +1000
> Greg Banks <gnb@sgi.com> wrote:
> 
> > On Fri, Sep 14, 2007 at 07:02:58AM -0400, Jeff Layton wrote:
> > > On Fri, 14 Sep 2007 20:25:45 +1000
> > > Greg Banks <gnb@sgi.com> wrote:
> > > 
> > > > I'm curious about the reasons behind this change.  You mention
> > > > credential issues; how exactly is it that you have the correct creds
> > > > to perform a WRITE rpc but not a SETATTR rpc?
> > > > 
> > > 
> > > Consider this case. user1 and user2 are both members of group
> > > "allusers":
> > > 
> > > user1$ echo foo > foo
> > > user1$ chgrp allusers foo
> > > user1$ chmod 04770 foo
> > > user2$ echo bar >> foo
> > > 
> > > On most local filesystems, this would work correctly. The end result
> > > would be a file with mode 0770 and the expected contents. On NFS
> > > though, the write by user2 fails. When the write is attempted, the
> > > kernel tries to squash the setuid bit using the credentials of user2,
> > > who's not allowed to change the mode. The write then fails because the
> > > setattr fails.
> > 
> > Ok, I ran an experiment and I see this failure mode.
> > 
> > So the SETATTR rpc is really a side effect of the client kernel's
> > behaviour and not an operation directly requested by the user process
> > on the client.  Is there any reason why that rpc needs to have user2's
> > creds?  Why not do the rpc with a fake set of creds with uid and gid
> > set to the uid and gid of the file, in this case user1/allusers ?
> > That way the rpc will most likely pass the server's permission check.
> > 
> 
> That might work in some cases, but there are many where it wouldn't...
> 
> Suppose user1 here is root and all of the user1 operations are being
> done on the server. If the server has root squashing enabled, then
> user2's operation would still fail.

In that case, user1's operations would also fail, which is even more
serious a problem.  Also arguably you actually *want* writes by a
nonroot user to a setuid root executable to fail ;-)

> Another problem:
> 
> Suppose we're using gssapi. There's no guarantee that the client will
> have the proper credentials to fake up a call as user1 (you might need
> user1 krb5 tickets, etc).

Yes, good point.  You could use the root creds, except for root squashing.
Ok, you convinced me.

Greg.
-- 
Greg Banks, R&D Software Engineer, SGI Australian Software Group.
Apparently, I'm Bedevere.  Which MPHG character are you?
I don't speak for SGI.
