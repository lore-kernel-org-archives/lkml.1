Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbXLGA30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbXLGA30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 19:29:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752405AbXLGA3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 19:29:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60188 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbXLGA3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 19:29:18 -0500
Date: Thu, 6 Dec 2007 16:32:04 -0800
From: Greg KH <greg@kroah.com>
To: Badari Pulavarty <pbadari@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, rsa@us.ibm.com, apw@shadowen.org,
       balbir@in.ibm.com
Subject: Re: 2.6.24-rc4-mm1 kobject changes broken with hvcs driver on
	powerpc
Message-ID: <20071207003204.GA11947@kroah.com>
References: <20071204211701.994dfce6.akpm@linux-foundation.org> <20071205141202.GB13189@linux.vnet.ibm.com> <47583D4F.2050707@linux.vnet.ibm.com> <20071206185006.GA21641@kroah.com> <47584672.8040201@linux.vnet.ibm.com> <20071206203118.GA28618@kroah.com> <1196985291.18388.19.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196985291.18388.19.camel@dyn9047017100.beaverton.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 06, 2007 at 03:54:51PM -0800, Badari Pulavarty wrote:
> On Thu, 2007-12-06 at 12:31 -0800, Greg KH wrote:
> > On Fri, Dec 07, 2007 at 12:28:58AM +0530, Balbir Singh wrote:
> > > Greg KH wrote:
> > > 
> > > >> Why release the spinlock here? It's done after the count is incremented.
> > > >> This patch does not seem correct.
> > > > 
> > > > Doh, you are correct, I'll make sure that I fix this up before applying
> > > > it.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > 
> > > Hi, Greg,
> > > 
> > > I ran some tests with the fixed up version of this patch and the system
> > > fails to come up.
> > > 
> > > I see the WARN_ON in lib/kref.c:33 and the system fails to boot beyond
> > > that point. I have not yet found time to debug it though.
> > 
> > That's not good, that warning means that someone has tried to use this
> > kref _before_ it was initialized, so there is a logic error in the code
> > that was previously being papered over with the lack of this message in
> > the kobject code.
> > 
> > I do have this same message availble as a patch for the kobject core, it
> > would be interesting if you could just run 2.6.24-rc4 with just this
> > patch:
> > 	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-01-driver/kobject-warn.patch
> > 
> > it might take some fuzz to fit properly, but all you really want to do
> > is add:
> > 	WARN_ON(atomic_read(&kobj->kref.refcount));
> > before the kref_init() call in kobject_init().
> > 
> > thanks,
> > 
> > greg k-h
> 
> 2.6.24-rc4 with above patch booted fine without any warnings. 
> But 2.6.24-rc4-mm1 doesn't boot, it hangs after following messages.
> 
> 
> e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
> e100: Copyright(c) 1999-2006 Intel Corporation
> ipr: IBM Power RAID SCSI Device Driver version: 2.4.1 (April 24, 2007)
> ipr 0000:d0:01.0: Found IOA with IRQ: 119
> ipr 0000:d0:01.0: Starting IOA initialization sequence.
> ipr 0000:d0:01.0: Adapter firmware version: 020A005E
> ipr 0000:d0:01.0: IOA initialized.
> scsi0 : IBM 570B Storage Adapter
> scsi 0:0:3:0: Direct-Access     IBM   H0 HUS103014FL3800  RPQF PQ: 0 ANSI: 4
> scsi 0:0:5:0: Direct-Access     IBM   H0 HUS103014FL3800  RPQF PQ: 0 ANSI: 4
> scsi 0:0:8:0: Direct-Access     IBM   H0 HUS103014FL3800  RPQF PQ: 0 ANSI: 4
> scsi 0:0:15:0: Enclosure         IBM      VSBPD4E2  U4SCSI 7134 PQ: 0 ANSI: 2
> ------------[ cut here ]------------
> Badness at lib/kref.c:33
> NIP: c0000000002e1254 LR: c0000000002dfbd8 CTR: c0000000002e60f0
> REGS: c00000003f0db050 TRAP: 0700   Not tainted  (2.6.24-rc4-mm1)
> MSR: 8000000000029032 <EE,ME,IR,DR>  CR: 28002042  XER: 0000000f
> TASK = c00000003f0d78d0[1] 'swapper' THREAD: c00000003f0d8000 CPU: 0
> GPR00: 0000000000000000 c00000003f0db2d0 c000000000724098 c00000003f131620
> GPR04: fffffffffffffff1 fffffffffffffffe 000000000000000a ffffffffffffffff
> GPR08: c00000003d4d9000 c00000003f0cbfe0 c000000000556591 0000000000000073
> GPR12: 0000000024002084 c000000000651980 0000000000000000 0000000000000000
> GPR16: 0000000000000000 d000080080080000 c00000000064d6f0 c00000003d4d9570
> GPR20: c00000003d4d94b8 0000000000000002 c00000003d4d9170 c00000003d4d9170
> GPR24: c00000003d4d9000 0000000000000001 c00000003d570d58 c00000003d570d18
> GPR28: 0000000000000000 c00000003d4d9260 c0000000006b5400 c00000003f131618
> NIP [c0000000002e1254] .kref_get+0x10/0x2c
> LR [c0000000002dfbd8] .kobject_get+0x24/0x40
> Call Trace:
> [c00000003f0db2d0] [c00000003f0db360] 0xc00000003f0db360 (unreliable)
> [c00000003f0db350] [c0000000002e00e8] .kobject_add+0x8c/0x21c
> [c00000003f0db3e0] [c000000000344b00] .device_add+0xd4/0x680
> [c00000003f0db4a0] [c0000000003a1c4c] .scsi_alloc_target+0x218/0x404
> [c00000003f0db570] [c0000000003a1fb4] .__scsi_scan_target+0xa8/0x640
> [c00000003f0db6b0] [c0000000003a25c4] .scsi_scan_channel+0x78/0xdc
> [c00000003f0db750] [c0000000003a26f8] .scsi_scan_host_selected+0xd0/0x140
> [c00000003f0db7f0] [c0000000003c3ff4] .ipr_probe+0x1270/0x1348

This looks like a scsi issue to me, I don't see how the kref changes
could cause this backtrace/oops, do you?

thanks,

greg k-h
