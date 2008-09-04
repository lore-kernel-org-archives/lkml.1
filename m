Return-Path: <linux-kernel-owner+w=401wt.eu-S1754270AbYIDRUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbYIDRUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 13:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbYIDRUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 13:20:30 -0400
Received: from citi.umich.edu ([141.211.133.111]:23647 "EHLO citi.umich.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbYIDRU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 13:20:29 -0400
X-Greylist: delayed 1982 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2008 13:20:29 EDT
Date: Thu, 4 Sep 2008 12:47:26 -0400 (EDT)
From: "david m. richter" <richterd@citi.umich.edu>
To: Benny Halevy <bhalevy@panasas.com>
cc: "J. Bruce Fields" <bfields@fieldses.org>, Jiri Pirko <jpirko@redhat.com>,
       linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, neilb@suse.de
Subject: Re: [PATCH] nfsd/nfs4acl: Number of used used array elements needs
 to be zeroed.
In-Reply-To: <48C00F90.40907@panasas.com>
Message-ID: <Pine.BSO.4.64.0809041245240.30827@citi.umich.edu>
References: <20080904165518.15a02908@psychotron.englab.brq.redhat.com>
 <20080904150101.GB4536@fieldses.org> <48C00F90.40907@panasas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008, Benny Halevy wrote:

> On Sep. 04, 2008, 18:01 +0300, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> > On Thu, Sep 04, 2008 at 04:55:18PM +0200, Jiri Pirko wrote:
> >> Number of used used array elements needs to be zeroed. It may cause
> >> problems otherwise, because it's used uninitialized in find_uid().
> >>
> >> Signed-off-by: Jiri Pirko <jpirko@redhat.com>
> >> ---
> >>  fs/nfsd/nfs4acl.c |    2 ++
> >>  1 files changed, 2 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/fs/nfsd/nfs4acl.c b/fs/nfsd/nfs4acl.c
> >> index 54b8b41..7dcd90f 100644
> >> --- a/fs/nfsd/nfs4acl.c
> >> +++ b/fs/nfsd/nfs4acl.c
> >> @@ -447,11 +447,13 @@ init_state(struct posix_acl_state *state, int cnt)
> >>  	state->users = kzalloc(alloc, GFP_KERNEL);
> >>  	if (!state->users)
> >>  		return -ENOMEM;
> >> +	state->users->n = 0;
> >>  	state->groups = kzalloc(alloc, GFP_KERNEL);
> >>  	if (!state->groups) {
> >>  		kfree(state->users);
> >>  		return -ENOMEM;
> >>  	}
> >> +	state->groups->n = 0;
> >>  	return 0;
> >>  }
> > 
> > Thanks for the extra eyes on this code, but: surely the kzalloc()'s are
> > all that's necessary?  Am I missing something?
> 
> quickly browsing over the code, shouldn't it be:
> 
> diff --git a/fs/nfsd/nfs4acl.c b/fs/nfsd/nfs4acl.c
> index b6ed383..54b8b41 100644
> --- a/fs/nfsd/nfs4acl.c
> +++ b/fs/nfsd/nfs4acl.c
> @@ -443,7 +443,7 @@ init_state(struct posix_acl_state *state, int cnt)
>  	 * enough space for either:
>  	 */
>  	alloc = sizeof(struct posix_ace_state_array)
> -		+ cnt*sizeof(struct posix_ace_state);
> +		+ cnt*sizeof(struct posix_user_ace_state);

	:) heheheh, we could've used your sharp eyes last week when we 
were dealing with ACL shenanigans -- i believe that this is covered in one 
of the patches that bruce sent out in the last few days.

	d
	.

>  	state->users = kzalloc(alloc, GFP_KERNEL);
>  	if (!state->users)
>  		return -ENOMEM;
> 
> Benny
> 
> > 
> > --b.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
