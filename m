Return-Path: <linux-kernel-owner+w=401wt.eu-S1753074AbYIPViw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbYIPViw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 17:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYIPVio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 17:38:44 -0400
Received: from mx1.wp.pl ([212.77.101.5]:49866 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbYIPVio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 17:38:44 -0400
Date: Tue, 16 Sep 2008 23:39:16 +0200
From: Krzysztof Helt <krzysztof.h1@wp.pl>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rpurdie@rpsys.net, adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [fbdev] Lockdep error
Message-Id: <20080916233916.4f9c0dfd.krzysztof.h1@wp.pl>
In-Reply-To: <20080915122152.GA4570@doriath.ww600.siemens.net>
References: <20080915122152.GA4570@doriath.ww600.siemens.net>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-AV: skaner antywirusowy poczty Wirtualnej Polski S. A.
X-WP-SPAM: NO 0000000 [QePE]                               
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Sep 2008 16:21:52 +0400
Dmitry Baryshkov <dbaryshkov@gmail.com> wrote:

> Hi,
> 
> After doing
> # echo 1 > /sys/class/graphics/fb0/blank
> I got the following in my kernel log:
> 
> =============================================
> [ INFO: possible recursive locking detected ]
> 2.6.27-rc6-00086-gda63874-dirty #97
> ---------------------------------------------
> echo/1564 is trying to acquire lock:
>  ((fb_notifier_list).rwsem){..--}, at: [<c005a384>] __blocking_notifier_call_chain+0x38/0x6c
> 

Does the patch below fix the problem for you?

Kind regards,
Krzysztof

diff -urp linux-ref/drivers/video/console/fbcon.c linux-mm/drivers/video/console/fbcon.c
--- linux-ref/drivers/video/console/fbcon.c	2008-09-05 23:38:47.000000000 +0200
+++ linux-mm/drivers/video/console/fbcon.c	2008-09-16 23:30:52.309604454 +0200
@@ -2400,11 +2400,15 @@ static int fbcon_blank(struct vc_data *v
 
  	if (!fbcon_is_inactive(vc, info)) {
 		if (ops->blank_state != blank) {
+			int ret = 1;
+
 			ops->blank_state = blank;
 			fbcon_cursor(vc, blank ? CM_ERASE : CM_DRAW);
 			ops->cursor_flash = (!blank);
 
-			if (fb_blank(info, blank))
+			if (info->fbops->fb_blank)
+				ret = info->fbops->fb_blank(blank, info);
+			if (ret)
 				fbcon_generic_blank(vc, info, blank);
 		}
 
