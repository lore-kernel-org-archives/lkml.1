Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbXHAWHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbXHAWHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 18:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753056AbXHAWHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 18:07:04 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40937 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbXHAWHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 18:07:01 -0400
Date: Wed, 1 Aug 2007 18:06:36 -0400
Message-Id: <200708012206.l71M6ai6028268@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Josef Sipek <jsipek@fsl.cs.sunysb.edu>, Jan Blunck <jblunck@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>, hch@infradead.org
Subject: Re: [RFC 12/26] ext2 white-out support 
In-reply-to: Your message of "Wed, 01 Aug 2007 14:52:21 CDT."
             <1185997941.18007.30.camel@kleikamp.austin.ibm.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1185997941.18007.30.camel@kleikamp.austin.ibm.com>, Dave Kleikamp writes:
> On Wed, 2007-08-01 at 15:33 -0400, Josef Sipek wrote:
> > On Wed, Aug 01, 2007 at 02:10:31PM -0500, Dave Kleikamp wrote:
> > > On Wed, 2007-08-01 at 14:44 -0400, Josef Sipek wrote:
> > > > Now what? How do you rename? Do you rename in the same branch (assuming it
> > > > is rw)?
> > > 
> > > Er, no.  According to Documentation/filesystems/union-mounts.txt, "only
> > > the topmost layer of the mount stack can be altered".
> > 
> > This brings up an very interesting (but painful) question...which makes more
> > sense? Allowing the modifications in only the top-most branch, or any branch
> > (given the user allows it at mount-time)?
> 
> Your examples point out the complexity of trying to allow modifications
> at lower levels.  It seems to me to be simpler (even if recursive copies
> are needed) to leave it as proposed.
[...]

There are three other reasons why Unionfs and our users like to have
multiple writable branches:

1. If only the topmost layer is writable, then every little change tends to
   cause a copyup, which tends to clutter the top layer more quickly.  Some
   of our users didn't like that idea, while others explicitly wanted it --
   so we give them a choice to decide, on a per layer/branch whether it
   should be writable or readonly.

2. Some users unify different packages together.  Imagine you union under
   /union, several installed packages: /X11R6/{bin,man,lib,conf},
   /apache/{bin,man,lib,etc}, and /mysql/{bin,man,lib,etc}, and so on.  If a
   user modifies /union/apache/etc/apache.conf, they sometimes want
   apache.conf to remain in the writable branch it came from, not copied up.
   That way all apache related files are logically left where they came
   from, which makes administration easier.  Again, some users like to have
   multiple writable branches, and some don't -- so in Unionfs we give them
   the choice.  And yes, it does make our implementation more complex.

3. Some people use Unionfs in the scenario described in point #2 above, as a
   poor man's space- and load- distribution system.  Some of our users like
   the idea of controlling how much storage space they give each branch, and
   how much it might grow, and even how much CPU or I/O load might be placed
   on each of the lower filesystems which serve a given branch.  That way
   they worry less about the top-layer's space filling up more quickly than
   expected.  Now Unionfs was never designed to be a load-balancing f/s (we
   have RAIF for that, see <http://www.filesystems.org/project-raif.html>),
   but users seems to always find creative ways to [ab]use one's software in
   ways one never thought of. :-)

BTW, does Union Mounts copyup on meta-data changes (e.g., chmod, chgrp,
etc.)?

Erez.
