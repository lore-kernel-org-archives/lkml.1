Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbYHKD0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbYHKD0t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 23:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbYHKD0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 23:26:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:31110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835AbYHKD0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 23:26:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,341,1215414000"; 
   d="scan'208";a="325024571"
Subject: Re: [PATCH] lib/vsprintf.c: wrong conversion function used
From: Yi Yang <yi.y.yang@intel.com>
Reply-To: yi.y.yang@intel.com
To: Swen Schillig <swen@vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200808071124.06160.swen@vnet.ibm.com>
References: <200808071124.06160.swen@vnet.ibm.com>
Content-Type: text/plain
Organization: Intel OTC Beijing
Date: Sun, 10 Aug 2008 23:38:40 +0800
Message-Id: <1218382720.1409.37.camel@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swen, your fix is just partly correct, it'll has a big problem for strict_strtoul, because val is of long type, 
but you patch will result in long long return type, the below patch is a correct fix.



Signed-off-by: Yi Yang <yi.y.yang@intel.com>
Noticed-by: Swen Schillig <swen@vnet.ibm.com>
---
 vsprintf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 1dc2d1d..d8d1d11 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -220,7 +220,7 @@ int strict_strtou##type(const char *cp, unsigned int base, valtype *res)\
 	if (len == 0)							\
 		return -EINVAL;						\
 									\
-	val = simple_strtoul(cp, &tail, base);				\
+	val = simple_strtou##type(cp, &tail, base);			\
 	if ((*tail == '\0') ||						\
 		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {\
 		*res = val;						\


On Thu, 2008-08-07 at 11:24 +0200, Swen Schillig wrote:
> From: Swen Schillig <swen@vnet.ibm.com>
> 
> The macro define_strict_strtoux() is using the simple_strtoul ()
> function as opposed to the simple_strtoull() function.
> This leads to false conversions on non-64bit 
> machines (here 31bit System z).
> 
> The following patch fixes the issue introduced by 
> 
> commit 06b2a76d25d3cfbd14680021c1d356c91be6904e 
> Author: Yi Yang <yi.y.yang@intel.com> 
> Date:   Fri Feb 8 04:21:57 2008 -0800 
> 
> Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
> ---
>  lib/vsprintf.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: HEAD/lib/vsprintf.c
> ===================================================================
> --- HEAD.orig/lib/vsprintf.c
> +++ HEAD/lib/vsprintf.c
> @@ -220,7 +220,7 @@ int strict_strtou##type(const char *cp, 
>  	if (len == 0)							\
>  		return -EINVAL;						\
>  									\
> -	val = simple_strtoul(cp, &tail, base);				\
> +	val = simple_strtoull(cp, &tail, base);				\
>  	if ((*tail == '\0') ||						\
>  		((len == (size_t)(tail - cp) + 1) && (*tail == '\n'))) {\
>  		*res = val;						\

