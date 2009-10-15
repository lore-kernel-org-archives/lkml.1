Return-Path: <linux-kernel-owner+w=401wt.eu-S935237AbZJOSmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935237AbZJOSmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 14:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757871AbZJOSmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 14:42:50 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:34385 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757629AbZJOSmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 14:42:49 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH] hvc_console: returning 0 from put_chars is not an error
Date: Thu, 15 Oct 2009 20:41:26 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc4-self-00094-g80f5069-dirty; KDE/4.3.1; i686; ; )
Cc: Timur Tabi <timur@freescale.com>, linuxppc-dev@ozlabs.org,
       brueckner@linux.vnet.ibm.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1255557226-4403-1-git-send-email-timur@freescale.com> <200910151305.47100.borntraeger@de.ibm.com> <20091015160906.GA3730@loki.buserror.net>
In-Reply-To: <20091015160906.GA3730@loki.buserror.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910152041.26646.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 15 Oktober 2009 18:09:06 schrieb Scott Wood:
> On Thu, Oct 15, 2009 at 01:05:47PM +0200, Christian Borntraeger wrote:
> > The fact that struct console->write returns void indicates that the
> > console layer is not interested in errors. We have two policies we can
> > implement:
> >
> > 1. drop console messages if case of congestion but keep the system going
> > 2. dont drop messages and wait, even if the system might come to a
> > complete stop
> >
> > Looking at drivers/char/vt.c
> >         /* console busy or not yet initialized */
> >         if (!printable)
> >                 return;
> >         if (!spin_trylock(&printing_lock))
> >                 return;
> > could mean that  Linux consoles should not block.
> 
> That's a bit different -- the code above is testing for potential deadlocks
> within Linux (or a not-yet-initialized console), not a device that has yet
> to process the last batch of characters we threw at it.  Plus, given the
> "console must be locked when we get here" comment, I'm not sure that you'll
> ever see contention on printing_lock?
> 
> Serial consoles currently block when waiting for the buffer to drain:

Right. Looking at more drivers it seems that both ways (waiting and dropping) 
are used.

Hmmm, if we are ok with having both options, we should let the hvc backend 
decide if it wants to drain or to discard.

If we just busy loop, it actually does not matter how we let hvc_console react 
on 0, as long as we adopt all backends to use that interface consistent.

On the other hand, backends might want to do special magic on congestion so I 
personally tend to let the backend loop instead of hvc_console. But I am really  
not sure.

Christian
