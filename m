Return-Path: <linux-kernel-owner+w=401wt.eu-S1763329AbXKUBgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763329AbXKUBgs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 20:36:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbXKUBgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 20:36:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbXKUBgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 20:36:38 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [rfc 08/45] cpu alloc: x86 support
Date: Wed, 21 Nov 2007 02:36:33 +0100
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
References: <20071120011132.143632442@sgi.com> <Pine.LNX.4.64.0711201607460.29220@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0711201703570.29648@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0711201703570.29648@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711210236.33460.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 November 2007 02:16:11 Christoph Lameter wrote:
> But one can subtract too... 

The linker cannot subtract (unless you add a new relocation types) 

> Hmmm... So the cpu area 0 could be put at 
> the beginning of the 2GB kernel area and then grow downwards from 
> 0xffffffff80000000. The cost in terms of code is one subtract
> instruction for each per_cpu() or CPU_PTR()
> 
> The next thing doward from 0xffffffff80000000 is the vmemmap at 
> 0xffffe20000000000, so ~32TB. If we leave 16TB for the vmemmap
> (a 16TB vmmemmap be able to map 2^(44 - 6 + 12) = 2^50 bytes 
> more than currently supported by the processors)
> 
> then the remaining 16TB could be used to map 1GB per cpu for a 16k config. 
> That is wildly overdoing it. Guess we could just do it with 1M anyways. 
> Just to be safe we could do 128M. 128M x 16k = 2TB?
> 
> Would such a configuration be okay?

I'm not sure I really understand your problem.

All you need is a 2MB area (16MB is too large if you really
want 16k CPUs someday) somewhere in the -2GB or probably better
in +2GB. Then the linker puts stuff in there and you use
the offsets for referencing relative to %gs.

But %gs can be located wherever you want in the end,
at a completely different address than you told the linker.
All you're interested in were offsets anyways.

Then for all CPUs (including CPU #0) you put the real mapping
somewhere else, copy the reference data there (which also doesn't need
to be on the offset the linker assigned, just on a constant offset
from it somewhere in the normal kernel data) and off you go.

Then the reference data would be initdata and eventually freed.
That is similar to how the current per cpu data works.

-Andi
