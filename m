Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbZAFTl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbZAFTl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 14:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751308AbZAFTlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 14:41:16 -0500
Received: from mail.fieldses.org ([141.211.133.115]:45118 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbZAFTlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 14:41:15 -0500
Date: Tue, 6 Jan 2009 14:41:01 -0500
To: David Howells <dhowells@redhat.com>
Cc: hch@lst.de, jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix NFSD regression
Message-ID: <20090106194101.GB5901@fieldses.org>
References: <806.1231174132@redhat.com> <20090105171937.4463.98583.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105171937.4463.98583.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 05:19:37PM +0000, David Howells wrote:
> Fix a regression in NFSD's permission checking introduced by the credentials
> patches.  There are two parts to the problem, both in nfsd_setuser():
> 
>  (1) The return value of set_groups() is -ve if in error, not 0, and should be
>      checked appropriately.  0 indicates success.
> 
>  (2) The UID to use for fs accesses is in new->fsuid, not new->uid (which is
>      0).  This causes CAP_DAC_OVERRIDE to always be set, rather than being
>      cleared if the UID is anything other than 0 after squashing.
> 
> Reported-by: J. Bruce Fields <bfields@fieldses.org>
> Signed-off-by: David Howells <dhowells@redhat.com>

OK, I've tested this and applied it for 2.6.29.

Though it only actually fixes the regression if your other patch ("CRED:
Fix regression in cap_capable() as shown up by sys_faccessat() [ver #2")
is also applied.  I'd like to send in my pull request today, but I
usually try not to send a pull request whose tip doesn't pass at least
my basic regression tests....  And that other patch is outside my
baliwick.    Can someone else handle it?

--b.


> ---
> 
>  fs/nfsd/auth.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
> index 0184fe9..c903e04 100644
> --- a/fs/nfsd/auth.c
> +++ b/fs/nfsd/auth.c
> @@ -76,10 +76,10 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
>  
>  	ret = set_groups(new, gi);
>  	put_group_info(gi);
> -	if (!ret)
> +	if (ret < 0)
>  		goto error;
>  
> -	if (new->uid)
> +	if (new->fsuid)
>  		new->cap_effective = cap_drop_nfsd_set(new->cap_effective);
>  	else
>  		new->cap_effective = cap_raise_nfsd_set(new->cap_effective,
> 
