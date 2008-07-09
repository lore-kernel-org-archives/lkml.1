Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbYGIWai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbYGIWai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751522AbYGIWaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:30:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52506 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbYGIWaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:30:30 -0400
Message-ID: <48753A71.2030006@zytor.com>
Date: Wed, 09 Jul 2008 18:23:45 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>
In-Reply-To: <m1r6a2r9nj.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>>>
>> CONFIG_PHYSICAL_START rather.  And no, it can't be zero!  Realistically we
>> should make it 16 MB by default (currently 2 MB), to keep the DMA zone clear.
> 
> Also on x86_64 CONFIG_PHYSICAL_START is irrelevant as the kernel text segment
> is liked at a fixed address -2G and the option only determines the virtual
> to physical address mapping.
> 

No, it's not irrelevant; we currently base the kernel at virtual address 
-2 GB (KERNEL_IMAGE_START) + CONFIG_PHYSICAL_START, in order to have the 
proper alignment for large pages.

Now, it probably wouldn't hurt moving KERNEL_IMAGE_START up a bit to 
have low positive values safer to use.

> That said the idea may not be too far off.
> 
> Potentially we could put the percpu area at our fixed -2G address and then
> we have a constant (instead of an address) we could subtract from this address.

We can't put it at -2 GB since the offset +40 for the stack sentinel is 
hard-coded into gcc.  This leaves growing upward from +48 (or another 
small positive number), or growing down from zero (or +40) as realistic 
options.

Unfortunately, GNU ld handles grow-down not at all.

	-hpa
