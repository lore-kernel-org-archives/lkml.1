Return-Path: <linux-kernel-owner+w=401wt.eu-S1758541AbYDXMni@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541AbYDXMni (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 08:43:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbYDXMn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 08:43:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50876 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbYDXMn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 08:43:28 -0400
Date: Thu, 24 Apr 2008 13:42:46 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
Message-ID: <20080424124245.GC15214@ZenIV.linux.org.uk>
References: <20080424113950.818688067@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424113950.818688067@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 01:39:50PM +0200, Miklos Szeredi wrote:
> Then I did this series, which basically guarantees, that that cannot
> happen.  Al rejected it, and rather fixed some of the remaining
> places.  He still missed several, which sort of proves my point.

Which ones have I missed?
 
> I think it's totally pointless to continue trying to fix the symptoms
> instead of getting at the root of the problem.
> 
> I know that VFS interfaces are a sensitive question, but it would be
> nice it we could have some sanity back in this discussion.

Yes, it would.  How about that, for starters:

path_create() et.al. are *wrong* for nfsd; if nothing else, I'm not at
all convinced that even apparmour wants export path + relative there
_and_ r/o vs. r/w is decision that doesn't clearly map to ex_mnt flags.

Moreover, it's not at all obvious that we want to drop write access as
soon as vfs_...() is over in case of nfsd.  Some of the stuff done
immeidately afterwards might very well qualify for inclusion into
protected area; some of the stuff done immediately _prior_ very likely
needs that as well - look at fh_verify() and tell me why we don't want
that "I'll hold write access to vfsmount" to span the area including
that sucker.  If we want the r/o vs r/w policy directly vfsmount-based
for nfsd, that is.

For ecryptfs it's also bogus - at the very least we need to decide what
should happen when underlying vfsmount is remounted.  Again, I'm less
than convinced that we want the same way to express r/o vs. r/w policy.
