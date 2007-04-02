Return-Path: <linux-kernel-owner+w=401wt.eu-S1751218AbXDBHeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218AbXDBHeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbXDBHeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:34:16 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:44290 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbXDBHeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:34:15 -0400
Date: Mon, 2 Apr 2007 09:31:37 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Antonino A. Daplas" <adaplas@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>,
       Daniel Jacobowitz <dan@debian.org>
Subject: [PATCH 17/16] Do not reset UTF8 on terminal reset
In-Reply-To: <1175496595.4614.11.camel@daplas>
Message-ID: <Pine.LNX.4.61.0704020904460.1245@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr> 
 <Pine.LNX.4.61.0704012001130.12316@yvahk01.tjqt.qr> <1175496595.4614.11.camel@daplas>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 2 2007 14:49, Antonino A. Daplas wrote:
>On Sun, 2007-04-01 at 20:13 +0200, Jan Engelhardt wrote:
>
>> Allow for the palette to be exposed and changed via sysfs. A call to
>> /usr/bin/reset will slurp the new definitions in for the current
>> console.
>
>I like this. The escape sequences to change the palette does not stay
>permanently.

As much as you like it, there is a slight problem with it. Linux will
currently throw virtual consoles out of UTF8 mode when reset is called.

Also see:
	http://lkml.org/lkml/2005/5/17/289
	http://lkml.org/lkml/2005/5/17/297

These posts argue about terminfo being the culprit. But how can terminfo 
be at fault, when `echo -en "\ec"` triggers it too?

Since I am in a patch mood, here's my stance/patch, which is compile and 
run tested and behaves as expected (both with `echo` and `reset`).

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Andrew Morton <akpm@osdl.org>
Cc: Daniel Jacobowitz <dan@debian.org>
Cc: Paul LeoNerd Evans <leonerd@leonerd.org.uk>
Obsoletes: https://bugzilla.novell.com/show_bug.cgi?id=225853

Index: linux-2.6.21-rc5/drivers/char/vt.c
===================================================================
--- linux-2.6.21-rc5.orig/drivers/char/vt.c
+++ linux-2.6.21-rc5/drivers/char/vt.c
@@ -1518,7 +1518,6 @@ static void reset_terminal(struct vc_dat
 	vc->vc_charset		= 0;
 	vc->vc_need_wrap	= 0;
 	vc->vc_report_mouse	= 0;
-	vc->vc_utf		= 0;
 	vc->vc_utf_count	= 0;
 
 	vc->vc_disp_ctrl	= 0;
#<EOF>
