Return-Path: <linux-kernel-owner+w=401wt.eu-S934259AbXC1BPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934259AbXC1BPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 21:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934344AbXC1BPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 21:15:39 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36879 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934259AbXC1BPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 21:15:38 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Williams, Mitch A" <mitch.a.williams@intel.com>
Cc: "Grant Grundler" <grundler@parisc-linux.org>,
       <linux-pci@atrey.karlin.mff.cuni.cz>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
Subject: Re: [PATCH 2.6.21-rc5] MSI: read-flush MSI-X table
References: <08FE5CC30C9A3F41BF819A502CF7BF6EF98580@fmsmsx411.amr.corp.intel.com>
Date: Tue, 27 Mar 2007 19:14:37 -0600
In-Reply-To: <08FE5CC30C9A3F41BF819A502CF7BF6EF98580@fmsmsx411.amr.corp.intel.com>
	(Mitch A. Williams's message of "Tue, 27 Mar 2007 14:43:55 -0700")
Message-ID: <m14po6w4n6.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Williams, Mitch A" <mitch.a.williams@intel.com> writes:

> Doh!  I was reading the code wrong.  We only mask if we're still
> handling a previous interrupt on the same vector.  My bad.
>
> However, I can't really see where mask() is used outside of that
> instance.  Which then leads us back to the question:  do we need
> a read flush on mask/unmask or just enable/disable?

I'm not even certain we need the read flush in the enable.
However having it in there makes the code easier to reason
about.  Which is a big plus.

Generally if the interrupt controller hardware is sane 
mask/unmask and enable/disable should be the same function.

If we need to work around something in the hardware enable/disable
should do that and mask/unmask should poke the hardware.

Since MSI is specified as properly handle pending interrupts
I would put the write flush in mask.  It makes the code easier
to understand and comprehend.

The practical question in my book is do we set the enable/disable
methods to the same functions as the mask/unmask methods or
do we let them default to the crazy delayed disable scenario.

Given that we do have a tiny race where we need to ensure the
MSI is disabled before we unregister it, we don't know of any
MSI implementation problems that will result in a screaming IRQ.
I would say set enable/disable to the mask/unmask methods.

This will fix the tiny freeing bug mentioned above, and not play
games with drivers that are using MSI irqs.

If at some point we need a lesser form someone can change the msi
enable/disable methods to something else.

Eric
