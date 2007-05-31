Return-Path: <linux-kernel-owner+w=401wt.eu-S1758455AbXEaCwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455AbXEaCwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 22:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbXEaCvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 22:51:55 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:58197 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504AbXEaCvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 22:51:54 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, ak@suse.de, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Zou, Nanhai" <nanhai.zou@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Packard, Keith" <keith.packard@intel.com>
Subject: Re: [patch] x86_64, irq: check remote IRR bit before migrating level triggered irq
References: <20070518010119.GB12088@linux-os.sc.intel.com>
	<m1veeqjitm.fsf@ebiederm.dsl.xmission.com>
	<20070518180749.GA26081@linux-os.sc.intel.com>
Date: Wed, 30 May 2007 20:50:55 -0600
In-Reply-To: <20070518180749.GA26081@linux-os.sc.intel.com> (Suresh
	B. Siddha's message of "Fri, 18 May 2007 11:07:49 -0700")
Message-ID: <m1wsyp6700.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Siddha, Suresh B" <suresh.b.siddha@intel.com> writes:

> Eric,
>
> On Fri, May 18, 2007 at 07:40:53AM -0700, Eric W. Biederman wrote:
>> Still in any of those I don't see a problem with switching to edge
>> triggered mode and then back again.  Either Remote IRR will keep
>> it's current state or it will be cleared.   Remote IRR should not
>> get set (when it was clear) by such a procedure because that
>> would mess up the normal interrupt enable sequence that happens
>> on boot.  So I'm pretty certain toggling the edge bit is harmless
>> and it may actually clear Remote IRR for us.
> ...
>> 
>> I think going more the way that this code has gone on arch/i386 with
>> real functions is preferable.
>
> There is an issue with this suggestion. We have an inflight
> EOI broadcast msg to this IOAPIC (that got delayed but still alive) and
> that can cause problem if we use edge and back to level to reset remote IRR bit.
>
> If the vector number stays same during irq migration and if we reset remote
> IRR bit using the above method(edge and then back to level) during
> irq migration, then we have a problem. A new interrupt arriving on a new
> cpu will set the remote IRR bit and now the old inflight EOI broadcast
> reaches IOAPIC RTE(resetting the remote IRR bit, because the vector in the
> broadcast msg is same), while the kernel code still assumes that the remote
> IRR bit is still set. This will lead to more problems and issues.

Ok.  I will agree that if the level->edge->level switch does not reset
Remote_IRR and the EOI arrives in that window.  We have another condition
in which Remote_IRR can get stuck on.

Eric
