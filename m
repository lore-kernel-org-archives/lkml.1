Return-Path: <linux-kernel-owner+w=401wt.eu-S1761055AbZDANHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761055AbZDANHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbZDANHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:07:34 -0400
Received: from mx2.netapp.com ([216.240.18.37]:4398 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491AbZDANHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:07:32 -0400
X-IronPort-AV: E=Sophos;i="4.39,306,1235980800"; 
   d="scan'208";a="148705176"
Subject: Re: [PATCH 1/4] VFS: Add a VFS helper function
 vfs_remote_path_lookup()
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org
In-Reply-To: <20090401021554.GV28946@ZenIV.linux.org.uk>
References: <cover.1238525532.git.Trond.Myklebust@netapp.com>
	 <3f1264127d431f695be25b940b477e3d287edc68.1238525532.git.Trond.Myklebust@netapp.com>
	 <20090401021554.GV28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Wed, 01 Apr 2009 09:06:28 -0400
Message-Id: <1238591188.5810.18.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
X-OriginalArrivalTime: 01 Apr 2009 13:07:28.0346 (UTC) FILETIME=[CF0A33A0:01C9B2CA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-01 at 03:15 +0100, Al Viro wrote:
> On Wed, Mar 11, 2009 at 03:50:33PM -0400, Trond Myklebust wrote:
> > The purpose of this patch is to improve the mount path lookup support for
> > filesystems such as NFSv4, which require you to look up a mount path
> > string in a remote server's namespace.
> > 
> > Traversing such a path is pretty much identical to walking a local path,
> > in that it may involve following symlinks and even following referrals to
> > volumes that reside on other servers. Since the standard VFS path lookup
> > code already supports all these features (using in-kernel automounts for
> > following referrals) it would be nice to be able to reuse that code rather
> > than special case the mount path lookup in the NFS client.
> > 
> > This patch therefore defines a VFS helper function that sets up a temporary
> > mount namespace to represent the server namespace, and has the current
> > task pivot into that prior to doing the path lookup. Upon completion, it
> > pivots back into the original namespace, and destroys the private one.
> 
> NAK.  You are relying on too many things about caller (e.g. just what happens
> if you have shared fs_struct?  Does caller guarantee it won't happen?), so
> that's a bloody bad interface.  Open-code that sucker, then let's see what
> to do with surrounding code.  As it stands - no.

Since vfs_remote_path_lookup() creates a private copy of the fs_struct,
are you referring to the assumptions that are made in
create_private_mnt_ns()? Sure; that's not intended as an interface for
general use. I'll rewrite that...

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
