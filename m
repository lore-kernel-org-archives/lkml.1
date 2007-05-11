Return-Path: <linux-kernel-owner+w=401wt.eu-S933900AbXEKW41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933900AbXEKW41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 18:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbXEKW4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 18:56:19 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:62799 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168AbXEKW4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 18:56:18 -0400
Date: Fri, 11 May 2007 15:56:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Len Brown <lenb@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 6/7] Add common orderly_poweroff()
Message-Id: <20070511155612.1d4575ea.randy.dunlap@oracle.com>
In-Reply-To: <20070511000028.446470000@goop.org>
References: <20070510235708.155502000@goop.org>
	<20070511000028.446470000@goop.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 16:57:14 -0700 Jeremy Fitzhardinge wrote:

> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2208,3 +2208,61 @@ asmlinkage long sys_getcpu(unsigned __us
> +
> +/**
> + * Trigger an orderly system poweroff

    * orderly_poweroff - Trigger an orderly system poweroff

> + * @force: force poweroff if command execution fails
> + *
> + * This may be called from any context to trigger a system shutdown.
> + * If the orderly shutdown fails, it will force an immediate shutdown.
> + */
> +int orderly_poweroff(bool force)
> +{
> +	int argc;
> +	char **argv = argv_split(GFP_ATOMIC, poweroff_cmd, &argc);
> +	static char *envp[] = {
> +		"HOME=/",
> +		"PATH=/sbin:/bin:/usr/sbin:/usr/bin",
> +		NULL
> +	};
> +	int ret = -ENOMEM;
> +	struct subprocess_info *info;
> +
> +	if (argv == NULL) {
> +		printk(KERN_WARNING "%s failed to allocate memory for \"%s\"\n",
> +		       __func__, poweroff_cmd);
> +		goto out;
> +	}
> +
> +	info = call_usermodehelper_setup(argv[0], argv, envp);
> +	if (info == NULL) {
> +		argv_free(argv);
> +		goto out;
> +	}
> +
> +	call_usermodehelper_setcleanup(info, argv_cleanup);
> +
> +	ret = call_usermodehelper_exec(info, -1);
> +
> +  out:
> +	if (ret && force) {
> +		printk(KERN_WARNING "Failed to start orderly shutdown: "
> +		       "forcing the issue\n");
> +
> +		/* I guess this should try to kick off some daemon to
> +		   sync and poweroff asap.  Or not even bother syncing
> +		   if we're doing an emergency shutdown? */
> +		emergency_sync();
> +		kernel_power_off();
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(orderly_poweroff);


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
