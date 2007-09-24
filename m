Return-Path: <linux-kernel-owner+w=401wt.eu-S1756446AbXIXWAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbXIXWAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 18:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753832AbXIXWAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 18:00:07 -0400
Received: from vena.lwn.net ([206.168.112.25]:41566 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728AbXIXWAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 18:00:06 -0400
To: Tejun Heo <htejun@gmail.com>
To: ebiederm@xmission.com, cornelia.huck@de.ibm.com, greg@kroah.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 1/4] module: implement module_inhibit_unload() 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Thu, 20 Sep 2007 16:26:15 +0900."
             <11902731752708-git-send-email-htejun@gmail.com> 
Date: Mon, 24 Sep 2007 16:00:05 -0600
Message-ID: <25380.1190671205@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Tejun,

I was just looking over these changes...

> +	/* Don't proceed till inhibition is lifted. */
> +	add_wait_queue(&module_unload_wait, &wait);
> +	set_current_state(TASK_UNINTERRUPTIBLE);
> +	if (atomic_read(&module_unload_inhibit_cnt))
> +		schedule();
> +	__set_current_state(TASK_RUNNING);
> +	remove_wait_queue(&module_unload_wait, &wait);
> +
> +	mutex_lock(&module_mutex);

Maybe I'm missing something, but this looks racy to me.  There's no
check after schedule() to see if module_unload_inhibit_cnt is really
zero, and nothing to keep somebody else from slipping in and raising it
again afterward.

Given your description of this tool as a "sledgehammer," might it not be
easier to just take and hold module_mutex for the duration of the unload
block?

jon

