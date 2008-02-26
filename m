Return-Path: <linux-kernel-owner+w=401wt.eu-S932535AbYBZWGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932535AbYBZWGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764598AbYBZWFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:05:38 -0500
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:52777 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764154AbYBZWFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:05:36 -0500
X-Greylist: delayed 36159 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Feb 2008 17:05:36 EST
Date: Tue, 26 Feb 2008 23:05:32 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: problem with starting 2.6.25-rc1 and latest git
Message-ID: <20080226230532.76f63db3@hyperion.delvare>
In-Reply-To: <200802261704.46848.m.kozlowski@tuxland.pl>
References: <200802132316.03155.m.kozlowski@tuxland.pl>
	<20080218142832.3a092dd5@hyperion.delvare>
	<20080226130254.5668d330@hyperion.delvare>
	<200802261704.46848.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mariusz,

On Tue, 26 Feb 2008 17:04:46 +0100, Mariusz Kozlowski wrote:
> I can reproduce this here on rc3 as well. Weird - on git tree before
> rc3 was released this didn't happen. rc2 and rc1 are broken. I also
> don't know why nobody else see this but us :) And not sure how
> to debug it some more or provide more accurate information.

Here's a quick and dirty debugging patch I wrote in an attempt to find
out what was going on. Unfortunately, the problem never happened to me
when this debug patch was applied. Maybe you'll have more "luck"?

 kernel/module.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-2.6.25-rc1.orig/kernel/module.c	2008-02-14 09:16:15.000000000 +0100
+++ linux-2.6.25-rc1/kernel/module.c	2008-02-14 23:20:22.000000000 +0100
@@ -2153,8 +2153,10 @@ sys_init_module(void __user *umod,
 		return PTR_ERR(mod);
 	}
 
+	printk(KERN_WARNING "loading module %s, checkpoint 1\n", mod->name);
 	/* Drop lock so they can recurse */
 	mutex_unlock(&module_mutex);
+	printk(KERN_WARNING "loading module %s, checkpoint 2\n", mod->name);
 
 	blocking_notifier_call_chain(&module_notify_list,
 			MODULE_STATE_COMING, mod);
@@ -2177,6 +2179,7 @@ sys_init_module(void __user *umod,
 
 	/* Now it's a first class citizen! */
 	mutex_lock(&module_mutex);
+	printk(KERN_WARNING "loading module %s, checkpoint 3\n", mod->name);
 	mod->state = MODULE_STATE_LIVE;
 	/* Drop initial reference. */
 	module_put(mod);
@@ -2186,6 +2189,7 @@ sys_init_module(void __user *umod,
 	mod->init_size = 0;
 	mod->init_text_size = 0;
 	mutex_unlock(&module_mutex);
+	printk(KERN_WARNING "loading module %s, checkpoint 4\n", mod->name);
 	wake_up(&module_wq);
 
 	return 0;


-- 
Jean Delvare
