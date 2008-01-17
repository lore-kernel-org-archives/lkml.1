Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbYAQTX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbYAQTX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbYAQTXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:23:51 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58983 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752281AbYAQTXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:23:50 -0500
Date: Thu, 17 Jan 2008 11:23:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: nigel@nigel.suspend2.net, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       TuxOnIce-devel <tuxonice-devel@lists.tuxonice.net>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] (2.4.25 material?) Fix unbalanced helper_lock in
 kernel/kmod.c
Message-Id: <20080117112332.9e34b7d9.akpm@linux-foundation.org>
In-Reply-To: <200801171902.44133.rjw@sisk.pl>
References: <478EA17B.30601@nigel.suspend2.net>
	<200801171902.44133.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 19:02:43 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Thursday, 17 of January 2008, Nigel Cunningham wrote:
> > Hi all.
> 
> Hi,
> 
> > First up, sorry for not inlining the patch - trouble with line wrapping.
> 
> No big deal.
> 
> > In 2.6.24-rc8, call_usermodehelper_exec has an exit path that can leave
> > the helper_lock() call at the top of the routine unbalanced. The
> > attached patch fixes this issue.
> 
> Thanks a lot for the patch (reproduced below), I think it's 2.6.24 material.
> Andrew?
> 
> > Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
> 
> ---
> From: Nigel Cunningham <nigel@tuxonice.net>
> 
> In 2.6.24-rc8, call_usermodehelper_exec has an exit path that can leave
> the helper_lock() call at the top of the routine unbalanced.  Fix it.
> 
> Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index c6a4f8a..de27e15 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -468,8 +468,10 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info,
>  	sub_info->wait = wait;
>  
>  	queue_work(khelper_wq, &sub_info->work);
> -	if (wait == UMH_NO_WAIT) /* task has freed sub_info */
> +	if (wait == UMH_NO_WAIT) { /* task has freed sub_info */
> +		helper_unlock();
>  		return 0;
> +	}
>  	wait_for_completion(&done);
>  	retval = sub_info->retval;
>  

Yup, I ended up queueing this:

From: Nigel Cunningham <nigel@nigel.suspend2.net>

call_usermodehelper_exec() has an exit path that can leave the
helper_lock() call at the top of the routine unbalanced.  The attached
patch fixes this issue.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kmod.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN kernel/kmod.c~fix-unbalanced-helper_lock-in-kernel-kmodc kernel/kmod.c
--- a/kernel/kmod.c~fix-unbalanced-helper_lock-in-kernel-kmodc
+++ a/kernel/kmod.c
@@ -451,13 +451,11 @@ int call_usermodehelper_exec(struct subp
 			     enum umh_wait wait)
 {
 	DECLARE_COMPLETION_ONSTACK(done);
-	int retval;
+	int retval = 0;
 
 	helper_lock();
-	if (sub_info->path[0] == '\0') {
-		retval = 0;
+	if (sub_info->path[0] == '\0')
 		goto out;
-	}
 
 	if (!khelper_wq || usermodehelper_disabled) {
 		retval = -EBUSY;
@@ -468,13 +466,14 @@ int call_usermodehelper_exec(struct subp
 	sub_info->wait = wait;
 
 	queue_work(khelper_wq, &sub_info->work);
-	if (wait == UMH_NO_WAIT) /* task has freed sub_info */
-		return 0;
+	if (wait == UMH_NO_WAIT)	/* task has freed sub_info */
+		goto unlock;
 	wait_for_completion(&done);
 	retval = sub_info->retval;
 
-  out:
+out:
 	call_usermodehelper_freeinfo(sub_info);
+unlock:
 	helper_unlock();
 	return retval;
 }
_

