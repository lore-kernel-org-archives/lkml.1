Return-Path: <linux-kernel-owner+w=401wt.eu-S1755096AbZD2Ooa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbZD2Ooa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 10:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZD2OoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 10:44:19 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:19919 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbZD2OoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 10:44:18 -0400
Subject: Re: [PATCH RFC] ext3 data=guarded v5
From: Chris Mason <chris.mason@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <1241014093.20099.28.camel@think.oraclecorp.com>
References: <1240941840.15136.44.camel@think.oraclecorp.com>
	 <20090429085632.GA18273@duck.suse.cz>
	 <1241014093.20099.28.camel@think.oraclecorp.com>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 10:43:01 -0400
Message-Id: <1241016181.20099.31.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010202.49F8677E.01F0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 10:08 -0400, Chris Mason wrote:
> On Wed, 2009-04-29 at 10:56 +0200, Jan Kara wrote:
> 
> > > diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
> > > index fcfa243..1e90107 100644
> > > --- a/fs/ext3/inode.c
> > > +++ b/fs/ext3/inode.c
> > > @@ -38,6 +38,7 @@
> > >  #include <linux/bio.h>
> > >  #include <linux/fiemap.h>
> > >  #include <linux/namei.h>
> > > +#include <linux/workqueue.h>
> > >  #include "xattr.h"
> > >  #include "acl.h"
> > >  
> > > @@ -179,6 +180,105 @@ static int ext3_journal_test_restart(handle_t *handle, struct inode *inode)
> > >  }
> > >  
> > >  /*
> > > + * after a data=guarded IO is done, we need to update the
> > > + * disk i_size to reflect the data we've written.  If there are
> > > + * no more ordered data extents left in the tree, we need to
> >                                            ^^^^^^^^ the list
> > > + * get rid of the orphan entry making sure the file's
> > > + * block pointers match the i_size after a crash
> > > + *
> > > + * When we aren't in data=guarded mode, this just does an ext3_orphan_del.
> > > + *
> > > + * It returns the result of ext3_orphan_del.
> > > + *
> > > + * handle may be null if we are just cleaning up the orphan list in
> > > + * memory.
> > > + *
> > > + * pass must_log == 1 when the inode must be logged in order to get
> > > + * an i_size update on disk
> > > + */
> > > +static int ordered_orphan_del(handle_t *handle, struct inode *inode,
> > > +			      int must_log)
> > > +{
> >   I'm afraid this function is racy.
> > 1) We probably need i_mutex to protect against unlink happening in parallel
> >    (after we check i_nlink but before we all ext3_orphan_del).
> 
> This would mean IO completion (clearing PG_writeback) would have to wait
> on the inode mutex, which we can't quite do in O_SYNC and O_DIRECT.
> But, what I can do is check i_nlink after the ext3_orphan_del call and
> put the inode back on the orphan list if it has gone to zero.

Ugh, that won't work, we'll just race with link and risk an orphan that
never gets removed.  I'll make a version of ext3_orphan_del that expects
the super lock held and use that instead.

-chris


