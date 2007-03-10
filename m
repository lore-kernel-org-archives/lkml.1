Return-Path: <linux-kernel-owner+w=401wt.eu-S1767853AbXCJQJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767853AbXCJQJm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 11:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767856AbXCJQJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 11:09:41 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:12814 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767853AbXCJQJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 11:09:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=omSqVyX7KtjSZya2B2FePXAgsI+3PyLss+urzZpDH+8qFQwy5rwW5SR5G9eYloGRSXKRtl/2rK9zqRoANle04WlW2ih12UUJQlI5b5+ybhUzMaobH9qkMc5EdoPzDy1aQlN6Pab+v1EOk5fWNIwZ44owYXj03riJOepnrS17rDk=
Date: Sat, 10 Mar 2007 19:06:14 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vladimir <snigga@mail.ru>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: PROBLEM: "Make nenuconfig" does not save parameters.
Message-ID: <20070310160614.GB10230@cvg>
References: <20070310160542.21cdb968@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20070310160542.21cdb968@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

[Vladimir - Sat, Mar 10, 2007 at 04:05:42PM +0300]
| Here's the problem:
|   1. Unpack the kernel sources, run make menuconfig.
|   2. Mark the necessary options.
|   3. Pick "Save an alternate configuration file", enter a filename (e.g. /root/kernelcfg)
|   4. Pick "Exit".
| ->5. Configurator exits without saving. If type "make bzImage", it builtd all the default options.
| 
| And there's no ".config" file in kernel root directory, so i have to move there my "kernelcfg" and
| rename it.
| 
| If i just run "make menuconfig", then pick "Exit", then it asks "Save kernel configuration?".
| 
| This happens starting from kernel 2.6.20 till 2.6.20.2
| Slackware-current.
| PC: Athlon-XP 2000+, 256 MB RAM.
| Linux wolf 2.6.20.2 #1 SMP PREEMPT Sat Mar 10 15:41:42 MSK 2007 i686 athlon-4 i386 GNU/Linux
| -- 
| Faith manages.
| -
| 

Hi, Vladimir

here is the patch to resolve your problem. Test it and write me the
results...

		Cyrill


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="patch.diff"

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 664fe29..98836b6 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -432,8 +432,7 @@ int conf_write(const char *name)
 		     use_timestamp ? "# " : "",
 		     use_timestamp ? ctime(&now) : "");
 
-	if (!conf_get_changed())
-		sym_clear_all_valid();
+	sym_clear_all_valid();
 
 	menu = rootmenu.list;
 	while (menu) {
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 3f9a132..ea32df8 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -840,8 +840,11 @@ static void conf_save(void)
 		case 0:
 			if (!dialog_input_result[0])
 				return;
-			if (!conf_write(dialog_input_result))
+			res = conf_get_changed(); /* temporary used */
+			if (!conf_write(dialog_input_result)) {
+				sym_set_change_count(res);
 				return;
+			}
 			show_textbox(NULL, _("Can't create file!  Probably a nonexistent directory."), 5, 60);
 			break;
 		case 1:

--3V7upXqbjpZ4EhLz--
