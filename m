Return-Path: <linux-kernel-owner+w=401wt.eu-S932634AbXC0QCm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634AbXC0QCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:02:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932504AbXC0QCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:02:41 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:39323 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634AbXC0QCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:02:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Williams, Mitch A" <mitch.a.williams@intel.com>
Cc: "Grant Grundler" <grundler@parisc-linux.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
References: <08FE5CC30C9A3F41BF819A502CF7BF6EF97F5E@fmsmsx411.amr.corp.intel.com>
Date: Tue, 27 Mar 2007 10:01:50 -0600
In-Reply-To: <08FE5CC30C9A3F41BF819A502CF7BF6EF97F5E@fmsmsx411.amr.corp.intel.com>
	(Mitch A. Williams's message of "Tue, 27 Mar 2007 08:31:09 -0700")
Message-ID: <m1ejnay8sx.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Williams, Mitch A" <mitch.a.williams@intel.com> writes:

> Grant Grundler wrote: 
>
>>Why wouldn't MSI have the same problems as MSI-X?
>>
>
> Because enabling and disabling the MSI interrupt is done through
> config space, and config space writes are not posted.  So we won't
> see the problem that we do with MSI-X.

Normally this is true.  However when we have  memory mapped pci config
space the writes could very easily be posted.  Even if there aren't
any Intel platforms that do it today other architectures might.

The more I think about this the more I think we should make mask and
unmask do the read and set enable/disable to mask/unmask in the msi
case.

Ugh.  Looking closer the function should really be called msi_flush
or msi_flush_writes not msix_flush_writes.

William do you think you can fix any of that up?
That is name the function msi_flush_writes and call it from
mask_msi_irq/unmask_msi_irq.

I think being a little more paranoid will result in slightly simpler
more maintainable code, and not measurably affect performance.  I
don't expect you are migrating irqs in a fast path.

Eric
