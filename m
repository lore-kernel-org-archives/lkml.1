Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbYEOSjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbYEOSjG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbYEOSiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:38:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350AbYEOSix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:38:53 -0400
Date: Thu, 15 May 2008 11:38:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       stable@kernel.org
Subject: Re: Linux 2.6.25.4
Message-Id: <20080515113815.1a728226.akpm@linux-foundation.org>
In-Reply-To: <20080515172518.GA23810@suse.de>
References: <20080515150721.GA8420@kroah.com>
	<Pine.LNX.4.64.0805150942070.7254@shark.he.net>
	<20080515172518.GA23810@suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 10:25:18 -0700 Greg KH <gregkh@suse.de> wrote:

> On Thu, May 15, 2008 at 09:43:04AM -0700, Randy.Dunlap wrote:
> > On Thu, 15 May 2008, Greg Kroah-Hartman wrote:
> > 
> > > We (the -stable team) are announcing the release of the 2.6.25.4 kernel.
> > > 
> > > It contains a bunch of bug fixes, and one security update, so all users
> > > of the 2.6.25 series are encouraged to upgrade.
> > 
> > Build errors on i386 and x86_64 allyesconfig:
> > 
> > drivers/usb/host/ohci-sm501.c:242: error: 'hcd' undeclared (first use in this function)
> > drivers/usb/host/ohci-sm501.c:242: error: (Each undeclared identifier is reported only once
> > drivers/usb/host/ohci-sm501.c:242: error: for each function it appears in.)
> > make[3]: *** [drivers/usb/host/ohci-hcd.o] Error 1
> 
> Alan, this is due to your OHCI patch :(
> 
> Care to send me a fix for this?
> 

umm, I was just berated for repeatedly sending the below "unneeded"
patch to you:

From: Reynes Philippe <tremyfr@yahoo.fr>

The function ohci_sm501_resume in drivers/usb/host/ohci-hcd.c use the variable
hcd, but this variable is undeclared in this function, so the compilation
fails with this error :

  CC      drivers/usb/host/ohci-hcd.o
In file included from drivers/usb/host/ohci-hcd.c:1056:
drivers/usb/host/ohci-sm501.c: In function `ohci_sm501_resume':
drivers/usb/host/ohci-sm501.c:241: erreur: `hcd' undeclared (first use in this function)
drivers/usb/host/ohci-sm501.c:241: erreur: (Each undeclared identifier is reported only once
drivers/usb/host/ohci-sm501.c:241: erreur: for each function it appears in.)

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/host/ohci-sm501.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/usb/host/ohci-sm501.c~fix-gregkh-usb-usb-ohci-host-controller-resumes-leave-root-hub-suspended drivers/usb/host/ohci-sm501.c
--- a/drivers/usb/host/ohci-sm501.c~fix-gregkh-usb-usb-ohci-host-controller-resumes-leave-root-hub-suspended
+++ a/drivers/usb/host/ohci-sm501.c
@@ -238,7 +238,7 @@ static int ohci_sm501_resume(struct plat
 	ohci->next_statechange = jiffies;
 
 	sm501_unit_power(dev->parent, SM501_GATE_USB_HOST, 1);
-	ohci_finish_controller_resume(hcd);
+	ohci_finish_controller_resume(ohci_to_hcd(ohci));
 	return 0;
 }
 #else
_

