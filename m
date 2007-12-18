Return-Path: <linux-kernel-owner+w=401wt.eu-S1759633AbXLRSIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759633AbXLRSIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 13:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbXLRSIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 13:08:22 -0500
Received: from mga06.intel.com ([134.134.136.21]:28419 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753961AbXLRSIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 13:08:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,181,1196668800"; 
   d="scan'208";a="299832142"
Message-ID: <47680C16.1090905@linux.intel.com>
Date: Tue, 18 Dec 2007 10:06:14 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       protasnb@gmail.com, tytso@thunk.org, mpm@selenic.com
Subject: Re: Top kernel oopses/warnings this week
References: <4762CF8C.90808@linux.intel.com> <20071217172331.GA23070@elte.hu> <20071217133631.5bbc5842@laptopd505.fenrus.org> <12c511ca0712171458n1bc05b40nab6b4b7c92433c8d@mail.gmail.com> <476703A4.7000401@linux.intel.com> <12c511ca0712171526h242a7de8vadec78cd48747bd@mail.gmail.com> <20071217154727.404e4bc4@laptopd505.fenrus.org> <alpine.LFD.0.9999.0712171607370.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712171607370.21557@woody.linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------060103070607080108090004"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060103070607080108090004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
> 
> On Mon, 17 Dec 2007, Arjan van de Ven wrote:
>> +char *get_boot_uuid(void)
>> +{
>> +	static char target[38];
>> +	unsigned char *uuid;
>> +
>> +	if (sysctl_bootid[8] == 0)
>> +		generate_random_uuid(sysctl_bootid);
>> +	/* sysctl_bootid is signed, to print we need unsigned .. */
>> +	uuid = sysctl_bootid;
>> +
>> +	if (target[0] == 0) {
>> +		sprintf(target, "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-"
>> +			"%02x%02x%02x%02x%02x%02x",
> 
> Why isn't *everything* inside that "if (target[0] == 0" check?
> 
> IOW, that function should look something like


ok so this got a lot more involved than I was hoping for;
something like below will help me (and kerneloops.org ;) for the short term,
while I'll see what I can do for random.c in a few dead moments soon, for a 2.6.25
enhancement...


Subject: [patch] terminate the oops printing with a defined string/uuid
From: Arjan van de Ven <arjan@linux.intel.com>

Right now, it's hard for automated tools to determine when an oops has
ended; there's no clear marker for this. For later kernels I would also
like a UUID to printed here, but for short term I've put all zeros there
since printing a UUID seems to involve cleaning up/rewriting quite a chunk
of random.c and that's more involved -> later patch.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
  kernel/panic.c         |    1 +
  1 files changed, 1 insertion(+), 0 deletions(-)

Index: linux-2.6.24-rc5/kernel/panic.c
===================================================================
--- linux-2.6.24-rc5.orig/kernel/panic.c
+++ linux-2.6.24-rc5/kernel/panic.c
@@ -272,6 +273,7 @@ void oops_enter(void)
  void oops_exit(void)
  {
  	do_oops_enter_exit();
+	printk("---[ end of trace 00000000-0000-0000-0000-000000000000 ]---\n");
  }

  #ifdef CONFIG_CC_STACKPROTECTOR


--------------060103070607080108090004
Content-Type: text/x-patch;
 name="oopsend.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="oopsend.patch"

Subject: [patch] terminate the oops printing with a defined string/uuid
From: Arjan van de Ven <arjan@linux.intel.com>

Right now, it's hard for automated tools to determine when an oops has
ended; there's no clear marker for this. For later kernels I would also
like a UUID to printed here, but for short term I've put all zeros there
since printing a UUID seems to involve cleaning up/rewriting quite a chunk
of random.c and that's more involved -> later patch.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 kernel/panic.c         |    1 +
 1 files changed, 1 insertion(+), 0 deletions(-)

Index: linux-2.6.24-rc5/kernel/panic.c
===================================================================
--- linux-2.6.24-rc5.orig/kernel/panic.c
+++ linux-2.6.24-rc5/kernel/panic.c
@@ -272,6 +273,7 @@ void oops_enter(void)
 void oops_exit(void)
 {
 	do_oops_enter_exit();
+	printk("---[ end of trace 0000-00-00-00-000000 ]---\n");
 }
 
 #ifdef CONFIG_CC_STACKPROTECTOR

--------------060103070607080108090004--
