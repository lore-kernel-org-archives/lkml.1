Return-Path: <linux-kernel-owner+w=401wt.eu-S1759053AbZAVW2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbZAVW2a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 17:28:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbZAVW2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 17:28:16 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:39248 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753595AbZAVW2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 17:28:15 -0500
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
From: Zachary Amsden <zach@vmware.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "jeremy@xensource.com" <jeremy@xensource.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>
In-Reply-To: <4977A051.8050203@goop.org>
References: <20090120110542.GE19505@wotan.suse.de>
	 <20090120112634.GA20858@elte.hu> <20090120140324.GA26424@elte.hu>
	 <49763806.5090009@goop.org> <20090120205653.GA19710@elte.hu>
	 <20090121072718.GN24891@wotan.suse.de>  <4977A051.8050203@goop.org>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 14:28:31 -0800
Message-Id: <1232663311.16317.176.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-21 at 14:23 -0800, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > Oh, _llc_ references/misses? Ouch.
> >
> > You have, what 32K L1I, 32K L1D, and 4MB L2? And even this microbenchmark
> > is seeing increased L2 misses by nearly 3%. Hmm, I wonder where that is
> > coming from? Instruction fetches?
> >   
> 
> I assume so.  There should be no extra data accesses with 
> CONFIG_PARAVIRT (hm, there's probably some extra stack/spill traffic, 
> but I surely hope that's not falling out of cache).

These fragments, from native_pgd_val, certainly don't help:

c0120f60:       55                      push   %ebp
c0120f61:       89 e5                   mov    %esp,%ebp
c0120f63:       5d                      pop    %ebp
c0120f64:       c3                      ret
c0120f65:       8d 74 26 00             lea    0x0(%esi,%eiz,1),%esi
c0120f69:       8d bc 27 00 00 00 00    lea    0x0(%edi,%eiz,1),%edi

That is really disgusting.  We absolutely should be patching away the
function calls here in the native case.. not sure we do that today.

Zach

