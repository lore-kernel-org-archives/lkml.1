Return-Path: <linux-kernel-owner+w=401wt.eu-S1756908AbYH2QGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908AbYH2QGU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYH2QGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:06:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506AbYH2QGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:06:11 -0400
Date: Fri, 29 Aug 2008 09:05:16 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4 -
 fix
In-Reply-To: <1219997592-9975-1-git-send-email-yhlu.kernel@gmail.com>
Message-ID: <alpine.LFD.1.10.0808290854000.3300@nehalem.linux-foundation.org>
References: <1219997592-9975-1-git-send-email-yhlu.kernel@gmail.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Yinghai Lu wrote:
>
> try to insert_resource second time, by expand the resource...

I would hold off on this unless it's shown to actually be needed. And _if_ 
it is needed, I would just make a new function for doing this all: 
"insert_resource_expand_to_fit()"

That said, I think the insert_resource()/__insert_resource() change is 
pretty ok. However, it doesn't follow the rules, and is racy. The rules 
for resources are:

 - the "internal" version (with the "__" prepended) is static to 
   resource.c, because it must not be called from outside, which is in 
   turn because:

 - it must be called with the lock taken by the caller, because otherwise 
   returning a "struct resource *" is racy - the resource is not protected
   by anything!

So the "insert_resource_expand_to_fit()" thing would look something like 
this:

	void insert_resource_expand_to_fit(struct resource *root, struct resource *new)
	{
		write_lock(&resource_lock);
		while (new->start && new->parent) {
			struct resource *conflict;

			conflict = __insert_resource(root, new);
			if (!conflict)
				break;
			if (conflict->start < new->start)
				new->start = conflict->start;
			if (conflict->end > new->end)
				new->end = conflict->end;
		}
		write_unlock(&resource_lock);
	}

but the above is obviously _totally_ untested.

		Linus
