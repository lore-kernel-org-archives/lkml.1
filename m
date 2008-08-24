Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbYHXSE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbYHXSE0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 14:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752490AbYHXSER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 14:04:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36920 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752013AbYHXSEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 14:04:16 -0400
Date: Sun, 24 Aug 2008 11:03:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Vegard Nossum <vegard.nossum@gmail.com>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.27-rc4-git1: Reported regressions from 2.6.26
In-Reply-To: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
Message-ID: <alpine.LFD.1.10.0808241050180.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Aug 2008, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11410
> Subject		: SLUB list_lock vs obj_hash.lock...
> Submitter	: Daniel J Blueman <daniel.blueman@gmail.com>
> Date		: 2008-08-22 21:48 (2 days old)
> References	: http://marc.info/?l=linux-kernel&m=121944176609042&w=4

This one now has a suggested patch for Daniel to try from Vegard, but no 
reply yet:

	http://marc.info/?l=linux-kernel&m=121946972307110&w=4

Vegard, I think your patch is a bit odd, though. The result of your patch 
is

 - first loop:

	hlist_for_each_entry_safe(obj, node, tmp, &db->list, node) {
		hlist_del(&obj->node);
		hlist_add_head(&obj->node, &freelist);
	}

   and quite frankly, I don't see what the difference between that and a 
   something like a simple

	struct hlist_node *first = bd->list.first;
	if (first) {
		bd->list.first = NULL;
		first->pprev = &first;
	}

   really is?

I dunno. We don't have list splicing ops for the hlist things.

		Linus
