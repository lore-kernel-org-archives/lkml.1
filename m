Return-Path: <linux-kernel-owner+w=401wt.eu-S1760901AbYHUWJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760901AbYHUWJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 18:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759464AbYHUWJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 18:09:11 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:48001 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760168AbYHUWJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 18:09:09 -0400
Message-ID: <48ADE7C5.9030802@keyaccess.nl>
Date: Fri, 22 Aug 2008 00:10:13 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "Li, Shaohua" <shaohua.li@intel.com>
CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Airlie <airlied@gmail.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: [PATCH] x86: {reverve,free}_memtype() take a physical address
References: <20080819102633.GE6722@elte.hu> <48AAD680.7020508@keyaccess.nl> <20080819190757.GA17470@linux-os.sc.intel.com> <20080820100440.GE28492@elte.hu> <48ABF6DC.8070305@keyaccess.nl> <48AC29CA.1060203@keyaccess.nl> <20080820194127.GA10887@linux-os.sc.intel.com> <48AC8F69.4050201@keyaccess.nl> <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com> <20080820221630.GA3598@linux-os.sc.intel.com> <20080821120626.GG5615@elte.hu> <48ADA2C2.8090905@keyaccess.nl>
In-Reply-To: <48ADA2C2.8090905@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------050906010100090700040906"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050906010100090700040906
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 21-08-08 19:15, Rene Herman wrote:

> On 21-08-08 14:06, Ingo Molnar wrote:

>> Would be nice to test tip/master - it has both that patch included and 
>> the latest pageattr-array API (with enablement in AGP drivers) 
>> patchset, done by Shaohua Li, based on Dave's original patch.
> 
> That patch by itself doesn't help any -- the new set_memory_array_uc() 
> still calls reserve_memtype() for each single page in the array.

Worse yet, it appears to be broken. {reserve,free}_memtype() expect phys 
addresses but it's being passed virtual ones...

Rene.



--------------050906010100090700040906
Content-Type: text/plain;
 name="0001-x86-reverve-free-_memtype-take-a-physical-addres.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-x86-reverve-free-_memtype-take-a-physical-addres.patch"

>From 48b9d479e149dffac24f98f9491174fdfc19d26b Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Thu, 21 Aug 2008 23:32:25 +0200
Subject: [PATCH] x86: {reverve,free}_memtype() take a physical address

The new set_memory_array_{uc,wb}() pass virtual addresses to
{reserve,free}_memtype() it seems.

Signed-off-by: Rene Herman <rene.herman@gmail.com>
---
 arch/x86/mm/pageattr.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index b351c4f..d49e4db 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -947,7 +947,7 @@ int set_memory_array_uc(unsigned long *addr, int addrinarray)
 	 * for now UC MINUS. see comments in ioremap_nocache()
 	 */
 	for (i = 0; i < addrinarray; i++) {
-		if (reserve_memtype(addr[i], addr[i] + PAGE_SIZE,
+		if (reserve_memtype(__pa(addr[i]), __pa(addr[i]) + PAGE_SIZE,
 			    _PAGE_CACHE_UC_MINUS, NULL))
 			goto out;
 	}
@@ -956,7 +956,7 @@ int set_memory_array_uc(unsigned long *addr, int addrinarray)
 				    __pgprot(_PAGE_CACHE_UC_MINUS), 1);
 out:
 	while (--i >= 0)
-		free_memtype(addr[i], addr[i] + PAGE_SIZE);
+		free_memtype(__pa(addr[i]), __pa(addr[i]) + PAGE_SIZE);
 	return -EINVAL;
 }
 EXPORT_SYMBOL(set_memory_array_uc);
@@ -998,7 +998,7 @@ int set_memory_array_wb(unsigned long *addr, int addrinarray)
 {
 	int i;
 	for (i = 0; i < addrinarray; i++)
-		free_memtype(addr[i], addr[i] + PAGE_SIZE);
+		free_memtype(__pa(addr[i]), __pa(addr[i]) + PAGE_SIZE);
 
 	return change_page_attr_clear(addr, addrinarray,
 				      __pgprot(_PAGE_CACHE_MASK), 1);
-- 
1.5.5


--------------050906010100090700040906--
