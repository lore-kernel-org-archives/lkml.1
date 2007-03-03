Return-Path: <linux-kernel-owner+w=401wt.eu-S1030227AbXCCNKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030227AbXCCNKz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 08:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965558AbXCCNKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 08:10:55 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:21244 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965071AbXCCNKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 08:10:54 -0500
To: Dmitriy Monakhov <dmonakhov@sw.ru>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [patch] kobject: new_device->kref wasn't putted in kobject_move()
References: <87vehitrt2.fsf@sw.ru>
From: Dmitriy Monakhov <dmonakhov@sw.ru>
Date: Sat, 03 Mar 2007 16:11:21 +0300
In-Reply-To: <87vehitrt2.fsf@sw.ru> (Dmitriy Monakhov's message of "Sat, 03 Mar 2007 15:50:01 +0300")
Message-ID: <87lkieqxom.fsf@sw.ru>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitriy Monakhov <dmonakhov@sw.ru> writes:

> Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
>
> diff --git a/lib/kobject.c b/lib/kobject.c
> index b94f208..b11f7b2 100644
> --- a/lib/kobject.c
> +++ b/lib/kobject.c
> @@ -432,6 +432,7 @@ int kobject_move(struct kobject *kobj, struct kobject *new_parent)
>  	kobject_put(old_parent);
>  	kobject_uevent_env(kobj, KOBJ_MOVE, envp);
>  out:
> +	kobject_put(new_parent);
>  	kobject_put(kobj);
>  	kfree(devpath_string);
>  	kfree(devpath);
OOps i'm realy sorry, by occasion patch was incomplete :(
The updated patch version following:

  [PATCH] kobject: new_device->kref wasn't putted after error in kobject_move()
  If error happen we jump to "out" label, in this case new_device not yet 
  became the parent but it wasn't putted.
 
  Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>

diff --git a/lib/kobject.c b/lib/kobject.c
index b94f208..a6c9a06 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -429,9 +429,11 @@ int kobject_move(struct kobject *kobj, struct kobject *new_parent)
 		goto out;
 	old_parent = kobj->parent;
 	kobj->parent = new_parent;
+	new_parent = NULL;
 	kobject_put(old_parent);
 	kobject_uevent_env(kobj, KOBJ_MOVE, envp);
 out:
+	kobject_put(new_parent);
 	kobject_put(kobj);
 	kfree(devpath_string);
 	kfree(devpath);


