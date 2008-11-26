Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbYKZXRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbYKZXRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 18:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbYKZXRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 18:17:45 -0500
Received: from www.tglx.de ([62.245.132.106]:36795 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752121AbYKZXRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 18:17:44 -0500
Date: Thu, 27 Nov 2008 00:16:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: eranian@gmail.com
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
In-Reply-To: <7c86c4470811261337ic1ea828me5e3ba0de469f4b6@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811262355100.3325@localhost.localdomain>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com>  <alpine.LFD.2.00.0811261143480.3325@localhost.localdomain>  <20081126140054.GX6703@one.firstfloor.org>  <alpine.LFD.2.00.0811262156390.3325@localhost.localdomain>
 <7c86c4470811261337ic1ea828me5e3ba0de469f4b6@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, stephane eranian wrote:
> > What a nonsense. We have a bitmask already. Why not iterate over the
> > bitmask and be done ?
> >
> 
> Bitmask can be sparsed. Num represents the number of bits we have to find.
> The idea is that we don't need to scan the entire bitmask, we stop as soon as
> we have found all the bits we care about (i.e., all the bits that are set).
> 
> Example:
>          num = 3
>      bitmask=0000000010001001
>                                     ^ we will iterate until we are
> done with that bit.

Errm.

#define for_each_bit(bit, addr, size) \
        for ((bit) = find_first_bit((addr), (size)); \
             (bit) < (size); \
             (bit) = find_next_bit((addr), (size), (bit) + 1))

find_first_bit() and find_next_bit() are single instructions on most
architectures. "size" is known upfront at setup time of the
context/set and can be cached.

This takes exactly 3 iterations, while your method needs 8. And it
gets worse with the following example:

Example:
  num = 1
  bitmask=1000 0000 0000 0000 0000 0000 0000 00000

          ^ you will iterate until we are done with that bit (32 times)
	 
  for_each_bit() will iterate exactly _once_.

Thanks,

	tglx
