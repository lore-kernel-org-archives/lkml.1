Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbZANRvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbZANRvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 12:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZANRvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 12:51:33 -0500
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:60201 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752166AbZANRvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 12:51:32 -0500
Message-ID: <496E261F.9000803@rsk.demon.co.uk>
Date: Wed, 14 Jan 2009 17:51:27 +0000
From: richard kennedy <richard@rsk.demon.co.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Kyle McMartin <kyle@infradead.org>
CC: Takashi Iwai <tiwai@suse.de>, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] module: kzalloc mod->ref
References: <20090114033533.GL25103@bombadil.infradead.org> <s5hmydufe3c.wl%tiwai@suse.de> <20090114155859.GO25103@bombadil.infradead.org>
In-Reply-To: <20090114155859.GO25103@bombadil.infradead.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle McMartin wrote:
> On Wed, Jan 14, 2009 at 10:09:59AM +0100, Takashi Iwai wrote:
>> At Tue, 13 Jan 2009 22:35:33 -0500,
>> Kyle McMartin wrote:
>>> From: Kyle McMartin <kyle@redhat.com>
>>>
>>> Dynamically allocate mod->ref instead of fixing it in the struct module.
>>> Reduces on disk space wasted in the module .ko, and kills a loop
>>> initializing the local_t it contains since we can just kzalloc it.
>>>
>>> This matters when we're talking about large NR_CPUS.
>>>
>>> Signed-off-by: Kyle McMartin <kyle@redhat.com>
>>> ---
>>> The patch removing cacheline_aligned from struct module_ref should be
>>> applied as well to cut down on the amount of memory we allocate. This
>>> patch makes a nice stopgap until we have per_cpu module references.
>>>
>>> cheers, Kyle
>> Similar patches (including mine) have been already posted, but no
>> proceed until now...
>> 	http://lkml.org/lkml/2008/11/11/315
> 
> Ah, sigh.
> 
> It would be nice to get this sorted out, since we're serious wasting
> disk space for no good reason...
> 
> Although as Richard points out, dropping the cacheline_aligned might
> drop networking performance (which, sigh, is also stupid) but allocating
> 128b * NR_CPUS is just a ridiculous amount of memory to waste for a
> reference count...
> 
Aside from the code in socket does this reference count really get used
that often? Atomic_t gets used for ref counts is lots of other places in
the kernel, so why not turn module_ref into an atomic counter & drop the
array entirely saving all of the memory & disk space?

I do wonder if socket could manage its module lifetimes in some other
way, then we really could just use an atomic module ref without too much
impact. I didn't get very far in trying to work out what exactly was
going on in socket.c but maybe it's worth another look.

I don't have any network test harness so it's difficult to tell what
impact any code change is going to have. Do you have any suggestions for
a good test of this?

regards
Richard


