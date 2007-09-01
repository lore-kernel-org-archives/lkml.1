Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbXIAVJ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbXIAVJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 17:09:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbXIAVJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 17:09:47 -0400
Received: from gw.goop.org ([64.81.55.164]:42442 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757788AbXIAVJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 17:09:46 -0400
Message-ID: <46D9D517.6010201@goop.org>
Date: Sat, 01 Sep 2007 14:09:43 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       stable@kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [PATCH] Fix preemptible lazy mode bug
References: <46CE70C8.2030005@vmware.com> <46CE8069.9070404@goop.org> <46CE81DC.90103@vmware.com>
In-Reply-To: <46CE81DC.90103@vmware.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
> Do you agree it is better to be safe than sorry in this case?  The
> kind of bugs introduced by getting this wrong are really hard to find,
> and I would rather err on the side of an extra increment and decrement
> of preempt_count that causing a regression.

I think this patch is the direction we should go.  I this this would
work equally well for the other pv implementations; it would probably go
into the common lazy mode logic when we get around to doing it.

    J

diff -r b3fcc228c531 arch/i386/xen/enlighten.c
--- a/arch/i386/xen/enlighten.c	Mon Aug 20 14:20:15 2007 -0700
+++ b/arch/i386/xen/enlighten.c	Mon Aug 27 13:40:24 2007 -0700
@@ -250,6 +250,9 @@ static void xen_halt(void)
 
 static void xen_set_lazy_mode(enum paravirt_lazy_mode mode)
 {
+	if (preemptible() && mode == PARAVIRT_LAZY_FLUSH)
+		return;		/* nothing to flush with preempt on */
+
 	BUG_ON(preemptible());
 
 	switch (mode) {


