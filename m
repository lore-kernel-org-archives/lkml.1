Return-Path: <linux-kernel-owner+w=401wt.eu-S1765497AbZFQKka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765497AbZFQKka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 06:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758373AbZFQKkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 06:40:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:43262 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbZFQKkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 06:40:21 -0400
Subject: Re: [BUG] timer_migration interface accepts any number as input in
 2.6.30-git9
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: poornima nayak <mpnayak@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arun@linux.vnet.ibm.com,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1245229936.3345.67.camel@localhost.localdomain>
References: <1245229936.3345.67.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 16:11:09 +0530
Message-Id: <1245235269.2603.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 14:42 +0530, poornima nayak wrote:
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

Is this patch fix your problem:

[PATCH] kernel/sysctl: fix timer migration interface

Timer migration interface /proc/sys/kernel/timer_migration in
2.6.30-git9 accepts any numerical value as input.
Steps to reproduce
1. echo -6666666 > /proc/sys/kernel/timer_migration
2. cat /proc/sys/kernel/timer_migration
-6666666

1. echo 44444444444444444444444444444444444444444444444444444444444 > /proc/sys/kernel/timer_migration
2. cat /proc/sys/kernel/timer_migration
-1357789412

Expected behavior: Should 'echo: write error: Invalid argument' while
setting any value other then 0 & 1

Reported-by: Poornima Nayak <mpnayak@linux.vnet.ibm.com>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 kernel/sysctl.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index ac57832..d0f65e4 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -334,7 +334,10 @@ static struct ctl_table kern_table[] = {
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
-- 
1.6.0.6




