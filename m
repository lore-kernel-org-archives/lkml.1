Return-Path: <linux-kernel-owner+w=401wt.eu-S1757382AbYGKAF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382AbYGKAF7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 20:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754201AbYGKAFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 20:05:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59289 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753142AbYGKAFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 20:05:52 -0400
Date: Thu, 10 Jul 2008 16:59:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org,
       iommu@lists.linux-foundation.org, bhavna.sarathy@amd.com,
       Sebastian.Biemueller@amd.com, robert.richter@amd.com, joro@8bytes.org
Subject: Re: [PATCH 23/34] AMD IOMMU: add functions to find IOMMU device
 resources
Message-Id: <20080710165934.062e38e3.akpm@linux-foundation.org>
In-Reply-To: <20080710164644.GR14977@amd.com>
References: <1214508490-29683-1-git-send-email-joerg.roedel@amd.com>
	<1214508490-29683-24-git-send-email-joerg.roedel@amd.com>
	<20080709191827.dbdfcd96.akpm@linux-foundation.org>
	<20080710164644.GR14977@amd.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jul 2008 18:46:44 +0200 Joerg Roedel <joerg.roedel@amd.com> wrote:

> > > +static struct protection_domain *domain_for_device(u16 devid)
> > > +{
> > > +	struct protection_domain *dom;
> > > +	unsigned long flags;
> > > +
> > > +	read_lock_irqsave(&amd_iommu_devtable_lock, flags);
> > 
> > Why is this cheerfully undocumented lock irq-safe?  Is it ever taken from
> > IRQ context?
> 
> This function is called from the dma-mapping path. As far as I know the
> DMA mapping functions can be called from interrupt context.
> 
> > 
> > > +	dom = amd_iommu_pd_table[devid];
> > > +	read_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
> > > +
> > > +	return dom;
> > > +}
> > 
> > The locking in this function makes no sense.  We drop the lock then return
> > a value which the caller cannot use in a race-free fashion, because the
> > lock is no longer held.
> 
> The lock only protects the protection domain table (and the device
> table) itself. It does not protect the values the pointers in that list
> point to. In this case its also not racy because a value to that list is
> only written once and then never changed again (currently). If this
> changes in the future (and it will) I will change the locking too. This
> will also need reference counting for 'struct protection_domain' which
> is not implemented yet.

So no locking is needed in this function.
