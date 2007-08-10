Return-Path: <linux-kernel-owner+w=401wt.eu-S941652AbXHJUuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941652AbXHJUuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933301AbXHJUuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:50:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761013AbXHJUuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:50:07 -0400
Date: Fri, 10 Aug 2007 16:47:52 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
       zippel@linux-m68k.org, dhowells@redhat.com,
       linux-cifs-client@lists.samba.org, codalist@TELEMANN.coda.cs.cmu.edu,
       joel.becker@oracle.com, linux-ext4@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com,
       user-mode-linux-user@lists.sourceforge.net,
       mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com, jffs-dev@axis.com,
       jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
       reiserfs-devel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu,
       xfs@oss.sgi.com
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits from VFS into
 individual setattr functions (RESEND)
Message-Id: <20070810164752.23117e0e.jlayton@redhat.com>
In-Reply-To: <1186533934.6625.91.camel@heimdal.trondhjem.org>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
	<20070807171501.e31c4a97.akpm@linux-foundation.org>
	<1186533934.6625.91.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007 20:45:34 -0400
Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > - rename something so that unconverted filesystems will reliably fail to
> >   compile?
> > 
> > - leave existing filesystems alone, but add a new
> >   inode_operations.setattr_jeff, which the networked filesytems can
> >   implement, and teach core vfs to call setattr_jeff in preference to
> >   setattr?
> 
> If you really need to know that the filesystem is handling the flags,
> then how about instead having ->setattr() return something which
> indicates which flags it actually handled? That is likely to be a far
> more intrusive change, but it is one which is future-proof.
> 

One thing that we could do here is have notify_change check
attr->ia_valid after the setattr operation returns. If either ATTR_KILL_*
bit is set then BUG(). The helper function already clears those bits
so anything using it should automatically be ok. We'd have to fix
up NFS and a few others that don't implement suid/sgid.

This is not as certain as changing the name of the inode operation. It
would only pop when someone is attempting to change a setuid/setgid
file on these filesystems. Still, it should conceivably catch most if
not all offenders. Would that be sufficient to take care of everyone's
concerns?

-- 
Jeff Layton <jlayton@redhat.com>
