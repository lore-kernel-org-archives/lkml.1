Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbZHCAoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbZHCAoK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 20:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZHCAoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 20:44:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:32315 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbZHCAoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 20:44:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,310,1246863600"; 
   d="scan'208";a="538011916"
Subject: Re: [PATCH 6/10] drivers/net/wireless/iwlwifi: introduce missing
 kfree
From: Zhu Yi <yi.zhu@intel.com>
To: Julia Lawall <julia@diku.dk>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0908011054010.23408@ask.diku.dk>
References: <Pine.LNX.4.64.0908011054010.23408@ask.diku.dk>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 08:44:06 +0800
Message-Id: <1249260246.4069.26.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-01 at 16:54 +0800, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Error handling code following a kzalloc should free the allocated data.
> 
> The semantic match that finds the problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @r exists@
> local idexpression x;
> statement S;
> expression E;
> identifier f,f1,l;
> position p1,p2;
> expression *ptr != NULL;
> @@
> 
> x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
> ...
> if (x == NULL) S
> <... when != x
>      when != if (...) { <+...x...+> }
> (
> x->f1 = E
> |
>  (x->f1 == NULL || ...)
> |
>  f(...,x->f1,...)
> )
> ...>
> (
>  return \(0\|<+...x...+>\|ptr\);
> |
>  return@p2 ...;
> )
> 
> @script:python@
> p1 << r.p1;
> p2 << r.p2;
> @@
> 
> print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> ---
>  drivers/net/wireless/iwlwifi/iwl-debugfs.c     |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
> index 7707a26..c2106d0 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
> @@ -320,6 +320,7 @@ static ssize_t iwl_dbgfs_nvm_read(struct file *file,
>  	ptr = priv->eeprom;
>  	if (!ptr) {
>  		IWL_ERR(priv, "Invalid EEPROM/OTP memory\n");
> +		kfree(buf);
>  		return -ENOMEM;
>  	}
>  	pos += scnprintf(buf + pos, buf_size - pos, "NVM Type: %s\n",

Probably moving !priv->eeprom check prior to buf kzalloc is better.

Thanks,
-yi

