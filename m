Return-Path: <linux-kernel-owner+w=401wt.eu-S933913AbXC0RPr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913AbXC0RPr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 13:15:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933980AbXC0RPr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 13:15:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:4688 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933913AbXC0RPp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 13:15:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,335,1170662400"; 
   d="scan'208"; a="217319373:sNHT28355362"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
Date: Tue, 27 Mar 2007 10:15:22 -0700
Message-ID: <08FE5CC30C9A3F41BF819A502CF7BF6EF98178@fmsmsx411.amr.corp.intel.com>
In-Reply-To: <m1ejnay8sx.fsf@ebiederm.dsl.xmission.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
Thread-Index: AcdwiUW2gjOARs0pQfyf25kvBDj49QAAe7Tg
From: "Williams, Mitch A" <mitch.a.williams@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Grant Grundler" <grundler@parisc-linux.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
X-OriginalArrivalTime: 27 Mar 2007 17:15:23.0675 (UTC) FILETIME=[816546B0:01C77093]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote: 
>
>> Because enabling and disabling the MSI interrupt is done through
>> config space, and config space writes are not posted.  So we won't
>> see the problem that we do with MSI-X.
>
>Normally this is true.  However when we have  memory mapped pci config
>space the writes could very easily be posted.  Even if there aren't
>any Intel platforms that do it today other architectures might.

>From what I read in the spec, configuration writes are not ever posted.
They are a completely separate transaction type from memory writes, and
only memory writes are posted.  So there's no need to read-flush these.

>The more I think about this the more I think we should make mask and
>unmask do the read and set enable/disable to mask/unmask in the msi
>case.
>
>I think being a little more paranoid will result in slightly simpler
>more maintainable code, and not measurably affect performance.  I
>don't expect you are migrating irqs in a fast path.

Migrating IRQs happens in the fast path, but infrequently (every 10 
seconds or so).  However the mask function is called at EVERY interrupt,
so this change would be VERY expensive.

If the driver really needs to disable the interrupt, then it can call
irq_disable().  Otherwise, mask (as-is) should be fine -- it masks
the interrupt at the APIC, and the device's interrupt moderation
should take care of keeping it from generating interrupts right away.

-Mitch
