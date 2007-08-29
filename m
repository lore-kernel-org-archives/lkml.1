Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbXH2EuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbXH2EuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbXH2Et7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:49:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44903 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751579AbXH2Et6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:49:58 -0400
Date: Tue, 28 Aug 2007 21:49:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysctl: Deprecate sys_sysctl in a user space visible
 fashion.
Message-Id: <20070828214956.5f3020ef.akpm@linux-foundation.org>
In-Reply-To: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
References: <m1veazb7w0.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2007 16:40:15 -0600 ebiederm@xmission.com (Eric W. Biederman) wrote:

> +static int deprecated_sysctl_warning(struct __sysctl_args *args)
> +{
> +	static int msg_count;
> +	int name[CTL_MAXNAME];
> +	int i;
> +
> +	/* Read in the sysctl name for better debug message logging */
> +	for (i = 0; i < args->nlen; i++)
> +		if (get_user(name[i], args->name + i))
> +			return -EFAULT;
> +
> +	/* Ignore accesses to kernel.version */
> +	if ((args->nlen == 2) && (name[0] == CTL_KERN) && (name[1] == KERN_VERSION))
> +		return 0;

Do we want to do all the above if msg_count>=5?

> +	if (msg_count < 5) {
> +		msg_count++;
> +		printk(KERN_INFO
> +			"warning: process `%s' used the deprecated sysctl "
> +			"system call with ", current->comm);
> +		for (i = 0; i < args->nlen; i++)
> +			printk("%d.", name[i]);
> +		printk("\n");
> +	}
> +	return 0;
> +}
