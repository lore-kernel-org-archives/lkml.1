Return-Path: <linux-kernel-owner+w=401wt.eu-S1761294AbYFMFRp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761294AbYFMFRp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 01:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbYFMFRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 01:17:34 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:44343 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759752AbYFMFRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 01:17:33 -0400
Date: Thu, 12 Jun 2008 22:17:18 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       sam@ravnborg.org, shai@scalex86.org
Subject: Re: [2.6.25 - stable] Fix Kconfig dependencies to prevent
	CONFIG_X86_VSMP from vanishing
Message-ID: <20080613051718.GB6071@localdomain>
References: <20080613023348.GA6071@localdomain> <20080613044858.GC5427@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080613044858.GC5427@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 06:48:58AM +0200, Ingo Molnar wrote:
>
>* Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>
>> I am including a trimmed down patch of 
>> 823c248e7cc75b4f22da914b01f8e5433cff197e to fix CONFIG_VSMP as per 
>> stable policy.  This was tested and found to fix the problem mentioned 
>> above.  Please apply.
>
>hm, but why did you trim it down? I'd suggest we use the full 
>823c248e7cc75b4 patch because that's what had been tested upstream.

Was just following  the "It must fix only one thing" rule for stable,
and being a bit over-conservative I guess.  The changes were only to VSMP
parts keeping the impact minimal.

If 823c248e7cc75b4f22da914b01f8e5433cff197e can be applied completely then
great!  Here's the commit slightly re-diffed for 2.6.25

Thanks,
Kiran

---

From: Roman Zippel <zippel@linux-m68k.org>
Mainline commit: 823c248e7cc75b4f22da914b01f8e5433cff197e

    x86: fix recursive dependencies

    The proper dependency check uncovered a few dependency problems,
    the sub-architecture used a mixture of selects and depends on SMP
    and PCI dependency was messed up.


Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

Index: linux-2.6.25.4/arch/x86/Kconfig
===================================================================
--- linux-2.6.25.4.orig/arch/x86/Kconfig	2008-05-15 08:00:12.000000000 -0700
+++ linux-2.6.25.4/arch/x86/Kconfig	2008-06-06 16:05:46.405250939 -0700
@@ -253,8 +253,7 @@ config X86_ELAN
 
 config X86_VOYAGER
 	bool "Voyager (NCR)"
-	depends on X86_32
-	select SMP if !BROKEN
+	depends on X86_32 && (SMP || BROKEN)
 	help
 	  Voyager is an MCA-based 32-way capable SMP architecture proprietary
 	  to NCR Corp.  Machine classes 345x/35xx/4100/51xx are Voyager-based.
@@ -266,9 +265,8 @@ config X86_VOYAGER
 
 config X86_NUMAQ
 	bool "NUMAQ (IBM/Sequent)"
-	select SMP
+	depends on SMP && X86_32
 	select NUMA
-	depends on X86_32
 	help
 	  This option is used for getting Linux to run on a (IBM/Sequent) NUMA
 	  multiquad box. This changes the way that processors are bootstrapped,
@@ -339,7 +337,7 @@ config X86_RDC321X
 
 config X86_VSMP
 	bool "Support for ScaleMP vSMP"
-	depends on X86_64 && PCI
+	depends on X86_64
 	 help
 	  Support for ScaleMP vSMP systems.  Say 'Y' here if this kernel is
 	  supposed to run on these EM64T-based machines.  Only choose this option
@@ -1391,7 +1389,7 @@ endmenu
 menu "Bus options (PCI etc.)"
 
 config PCI
-	bool "PCI support" if !X86_VISWS
+	bool "PCI support" if !X86_VISWS && !X86_VSMP
 	depends on !X86_VOYAGER
 	default y
 	select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
