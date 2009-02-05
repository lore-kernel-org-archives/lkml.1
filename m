Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbZBEWOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbZBEWOa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 17:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbZBEWNf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 17:13:35 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:54361 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749AbZBEWNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 17:13:34 -0500
X-IronPort-AV: E=Sophos;i="4.37,387,1231113600"; 
   d="scan'208";a="138514229"
From: Roland Dreier <rdreier@cisco.com>
To: Floris Kraak <randakar@gmail.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trivial Patch Monkey <trivial@kernel.org>,
       Andreas Schwab <schwab@suse.de>
Subject: Re: [PATCH]: Cleanup: Remove gcc format string warnings when compiling  with -Wformat-security
References: <56e1b5710902050641l5ece10e5hedd11fb3f4292886@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 05 Feb 2009 14:13:32 -0800
In-Reply-To: <56e1b5710902050641l5ece10e5hedd11fb3f4292886@mail.gmail.com>
	(Floris Kraak's message of "Thu, 5 Feb 2009 15:41:55 +0100")
Message-ID: <adak584jzw3.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 05 Feb 2009 22:13:32.0748 (UTC) FILETIME=[FB6CF0C0:01C987DE]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Here's the patch that I get when I blindly patch every single location
 > that emits this warning.

I would strongly prefer to do this with a little more care.  For example
the b43/main.c change:

 > --- a/drivers/net/wireless/b43/main.c
 > +++ b/drivers/net/wireless/b43/main.c
 > @@ -2005,9 +2005,9 @@ static void b43_print_fw_helptext(struct b43_wl
 > *wl, bool error)
 >  	       "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
 >  	       "and download the latest firmware (version 4).\n";
 >  	if (error)
 > -		b43err(wl, text);
 > +		b43err(wl, "%s", text);
 >  	else
 > -		b43warn(wl, text);
 > +		b43warn(wl, "%s", text);
 >  }
would probably be better solved by doing

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -1999,11 +1999,11 @@ static void b43_release_firmware(struct b43_wldev *dev)
 
 static void b43_print_fw_helptext(struct b43_wl *wl, bool error)
 {
-	const char *text;
+	static const char text[] =
+		"You must go to "
+		"http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
+		"and download the latest firmware (version 4).\n";
 
-	text = "You must go to "
-	       "http://linuxwireless.org/en/users/Drivers/b43#devicefirmware "
-	       "and download the latest firmware (version 4).\n";
 	if (error)
 		b43err(wl, text);
 	else

and in any case I'm not totally convinced that we want to add the bloat
for trivial cases like

	char *safe = "foo";
	printk(safe);

Would be nice to think of a cleverer way to handle that...

 - R.
