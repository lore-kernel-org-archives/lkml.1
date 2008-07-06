Return-Path: <linux-kernel-owner+w=401wt.eu-S1756227AbYGFAFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbYGFAFM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 20:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYGFAE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 20:04:59 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:45815 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752936AbYGFAE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 20:04:58 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=mPAvQnQ4/G56JzzwPrWsrgWCO6w6osOPqNWJ0z8Tz2Zlmn8fCZaoFrspAVViXE35U2C/GTrUoxZbPQ4V3x4NwDYkuyKdDY2twx0lZtjbPlOFVwvn35Fo+c50azqejvFPS9Ger21KG0N+vURVMFhor/Oo3h1vaC5oVpOMdRn4v4g=  ;
X-YMail-OSG: i5sbFZsVM1lyw3DgvbuHrsbQ9qQkQ6o3Az0qyHFDqo4iStgcp5nC60YrmQ9.A2OBg02mVa5mdL.zONLGfEImu.QtbwsObtIOGLcFR4X5FAPyvPxm1OFXuaBIoDt64LhRVAY-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: All 2.6.26-rcX hang immediately after loading ohci_hcd
Date: Sat, 5 Jul 2008 17:04:55 -0700
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <200807051108.20183.arvidjaar@mail.ru> <alpine.LFD.1.10.0807051317450.2815@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807051317450.2815@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807051704.56141.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 July 2008, Linus Torvalds wrote:
> Alan - if it _is_ an interrupt flood, it looks like it basically starts 
> just as ohci_hub_status_data() does that spin_unlock_irqrestore() to 
> re-enable interrupts. And there has been some changes to 
> ohci_root_hub_state_changes() recently, and that OHCI_INTR_RHSC enable 
> logic in particular.
> 
> That root hub status interrupt changing thing is commit e872154921a6b5 
> ("USB: don't explicitly reenable root-hub status interrupts"), and it 
> _did_ happen after 2.6.25.

I seem to recall some oddness with RHSC on some platforms,
way back when I had lots of OHCI hardware and did comparative.
testing.  RHSC and RD did not act quite like the docs said ...

Simple experiments:  add "distrust_firmware=y" to the ohci
module options.  Or:  try a kernel without CONFIG_PM enabled.


More complex experiments:  try building with CONFIG_USB_DEBUG and
after editing drivers/usb/host/ohci-hcd.c to #define OHCI_VERBOSE_DEBUG
(just change the #undef to a #define) ... then restart things
(passing debug=8 on the kernel command line may help) and see what
it says on the system console.

If this is really an IRQ storm that may turn up more data.
Alternatively, it might not show info until you tweak ohci_irq()
(in that same file) to dump "ints" after it checks whether the
IRQ was "for some other device".  And if even that doesn't show
a storm of messages ... then the problem may not be directly
caused by OHCI.  Lots of stuff seems to be sharing that same
IRQ, after all...

- Dave
