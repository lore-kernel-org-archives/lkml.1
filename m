Return-Path: <linux-kernel-owner+w=401wt.eu-S1759526AbZA2WJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526AbZA2WJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 17:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbZA2WJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 17:09:12 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:56329 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955AbZA2WJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 17:09:11 -0500
Message-ID: <498228D1.7000105@oracle.com>
Date: Thu, 29 Jan 2009 14:08:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
CC: wimax@linuxwimax.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] wimax: fix build issue when debugfs is disabled
References: <200901291346.16906.inaky@linux.intel.com> <1233266369-16834-1-git-send-email-inaky@linux.intel.com>
In-Reply-To: <1233266369-16834-1-git-send-email-inaky@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.498228D6.026C:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inaky Perez-Gonzalez wrote:
> As reported by Toralf Förster and Randy Dunlap.
> 
> - http://linuxwimax.org/pipermail/wimax/2009-January/000460.html
> 
> - http://lkml.org/lkml/2009/1/29/279

Thanks.  That one builds.


> The definitions needed for the wimax stack and i2400m driver debug
> infrastructure was, by mistake, compiled depending on CONFIG_DEBUG_FS
> (by them being placed in the debugfs.c files); thus the build broke in
> 2.6.29-rc3 when debugging was enabled (CONFIG_WIMAX_DEBUG) and
> DEBUG_FS was disabled.
> 
> These definitions are always needed if debug is enabled at compile
> time (independently of DEBUG_FS being or not enabled), so moving them
> to a file that is always compiled fixes the issue.
> 
> Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>
> ---
>  drivers/net/wimax/i2400m/debugfs.c |   14 --------------
>  drivers/net/wimax/i2400m/driver.c  |   16 ++++++++++++++++
>  net/wimax/debugfs.c                |   11 -----------
>  net/wimax/stack.c                  |   13 +++++++++++++
>  4 files changed, 29 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/net/wimax/i2400m/debugfs.c b/drivers/net/wimax/i2400m/debugfs.c
> index 6266329..9b81af3 100644
> --- a/drivers/net/wimax/i2400m/debugfs.c
> +++ b/drivers/net/wimax/i2400m/debugfs.c
> @@ -234,20 +234,6 @@ struct dentry *debugfs_create_i2400m_reset(
>  				   &fops_i2400m_reset);
>  }
>  
> -/*
> - * Debug levels control; see debug.h
> - */
> -struct d_level D_LEVEL[] = {
> -	D_SUBMODULE_DEFINE(control),
> -	D_SUBMODULE_DEFINE(driver),
> -	D_SUBMODULE_DEFINE(debugfs),
> -	D_SUBMODULE_DEFINE(fw),
> -	D_SUBMODULE_DEFINE(netdev),
> -	D_SUBMODULE_DEFINE(rfkill),
> -	D_SUBMODULE_DEFINE(rx),
> -	D_SUBMODULE_DEFINE(tx),
> -};
> -size_t D_LEVEL_SIZE = ARRAY_SIZE(D_LEVEL);
>  
>  #define __debugfs_register(prefix, name, parent)			\
>  do {									\
> diff --git a/drivers/net/wimax/i2400m/driver.c b/drivers/net/wimax/i2400m/driver.c
> index 5f98047..e80a0b6 100644
> --- a/drivers/net/wimax/i2400m/driver.c
> +++ b/drivers/net/wimax/i2400m/driver.c
> @@ -707,6 +707,22 @@ void i2400m_release(struct i2400m *i2400m)
>  EXPORT_SYMBOL_GPL(i2400m_release);
>  
>  
> +/*
> + * Debug levels control; see debug.h
> + */
> +struct d_level D_LEVEL[] = {
> +	D_SUBMODULE_DEFINE(control),
> +	D_SUBMODULE_DEFINE(driver),
> +	D_SUBMODULE_DEFINE(debugfs),
> +	D_SUBMODULE_DEFINE(fw),
> +	D_SUBMODULE_DEFINE(netdev),
> +	D_SUBMODULE_DEFINE(rfkill),
> +	D_SUBMODULE_DEFINE(rx),
> +	D_SUBMODULE_DEFINE(tx),
> +};
> +size_t D_LEVEL_SIZE = ARRAY_SIZE(D_LEVEL);
> +
> +
>  static
>  int __init i2400m_driver_init(void)
>  {
> diff --git a/net/wimax/debugfs.c b/net/wimax/debugfs.c
> index 87cf443..94d216a 100644
> --- a/net/wimax/debugfs.c
> +++ b/net/wimax/debugfs.c
> @@ -28,17 +28,6 @@
>  #include "debug-levels.h"
>  
>  
> -/* Debug framework control of debug levels */
> -struct d_level D_LEVEL[] = {
> -	D_SUBMODULE_DEFINE(debugfs),
> -	D_SUBMODULE_DEFINE(id_table),
> -	D_SUBMODULE_DEFINE(op_msg),
> -	D_SUBMODULE_DEFINE(op_reset),
> -	D_SUBMODULE_DEFINE(op_rfkill),
> -	D_SUBMODULE_DEFINE(stack),
> -};
> -size_t D_LEVEL_SIZE = ARRAY_SIZE(D_LEVEL);
> -
>  #define __debugfs_register(prefix, name, parent)			\
>  do {									\
>  	result = d_level_register_debugfs(prefix, name, parent);	\
> diff --git a/net/wimax/stack.c b/net/wimax/stack.c
> index d4da92f..3869c03 100644
> --- a/net/wimax/stack.c
> +++ b/net/wimax/stack.c
> @@ -516,6 +516,19 @@ void wimax_dev_rm(struct wimax_dev *wimax_dev)
>  }
>  EXPORT_SYMBOL_GPL(wimax_dev_rm);
>  
> +
> +/* Debug framework control of debug levels */
> +struct d_level D_LEVEL[] = {
> +	D_SUBMODULE_DEFINE(debugfs),
> +	D_SUBMODULE_DEFINE(id_table),
> +	D_SUBMODULE_DEFINE(op_msg),
> +	D_SUBMODULE_DEFINE(op_reset),
> +	D_SUBMODULE_DEFINE(op_rfkill),
> +	D_SUBMODULE_DEFINE(stack),
> +};
> +size_t D_LEVEL_SIZE = ARRAY_SIZE(D_LEVEL);
> +
> +
>  struct genl_family wimax_gnl_family = {
>  	.id = GENL_ID_GENERATE,
>  	.name = "WiMAX",


-- 
~Randy
