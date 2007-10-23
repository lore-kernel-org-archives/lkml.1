Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbXJWCCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbXJWCCy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 22:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbXJWCCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 22:02:44 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:52573 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbXJWCCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 22:02:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=BswSBAxdDbSu1utNyTyiUb/qcHoyhXWjHcROlTJrWNlDzt9DOIYuKMofKQ2KkoxnZ68VqkJ3f6s7teu13w6o1uaAly7Jp6jfr+6VJ5TJSes0LuZOzr5TIeRk76JHWSQ+4NZ2HGnjZWeXHxDxHxwi6QnlMFe1FjmPjWx1ur7+4NA=
Message-ID: <dc1166600710221902t1383ff88q421a17b1ff1382cd@mail.gmail.com>
Date: Tue, 23 Oct 2007 12:02:39 +1000
From: "Michael Ellerman" <michael@ellerman.id.au>
To: "Greg Kroah-Hartman" <greg@kroah.com>
Subject: Re: [PATCH] Allow sysfs_remove_group() to be called on non-added groups
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <096fae99bd9797c5484ed8f4b87b82e58737cdc0.1189657514.git.michael@ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <096fae99bd9797c5484ed8f4b87b82e58737cdc0.1189657514.git.michael@ellerman.id.au>
X-Google-Sender-Auth: b4b2ae59752e9675
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/13/07, Michael Ellerman <michael@ellerman.id.au> wrote:
> It would be nice to be able to do:
>
> for_each_thing(thing) {
>         error = sysfs_create_group(&thing->kobj, attrs);
>         if (error) {
>                 for_each_thing(thing)
>                         sysfs_remove_group(&thing->kobj, attrs);
>                 return error;
>         }
> }
>
> But there's a BUG_ON() in sysfs_remove_group() which hits if the attributes
> were never added.
>
> As discussed here ...
> http://ozlabs.org/pipermail/cbe-oss-dev/2007-July/002774.html
>
> .. we should just return in that case instead of BUG'ing.
>
> Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
> ---
>  fs/sysfs/group.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
> index f318b73..a256775 100644
> --- a/fs/sysfs/group.c
> +++ b/fs/sysfs/group.c
> @@ -73,7 +73,8 @@ void sysfs_remove_group(struct kobject * kobj,
>
>         if (grp->name) {
>                 sd = sysfs_get_dirent(dir_sd, grp->name);
> -               BUG_ON(!sd);
> +               if (!sd)
> +                       return;
>         } else
>                 sd = sysfs_get(dir_sd);
>
>

Hi Greg,

I didn't see this in your series, any objections? AFAICT it still applies.

cheers
