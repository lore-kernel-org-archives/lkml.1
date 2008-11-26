Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699AbYKZVgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699AbYKZVgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 16:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbYKZVg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 16:36:27 -0500
Received: from mx2.redhat.com ([66.187.237.31]:43100 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbYKZVg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 16:36:26 -0500
Message-ID: <492DC13F.8020009@redhat.com>
Date: Wed, 26 Nov 2008 23:35:59 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Alexander van Heukelum <heukelum@fastmail.fm>, lguest@ozlabs.org,
       jeremy@xensource.com, LKML <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Ingo Molnar <mingo@elte.hu>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Lguest] [PATCH RFC/RFB] x86_64,	i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com>	<20081104150729.GC21470@localhost>	<20081104170501.GE29626@one.firstfloor.org>	<1225822006.21441.1282961299@webmail.messagingengine.com>	<20081104204400.GC10825@elte.hu>	<1226243805.27361.1283784629@webmail.messagingengine.com> <49178E89.2000307@zytor.com>
In-Reply-To: <49178E89.2000307@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Here is a prototype patch of the compressed IRQ stubs -- this patch
> compresses them down to 7 stubs per 32-byte cache line (or part of cache
> line) at the expense of a back-to-back jmp which has the potential of
> being ugly on some pipelines (we can only get 4 stubs into 32 bytes
> without that).
>   

You could actually get 4-byte stubs, using a 16-bit call (66 e8 ww ww).  
But it would be slower, since we won't be pairing it with a ret.

I suspect we could get it down to three bytes, by sharing the last byte 
of the four-byte call sequence with the first byte of the next:

  66 e8 ff 66 e8 fc 66 e8 f9 66 e8 f6 ...

Every three bytes a new stub begins; it's a four-byte call to offset 
0x6703 relative to the beginning of the first stub.

Can anyone better 24 bits/stub?

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

