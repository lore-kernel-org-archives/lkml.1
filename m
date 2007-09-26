Return-Path: <linux-kernel-owner+w=401wt.eu-S1754845AbXIZHWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845AbXIZHWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 03:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751986AbXIZHWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 03:22:33 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:64427 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbXIZHWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 03:22:32 -0400
Date: Wed, 26 Sep 2007 09:21:56 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: subsystem_unregister() breakage in -mm
Message-ID: <20070926092156.2f281eea@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070926024121.GA28124@kroah.com>
References: <E1IaIs6-00051t-00@dorka.pomaz.szeredi.hu>
	<20070925225330.GA26235@kroah.com>
	<E1IaJQL-00053O-00@dorka.pomaz.szeredi.hu>
	<20070926024121.GA28124@kroah.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 19:41:21 -0700,
Greg KH <greg@kroah.com> wrote:

> Ok, here's a patch that fixes this for me.  It should go on top of the
> -mm tree.  Let me know of this works or not.

Looks sane to me.

> In the end, we need to dynamically allocate these subsystems to properly
> fix this.  In looking through the tree, there really isn't that many of
> them, so I'll try to knock that out later this week.

What they need at least is a dynamically allocated k_name. Same goes
for all those objects that use set_kset_name(), and there are quite a
few of those...

> 
> 
> thanks,
> 
> greg k-h
> 
> ---
>  lib/kobject.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -487,11 +487,11 @@ void kobject_cleanup(struct kobject * ko
>  	struct kobject * parent = kobj->parent;
> 
>  	pr_debug("kobject %s: cleaning up\n",kobject_name(kobj));
> -	kfree(kobj->k_name);
> -	kobj->k_name = NULL;
> -	if (t && t->release)
> +	if (t && t->release) {
>  		t->release(kobj);
> -	else
> +		kfree(kobj->k_name);
> +		kobj->k_name = NULL;
> +	} else
>  		pr_debug("kobject '%s' does not have a release() function, "
>  			"if this is not a directory kobject, it is broken "
>  			"and must be fixed.\n",
