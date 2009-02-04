Return-Path: <linux-kernel-owner+w=401wt.eu-S1760737AbZBDW1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760737AbZBDW1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 17:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZBDW0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 17:26:50 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:20418 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932AbZBDW0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 17:26:49 -0500
X-IronPort-AV: E=Sophos;i="4.37,381,1231113600"; 
   d="scan'208";a="133073728"
From: Roland Dreier <rdreier@cisco.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Floris Kraak <randakar@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>
Subject: Re: [PATCH] Kbuild: Disable the -Wformat-security gcc flag
References: <56e1b5710902040628w5ceb36f5kdb1f433087355f80@mail.gmail.com>
	<20090204221451.GA27254@uranus.ravnborg.org>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 04 Feb 2009 14:26:45 -0800
In-Reply-To: <20090204221451.GA27254@uranus.ravnborg.org> (Sam Ravnborg's
	message of "Wed, 4 Feb 2009 23:14:51 +0100")
Message-ID: <adavdrplty2.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 04 Feb 2009 22:26:46.0685 (UTC) FILETIME=[AA3C5CD0:01C98717]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Before judging on this patch could you please post what warning it
 > triggers and one or a few patches to fix some of them.

The warnings are things like:

    init/main.c: In function 'start_kernel':
    init/main.c:557: warning: format not a string literal and no format arguments

where the patch to fix this would be:

diff --git a/init/main.c b/init/main.c
index 8442094..78fc0d8 100644
--- a/init/main.c
+++ b/init/main.c
@@ -554,7 +554,7 @@ asmlinkage void __init start_kernel(void)
 	boot_cpu_init();
 	page_address_init();
 	printk(KERN_NOTICE);
-	printk(linux_banner);
+	printk("%s", linux_banner);
 	setup_arch(&command_line);
 	mm_init_owner(&init_mm, &init_task);
 	setup_command_line(command_line);

with the impact:

add/remove: 0/0 grow/shrink: 1/0 up/down: 7/0 (7)
function                                     old     new   delta
start_kernel                                 689     696      +7


There are also many warnings like:

    drivers/char/mem.c: In function 'chr_dev_init':
    drivers/char/mem.c:994: warning: format not a string literal and no format arguments

which require a similar fix but show that we can't just restrict things
to some trick with printk():

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 3586b3b..ba3bf43 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -991,7 +991,7 @@ static int __init chr_dev_init(void)
 	for (i = 0; i < ARRAY_SIZE(devlist); i++)
 		device_create(mem_class, NULL,
 			      MKDEV(MEM_MAJOR, devlist[i].minor), NULL,
-			      devlist[i].name);
+			      "%s", devlist[i].name);
 
 	return 0;
 }
