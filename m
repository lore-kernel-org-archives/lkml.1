Return-Path: <linux-kernel-owner+w=401wt.eu-S935826AbZLQPIO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935826AbZLQPIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 10:08:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935018AbZLQPIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 10:08:07 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:46558 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935007AbZLQPIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 10:08:05 -0500
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
References: <20091216112844.GA31705@basil.fritz.box>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 17 Dec 2009 07:07:54 -0800
In-Reply-To: <20091216112844.GA31705@basil.fritz.box> (Andi Kleen's message of "Wed\, 16 Dec 2009 12\:28\:44 +0100")
Message-ID: <m16385abat.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH] SYSCTL: Fix sysctl breakage on systems with older glibc
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> SYSCTL: Fix breakage on systems with older glibc
>
> the sysctl(2) changes made systems
> with old glibc nearly unusable. About every command gives a:

> warning: process `ls' used the deprecated sysctl s ystem call with 1.4
>
> warning in the log.

I cranked the level of warning up at least in part to see what the
reaction would be.  If it makes logging in and manually using the
machine unbearable on systems with versions of glibc from days of
yore, the level of logging is too high.

> I see this on a SUSE 10.0 system with glibc 2.3.5.
> Don't warn for this common case.

Perhaps it is just my sample of the world but glibc < 2.5 isn't
common, especially on machines that I am putting new kernels on.
Equally machines with 3+ year old installs are rare.

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>
> diff -u linux-2.6.32-git12/kernel/sysctl_binary.c-o linux-2.6.32-git12/kernel/sysctl_binary.c
> --- linux-2.6.32-git12/kernel/sysctl_binary.c-o	2009-12-16 12:15:52.000000000 +0100
> +++ linux-2.6.32-git12/kernel/sysctl_binary.c	2009-12-16 12:14:58.000000000 +0100
> @@ -1399,6 +1399,13 @@
>  {
>  	int i;
>  
> +	/* 
> +	 * CTL_KERN/KERN_VERSION is used by older glibc and cannot 
> +	 * ever go away.
> +	 */
The comment is wrong.  Older versions of glibc are perfectly happy
getting -ENOSYS form sys_sysctl.

> +	if (name[0] == CTL_KERN && name[1] == KERN_VERSION)
> +		return;

If you make it printk_once for this case I think that strikes the right
balance.  You won't be spammed to death by messages telling you about
a silly old glibc, but you will be told.

>  	if (printk_ratelimit()) {
>  		printk(KERN_INFO
>  			"warning: process `%s' used the deprecated sysctl "

Eric
