Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbXH3G6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbXH3G6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 02:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754276AbXH3G63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 02:58:29 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59338 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754269AbXH3G62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 02:58:28 -0400
Date: Wed, 29 Aug 2007 23:58:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Chan =?UTF-8?B?6Km55a625piM?= <peter_chan@accusys.com.tw>
Cc: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       "Accusys_JeffChang" <jeffchang@accusys.com.tw>,
       "Accusys_Y.T.Huang" <ythuang@accusys.com.tw>,
       "Accusys_Preng" <preng@rd.accusys.com.tw>, <thwu@accusys.com.tw>,
       James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Add ACCUSYS RAID driver for Linux i386/x86-64
Message-Id: <20070829235818.c656b188.akpm@linux-foundation.org>
In-Reply-To: <10BD353233FA5448B2E9C3C9005057584471D7@exchange2.accusys.com.tw>
References: <10BD353233FA5448B2E9C3C9005057584471D7@exchange2.accusys.com.tw>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007 13:45:06 +0800 Peter Chan 詹家昌 <peter_chan@accusys.com.tw> wrote:

> Dear Morton
> 
> ACCUSYS Inc dedicated to design PCI-e RAID HBA, hence we would like to provide our driver bundle in kernel 2.6 for user.

Thank you!

> Could you kindly take a look attached file if it looks like Linux Driver?

It looks a bit like a Linux driver ;)  More on this below.

> If you need the RAID card to verify please let me know.

I personally am unlikely to make the time to test a specific HBA driver. 
But perhaps James or one of the other scsi developers (or any developer at
all) might like to volunteer to help out with testing, in which case yes,
please do send out a card or two.


First up, please become familar with the way in which we handle code patches.
I'd suggest that you subscribe to the linux-kernel or linux-scsi mailing
lists for a while, watch how other people prepare and present their patches.

Download, install and become familiar with quilt
(http://savannah.nongnu.org/projects/quilt) and use that to prepare patches.
quilt can also be used to email patches which might prove useful: new
kernel developers frequently have trouble with wordwrapping, tab-to-space
conversion and other ways in which mail clients corrupt patches.

Once you have quilt up and running you should convert this driver into a
single patch against Linus's latest kernel.  At this time, that is
2.6.23-rc4.

That patch should include the appropriate changes to drivers/scsi/Kconfig
and drivers/scsi/Makefile to wire this driver up to the kernel
configuration and build system.  (You may choose to create a separate
directory drivers/scsi/acs_ame/ for this driver).


Once we reach this stage, we have a patch which others can apply, test and
review.  Review will be the first step.


Your driver isn't ready for review yet.  There are a number of minor but
often-repeated problems which will require extensive changes to correct.

They're silly little things and they won't change the operation of the driver
at all, but it is best to get the driver looking and feeling like a typical
driver before we ask reviewers to start taking a serious look at the code.

- No c++-style comments, please.  Replace all // with /* .. */

- there's some commented-out and obviously dead code.  Things like

//#include <asm/semaphore.h>  //void sema_init 
                            //DECLARE_MUTEX(name)
                            //DECLARE_MUTEX_LOCKED(name)
//#include <linux/rwsem.h>    // read /write semaphore
// Why lock_kernel

//    #include <linux/smp_lock.h>
//    lock_kernel();
//#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,60)
////    daemonize();
//#else
//    daemonize("arcmsr kernel thread");
//#endif
//     unlock_kernel();

//Use unsigned long as a pointer 
// cause of size(unsigend long) always equal to pointer size under all linux compatible platform

  just delete all that, please.

- CHAR_DEV and EVENTSWITCH_ON should probably become CONFIG variables
  (set in drivers/scsi/Kconfig)

- try to keep the code fitting nicely in an 80-column display

- Identifiers like RequestNode and RemapPCIMem should be renamed
  request_node and remap_pci_mem if at all possible.  We use underscores to
  separate "words" within an identifier, not capital letters.

- Once you have a cleaned up patch, please pass that patch through
  scripts/checkpatch.pl.

  I just turned acs_ame.c, acs_ame.h and ame.h into a patch and fed it
  through checkpatch.pl.  Please see the result at
  http://userweb.kernel.org/~akpm/x.txt.

  (For those who are curious, the patch is at
  http://userweb.kernel.org/~akpm/a.patch)

  We have about 4,000 warnings there ;) Actually, a huge number of those
  warnings are incorrect (trailing whitespace).  checkpatch is still under
  development a bit.

  But still, there are a lot of things in the checkpatch output which can
  and should be fixed up.


All together I expect that after one or maybe two days work, you will have
a driver patch which is ready to be applied to the kernel and is ready to
be reviewed by kernel and scsi experts.

At that stage we will be able to get into more substantial details such as
the use of the scsi APIs, the DMA APIs, locking, commenting, design, etc. 
I'd expect that further changes will be made to the driver as a result of
that discussion, but they will improve the code.


When sending new versions of the patch, please send them to

Andrew Morton <akpm@linux-foundation.org>
James Bottomley <James.Bottomley@steeleye.com>
linux-scsi@vger.kernel.org
linux-kernel@vger.kernel.org

The way this driver will enter the 2.6 kernel is from you, into James's
scsi-misc git tree and then from James's scsi-misc tree into Linus's git
tree.  It is possible that I'll take a copy into my -mm tree for some early
testing but it is unlikely that I would send a scsi patch directly into
Linus - James does that.


Thanks.
