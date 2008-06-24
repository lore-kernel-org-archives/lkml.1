Return-Path: <linux-kernel-owner+w=401wt.eu-S1759347AbYFXOZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347AbYFXOZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 10:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbYFXOY7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 10:24:59 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:18794 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbYFXOY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 10:24:58 -0400
Date: Tue, 24 Jun 2008 16:24:48 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Wang Chen <wangchen@cn.fujitsu.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kobjects: Transmit return value of
 kobject_uevent_env() to caller
Message-ID: <20080624162448.4b1e3d87@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <4860B75A.1050307@cn.fujitsu.com>
References: <4860B75A.1050307@cn.fujitsu.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2008 16:59:06 +0800,
Wang Chen <wangchen@cn.fujitsu.com> wrote:

> The error signal shouldn't be dropped.
> 
> Signed-off-by: Wang Chen <wangchen@cn.fujitsu.com>
> ---
> diff --git a/lib/kobject.c b/lib/kobject.c
> index 718e510..e5de71e 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -430,7 +430,7 @@ int kobject_rename(struct kobject *kobj, const char *new_name)
>  	 * Some hotplug package track interfaces by their name and
>  	 * therefore want to know when the name is changed by the user. */
>  	if (!error)
> -		kobject_uevent_env(kobj, KOBJ_MOVE, envp);
> +		error = kobject_uevent_env(kobj, KOBJ_MOVE, envp);
> 
>  out:
>  	kfree(devpath_string);
> @@ -482,7 +482,7 @@ int kobject_move(struct kobject *kobj, struct kobject *new_parent)
>  	kobj->parent = new_parent;
>  	new_parent = NULL;
>  	kobject_put(old_parent);
> -	kobject_uevent_env(kobj, KOBJ_MOVE, envp);
> +	error = kobject_uevent_env(kobj, KOBJ_MOVE, envp);
>  out:
>  	kobject_put(new_parent);
>  	kobject_put(kobj);
> 
> 
> 

This looks wrong. If everything went right except sending the uevent,
you'll make the caller believe that the whole operation failed, while
in reality the sysfs operation succeeded. Either just drop the error
again (or print a warning), or undo the previous operations on error
(which may fail).
