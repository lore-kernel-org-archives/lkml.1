Return-Path: <linux-kernel-owner+w=401wt.eu-S932729AbXF2CPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932729AbXF2CPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 22:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765080AbXF2CPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 22:15:41 -0400
Received: from smtp-out.google.com ([216.239.33.17]:45114 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765064AbXF2CPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 22:15:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=pwlouuFTMa5BdXA4xkUsglGMD5dJ7IyPX5atn+EBG9Adsu+XVGfK4RAZu+S+SchIF
	3nY75bLpKomZ5Jy2tRy/Q==
Date: Thu, 28 Jun 2007 19:15:14 -0700 (PDT)
From: Joshua Wise <jwise@google.com>
X-X-Sender: jwise@internets.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org,
       thockin@google.com, mikew@google.com, masouds@google.com
Subject: Re: [PATCH] [revised -- version 2] Info dump on Oops or panic()
In-Reply-To: <20070628164855.012344cd.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706281850490.617@internets.corp.google.com>
References: <Pine.LNX.4.64.0706281502350.617@internets.corp.google.com>
 <20070628221835.GI2784@fattire.cabal.ca> <Pine.LNX.4.64.0706281603590.617@internets.corp.google.com>
 <20070628164855.012344cd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jun 2007, Andrew Morton wrote:
> Your email client is doing space-stuffing.  It's easy enough to fix at this
> end, but even easier if you fix it ;)

Aw darn :( Stupid PINE. I'll fix it for the next patch.

>> +	atomic_notifier_call_chain(&info_dumper_list, 0, NULL);
[...]
> So...  Please consider abandoning the notifier-chain and just go for a
> simple function call.


As we discovered some minutes ago, there appears to be infrastructure for this
already -- the die_chain. For thsoe of you who don't know, the die_chain
gets called from notify_die. It exists on almost all architectures. On i386,
it gets called from die() on arch/i386/kernel/traps.c:417 -- before
registers are scrolled by. So, if we want our own specific output there,
like utsname or uptime, then we can get it.

There exists a DIE_PANIC type on some architectures, but it's never actually
... used. So, I will probably write a patch to add it on all architectures,
and use it in the panic routines.

>> +ATOMIC_NOTIFIER_HEAD(info_dumper_list);
>> +EXPORT_SYMBOL(info_dumper_list);
>
> That export isn't needed.

If I want someone else to access it, like a module, it is... But, I guess
if I wanted to act as per canon, I should just do register functions, and
export those. On the die_chain, those are EXPORT_SYMBOL_GPL, FWIW

> Again, a deref of current->nsproxy->uts_ns->name at oops-time has risks.
>
> This string could be precalculated, no?

Yes, and will be.

> I don't know what to do here.  It will be hard to find a read-the-time
> function which is a) lockless and b) available on all architectures and
> configs.
>
> If you can find a way to use plain old jiffies, that'd be good.

jiffies sounds good enough to me.

There seems to be some opposition to the utsname and uptime patches. I'll
take a look at those here and see what I can do to make those a little more
pleasing to non-Google users. Expect a patch for DIE_PANIC tomorrow...

joshua

