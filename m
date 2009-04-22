Return-Path: <linux-kernel-owner+w=401wt.eu-S1752991AbZDVWsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991AbZDVWsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 18:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750960AbZDVWsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 18:48:04 -0400
Received: from tomts5.bellnexxia.net ([209.226.175.25]:62262 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZDVWsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 18:48:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoKAFc270lMQW1W/2dsb2JhbACBT5VMuWuDdAY
Date: Wed, 22 Apr 2009 18:47:49 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, mark.langsdorf@amd.com, arekm@maven.pl,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       Avi Kivity <avi@qumranet.com>
Subject: Re: [patch 2/2] x86 amd fix cmpxchg read acquire barrier
Message-ID: <20090422224749.GA22718@Krystal>
References: <20090422201852.092307236@polymtl.ca> <20090422202453.829846363@polymtl.ca> <20090422215913.67c1298e@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090422215913.67c1298e@lxorguk.ukuu.org.uk>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:34:36 up 53 days, 19:00,  2 users,  load average: 0.59, 0.26,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > There is no official AMD bug ID yet, but it seems to be reported in the field
> > and a fix is present in Solaris code base. The following links shows the current
> > understanding of the issue.
> 
> I would like to know why there isn't an official vendor Bug ID yet
> because without that nobody knows what the fix actually is or when it is
> needed.

I guess AMD should answer to this.

> It's also not going to help much given the user space problem
> (and mixed kernel/user stuff like futexes).

Yeah, ideally, unless user-space is completely audited, the kernel
should restrict multi-threaded user-space programs to run on a single
CPU unless they don't share any memory mapping when the kernel finds it
is running on such broken CPU. Or it can simply refuse to bring up more
than one CPU. That would be a very basic gross fix for a gross problem,
but at least there would be no data corruption. If we use this last
solution, then my cmpxchg lfence workaround becomes unneeded.

> Second point - it needs to be possible to avoid compiling this stuff in
> the first place. I don't see where you arrange CMPXCHNG_LFENCE to come
> out as blank when people compile for processors without the bug ?
> 

Good point. I should probably configure this as "nothing" unless

#ifdef CONFIG_X86_64
#if (defined(CONFIG_GENERIC_CPU) || defined(CONFIG_MK8))
...
#endif
#endif

I doubt it's worth adding a "HAVE_MISSING_CMPXCHG_LFENCE" select.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
