Return-Path: <linux-kernel-owner+w=401wt.eu-S1761697AbYCCXET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761697AbYCCXET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbYCCXEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:04:00 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:55344 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbYCCXD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:03:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=fkzmFYFDsyLOBC7vVjZqtZPINiKctcEybU1ZEE9b0tMNBm/KJ21+FQT8QmRSbLE+bcDMOtEGk/JHfOjj8l9AzTakAXSOR0HEUxLVKqTCIVJajpam2jf/nsREjhJlEGS++Ko7YHZGaxTBt42+z8XbXgjOstqLTPDgUp1w3ADjeaM=
Date: Tue, 4 Mar 2008 01:42:21 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH RFC] introduce pm_call() macro to get rid of most
	#ifdef CONFIG_PM
Message-ID: <20080303224221.GA27395@zarina>
Reply-To: cbouatmailru@gmail.com
References: <20080302234308.GA10116@zarina> <20080303141818.GE12606@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080303141818.GE12606@elf.ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 03:18:18PM +0100, Pavel Machek wrote:
> Hi!
> 
> > diff --git a/include/linux/pm.h b/include/linux/pm.h
> > index 015b735..6e0b9c2 100644
> > --- a/include/linux/pm.h
> > +++ b/include/linux/pm.h
> > @@ -114,6 +114,13 @@ typedef struct pm_message {
> >  	int event;
> >  } pm_message_t;
> >  
> > +#ifdef CONFIG_PM
> > +#define pm_call(x) (x)
> > +#else
> > +/* avoid `defined but not used' warning */
> > +#define pm_call(x) ((x) - 1 ? NULL : NULL)
> > +#endif /* CONFIG_PM */
> > +
> 
> This is evil. Maybe your gcc is smart enough to optimize this away,
> but I'm not sure mine is.

No problem. Let's use __maybe_unsed then, it gives the same effect.

- - - -
Subject: introduce pm_call() macro to get rid of most #ifdef CONFIG_PM

Currently drivers handle CONFIG_PM this way:

#ifdef CONFIG_PM
drv_suspend() {}
drv_resume() {}
#else
#define drv_suspend NULL
#define drv_resume NULL
#endif

struct driver drv = {
	.suspend = drv_suspend,
	.resume = drv_resume,
};

With this patch, the code above converts into:

__maybe_unused drv_suspend() {}
__maybe_unused drv_resume() {}

struct driver drv = {
	.suspend = pm_call(drv_suspend),
	.resume = pm_call(drv_resume),
};

GCC will optimize away suspend/resume calls if they're really
not used.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 include/linux/pm.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index 015b735..a3932c7 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -114,6 +114,12 @@ typedef struct pm_message {
 	int event;
 } pm_message_t;
 
+#ifdef CONFIG_PM
+#define pm_call(x) (x)
+#else
+#define pm_call(x) NULL
+#endif /* CONFIG_PM */
+
 /*
  * Several driver power state transitions are externally visible, affecting
  * the state of pending I/O queues and (for drivers that touch hardware)
-- 
1.5.4.3

