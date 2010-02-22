Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab0BVRPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 12:15:25 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:60426 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab0BVRPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 12:15:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UAGiXwyrJJA/hhSt6qPoPJdFJxdN1kUI58jFhaoyKzE6fpOcf4ojJ7/trgnAgjKOZa
         BuWE1sGWk8d+pXzkSbMJ9tBHeT4Rrj+XOxo0KtuOHpMLu/Q6tcJHZRmfXvOZQKjnVBoJ
         qu0zdYp5414ebIzWcMWs5xjqLc5iznuX4CwhY=
Date: Mon, 22 Feb 2010 18:15:20 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20100222171518.GD5055@nowhere>
References: <20100222165052.GA14352@elte.hu> <alpine.LFD.2.00.1002220856280.4141@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002220856280.4141@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 09:01:39AM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 22 Feb 2010, Ingo Molnar wrote:
> > 
> > The reason i'm sending them post -rc8 is the fix for the Wine breakage from 
> > Frederic, which would be nice to see resolved in -final.
> 
> Umm. That commit seems to be crap.
> 
> Yes, it was wrong to not allow a NULL address breakpoint. But if you call 
> kallsyms_lookup_name(), you should check the "I couldn't find it" end 
> result for _that_ case, and 0 is the correct check there.
> 
> So the code _should_ do something like
> 
> 	if (info->name) {
> 		info->address = kallsyms_lookup_name(info->name);
> 		if (!info->address)
> 			return -EINVAL;
> 	}
> 
> and that would correctly handle both the NULL original address _and_ the 
> name lookup failure.



Ah you're right. That part in itself is buggy. Fortunately this won't ever
be reached because we don't use the info->name field anymore . It's a field I
forgot to remove when I re-adapted the new hw-breakpoint API on top of perf.
The name resolution (used by the ksym tracer and the hw-breakpoint sample
only) is done in an upper layer now, and never stored in the arch back end in any
case.

I'll remove this field and the associated dead-code for .34

Thanks.

