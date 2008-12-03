Return-Path: <linux-kernel-owner+w=401wt.eu-S1751523AbYLCIle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbYLCIle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 03:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbYLCIlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 03:41:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55601 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859AbYLCIlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 03:41:25 -0500
Date: Wed, 3 Dec 2008 00:41:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fixup MODULE_DEVICE_TABLE(dmi, ...)
Message-Id: <20081203004120.460166ac.akpm@linux-foundation.org>
In-Reply-To: <20081121015559.GA4478@x200.localdomain>
References: <20081114234131.GA28559@x200.localdomain>
	<1226747692.3687.285.camel@macbook.infradead.org>
	<20081121015559.GA4478@x200.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2008 04:55:59 +0300 Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Sat, Nov 15, 2008 at 11:14:52AM +0000, David Woodhouse wrote:
> > On Sat, 2008-11-15 at 02:41 +0300, Alexey Dobriyan wrote:
> > > How can this work, given that MODULE_DEVICE_TABLE line expands into
> > > 
> > >         extern const struct dmi_device_id __mod_dmi_device_table
> > > __attribute__ ((unused, alias("mbp_device_table")));
> > >                                 ^^^^^^
> > > but there is no struct dmi_device_id, there is struct dmi_system_id?
> > 
> > Interesting question ;)
> > 
> > It actually looks like this...
> > 
> > static struct dmi_system_id __initdata mbp_device_table[] = {
> > 	...
> > };
> > 
> > extern const struct dmi_device_id __mod_dmi_device_table \
> > 		__attribute__ ((unused, alias("mbp_device_table")));
> > 
> > So 'struct dmi_device_id' isn't ever really used -- it's just like a
> > forward declaration of a struct, and the compiler doesn't care because
> > it never needs to know anything more about that struct.
> > 
> > Not ideal though -- we should probably see if we can fix it. I suspect
> > it's not worth a global change of dmi_system_id to dmi_device_id
> > though... got any better ideas?
> > 
> > Maybe we could change MODULE_GENERIC_TABLE to be more agnostic about the
> > datatype -- just call it and 'extern char'. After all, it's only for the
> > linker.
> 
> Let's do it the most staightforward way :-)
> 

What happened with all this?

> [PATCH] Fixup MODULE_DEVICE_TABLE(dmi, ...)
> 
> drivers/video/backlight/mbp_nvidia_bl.c:114: error: storage size of '__mod_dmi_device_table' isn't known
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  include/linux/mod_devicetable.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- a/include/linux/mod_devicetable.h
> +++ b/include/linux/mod_devicetable.h
> @@ -443,6 +443,7 @@ struct dmi_system_id {
>  	struct dmi_strmatch matches[4];
>  	void *driver_data;
>  };
> +#define dmi_device_id dmi_system_id	/* fixup MODULE_DEVICE_TABLE(dmi,...); */
>  #endif
>  
>  #define DMI_MATCH(a, b)	{ a, b }

The changelog is too crappy for me.  Why did that error occur, and how
does the patch fix it?

