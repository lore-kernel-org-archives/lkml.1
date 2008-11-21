Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbYKUBwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbYKUBwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 20:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYKUBwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 20:52:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:19985 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYKUBwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 20:52:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S8jN4an+n51hHOLpErT9cC8e3pEyEy6XPmYxQaJrfQyNbSnVtznlyUSYFyFR8nBnXD
         jyhY9xAJZktOirO/PeqELb+cFAYBWapr7kPCDFhX5Cevj5aba6S1ma2G6xF0NKJ/8VCj
         nwahK+qpFy7ZLpJ3RZVSC0KOdz3nnzsJE3K6M=
Date: Fri, 21 Nov 2008 04:55:59 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: [PATCH] Fixup MODULE_DEVICE_TABLE(dmi, ...)
Message-ID: <20081121015559.GA4478@x200.localdomain>
References: <20081114234131.GA28559@x200.localdomain> <1226747692.3687.285.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226747692.3687.285.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2008 at 11:14:52AM +0000, David Woodhouse wrote:
> On Sat, 2008-11-15 at 02:41 +0300, Alexey Dobriyan wrote:
> > How can this work, given that MODULE_DEVICE_TABLE line expands into
> > 
> >         extern const struct dmi_device_id __mod_dmi_device_table
> > __attribute__ ((unused, alias("mbp_device_table")));
> >                                 ^^^^^^
> > but there is no struct dmi_device_id, there is struct dmi_system_id?
> 
> Interesting question ;)
> 
> It actually looks like this...
> 
> static struct dmi_system_id __initdata mbp_device_table[] = {
> 	...
> };
> 
> extern const struct dmi_device_id __mod_dmi_device_table \
> 		__attribute__ ((unused, alias("mbp_device_table")));
> 
> So 'struct dmi_device_id' isn't ever really used -- it's just like a
> forward declaration of a struct, and the compiler doesn't care because
> it never needs to know anything more about that struct.
> 
> Not ideal though -- we should probably see if we can fix it. I suspect
> it's not worth a global change of dmi_system_id to dmi_device_id
> though... got any better ideas?
> 
> Maybe we could change MODULE_GENERIC_TABLE to be more agnostic about the
> datatype -- just call it and 'extern char'. After all, it's only for the
> linker.

Let's do it the most staightforward way :-)


[PATCH] Fixup MODULE_DEVICE_TABLE(dmi, ...)

drivers/video/backlight/mbp_nvidia_bl.c:114: error: storage size of '__mod_dmi_device_table' isn't known

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/linux/mod_devicetable.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -443,6 +443,7 @@ struct dmi_system_id {
 	struct dmi_strmatch matches[4];
 	void *driver_data;
 };
+#define dmi_device_id dmi_system_id	/* fixup MODULE_DEVICE_TABLE(dmi,...); */
 #endif
 
 #define DMI_MATCH(a, b)	{ a, b }
