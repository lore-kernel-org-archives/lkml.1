Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbZEOSv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbZEOSv3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 14:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbZEOSuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 14:50:54 -0400
Received: from gw.goop.org ([64.81.55.164]:60747 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756781AbZEOSuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 14:50:51 -0400
Message-ID: <4A0DB988.6000009@goop.org>
Date: Fri, 15 May 2009 11:50:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: Ingo Molnar <mingo@elte.hu>, Jun Nakajima <jun.nakajima@intel.com>,
       Xiaohui Xin <xiaohui.xin@intel.com>, Xin Li <xin.li@intel.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] Performance overhead of paravirt_ops on		 nativeidentified
References: <4A0B62F7.5030802@goop.org> <4A0BED040200007800000DB0@vpn.id2.novell.com> <4A0C58BB.3090303@goop.org> <4A0D3F8C02000078000010A7@vpn.id2.novell.com>
In-Reply-To: <4A0D3F8C02000078000010A7@vpn.id2.novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> A patch for the pv-ops kernel would require some time. What I can give you
> right away - just for reference - are the sources we currently use in our kernel:
> attached.

Hm, I see.  Putting a call out to a pv-ops function in the ticket lock 
slow path looks pretty straightforward.  The need for an extra lock on 
the contended unlock side is a bit unfortunate; have you measured to see 
what hit that has?  Seems to me like you could avoid the problem by 
using per-cpu storage rather than stack storage (though you'd need to 
copy the per-cpu data to stack when handling a nested spinlock).

What's the thinking behind the xen_spin_adjust() stuff?

> static __always_inline void __ticket_spin_lock(raw_spinlock_t *lock) { 
> unsigned int token, count; bool free; __ticket_spin_lock_preamble; if 
> (unlikely(!free)) token = xen_spin_adjust(lock, token); do { count = 1 
> << 10; __ticket_spin_lock_body; } while (unlikely(!count) && 
> !xen_spin_wait(lock, token)); } 


How does this work?  Doesn't it always go into the slowpath loop even if 
the preamble got the lock with no contention?

    J
