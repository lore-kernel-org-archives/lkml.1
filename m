Return-Path: <linux-kernel-owner+w=401wt.eu-S1766747AbXEBTi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766747AbXEBTi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766779AbXEBTi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:38:56 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:34520 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766747AbXEBTiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:38:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=UzFYQgEUFZ9j8VqF26sFmVXXoTHnWx45tCxfAerV1ClN1+dhLtz3antKcUdE7IRwGxG9YpljF2MAEaioLezFqwSWT3mhu2nUvBIZc2KTZhY12GFPgGyojR94CWITuYTUNjuf9UQQ3+Ek4e2qi18WijZfugofzFPJRTOKlkajWTQ=
Date: Thu, 3 May 2007 03:33:03 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [RELEASE] Lguest for 2.6.21
Message-ID: <20070502193303.GA1502@localhost.localdomain>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
Mail-Followup-To: Rusty Russell <rusty@rustcorp.com.au>,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
	virtualization <virtualization@lists.linux-foundation.org>
References: <1178117028.19815.14.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178117028.19815.14.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty!

I found you forgot to check the return value of copy_from_user, and here is the fix for drivers/lguest/interrupts_and_traps.c.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

--- linux-2.6.21-rc7-mm2/drivers/lguest/interrupts_and_traps.c.orig	2007-05-03 03:10:44.000000000 +0800
+++ linux-2.6.21-rc7-mm2/drivers/lguest/interrupts_and_traps.c	2007-05-03 03:11:42.000000000 +0800
@@ -75,7 +75,8 @@ void maybe_do_interrupt(struct lguest *l
 		set_bit(0, lg->irqs_pending);
 
 	/* Mask out any interrupts they have blocked. */
-	copy_from_user(&blk, lg->lguest_data->blocked_interrupts, sizeof(blk));
+	if (copy_from_user(&blk, lg->lguest_data->blocked_interrupts, sizeof(blk)))
+		return;
 	bitmap_andnot(blk, lg->irqs_pending, blk, LGUEST_IRQS);
 
 	irq = find_first_bit(blk, LGUEST_IRQS);
