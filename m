Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbZKGQy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbZKGQy0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 11:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbZKGQyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 11:54:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45280 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbZKGQyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 11:54:23 -0500
Date: Sat, 7 Nov 2009 17:54:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Dasgupta, Romit" <romit@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 1/1] PM: Thaws refrigerated and to be exited kernel
	threads
Message-ID: <20091107165421.GA1630@ucw.cz>
References: <B85A65D85D7EB246BE421B3FB0FBB59301DE31F934@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59301DE31F934@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Kicks out a frozen thread from the refrigerator when an active thread has
> invoked kthread_stop on the frozen thread.
> 
> Signed-off-by: Romit Dasgupta <romit@ti.com>
> ---
> 
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index bd1d42b..c28dbe8 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -9,6 +9,7 @@
>  #include <linux/module.h>
>  #include <linux/syscalls.h>
>  #include <linux/freezer.h>
> +#include <linux/kthread.h>
>  
>  /*
>   * freezing is complete, mark current process as frozen
> @@ -49,7 +50,7 @@ void refrigerator(void)
>  
>  	for (;;) {
>  		set_current_state(TASK_UNINTERRUPTIBLE);
> -		if (!frozen(current))
> +		if (!frozen(current) || (!current->mm && kthread_should_stop()))
>  			break;
>  		schedule();

Well, what if the thread does some processing before stopping? That
would break refrigerator assumptions...
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
