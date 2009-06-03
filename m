Return-Path: <linux-kernel-owner+w=401wt.eu-S1753057AbZFCVjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753057AbZFCVjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbZFCVjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:39:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53149 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753097AbZFCVjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:39:41 -0400
Date: Wed, 3 Jun 2009 14:39:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, ying.huang@intel.com,
       W.Li@Sun.COM, michaele@au1.ibm.com, mingo@elte.hu,
       heicars2@linux.vnet.ibm.com, mschwid2@linux.vnet.ibm.com
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
Message-Id: <20090603143923.a5387555.akpm@linux-foundation.org>
In-Reply-To: <4A26961E.7040207@linux.vnet.ibm.com>
References: <20090602114359.129247921@linux.vnet.ibm.com>
	<20090602114402.951631599@linux.vnet.ibm.com>
	<20090602150324.c706b1d2.akpm@linux-foundation.org>
	<4A266546.5080601@linux.vnet.ibm.com>
	<4A26961E.7040207@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 03 Jun 2009 17:26:22 +0200
Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:

> > Right - the sscanf would make sense if kernel parameters could contain 
> > spaces (in that case it catches <number><blanks><garbage> input) which 
> > it can't so strtoul() would indeed make more sense. I'll prepare an 
> > updated patch and send it out later today.
> 
> See below for the updated patch that uses strtoul instead of sscanf.
> This patch replaces kernel-constructor-support.patch in the -mm tree:

umm, no it doesn't.  I get the below incremental patch, against
gcov-add-gcov-profiling-infrastructure.patch:

--- a/kernel/gcov/fs.c~gcov-add-gcov-profiling-infrastructure-update
+++ a/kernel/gcov/fs.c
@@ -70,15 +70,8 @@ static int gcov_persist = 1;
 
 static int __init gcov_persist_setup(char *str)
 {
-	int val;
-	char delim;
-
-	if (sscanf(str, "%d %c", &val, &delim) != 1) {
-		pr_warning("invalid gcov_persist parameter '%s'\n", str);
-		return 0;
-	}
-	pr_info("setting gcov_persist to %d\n", val);
-	gcov_persist = val;
+	gcov_persist = simple_strtoul(str, NULL, 0);
+	pr_info("setting gcov_persist to %d\n", gcov_persist);
 
 	return 1;
 }
_

arguably we should use strict_strtoul(), but the kernel is a lot less
fussy about boot parameters than it is with sysfs writes, etc.  If you
fat-finger your grub.conf, you lose and we don't tell you.
