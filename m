Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZK3G1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZK3G1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 01:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZK3G1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 01:27:21 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:34840 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbZK3G1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 01:27:20 -0500
Date: Mon, 30 Nov 2009 01:26:53 -0500
Message-Id: <200911300626.nAU6QrSv022100@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 13/41] whiteout: tmpfs whiteout support 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:11 PDT."
             <1256152779-10054-14-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-14-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@suse.de>
> 
> Add support for whiteout dentries to tmpfs.

Shouldn't you CC Hugh Dickins here?  He's probably best positioned to review
the changes in mm/shmem.c.

> XXX - Not sure this is the right patch to put the code for supporting
> whiteouts in d_genocide().
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/dcache.c |    3 +-
>  mm/shmem.c  |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
>  2 files changed, 137 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 0fcae4b..1fae1df 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -2280,7 +2280,8 @@ resume:
>  		struct list_head *tmp = next;
>  		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
>  		next = tmp->next;
> -		if (d_unhashed(dentry)||!dentry->d_inode)
> +		if (d_unhashed(dentry)||(!dentry->d_inode &&
> +					 !d_is_whiteout(dentry)))

I think this d_genocide patch should go elsewhere.  What does it have to do
with tmpfs?

Also, is your logic above correct?  If I understood d_genocide correctly,
then the code you changed attempts to skip over dentries for which
d_genocide has no work to do, like unhashed and negative dentries.  So I
assume it should also skip over whiteout dentries.  Your condition is

if (d_unhashed(dentry) || (!dentry->d_inode && !d_is_whiteout(dentry)))

but perhaps it needs to be

if (d_unhashed(dentry) || !dentry->d_inode || d_is_whiteout(dentry))

No?

Either way, you may want to document any complex conditional that may be
confusing to parse.

>  			continue;
>  		if (!list_empty(&dentry->d_subdirs)) {
>  			this_parent = dentry;
> diff --git a/mm/shmem.c b/mm/shmem.c
> index d713239..2faa14b 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
[mm/shmem.c changes snipped]

Erez.
