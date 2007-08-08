Return-Path: <linux-kernel-owner+w=401wt.eu-S936278AbXHHQvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936278AbXHHQvi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 12:51:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758566AbXHHQv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 12:51:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55310 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449AbXHHQvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 12:51:23 -0400
Date: Wed, 8 Aug 2007 09:48:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       v9fs-developer@lists.sourceforge.net, zippel@linux-m68k.org,
       dhowells@redhat.com, linux-cifs-client@lists.samba.org,
       codalist@TELEMANN.coda.cs.cmu.edu, joel.becker@oracle.com,
       linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       cluster-devel@redhat.com, user-mode-linux-user@lists.sourceforge.net,
       mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com, jffs-dev@axis.com,
       jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
       reiserfs-devel@vger.kernel.org, bfennema@falcon.csc.calpoly.edu,
       xfs@oss.sgi.com
Subject: Re: [PATCH 00/25] move handling of setuid/gid bits from VFS into
 individual setattr functions (RESEND)
Message-Id: <20070808094853.8c27450c.akpm@linux-foundation.org>
In-Reply-To: <20070808085435.722f2b10.jlayton@redhat.com>
References: <200708061354.l76Ds3mU002255@dantu.rdu.redhat.com>
	<20070807171501.e31c4a97.akpm@linux-foundation.org>
	<20070808085435.722f2b10.jlayton@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 08:54:35 -0400 Jeff Layton <jlayton@redhat.com> wrote:

> On Tue, 7 Aug 2007 17:15:01 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Mon, 6 Aug 2007 09:54:03 -0400
> > Jeff Layton <jlayton@redhat.com> wrote:
> > 
> > Is there any way in which we can prevent these problems?  Say
> > 
> > - rename something so that unconverted filesystems will reliably fail to
> >   compile?
> > 
> 
> I suppose we could rename the .setattr inode operation to something
> else, but then we'll be stuck with it for at least a while. That seems
> sort of kludgey too...

Sure.  We're changing the required behaviour of .setattr.  Changing its
name is a fine and reasonably reliable way to communicate that fact.

> > - leave existing filesystems alone, but add a new
> >   inode_operations.setattr_jeff, which the networked filesytems can
> >   implement, and teach core vfs to call setattr_jeff in preference to
> >   setattr?
> > 
> > Something else?
> 
> There's also the approach suggested by Miklos: Add a new inode flag that
> tells notify_change not to convert ATTR_KILL_S* flags into a mode
> change. Basically, allow filesystems to "opt out" of that behavior. 
> 
> I'd definitly pick that over a new inode op. That would also allow the
> default case be for the VFS to continue handling these flags.
> Everything would continue to work but filesystems that need to handle
> these flags differently would be able to do so.
> 

We should opt for whatever produces the best end state in the kernel tree. 
ie: if it takes more work and a larger patch to create a better result,
let's go for the better result.  We merge large patches all the time.  We
prefer to smash through, get it right whatever the transient cost.  But
quietly making out-of-tree filesystems less secure is a pretty high cost.

I'm suspecting that adding more flags and some code to test them purely to
minimise the size of the patch and to retain compatibility with the old
.setattr is not a good tradeoff, given that we'd carry the flags and tests
for evermore.

So I'd suggest s/setattr/something_else/g.
