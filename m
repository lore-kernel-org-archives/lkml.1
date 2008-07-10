Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbYGJMxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbYGJMxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 08:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754071AbYGJMxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 08:53:43 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:63861 "EHLO
	WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbYGJMxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 08:53:42 -0400
X-BigFish: VPS-39(zz1432R98dR7efV1805M179dR873fnzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K3SJT7-03-RQZ-01
Date: Thu, 10 Jul 2008 14:53:20 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 19/34] AMD IOMMU: add functions to send IOMMU commands
Message-ID: <20080710125320.GN14977@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com> <1214508490-29683-20-git-send-email-joerg.roedel@amd.com> <20080709190453.527535f7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080709190453.527535f7.akpm@linux-foundation.org>
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 10 Jul 2008 12:53:20.0189 (UTC) FILETIME=[EE07F6D0:01C8E28B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 07:04:53PM -0700, Andrew Morton wrote:
> On Thu, 26 Jun 2008 21:27:55 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:
> > +static int iommu_completion_wait(struct amd_iommu *iommu)
> > +{
> > +	int ret;
> > +	struct command cmd;
> > +	volatile u64 ready = 0;
> > +	unsigned long ready_phys = virt_to_phys(&ready);
> > +
> > +	memset(&cmd, 0, sizeof(cmd));
> > +	cmd.data[0] = LOW_U32(ready_phys) | CMD_COMPL_WAIT_STORE_MASK;
> > +	cmd.data[1] = HIGH_U32(ready_phys);
> > +	cmd.data[2] = 1; /* value written to 'ready' */
> > +	CMD_SET_TYPE(&cmd, CMD_COMPL_WAIT);
> > +
> > +	iommu->need_sync = 0;
> > +
> > +	ret = iommu_queue_command(iommu, &cmd);
> > +
> > +	if (ret)
> > +		return ret;
> > +
> > +	while (!ready)
> > +		cpu_relax();
> 
> I busywait is a big red flag.  An uncommented one is not acceptable IMO.
> 
> What is the maximum duration?

This depends on the hardware and how many commands have to be executed
before that command.

> Is it not possible to sleep and await an interrupt?

Yes it is. I plan to do so as an optimization to the current code. But
this needs changes to the address allocator to not allocate addresses
which have been freed but not yet flushed from the IOMMU TLB.

> Should we implement a timeout in case the hardware is busted?

This is the best I think. Ok, if the hardware is busted the whole
machine has a problem because DMA does not work reliably anymore. But I
will add a counter to that loop to have an emergency exit from it until
the optimization is implemented (which is a bit more work).

> > +	return 0;
> > +}
> > +
> > +static int iommu_queue_inv_dev_entry(struct amd_iommu *iommu, u16 devid)
> > +{
> > +	struct command cmd;
> 
> `command' was a poorly-chosen identifier for this structure.  Too generic.

Hmm, maybe iommu_cmd. I don't want the identifier too long like
amd_iommu_command because it is only used in that file and thus its
clear that it belongs to the amd_iommu.

Joerg


-- 
           |           AMD Saxony Limited Liability Company & Co. KG
 Operating |         Wilschdorfer Landstr. 101, 01109 Dresden, Germany
 System    |                  Register Court Dresden: HRA 4896
 Research  |              General Partner authorized to represent:
 Center    |             AMD Saxony LLC (Wilmington, Delaware, US)
           | General Manager of AMD Saxony LLC: Dr. Hans-R. Deppe, Thomas McCoy

