Return-Path: <linux-kernel-owner+w=401wt.eu-S934001AbYBBTuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934001AbYBBTuP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 14:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760083AbYBBTuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 14:50:00 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:56898 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbYBBTt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 14:49:59 -0500
Date: Sat, 2 Feb 2008 20:50:03 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Zachar <mgzachar@mail.t-com.sk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: make menuconfig broken
Message-ID: <20080202195003.GA26033@uranus.ravnborg.org>
References: <200802021830.00335.mgzachar@mail.t-com.sk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802021830.00335.mgzachar@mail.t-com.sk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal.

Thanks for your report.

On Sat, Feb 02, 2008 at 06:29:59PM +0100, Michal Zachar wrote:
> I dont know if it was not reported yet or not fixed yet.
> 
> It apeared about in version 2.6.20.xx or there about so it is broken already 
> awhile.
> 
> Problem:
> 
> changing settings manualy seem to work. Where problem apears is that loading 
> alternate config file changes settings but on exit '.config' file is not 
> writen and one is advised to run make which bombs.
> 
> Also window:	Do you wish to save your new kernel configuration ?
> 				<ESC><ESC> to continue
> 					<YES>	<NO>
> 
> does not apear.
This is a bug - we should notice the config changed.

> 
> Solution for me is before exit to change content of window (Save an Alternate 
> Configuration File) to .config. And only then file .config is writen.
> 
> It seems that contents of bouth Load and save Alt Conf File are set to same 
> using Load. It may actualy write to alternate file instead to .config

And this is a feature not a bug.
I am well aware that this is a change in behaviour but
if you looks at top left corner you can see the current filename
and is thus told what menuconfig use as default filename.

	Sam

I fixed the bug like this:

>From 7c280820a7a66abbb6b3b3f82c3753c7564600f2 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 2 Feb 2008 20:44:09 +0100
Subject: [PATCH] kconfig: mark config as changed when loading an alternate config

Michal Zachar <mgzachar@mail.t-com.sk> reported that
menuconfig did not save the new config when loading
an alternate config unless he altered it manually.

Mark config as changed upon load of alternate config fixed this.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/mconf.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 50e61c4..734cf4f 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -821,6 +821,7 @@ static void conf_load(void)
 				return;
 			if (!conf_read(dialog_input_result)) {
 				set_config_filename(dialog_input_result);
+				sym_set_change_count(1);
 				return;
 			}
 			show_textbox(NULL, _("File does not exist!"), 5, 38);
-- 
1.5.4.rc3.14.g44397

