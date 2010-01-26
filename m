Return-Path: <linux-kernel-owner+w=401wt.eu-S1752002Ab0AZWih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab0AZWih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 17:38:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717Ab0AZWig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 17:38:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab0AZWif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 17:38:35 -0500
Date: Tue, 26 Jan 2010 17:38:05 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/41] union-mount: Introduce union_mount structure
Message-ID: <20100126223805.GA17104@shell>
References: <1256152779-10054-21-git-send-email-vaurora@redhat.com> <200911300846.nAU8kTgF024429@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911300846.nAU8kTgF024429@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 03:46:29AM -0500, Erez Zadok wrote:
> In message <1256152779-10054-21-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> > From: Jan Blunck <jblunck@suse.de>
> > 
> > This patch adds the basic structures of VFS based union mounts. It is a new
> > implementation based on some of my old ideas that influenced Bharata B Rao
> > <bharata@linux.vnet.ibm.com> who came up with the proposal to let the
> > union_mount struct only point to the next layer in the union stack. I rewrote
> > nearly all of the central patches around lookup and the dcache interaction.
> > 
> > Advantages of the new implementation:
> > - the new union stack is no longer tied directly to one dentry
> > - the union stack enables dentries to be part of more than one union
> >   (bind mounts)
> > - it is unnecessary to traverse the union stack when de/referencing a dentry
> > - caching of union stack information still driven by dentry cache
> > 
> > XXX - is_unionized() is pretty heavy-weight for non-union file systems
> > on a union mount-enabled kernel.  May be simplified by assuming one or
> > more of:
> > 
> > - Two layers only
> > - One-to-one association between layers (doesn't union submounts)
> > - Writable layer mounted in only one place
> 
> Yes, is_unionized() does appear to be heavy.  Is it correct to assume that
> every such dentry will have gotten looked up or traversed as part of a
> union?  If so, can we just set a flag in the dentry to mark it as
> D_THIS_IS_PART_OF_A_UNION?  Even if you could, what happens when a union r-w
> layer is removed: could there be leftover dentries marked as part of a
> union, which are no longer really part of it?

dentries aren't themselves part of a unioned file system - they are
shared among all the mounts of a superblock/device. A dentry is
unioned or not only in the context of a particular mount.  So we can't
mark the dentry itself since it will be unioned in one mount (say,
/mnt/union) and not in another (/mnt/ro).  A dentry can be looked up
in another mount of one of the components of the union before the
union mount is created, so we can't mark a dentry at lookup anyway.

The vfsmount for the top layer <dentry,mnt> pair is marked with
MNT_UNION, but the vfsmount for the bottom layer is not.  I think we
could mark the lower vfsmount with a flag (probably not MNT_UNION but
MNT_UNION_LOWER or something like that) and check for that.  Al?  Jan?
Christoph?

-VAL
