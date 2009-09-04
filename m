Return-Path: <linux-kernel-owner+w=401wt.eu-S933812AbZIDRzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933812AbZIDRzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 13:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757163AbZIDRzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 13:55:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757152AbZIDRzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 13:55:53 -0400
Date: Fri, 4 Sep 2009 07:55:30 -1000 (HST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mikael Pettersson <mikpe@it.uu.se>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's
 testsuite
In-Reply-To: <alpine.LFD.2.00.0909040739060.17375@eeepc.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0909040753370.17375@eeepc.linux-foundation.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <19099.52899.620345.326521@pilspetsen.it.uu.se> <19100.31254.666066.755541@pilspetsen.it.uu.se> <200909012042.59856.rjw@sisk.pl> <alpine.LFD.2.00.0909021429360.3590@eeepc.linux-foundation.org>
 <19105.5352.28380.230615@pilspetsen.it.uu.se> <alpine.LFD.2.00.0909040729490.5232@eeepc.linux-foundation.org> <alpine.LFD.2.00.0909040739060.17375@eeepc.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 4 Sep 2009, Linus Torvalds wrote:
> 
> How about something like this? It's way too anal - it says that we can 
> only write data if there's enough space to always push it all the way to 
> the receive buffer (including all the data that was already buffered up, 
> ie the "memory_used" part). But if it finally makes the problem go away, 
> we have another clue.

I forgot to actually include the patch. Duh.

And again - UNTESTED. Maybe this makes the buffering _too_ small (the 
'memory_used' thing is not really counted in bytes buffered, it's counted 
in how much buffer space we've allocated) and things break even worse and 
pty's don't work at all. But I think it might work.

		Linus

---
 drivers/char/pty.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index d083c73..139fa5a 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -91,7 +91,7 @@ static void pty_unthrottle(struct tty_struct *tty)
 
 static int pty_space(struct tty_struct *to)
 {
-	int n = 8192 - to->buf.memory_used;
+	int n = to->receive_room - to->buf.memory_used;
 	if (n < 0)
 		return 0;
 	return n;
