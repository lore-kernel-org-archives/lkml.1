Return-Path: <linux-kernel-owner+w=401wt.eu-S1750959AbZFQKVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750959AbZFQKVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 06:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758336AbZFQKV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 06:21:28 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:54153 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071AbZFQKV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 06:21:27 -0400
Date: Wed, 17 Jun 2009 15:51:26 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: poornima nayak <mpnayak@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [BUG] timer_migration interface accepts any number as input in
	2.6.30-git9
Message-ID: <20090617102126.GA28647@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <1245229936.3345.67.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1245229936.3345.67.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* poornima nayak <mpnayak@linux.vnet.ibm.com> [2009-06-17 14:42:16]:

> Hi
> 
> Timer migration interface /proc/sys/kernel/timer_migration in
> 2.6.30-git9 accepts any numerical value as input.
> Steps to reproduce 
> 1. echo -6666666 > /proc/sys/kernel/timer_migration
> 2. cat /proc/sys/kernel/timer_migration
> -6666666
> 
> 1. echo 44444444444444444444444444444444444444444444444444444444444 > /proc/sys/kernel/timer_migration
> 2. cat /proc/sys/kernel/timer_migration
> -1357789412
> 
> Expected behavior: Should 'echo: write error: Invalid argument' while
> setting any value other then 0 & 1
> 
> Regards
> Poornima
> 

Hi Poornima,

Thanks for reporting the bug.
Hope this patch removes the bug.
The patch is based against the latest -tip/master.

--arun


Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 kernel/sysctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux.trees.git/kernel/sysctl.c
===================================================================
--- linux.trees.git.orig/kernel/sysctl.c
+++ linux.trees.git/kernel/sysctl.c
@@ -335,7 +335,10 @@ static struct ctl_table kern_table[] = {
 		.data		= &sysctl_timer_migration,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &one,
 	},
 #endif
 	{
