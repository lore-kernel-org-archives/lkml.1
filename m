Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbXJULhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbXJULhz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbXJULhs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:37:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56574 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbXJULhr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:37:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: mysqld prevents s2ram [Re: 2.6.23-mm1]
Date: Sun, 21 Oct 2007 13:53:57 +0200
User-Agent: KMail/1.9.5
Cc: Mattia Dongili <malattia@linux.it>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <20071021055816.GA4204@inferi.kami.home> <20071021095802.GA25669@elf.ucw.cz>
In-Reply-To: <20071021095802.GA25669@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710211353.57770.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 21 October 2007 11:58, Pavel Machek wrote:
> Hi!
> 
> > On Thu, Oct 11, 2007 at 09:31:26PM -0700, Andrew Morton wrote:
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> > 
> > Ok, now that it boots let's go for more.
> > 
> > I cannot suspend if mysqld is running. mysql isn't atually doing
> > anything useful anyway.
> 
> I believe this is known and rafael already has a fix somewhere. The
> "guilty" patch already hit mainline, not sure about the "fix" patch.

The fix has not been merged yet, but
freezer-use-wait-queue-instead-of-busy-looping.patch has been dropped for
another reason.

The mysqld problem seems to have been caused by another patch, though, and the
fix is appended.

Greetings,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>

Do not allow processes to clear their TIF_SIGPENDING if TIF_FREEZE is set,
so that they will not race with the freezer (like mysqld, for example).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/signal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-mm1/kernel/signal.c
===================================================================
--- linux-2.6.23-mm1.orig/kernel/signal.c
+++ linux-2.6.23-mm1/kernel/signal.c
@@ -124,7 +124,7 @@ void recalc_sigpending_and_wake(struct t
 
 void recalc_sigpending(void)
 {
-	if (!recalc_sigpending_tsk(current))
+	if (!recalc_sigpending_tsk(current) && !freezing(current))
 		clear_thread_flag(TIF_SIGPENDING);
 
 }
