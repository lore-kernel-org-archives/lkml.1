Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbYKVCbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbYKVCbX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 21:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbYKVCbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 21:31:15 -0500
Received: from ozlabs.org ([203.10.76.45]:54391 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075AbYKVCbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 21:31:15 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Greg KH <gregkh@suse.de>
Subject: Re: linux-next: rr tree build failure
Date: Sat, 22 Nov 2008 13:01:06 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       Pete Zaitcev <zaitcev@redhat.com>
References: <20081121141913.90d05091.sfr@canb.auug.org.au> <200811212128.52317.rusty@rustcorp.com.au> <20081121183403.GC16353@suse.de>
In-Reply-To: <20081121183403.GC16353@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811221301.07058.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 November 2008 05:04:03 Greg KH wrote:
> On Fri, Nov 21, 2008 at 09:28:51PM +1030, Rusty Russell wrote:
> > Greg, here's the complete patch I have now:
> >
> > Subject: USB: Use core_param.
> >
> > Found this when I changed args to __module_param_call.  We now have
> > core_param for exactly this.
> >
> > This reverts to the 2005 (pre- aafbf24a) behaviour where "nousb" was
> > not a module parameter, just a kernel command line parameter.  That's
> > more sensible anyway.
>
...
> No, we need to keep that module parameter please, some distros and users
> rely on it.

Fair enough.  Patch below does this as moduleparam.h suggests.

It still means that the paremeter appears in 
/sys/module/kernel/parameters/nousb OR
/sys/module/usbcore/parameters/nousb.

FYI, if Pete had discovered this __setup issue today, the correct fix would
be:
1) core_param(nousb) for backwards compat.
2) module_param(disable) for modern users who want module/in-built symmetry
   (ie. boot cmdline "usbcore.disable", and "modprobe usbcore disable")


USB: Don't use __module_param_call

Found this when I changed args to __module_param_call.  We now have
core_param for exactly this, but Greg assures me "nousb" is used as a
module parameter, using the method suggested in moduleparam.h will
have to do.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Pete Zaitcev <zaitcev@redhat.com>
---
 drivers/usb/core/usb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/usb.c b/drivers/usb/core/usb.c
--- a/drivers/usb/core/usb.c
+++ b/drivers/usb/core/usb.c
@@ -962,9 +962,6 @@ void usb_buffer_unmap_sg(const struct us
 }
 EXPORT_SYMBOL_GPL(usb_buffer_unmap_sg);
 
-/* format to disable USB on kernel command line is: nousb */
-__module_param_call("", nousb, param_set_bool, param_get_bool, &nousb, 0444);
-
 /*
  * for external read access to <nousb>
  */
@@ -1052,6 +1049,11 @@ static void __exit usb_exit(void)
 	ksuspend_usb_cleanup();
 }
 
+/* To disable USB, kernel command line is 'nousb' not 'usbcore.nousb' */
+#undef MODULE_PARAM_PREFIX
+#define MODULE_PARAM_PREFIX
+module_param(nousb, bool, 0444);
+
 subsys_initcall(usb_init);
 module_exit(usb_exit);
 MODULE_LICENSE("GPL");

