Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbZGUSdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbZGUSdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 14:33:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbZGUSdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 14:33:39 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:27729 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbZGUSdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 14:33:39 -0400
X-IronPort-AV: E=Sophos;i="4.43,242,1246852800"; 
   d="scan'208";a="4122344"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] - printk handling more than one CON_BOOT
Date: Tue, 21 Jul 2009 14:37:03 -0400
User-Agent: KMail/1.9.5
CC: "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       Sonic.Zhang@analog.com
References: <200906290703.21539.rgetz@blackfin.uclinux.org> <200907012108.38030.rgetz@blackfin.uclinux.org>
In-Reply-To: <200907012108.38030.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200907211437.04056.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 21 Jul 2009 18:33:34.0146 (UTC) FILETIME=[C1049A20:01CA0A31]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 1 Jul 2009 21:08, Robin Getz pondered:
>  printk.c |  146 +++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 92 insertions(+), 54 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index b4d97b5..9acc262 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c

[snip]

>  static int __init disable_boot_consoles(void)
>  {
> -	if (console_drivers != NULL) {
> -		if (console_drivers->flags & CON_BOOT) {
> +	struct console *con;
> +
> +	for_each_console(con) {
> +		if (con->flags & CON_BOOT) {
>  			printk(KERN_INFO "turn off boot console %s%d\n",
> -				console_drivers->name, console_drivers->index);
> -			return unregister_console(console_drivers);
> +				con->name, con->index);
> +			return unregister_console(con);
>  		}
>  	}
>  	return 0;

This causes a bug that Sonic found.

The below patch fixes it, and should be applied to tip.

---

From: Sonic Zhang <Sonic.Zhang@analog.com>

Don't return when we find the first bootconsole - it can leave other
bootconsoles still installed, and they can be used and cause problems later
(if they are in the init section, and eventually released), and cause
problems. Make sure we remove all of them.

Signed-off-by: Sonic Zhang <Sonic.Zhang@analog.com>
Signed-off-by: Robin Getz <rgetz@analog.com>

---

diff --git a/kernel/printk.c b/kernel/printk.c
index e0daaf5..e10d193 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1352,7 +1352,7 @@ static int __init disable_boot_consoles(void)
 		if (con->flags & CON_BOOT) {
 			printk(KERN_INFO "turn off boot console %s%d\n",
 				con->name, con->index);
-			return unregister_console(con);
+			unregister_console(con);
 		}
 	}
 	return 0;

