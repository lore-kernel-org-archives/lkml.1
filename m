Return-Path: <linux-kernel-owner+w=401wt.eu-S1758320AbYGAOeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320AbYGAOeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbYGAOeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:34:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681AbYGAOeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:34:09 -0400
Subject: Re: [patch resend] gfs2: don't call permission()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org
In-Reply-To: <E1KDgiC-0005Qu-Re@pomaz-ex.szeredi.hu>
References: <E1K8DFJ-0006nQ-E7@pomaz-ex.szeredi.hu>
	 <E1KDfzL-0005GI-DP@pomaz-ex.szeredi.hu> <1214920311.4011.80.camel@quoit>
	 <E1KDgiC-0005Qu-Re@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 Jul 2008 15:27:22 +0100
Message-Id: <1214922442.4011.87.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2008-07-01 at 16:20 +0200, Miklos Szeredi wrote:
> Hi Steve,
> 
> Thanks for looking a the patch.
> 
> On Tue, 01 Jul 2008, Steven Whitehouse wrote:
> > On Tue, 2008-07-01 at 15:33 +0200, Miklos Szeredi wrote:
> > > From: Miklos Szeredi <mszeredi@suse.cz>
> > > 
> > > GFS2 calls permission() to verify permissions after locks on the files
> > > have been taken.
> > > 
> > > For this it's sufficient to call gfs2_permission() instead.  This
> > > results in the following changes:
> > > 
> > >   - IS_RDONLY() check is not performed
> > >   - IS_IMMUTABLE() check is not performed
> > >   - devcgroup_inode_permission() is not called
> > >   - security_inode_permission() is not called
> > > 
> > > IS_RDONLY() should be unnecessary anyway, as the per-mount read-only
> > > flag should provide protection against read-only remounts during
> > > operations.  do_gfs2_set_flags() has been fixed to perform
> > > mnt_want_write()/mnt_drop_write() to protect against remounting
> > > read-only.
> > > 
> > > IS_IMMUTABLE has been added to gfs2_do_permission()
> > > 
> > > Repeating the security checks seems to be pointless, as they don't
> > > normally change, and if they do, it's independent of the filesystem
> > > state.
> > > 
> > > I also suspect the conditional locking in gfs2_do_permission() could
> > > be cleaned up, due to the removal of the implicit recursion.
> > > 
> > > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > > ---
> > >  fs/gfs2/inode.c     |    6 +++---
> > >  fs/gfs2/inode.h     |    1 +
> > >  fs/gfs2/ops_file.c  |   11 +++++++++--
> > >  fs/gfs2/ops_inode.c |   18 +++++++++++++-----
> > >  4 files changed, 26 insertions(+), 10 deletions(-)
> > > 
> > 
> > I've seen this patch drop into my inbox a number of times now. What is
> > the status of the rest of the patches in the original series?
> 
> Al Viro said, that he has something similar in the works, but as yet
> we haven't seen any of it.  So basically I'm waiting for him to come
> out with that.
> 
> But whatever that does, this patch shouldn't have any major conflict
> with it.
> 
> > I'm sorry that I've not got around to looking at this again a bit sooner
> > (due to holidays and various things) but bearing in mind that both
> > myself and Christoph have raised various points relating to this, it
> > would have been nice to have seen them addressed rather than having to
> > watch you post this via -mm and various other places, still in its
> > original form.
> > 
> > So going back to my original comment:
> > 
> > >> That looks ok, but I wonder do we really need gfs2_do_permission()
> > and
> > >> gfs2_permission when the only difference seems to be one argument?
> > 
> > >Later in this series ->permission() is changed to take a dentry as the
> > >first argument, so a separate function would've had to be reintroduced
> > >anyway.
> > 
> > Is this still true? or are the later patches changed now? Even so I
> > don't see why that means we need two functions there. I've lost track of
> > what the other patches status is.
> 
> Al's patches don't take a dentry.  But the struct namespace argument
> from ->permission() will be gone, so I believe it's still better to
> have the internal permission function not have a nameidata argument.
> 
> Maybe it would be best to rename the internal one gfs2_permission(),
> and the external one something else, and after Al's patches, the
> external one can go away.  If that's OK for everybody, I'll fix up the
> patch.
> 
> Thanks,
> Miklos
> 
Yes, that seems to make more sense so I'd be happy with that,

Steve.


