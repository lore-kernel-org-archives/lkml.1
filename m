Return-Path: <linux-kernel-owner+w=401wt.eu-S1750878AbXCWDKJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878AbXCWDKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 23:10:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbXCWDKJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 23:10:09 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45420 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbXCWDKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 23:10:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: michael@ellerman.id.au
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       daniel.e.wolstenholme@intel.com
Subject: Re: [PATCH 17/21] MSI: Clear the irq_desc's msi pointer on free
References: <20070322105344.A34C6DDF74@ozlabs.org>
	<m1slbx8ihm.fsf@ebiederm.dsl.xmission.com>
	<1174604508.5401.7.camel@concordia.ozlabs.ibm.com>
Date: Thu, 22 Mar 2007 21:00:47 -0600
In-Reply-To: <1174604508.5401.7.camel@concordia.ozlabs.ibm.com> (Michael
	Ellerman's message of "Fri, 23 Mar 2007 10:01:48 +1100")
Message-ID: <m1y7lo64v4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman <michael@ellerman.id.au> writes:

> On Thu, 2007-03-22 at 08:23 -0600, Eric W. Biederman wrote:
>> Michael Ellerman <michael@ellerman.id.au> writes:
>> 
>> > Currently we never clear the msi_desc pointer in the irq_desc. This
>> > leaves us with a pointer to free'ed memory hanging around. No one seems
>> > to have hit this, so presumably other parts of the code are protecting
>> > us from ever using the stale pointer .. or we're just lucky, we should
>> > still clear it.
>> 
>> Hmm.  Maybe.  Currently this is done in dynamic_irq_cleanup,
>> at least for everything except sparc64.
>
> OK, I missed that. I still think we should do it here, otherwise there's
> a window, however small, where the msi_desc pointer is pointing at freed
> memory.

After following the code through the current cleanup happens before you are
proposing, and in fact the irq is return to the set of irq's that can
be allocated before you are calling set_irq_msi(irq, NULL).

Therefore you are doing this too late and we need to ensure the
architecture code does this in arch_teardown_msi_irq.

Eric
