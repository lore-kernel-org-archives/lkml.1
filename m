Return-Path: <linux-kernel-owner+w=401wt.eu-S1758038AbZEEAFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038AbZEEAFD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 20:05:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbZEEAEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 20:04:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753946AbZEEAEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 20:04:51 -0400
Date: Mon, 4 May 2009 16:54:06 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged
 processes
In-Reply-To: <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0905041646240.4983@localhost.localdomain>
References: <20090504125114.5e391564@chukar> <alpine.LFD.2.01.0905041159480.4983@localhost.localdomain> <20090504125124.0f469970@infradead.org> <m1vdogbows.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 4 May 2009, Linus Torvalds wrote:
> 
> Quite frankly, the way "get_random_bytes()" works now (it does a _full_ 
> sha thing every time), I think it's insane overkill. But I do have to 
> admit that our current "get_random_int()" is insane _underkill_.

Actually, I don't think "get_random_int()" is underkill per se (it does 
that half md4 transform to try to hide the source of the data), but the 
data itself is simply not modified at all, and the buffers aren't updated 
in between rounds.

In fact "secure_ip_id()" (which it uses) explicityl does that private 
hash[] array so that the mixing that "half_md4_transform()" does do will 
_not_ be saved for the next round - so the next round will always start 
from the same keyptr "secret" state.

I think.

If that wasn't the case, and we actually kept mixing up the end result 
back into the next iteration, I suspect the current "get_random_int()" 
wouldn't be _nearly_ as bad as it is now. 

Or maybe I'm missing some part of the transform, and we do mix the values 
back as we do that "get_random_int()". I just don't see it. And if I'm 
right, then I think _that_ is the real weakness of our current 
get_random_int().

			Linus
