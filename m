Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbZJFIuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbZJFIuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 04:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbZJFIuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 04:50:20 -0400
Received: from smtp.nokia.com ([192.100.105.134]:25315 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697AbZJFIuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 04:50:18 -0400
Subject: Re: [PATCH 1/1] Kobject: bail early if no new_parent in
	kobject_move()
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
Reply-To: ext-phil.2.carmody@nokia.com
To: ext Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20091005183753.4d77afcb@gondolin>
References: <c4b4c2e3155280589fb539f952e58c77a1fa7e96.1254408493.git.ext-phil.2.carmody@nokia.com>
	 <20091005183753.4d77afcb@gondolin>
Content-Type: text/plain
Organization: Nokia Oyj
Date: Tue, 06 Oct 2009 11:52:09 +0300
Message-Id: <1254819129.23533.27.camel@pcarmody-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2009 08:48:39.0895 (UTC) FILETIME=[CD059E70:01CA4661]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-10-05 at 18:37 +0200, ext Cornelia Huck wrote:
> On Thu,  1 Oct 2009 17:50:48 +0300,
> Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:
> 
> > From: Phil Carmody <ext-phil.2.carmody@nokia.com>
> > 
> > In the absense of kobj->kset, new_parent would remain NULL.
> > NULL-dereference shenanighans then ensues in the subsequent
> > sysfs_move_dir(..., new_parent) call. Bail early instead.
> 
> But sysfs_move_dir(..., NULL) should work and fall back to the sysfs
> root...

I guess there are two schools of thought - the strict and the
accommodating. I was contemplating resending an even stricter patch, but
there's nothing wrong with adopting sane safe fallbacks instead. 

> <looks at code>
> 
> It seems that has been broken for some time. Should probably be
> something like this instead (uncompiled); I can send it with proper
> description and s-o-b once I gave it a test.
> 
> ---
>  fs/sysfs/dir.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.orig/fs/sysfs/dir.c
> +++ linux-2.6/fs/sysfs/dir.c
> @@ -894,7 +894,8 @@ int sysfs_move_dir(struct kobject *kobj,
>  
>  	mutex_lock(&sysfs_rename_mutex);
>  	BUG_ON(!sd->s_parent);
> -	new_parent_sd = new_parent_kobj->sd ? new_parent_kobj->sd : &sysfs_root;
> +	new_parent_sd = (new_parent_kobj && new_parent_kobj->sd) ?
> +		new_parent_kobj->sd : &sysfs_root;
>  
>  	error = 0;
>  	if (sd->s_parent == new_parent_sd)

Looks like it knocks the NULL dereference squarely on the head. Yup.

Phil
-- 
"They weren't designed to run on a computer, they were designed
to run on a Powerpoint slide projector." -- Peter Gutmann

