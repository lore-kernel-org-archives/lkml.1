Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbXKPDLF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbXKPDLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 22:11:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754044AbXKPDKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 22:10:50 -0500
Received: from ag-out-0708.google.com ([72.14.246.244]:14306 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760240AbXKPDKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 22:10:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=C7PcIRtipDeZPoeqZUR+54vmTqCtmkeE68JG6MI9jQcu+F4gehV+M3rPkZYdvNeIjOgpNCQSISAW4cB+0uckFlxkwrGwdwXa2WWl2H9vux1I2sgpY2vmUAqOlN+i/I8Tlc5Lijq74+kty2l9MgUP89tFdK+j0IK+QHdYeJe7J/A=
Date: Fri, 16 Nov 2007 11:08:32 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
       Jeff Dike <jdike@addtoit.com>, akpm@linux-foundation.org,
       Chris Wright <chrisw@sous-sol.org>
Subject: [Patch] Fix UML broken (was Re: User Mode Linux still broken in
	2.6.23.1)
Message-ID: <20071116030832.GB2563@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <200711032351.52977.rob@landley.net> <200711142358.16072.rob@landley.net> <20071115060255.GA4837@kroah.com> <200711151457.22395.rob@landley.net> <20071115210608.GA12213@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071115210608.GA12213@kroah.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 01:06:08PM -0800, Greg KH wrote:
>On Thu, Nov 15, 2007 at 02:57:21PM -0600, Rob Landley wrote:
>> On Thursday 15 November 2007 00:02:55 Greg KH wrote:
>> > On Wed, Nov 14, 2007 at 11:58:15PM -0600, Rob Landley wrote:
>> > > On Wednesday 14 November 2007 12:54:44 Greg KH wrote:
>> > > > On Sat, Nov 03, 2007 at 11:51:50PM -0500, Rob Landley wrote:
>> > > > > Building with the attached .config on x86-64, it does this:
>> > > > >
>> > > > >   CC      arch/um/kernel/smp.o
>> > > > > In file included from include/asm/arch/tlb.h:11,
>> > > > >                  from include/asm/tlb.h:4,
>> > > > >                  from arch/um/kernel/smp.c:8:
>> > > > > include/asm-generic/tlb.h: In function ???tlb_flush_mmu???:
>> > > > > include/asm-generic/tlb.h:76: error: implicit declaration of function
>> > > > > ???release_pages??? include/asm-generic/tlb.h: In function
>> > > > > ???tlb_remove_page???:
>> > > > > include/asm-generic/tlb.h:105: error: implicit declaration of
>> > > > > function ???page_cache_release??? make[1]: *** [arch/um/kernel/smp.o]
>> > > > > Error 1 make: *** [arch/um/kernel] Error 2
>> > > > >
>> > > > > I've been doing the following to fix it.  I know it's not the right
>> > > > > fix, (see the earlier thread about it at
>> > > > > http://lkml.org/lkml/2007/8/24/441 ) but could the one line fix go
>> > > > > into the -stable queue 2.6.23 while a proper fix goes into 2.6.24?
>> > > >
>> > > > I think the patches that I have just added to the stable queue for
>> > > > 2.6.23.2 will fix this.  If not, please let me know after testing.
>> > >
>> > > Where do I find these patches to test?  I know where to find the stable
>> > > releases, but not the "stable queue".
>> > >
>> > > Documentation/stable_kernel_rules.txt just says there _is_ a stable
>> > > queue, not where to access it.  Google's first hit for "linux stable
>> > > queue" was
>> > > http://git.kernel.org/?p=linux/kernel/git/chrisw/stable-queue.git;a=short
>> > >log which apparently stopped updating in march...
>> > >
>> > > Happy to test the patch you mentioned, if I can figure out where to find
>> > > it...
>> >
>> > It's at:
>> > 	http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=summar
>> >y
>> >
>> > Chris and I used to have separate queues, but that got messy, I suppose
>> > we should just delete those old copies...
>> 
>> In a freshly extracted 2.6.23 tarball, I applied the 4 uml-*.patch files from 
>> stable-queue/review-2.6.23-2 in sequence (all applied cleanly), and then did 
>> the following:
>> 
>> cat > mini.conf << EOF &&
>> CONFIG_BINFMT_ELF=y
>> CONFIG_HOSTFS=y
>> CONFIG_LBD=y
>> CONFIG_BLK_DEV=y
>> CONFIG_BLK_DEV_LOOP=y
>> CONFIG_STDERR_CONSOLE=y
>> CONFIG_UNIX98_PTYS=y
>> CONFIG_EXT2_FS=y
>> EOF
>> make ARCH=um allnoconfig KCONFIG_ALLCONFIG=mini.conf 
>> 
>> Then I did:
>> 
>> make -j 2 ARCH=um
>> 
>> And it still breaks:
>> 
>>   CC      arch/um/kernel/smp.o
>> In file included from include/asm/arch/tlb.h:11,
>>                  from include/asm/tlb.h:4,
>>                  from arch/um/kernel/smp.c:8:
>> include/asm-generic/tlb.h: In function ???tlb_flush_mmu???:
>> include/asm-generic/tlb.h:76: error: implicit declaration of 
>> function ???release_pages???
>> include/asm-generic/tlb.h: In function ???tlb_remove_page???:
>> include/asm-generic/tlb.h:105: error: implicit declaration of 
>> function ???page_cache_release???
>> make[1]: *** [arch/um/kernel/smp.o] Error 1
>> make: *** [arch/um/kernel] Error 2
>> make: *** Waiting for unfinished jobs....
>> 
>> My .config is attached.
>
>Hm, not good.  I'll let Jeff handle this :)

Could you please try this patch? Can it fix the error?

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/Makefile b/Makefile
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 4f3838a..2c3ce4c 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -6,6 +6,7 @@
 #include <linux/mmzone.h>
 #include <linux/list.h>
 #include <linux/sched.h>
+#include <linux/pagemap.h>
 
 #include <asm/atomic.h>
 #include <asm/page.h>
