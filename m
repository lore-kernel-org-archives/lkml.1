Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbYHMBTB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbYHMBTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 21:19:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYHMBSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 21:18:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42181 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752289AbYHMBSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 21:18:52 -0400
Date: Tue, 12 Aug 2008 18:16:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: jbaron@redhat.com, randy.dunlap@oracle.com, linux-kernel@vger.kernel.org,
       joe@perches.com, nick@nick-andrew.net, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/7] dynamic debug v2 - infrastructure
Message-Id: <20080812181653.32d6f373.akpm@linux-foundation.org>
In-Reply-To: <20080813010804.GA17446@kroah.com>
References: <20080717070103.GA21961@kroah.com>
	<20080717212040.GB13252@redhat.com>
	<20080717223222.GA28016@kroah.com>
	<20080808215153.GA16729@redhat.com>
	<20080808193851.24210bc4.randy.dunlap@oracle.com>
	<20080811173616.GC6103@redhat.com>
	<20080811223309.GD9810@kroah.com>
	<20080812194817.GD6056@redhat.com>
	<20080812200908.GA444@kroah.com>
	<20080812204619.GE6056@redhat.com>
	<20080813010804.GA17446@kroah.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Aug 2008 18:08:04 -0700
Greg KH <greg@kroah.com> wrote:

> On Tue, Aug 12, 2008 at 04:46:19PM -0400, Jason Baron wrote:
> > On Tue, Aug 12, 2008 at 01:09:08PM -0700, Greg KH wrote:
> > > So close, can I have a good changelog comment with the patch so people
> > > know what it is when they look in the logs?
> > > 
> > > Care to resend it with that?
> > > 
> > 
> > Base infrastructure to enable per-module debug messages.
> 
> Ah, so close...
> 
> With this patch, I get the following build error:
> 
>   CC [M]  drivers/usb/gadget/u_ether.o
> drivers/usb/gadget/u_ether.c: In function ___gether_setup___:
> drivers/usb/gadget/u_ether.c:787: error: ___KBUILD_MODNAME___ undeclared (first use in this function)
> drivers/usb/gadget/u_ether.c:787: error: (Each undeclared identifier is reported only once
> drivers/usb/gadget/u_ether.c:787: error: for each function it appears in.)
> drivers/usb/gadget/u_ether.c:787: error: unknown field ___Usage___ specified in initializer
> drivers/usb/gadget/u_ether.c:787: error: expected expression before ___.___ token
> drivers/usb/gadget/u_ether.c:787: error: initializer element is not constant
> drivers/usb/gadget/u_ether.c:787: error: (near initialization for ___descriptor.hash___)
> drivers/usb/gadget/u_ether.c:787: error: ___Usage___ undeclared (first use in this function)
> drivers/usb/gadget/u_ether.c:787: error: invalid operands to binary << (have ___long long int___ and ___char *___)
> drivers/usb/gadget/u_ether.c:787: error: expected ___)___ before ___:___ token
> drivers/usb/gadget/u_ether.c:787: error: invalid operands to binary & (have ___long long int___ and ___char *___)
> drivers/usb/gadget/u_ether.c:787: error: invalid operands to binary << (have ___long long int___ and ___char *___)
> drivers/usb/gadget/u_ether.c:787: error: expected ___)___ before ___:___ token
> drivers/usb/gadget/u_ether.c:787: error: invalid operands to binary & (have ___long long int___ and ___char *___)
> drivers/usb/gadget/u_ether.c:787: error: expected ___)___ before ___:___ token
> drivers/usb/gadget/u_ether.c:787: warning: passing argument 4 of _____dynamic_dbg_enabled_helper___ makes integer from pointer without a cast
> drivers/usb/gadget/u_ether.c:787: error: expected ___)___ before ___KBUILD_MODNAME___

(lol at gcc crap)

> drivers/usb/gadget/u_ether.c:787: warning: too few arguments for format

argh, not that again.  We had this with a patch from Jesse a while
back, which I fixed thusly:

From: Andrew Morton <akpm@linux-foundation.org>

alpha:

CC [M]  drivers/usb/gadget/u_ether.o
In file included from include/asm/dma-mapping.h:7,
                 from include/linux/dma-mapping.h:52,
                 from include/linux/dmaengine.h:29,
                 from include/linux/skbuff.h:29,
                 from include/linux/if_ether.h:114,
                 from include/linux/etherdevice.h:27,
                 from drivers/usb/gadget/u_ether.c:29:
include/linux/pci.h: In function 'pci_register_driver':
include/linux/pci.h:673: error: 'KBUILD_MODNAME' undeclared (first use in this function)
include/linux/pci.h:673: error: (Each undeclared identifier is reported only once
include/linux/pci.h:673: error: for each function it appears in.)


Sam says:

The problem is that u_ether.o is used by two modules so when we build it
KBUILD_MODNAME is not defined because kbuild does not know what value to
use.

And in pci.h we have the following inline:

static inline int __must_check pci_register_driver(struct pci_driver *driver)
{
        return __pci_register_driver(driver, THIS_MODULE, KBUILD_MODNAME);
}

And alpha uses dma-mapping.h to nullify a number of functions that seem to
require something from pci.h.

Making it a macro seems to fix this.

Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pci.h |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN include/linux/pci.h~pci-make-pci_register_driver-a-macro include/linux/pci.h
--- a/include/linux/pci.h~pci-make-pci_register_driver-a-macro
+++ a/include/linux/pci.h
@@ -680,10 +680,12 @@ void pci_enable_bridges(struct pci_bus *
 /* Proper probing supporting hot-pluggable devices */
 int __must_check __pci_register_driver(struct pci_driver *, struct module *,
 				       const char *mod_name);
-static inline int __must_check pci_register_driver(struct pci_driver *driver)
-{
-	return __pci_register_driver(driver, THIS_MODULE, KBUILD_MODNAME);
-}
+
+/*
+ * pci_register_driver must be a macro so that KBUILD_MODNAME can be expanded
+ */
+#define pci_register_driver(driver)		\
+	__pci_register_driver(driver, THIS_MODULE, KBUILD_MODNAME)
 
 void pci_unregister_driver(struct pci_driver *dev);
 void pci_remove_behind_bridge(struct pci_dev *dev);
_

