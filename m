Return-Path: <linux-kernel-owner+w=401wt.eu-S1761436AbYDCCdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761436AbYDCCdF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 22:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759011AbYDCCcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 22:32:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45084 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758950AbYDCCcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 22:32:50 -0400
Date: Thu, 3 Apr 2008 03:32:39 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
Message-ID: <20080403023239.GY9785@ZenIV.linux.org.uk>
References: <20080403014622.GW9785@ZenIV.linux.org.uk> <200804030221.m332LOH6007818@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804030221.m332LOH6007818@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 02, 2008 at 10:21:24PM -0400, Erez Zadok wrote:
> Yes, I do grab both vfsmount and superblock refs.  I found out that grabbing
> vfsmount refs wasn't enough to prevent "umount -l" from detaching the f/s on
> which I'm stacked on.  So now at mount time (or branch management time), I
> grab those super-refs, as I have them after a successful path_lookup.  And,
> since I keep a list of the branches I'm stacked on, I know precisely which
> superblocks' references I need to release when unionfs is unmounted.

How the devil would holding a superblock prevent umount -l?
 
> But what do I do if I descend into another lower superblock while looking up
> a lower directory?  How do keep track of the superblock refs now?  I'd
> basically have to memorize the hierarchy of mounted superblocks somehow?
> How would I know when to release those refs?  (hmm, maybe I can rely on
> d_mounted or the like?)
>
> > > - sometimes it's ok to pass NULL for those things, sometimes it's not ok
> > 
> > See above.  This crap will be gone.  For ->follow_link() nobody is allowed
> > to pass NULL as nameidata, period.
> 
> There's been talk in the past of splitting nameidata into intent structure
> and all the rest.  Is that also part of your plan for 26?  Intents are
> indeed very useful in ->lookup; the rest I can do without.

intents will die.  There'll be a method for final step of lookup + open,
but that's it (and it'll take preallocated struct file as one of the
arguments).  Please, explain what you want to do with intents, because
as far as I'm concerned these had been a mistake for a lot of reasons.

> Ironically, since lookup_one_len doesn't involve vfsmounts, but I need them
> for other reasons, I'm forced to live with NULL vfsmounts in some cases, or
> refer to the lower vfsmounts I already had for my root dentry (that makes
> transparently descending into a different vfsmount challenging, if not
> inconsistent).

Details, please.  If you just want a snapshot of vfsmount tree, then by
all means take a bloody snapshot.  collect_mounts() is there for purpose.
If you want mount/umount/etc. changes affect what you have, then I really
would like to see the semantics you want.  Some variation on shared-subtree
might be close to that...
