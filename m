Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbZAVT5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbZAVT5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 14:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbZAVT5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 14:57:13 -0500
Received: from mail.fieldses.org ([141.211.133.115]:53194 "EHLO
	pickle.fieldses.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452AbZAVT5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:57:11 -0500
Date: Thu, 22 Jan 2009 14:57:12 -0500
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-nfs@vger.kernel.org, cluster-devel@redhat.com,
       teigland@redhat.com
Subject: Re: [PATCH 0/2] nfsd/dlm: fix knfsd panic when NFSv4 client does
	GETLK call
Message-ID: <20090122195712.GJ15279@fieldses.org>
References: <1232651764-10799-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232651764-10799-1-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2009 at 02:16:02PM -0500, Jeff Layton wrote:
> This patchset fixes a regression due to this patch:

These look reasonable, thanks.

My testing infrastructure and stuff is still down, so I may be a little
slow getting these upstream.... Bug me again next week if I haven't done
anything and you think of it.

--b.

> 
> ----------------[snip]----------------
> commit 55ef1274dddd4de387c54d110e354ffbb6cdc706
> Author: J. Bruce Fields <bfields@citi.umich.edu>
> Date:   Sat Dec 20 11:58:38 2008 -0800
> 
>     nfsd: Ensure nfsv4 calls the underlying filesystem on LOCKT
> ----------------[snip]----------------
> 
> To reproduce, set up a nfs server that is serving out a GFS2 filesystem.
> Set a lock locally on a file on the GFS2 export on the server. From a
> NFSv4 client, do a GETLK against the same file. The server will oops due
> to a NULL pointer dereference. The fl_lmops will be set, but the
> fl_owner will be a NULL pointer. The knfsd code does not account for
> this possibility. It assumes that when fl_lmops is set this way that
> the fl_owner will point to a valid nfs4_stateowner struct.
> 
> In actuality, Bruce's patch is correct, but it exposes a bug in DLM's
> GETLK codepath. The first patch in this set fixes that.
> 
> The second patch fixes knfsd to be a little more careful about the
> file_lock struct it builds to pass to vfs_test_lock.
> 
> Either patch should prevent the panic, though I think applying both
> patches is the best approach to fixing this.
> 
> Jeff Layton (2):
>   dlm: initialize file_lock struct in GETLK before copying conflicting
>     lock
>   nfsd: only set file_lock.fl_lmops in nfsd4_lockt if a stateowner is
>     found
> 
>  fs/dlm/plock.c      |    2 ++
>  fs/nfsd/nfs4state.c |    1 -
>  2 files changed, 2 insertions(+), 1 deletions(-)
> 
