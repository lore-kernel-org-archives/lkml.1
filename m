Return-Path: <linux-kernel-owner+w=401wt.eu-S1761797AbXKNRvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761797AbXKNRvD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 12:51:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756023AbXKNRux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 12:50:53 -0500
Received: from pat.uio.no ([129.240.10.15]:52239 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbXKNRuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 12:50:52 -0500
Subject: Re: [PATCH] - [7/15] - remove defconfig ptr comparisons to 0 -
	fs/lockd
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Neil Brown <neilb@suse.de>
Cc: Joe Perches <joe@perches.com>, linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       nfs@lists.sourceforge.net
In-Reply-To: <1195015507.7468.86.camel@heimdal.trondhjem.org>
References: <1195005918.5163.93.camel@localhost>
	 <18234.24623.742782.328651@notabene.brown>
	 <1195015507.7468.86.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Wed, 14 Nov 2007 12:50:46 -0500
Message-Id: <1195062646.7584.27.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.080)
X-UiO-Scanned: 43592F441858907828C432CDB83AD942B33D229E
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 885 total 5132658 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-11-13 at 23:45 -0500, Trond Myklebust wrote:
> On Wed, 2007-11-14 at 13:40 +1100, Neil Brown wrote:
> > On Tuesday November 13, joe@perches.com wrote:
> > > Remove defconfig ptr comparison to 0
> > > 
> > > Remove sparse warning: Using plain integer as NULL pointer
> > > 
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > > 
> > > ---
> > > 
> > > diff --git a/fs/lockd/svcshare.c b/fs/lockd/svcshare.c
> > > index 068886d..98548ad 100644
> > > --- a/fs/lockd/svcshare.c
> > > +++ b/fs/lockd/svcshare.c
> > > @@ -71,7 +71,7 @@ nlmsvc_unshare_file(struct nlm_host *host, struct nlm_file *file,
> > >  	struct nlm_share	*share, **shpp;
> > >  	struct xdr_netobj	*oh = &argp->lock.oh;
> > >  
> > > -	for (shpp = &file->f_shares; (share = *shpp) != 0; shpp = &share->s_next) {
> > > +	for (shpp = &file->f_shares; (share = *shpp); shpp = &share->s_next) {
> > >  		if (share->s_host == host && nlm_cmp_owner(share, oh)) {
> > >  			*shpp = share->s_next;
> > >  			kfree(share);
> > > 
> > 
> > I particularly disagree with this change as it now looked like it
> > could be an '==' comparison that was mistyped.  Making it 
> >         ....; (share = *shpp) != NULL; ....
> 
> There would also be the minor fact that the original test is being
> inverted in this 'fix'. An accurate fix should at the very least be
>    !(share = *shpp).

Apologies to Joe. I must have been tired when I typed the above. However
I'm still NACKing the patch: removing the '!= 0' altogether reduces code
legibility rather than improving it, particularly when we have that ugly
assignment.
If the intent is just to silence 'sparse', then replace with '!= NULL'.

> > makes the intent clear.
> 
> It would be a lot cleaner just to pull the entire assignment out of the
> for() statement. IOW:
> 
> 	for (shpp = &file->f_shares; *shpp != NULL; shpp = &(*shpp)->s_next) {
> 		struct nlm_share *share = *shpp;

...however doing something like the above would be altogether
preferable, since that cleans up the assignment which is the source of
the ugliness.

Cheers
  Trond

