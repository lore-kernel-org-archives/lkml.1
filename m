Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYFYUWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYFYUWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 16:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbYFYUWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 16:22:15 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:31648 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbYFYUWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 16:22:14 -0400
Date: Wed, 25 Jun 2008 13:20:58 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: configfs: Q: item leak in a failing configfs_attach_group()?
Message-ID: <20080625202058.GC14049@ca-server1.us.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com
References: <20080624141649.GH7621@hawkmoon.kerlabs.com> <20080624171051.GD4184@ca-server1.us.oracle.com> <20080624180456.GA32036@hawkmoon.kerlabs.com> <20080624213439.GB2785@mail.oracle.com> <20080625095527.GB32036@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080625095527.GB32036@hawkmoon.kerlabs.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 11:55:27AM +0200, Louis Rilling wrote:
> On Tue, Jun 24, 2008 at 02:34:39PM -0700, Joel Becker wrote:
> > On Tue, Jun 24, 2008 at 08:04:56PM +0200, Louis Rilling wrote:
> > > On Tue, Jun 24, 2008 at 10:10:51AM -0700, Joel Becker wrote:
> > > > On Tue, Jun 24, 2008 at 04:16:49PM +0200, Louis Rilling wrote:
> > > > > Hi,
> > > > > 
> > > > > I'd like an opinion on the following scenario:
> > > > > 
> > > > > process 1: 					process 2:
> > > > > configfs_mkdir("A")
> > > > >   attach_group("A")
> > > > >     attach_item("A")
> > > > >       d_instantiate("A")
> > > > >     populate_groups("A")
> > > > >       mutex_lock("A")
> > > > >       attach_group("A/B")
> > > > >         attach_item("A")
> > > > >           d_instantiate("A/B")
> > > > > 						mkdir("A/B/C")
> > > > > 						  do_path_lookup("A/B/C", LOOKUP_PARENT)
> > > > 
> > > > 					This has to sleep until
> > > > 					configfs_mkdir("A") finishes.
> > > > 					It's waiting on A->d_parent's
> > > > 					i_mutex, which is held by
> > > > 					sys_mkdirat().
> > > 
> > > Can you be more precise? I don't see where do_path_lookup() locks an inode
> > 
> > 	It doesn't.  It's in lookup_create(), which takes the mutex on the
> > parent of 'A'.  Note that the end of sys_mkdirat() explicitly drops that
> > mutex - it couldn't do so if it hadn't been taken :-)
> 
> So, my scenario is realistic. Process 2 only locks "B"'s inode in
> lookup_create() ("B" is the parent of the new directory "C"), and never has to
> lock "A" or "A"'s parent. IOW, process 2 does not have to wait on any i_mutex
> locked by process 1.

	Um, 'A' hasn't appeared yet.  I don't see how it looks up 'A'
until we're done.

Joel

-- 

"When ideas fail, words come in very handy." 
         - Goethe

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
