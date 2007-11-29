Return-Path: <linux-kernel-owner+w=401wt.eu-S1761525AbXK2Jzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761525AbXK2Jzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 04:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756508AbXK2Jz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 04:55:26 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:52149 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbXK2JzZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 04:55:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Date: Thu, 29 Nov 2007 10:55:01 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org,
       rusty@rustcorp.com.au
References: <20071122343.446909000@suse.de>
In-Reply-To: <20071122343.446909000@suse.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711291055.02056.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18bR6o/k746PfPLu23RUha9t0sCblkpfkSlRB1
 V2/yk7KsY2JtRtHtkvcdeE+kVfRmR8RxM/9dSoLYdLD1njZgXD
 DbmiWAh81sxul34sW2cvQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 November 2007, Andi Kleen wrote:
>  #define EXPORT_SYMBOL(sym)                                     \
> -       __EXPORT_SYMBOL(sym, "")
> +       __EXPORT_SYMBOL(sym, "",,, NULL)
>  
>  #define EXPORT_SYMBOL_GPL(sym)                                 \
> -       __EXPORT_SYMBOL(sym, "_gpl")
> +       __EXPORT_SYMBOL(sym, "_gpl",,, NULL)
>  
>  #define EXPORT_SYMBOL_GPL_FUTURE(sym)                          \
> -       __EXPORT_SYMBOL(sym, "_gpl_future")
> +       __EXPORT_SYMBOL(sym, "_gpl_future",,, NULL)
>  
> +/* Export symbol into namespace ns
> + * No _GPL variants because namespaces imply GPL only
> + */
> +#define EXPORT_SYMBOL_NS(ns, sym)                              \
> +       __EXPORT_SYMBOL(sym, "_gpl",__##ns, NS_SEPARATOR #ns, #ns)
>  

I think it would be good if you could specify a default namespace
per module, that could reduce the amount of necessary changes significantly.

For example, you can do

#define EXPORT_SYMBOL_GLOBAL(sym) __EXPORT_SYMBOL(sym, "_gpl",,, NULL)
#ifdef MODULE_NAMESPACE
#define EXPORT_SYMBOL_GPL(sym) EXPORT_SYMBOL_GLOBAL(sym)
#else
#define EXPORT_SYMBOL_GPL(sym) EXPORT_SYMBOL_NS(sym, MODULE_NAMESPACE)
#endif

If we go that way, it may be useful to extend the namespace mechanism to
non-GPL symbols as well, like

#define EXPORT_SYMBOL(sym) __EXPORT_SYMBOL(sym, "",__## MODULE_NAMESPACE, NS_SEPARATOR #MODULE_NAMESPACE, #MODULE_NAMESPACE)

Unfortunately, doing this automatic namespace selection requires to set
the namespace before #include <linux/module.h>. One way to work around this
could be to use Makefile magic so you can list a Makefile as

obj-$(CONFIG_COMBINED) += combined.o
combined-$(CONFIG_SUBOPTION) += combined_main.o combined_other.o
obj-$(CONFIG_SINGLE) += single.o
obj-$(CONFIG_OTHER) += other.o
obj-$(CONFIG_API) += api.o

NAMESPACE = subsys                       # default, used for other.o
NAMESPACE_single.o = single              # used only for single.o
NAMESPACE_combined.o = combined          # all parts of combined.o
NAMESPACE_combined_other.o = special     #    except this one
NAMESPACE_api.o =                        # api.o is put into the global ns

The Makefile logic here would basically just follow the rules we have for
CFLAGS etc, and then pass -DMODULE_NAMESPACE=$(NAMESPACE_$(obj)) to gcc.

	Arnd <><
