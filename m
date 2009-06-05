Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbZFENHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbZFENHf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbZFENHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:07:11 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:54977 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbZFENHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:07:08 -0400
Message-ID: <4A29182D.5040003@linux.vnet.ibm.com>
Date: Fri, 05 Jun 2009 15:05:49 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, andi@firstfloor.org, ying.huang@intel.com,
       W.Li@Sun.COM, michaele@au1.ibm.com, mingo@elte.hu,
       heicars2@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
References: <20090602114359.129247921@linux.vnet.ibm.com> <20090602114402.951631599@linux.vnet.ibm.com> <20090602150324.c706b1d2.akpm@linux-foundation.org> <4A266546.5080601@linux.vnet.ibm.com>	<4A26961E.7040207@linux.vnet.ibm.com> <20090603143923.a5387555.akpm@linux-foundation.org>
In-Reply-To: <20090603143923.a5387555.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 03 Jun 2009 17:26:22 +0200
> Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:
> --- a/kernel/gcov/fs.c~gcov-add-gcov-profiling-infrastructure-update
> +++ a/kernel/gcov/fs.c
> @@ -70,15 +70,8 @@ static int gcov_persist = 1;
> 
>  static int __init gcov_persist_setup(char *str)
>  {
> -	int val;
> -	char delim;
> -
> -	if (sscanf(str, "%d %c", &val, &delim) != 1) {
> -		pr_warning("invalid gcov_persist parameter '%s'\n", str);
> -		return 0;
> -	}
> -	pr_info("setting gcov_persist to %d\n", val);
> -	gcov_persist = val;
> +	gcov_persist = simple_strtoul(str, NULL, 0);
> +	pr_info("setting gcov_persist to %d\n", gcov_persist);
> 
>  	return 1;
>  }
> _
> 
> arguably we should use strict_strtoul(), but the kernel is a lot less
> fussy about boot parameters than it is with sysfs writes, etc.  If you
> fat-finger your grub.conf, you lose and we don't tell you.

To improve user-friendliness a bit:

Subject: gcov: use strict_strtoul

From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>

Use strict_strtoul to identify kernel parameter format errors.

Signed-off-by: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
---
 kernel/gcov/fs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6.30-rc8-mm1/kernel/gcov/fs.c
===================================================================
--- linux-2.6.30-rc8-mm1.orig/kernel/gcov/fs.c
+++ linux-2.6.30-rc8-mm1/kernel/gcov/fs.c
@@ -70,7 +70,13 @@ static int gcov_persist = 1;
 
 static int __init gcov_persist_setup(char *str)
 {
-	gcov_persist = simple_strtoul(str, NULL, 0);
+	unsigned long val;
+
+	if (strict_strtoul(str, 0, &val)) {
+		pr_warning("invalid gcov_persist parameter '%s'\n", str);
+		return 0;
+	}
+	gcov_persist = val;
 	pr_info("setting gcov_persist to %d\n", gcov_persist);
 
 	return 1;

