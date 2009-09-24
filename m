Return-Path: <linux-kernel-owner+w=401wt.eu-S1752585AbZIXDHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbZIXDHP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 23:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752516AbZIXDHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 23:07:04 -0400
Received: from smtp101.sbc.mail.mud.yahoo.com ([68.142.198.200]:38985 "HELO
	smtp101.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752198AbZIXDHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 23:07:02 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Reply-To:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding;
  b=5MceRLNIgvCF8y7G3keLSmjcARUOkRZI7bq5D/P5Wxf5vQ0sx9rpMGX3D4vsYpV2f8g/kg3VWR2KYxuwlBjmrZWVeKhEh9KS2JAjbRQb+aQfnmzLgXUZDaeQo1QxDtDbcAfb5faqL3+9u1zzByuJFqP0u4GZIULwF720OZmDoQA=  ;
X-Yahoo-SMTP: q38J5tGswBASNRk23p5VHCyHWVYsH2R.h.gucH7RqCYkQRE-
X-YMail-OSG: 4uPPihoVM1kYJbniG.XfwE47L_DzJQ4KULwLcWwotieE1eKDKv_7PBr.yymrWCXm9_sKZarWvy0r6siaPdpsGEjpLiByhMeMK24h5612qfSSbsZlqkZ0tEpeyiW_8DptqCYD6Aei2yJRpY5WNPrPEp0MfilzfVvGaKSs.gUF8rZ9T1gec_w6xUBs8_Kbf1YVuVjsKP7csLQgap6QJljKQe3QneQ4KjCPMH0FHIB3RTbURxZVyX9qz.0at7TPCfqiIa5PwMFiT6BkYLtDzuTFVGls2rwsC22qfem.oro3h1Hk2tb7xOwNZ9LRGlwYUdtMwdQmadSaAmGX0Ergs1.OD2MKvQ--
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 23 Sep 2009 22:06:54 -0500
From: Will <whansard@sbcglobal.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: disk speed regression kernel 2.6.29 and after
Message-Id: <20090923220654.71cd5548.whansard@sbcglobal.net>
In-Reply-To: <9e4733910909230523v47d1fb3fn2575ed5d8e86069c@mail.gmail.com>
References: <4ABA0FDA.9090707@sbcglobal.net>
	<9e4733910909230523v47d1fb3fn2575ed5d8e86069c@mail.gmail.com>
Reply-To: whansard@sbcglobal.net
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.13; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Wed, Sep 23, 2009 at 8:08 AM, will <whansard@sbcglobal.net> wrote:
> > I had been using an old 2.6.22 kernel on my machine, and I often backup one
> > partition of my main hard drive to a partition on a second hard drive. The
> > main hard drive is sata 640 gigs, and the second is a pata 320 gig. copying
> > this partition from one drive to the other with dd takes about 3 minutes and
> > 30 seconds. When I installed kernel 2.6.30, and 2.6.31, the time took 9
> > minutes and 20 seconds. I decided to go to the trouble of compiling all the
> > kernels between, and kernels 2.6.22-2.6.28 all do the operation in about 3
> 

> > the drives
> > with the kernels 2.6.29 and after.
> > Please cc me with any followups or anything. thanks

295f00042aaf6b553b5f37348f89bab463d4a469 is first bad commit
commit 295f00042aaf6b553b5f37348f89bab463d4a469
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Fri Jan 2 16:12:48 2009 +0100

    ide: don't execute the next queued command from the hard-IRQ context (v2)
    
    * Tell the block layer that we are not done handling requests by using
      blk_plug_device() in ide_do_request() (request handling function)
      and ide_timer_expiry() (timeout handler) if the queue is not empty.
    
    * Remove optimization which directly calls ide_do_request() for the next
      queued command from the ide_intr() (IRQ handler) and ide_timer_expiry().
    
    * Remove no longer needed IRQ masking from ide_do_request() - in case of
      IDE ports needing serialization disable_irq_nosync()/enable_irq() was
      used for the (possibly shared) IRQ of the other IDE port.
    
    * Put the misplaced comment in the right place in ide_do_request().
    
    * Drop no longer needed 'int masked_irq' argument from ide_do_request().
    
    * Merge ide_do_request() into do_ide_request().
    
    * Remove no longer needed IDE_NO_IRQ define.
    
    While at it:
    
    * Don't use HWGROUP() macro in do_ide_request().
    
    * Use __func__ in ide_intr().
    
    This patch reduces IRQ hadling latency for IDE and improves the system-wide
    handling of shared IRQs (which should result in more timeout resistant and
    stable IDE systems).  It also makes it possible to do some further changes
    later (i.e. replace some busy-waiting delays with sleeping equivalents).
    
    v2:
    Changes per review from Elias Oltmanns:
    - fix wrong goto statement in 'if (startstop == ide_stopped)' block
    - use spin_unlock_irq()
    - don't use obsolete HWIF() macro
    
    Cc: Elias Oltmanns <eo@nebensachen.de>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

:040000 040000 fff6eb1cea019a90a494005e0916ed2387018c5d 7a6e4e5282416cffc86db5cc50da21672476312d M	drivers
:040000 040000 1e3015fb52fe682ce22fb98f952bb0bcdf1bc3c3 21a9860a6dc3a07f2e1944f1b4aaa16a8720d7ab M	include

