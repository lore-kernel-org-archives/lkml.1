Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbZB1UCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbZB1UCu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 15:02:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752744AbZB1UCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 15:02:41 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:28729 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752514AbZB1UCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 15:02:40 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=D+zaAQPqXKUmnAcfpG7C3rUdfU/dwnBMQGvQc19BYFa54VFJs8kRF/OuKaRnrdB5RSpUPrHHINcPdnNp5JIXW7GDcDAe26+vdmjJtAbzWS7Hx+uTnKs2uyOwVNdSwbAFkKu+VadPl1Ie0kpzNboU71iAfv7YPVMzvSK//u7DPYk=  ;
X-YMail-OSG: b0wYC_4VM1lBRq1ocrmRacfKQZrKN82xu6nWuB_XVHb_HBPkVqJ2yKA5Z36OY9FRuPmq1S9recyChJ9IkotAgPbVmcpp9NAIzaG_Zh0eIAU5M5GNU5O4mwTHQxsX1lSnLImG3bZLH0UpbPaeASuhMKDnth4TXPyd9DIoHQWBIKTchzZFOqNAGoC2dxqEtBSWUiEcy8_.ovRxhoaPNRyvhIOx2_OO
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: lockdep and threaded IRQs (was: ...)
Date: Sat, 28 Feb 2009 12:02:36 -0800
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       felipe.balbi@nokia.com, dmitry.torokhov@gmail.com, sameo@openedhand.com,
       a.p.zijlstra@chello.nl
References: <1235762883-20870-1-git-send-email-me@felipebalbi.com> <200902280416.26687.david-b@pacbell.net> <alpine.LFD.2.00.0902281741560.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902281741560.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902281202.36804.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 February 2009, Thomas Gleixner wrote:
> > > > 
> > > > Where you'll observe twl_init_irq() at line 688 setting
> > > > up the thread and the Primary IRQ Handler (PIH) dispatch.
> > > > That's pretty much bog-standard chained IRQ setup code,
> > > > except that it chains through a thread.
> > > 
> > > So this would be the perfect candidate to test the generic threaded
> > > code I posted a few days ago ?
> > 
> > Could be.  URL?
> 
> http://lkml.org/lkml/2009/2/26/146

Quick report:

 - patch 2/4 didn't apply, mainline uses GFP_ATOMIC in that
   memory allocation not GFP_KERNEL; obvious fix.

 - patch 4/4 also didn't apply, 5/15 hunks failed ... looks
   like IRQ affinity stuff.  free_irq() changes need rework,
   the others look to have obvious fixes.

Got a version that applies to mainline GIT?


At a quick glance it looks like these patches don't cover
set_irq_chained_handler(), which would be trouble since
__setup_irq() doesn't get called in those cases.

They should however handle simpler cases, like I2C devices
that only expose one IRQ instead of needing to demux several
dozen IRQs going to different drivers and subsystems.

And, not touching lockdep, the original ugliness will still
be needed (re-enabling IRQs in threaded handlers).

- Dave
