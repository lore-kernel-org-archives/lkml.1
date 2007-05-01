Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbXEAUGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbXEAUGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbXEAUGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:06:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:44224 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbXEAUGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:06:43 -0400
Date: Tue, 1 May 2007 13:08:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Richard Purdie <rpurdie@openedhand.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       herbert@gondor.apana.org.au, linux-mtd <linux-mtd@lists.infradead.org>,
       linux-crypto@vger.kernel.org
Subject: Re: [PATCH 4/5] jffs2: Allow selection of compression mode via a
 sysfs attribute
Message-Id: <20070501130811.5c9c9f7d.randy.dunlap@oracle.com>
In-Reply-To: <1178030839.5883.56.camel@localhost.localdomain>
References: <1178030839.5883.56.camel@localhost.localdomain>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 May 2007 15:47:19 +0100 Richard Purdie wrote:

> Allow selection of the compression mode for jffs2 via a sysfs
> attribute. This establishes a sysfs presence for jffs2 through
> which other compression options could easily be exported too.
> 
> Signed-off-by: Richard Purdie <rpurdie@openedhand.com>
> ---
>  fs/Kconfig       |    9 ++++++++
>  fs/jffs2/compr.c |   41 ++++++++++++++++++++++++++++++++++++
>  fs/jffs2/compr.h |    6 +++++
>  fs/jffs2/super.c |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 117 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 328a62f..9da136b 100644
> diff --git a/fs/jffs2/compr.c b/fs/jffs2/compr.c
> index fdb0efd..8c57dc7 100644
> --- a/fs/jffs2/compr.c
> +++ b/fs/jffs2/compr.c
> @@ -11,6 +11,7 @@
>   *
>   */
>  
> +#include <linux/kobject.h>

is that used/needed in this source file?

>  #include "compr.h"
>  
>  static DEFINE_SPINLOCK(jffs2_compressor_list_lock);
> @@ -296,6 +297,46 @@ int jffs2_unregister_compressor(struct jffs2_compressor *comp)
>          return 0;
>  }
>  
> +#ifdef CONFIG_JFFS2_SYSFS
> +
> +char *jffs2_get_compression_mode_name(void)
> +{
> +        switch (jffs2_compression_mode) {
> +        case JFFS2_COMPR_MODE_NONE:
> +                return "none";
> +        case JFFS2_COMPR_MODE_PRIORITY:
> +                return "priority";
> +        case JFFS2_COMPR_MODE_SIZE:
> +                return "size";
> +	case JFFS2_COMPR_MODE_FAVOURLZO:
> +		return "favourlzo";
> +        }
> +        return "unkown";

Lots of whitespace damage above (needs tabs).

> +}
> +
> +int jffs2_set_compression_mode_name(const char *name)
> +{
> +        if (!strncmp("none", name, 4)) {
> +                jffs2_compression_mode = JFFS2_COMPR_MODE_NONE;
> +                return 0;
> +        }
> +        if (!strncmp("priority", name, 8)) {
> +                jffs2_compression_mode = JFFS2_COMPR_MODE_PRIORITY;
> +                return 0;
> +        }
> +        if (!strncmp("size", name, 4)) {
> +                jffs2_compression_mode = JFFS2_COMPR_MODE_SIZE;
> +                return 0;
> +        }
> +	if (!strncmp("favourlzo", name, 9)) {
> +		jffs2_compression_mode = JFFS2_COMPR_MODE_FAVOURLZO;
> +		return 0;
> +	}
> +        return -EINVAL;

Lots of tabs needed above also.

> +}
> +
> +#endif
> +
>  void jffs2_free_comprbuf(unsigned char *comprbuf, unsigned char *orig)
>  {
>          if (orig != comprbuf)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
