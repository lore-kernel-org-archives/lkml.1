Return-Path: <linux-kernel-owner+w=401wt.eu-S1756096AbYBQJZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756096AbYBQJZy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 04:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbYBQJZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 04:25:38 -0500
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:15054 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752384AbYBQJZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 04:25:34 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Unable to continue testing of 2.6.25
Date: Sun, 17 Feb 2008 10:25:30 +0100
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802171025.30590.elendil@planet.nl>
X-OriginalArrivalTime: 17 Feb 2008 09:25:32.0932 (UTC) FILETIME=[0B7B8440:01C87147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yesterday, after spending quite a few hours over the last days on bisecting 
some serious regressions and finding workarounds for them, I thought I 
could start using 2.6.25-rc2 as the new kernel for my desktop. 
Unfortunately I found that I cannot because it would make my other main 
activity - working on the Debian installation system - impossible.

For my work on the Debian Installer I heavily rely on emulators to run test 
installs and ATM my emulator of choice is VirtualBox (the fully open "ose" 
version). This requires the vboxdrv kernel module, but unfortunately:
   vboxdrv: Unknown symbol change_page_attr

At first I traced this to:
e1271f68
 x86: deprecate change_page_attr() for drivers
 With the introduction of the new API, no driver or non-archcore code needs
 to use c-p-a anymore, so this patch also deprecates the EXPORT_SYMBOL of
 CPA (it's a horrible API after all).
which had:
-EXPORT_SYMBOL(change_page_attr);
+EXPORT_UNUSED_SYMBOL(change_page_attr); /* to be removed in 2.6.27 */

Which seemed entirely reasonable but left me wondering about the error I 
got.

But then I found:
d1028a15
 x86: make various pageattr.c functions static
 change_page_attr_add is only used in pageattr.c now, so we can
 make this function static.
 change_page_attr() isn't used anywere at all anymore; this function
 is a really bad API anyway so just remove the bloat entirely.

Which removed the entire function (without even properly mentioning it in 
the shortlog).


OF COURSE it is up to the VirtualBox developers to adjust to the new 
interface (and based on past experience I expect they will with their next 
version). And it may very well be that they were totally braindead to use 
the function in the first place. I don't know and I really don't care.
The important fact for me is that I can no longer use a piece of software 
that is essential to me and thereby lose the motivation to do any work on 
the kernel.

Lesson of the day: thinking only about in-kernel users of published API when 
doing restructuring is going to lose you testers who do MORE with their 
systems than just kernel development.

Please allow external users some decent period for transitioning. The 
initial plan to "remove the old function in 2.6.27" was entirely sensible. 
It's a pity it was not followed through.

Thanks,
FJP

P.S. Of course I _will_ follow up on issues that I've already reported. I 
will just not be doing any new testing.
