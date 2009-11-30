Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbZK3QHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbZK3QHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbZK3QHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:07:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36138 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752460AbZK3QHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:07:16 -0500
Date: Mon, 30 Nov 2009 08:07:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul McKenney <paulmck@us.ibm.com>
Subject: Re: [rfc] "fair" rw spinlocks
In-Reply-To: <20091130154031.GE21639@wotan.suse.de>
Message-ID: <alpine.LFD.2.00.0911300754420.2872@localhost.localdomain>
References: <20091123145409.GA29627@wotan.suse.de> <alpine.LFD.2.00.0911280927180.2561@localhost> <20091130075557.GI17484@wotan.suse.de> <alpine.LFD.2.00.0911300706420.2872@localhost.localdomain> <20091130154031.GE21639@wotan.suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Nov 2009, Nick Piggin wrote:
> 
> Well the simple thing I tried earlier was a per-cpu array of nesting
> counter there. It's not _too_ expensive, but it does add another cacheline
> access and branch there. It seems to work in solving the livelock though.

So how did you do the nesting counter? Afaik, it needs to be something 
like

	local_irq_save(flags);
	if (!get_cpu_var(tasklist_counter)++)
		spin_lock(&tasklist_lock);
	local_irq_restore(flags);

on the read_lock side (and the same in reverse on unlock). Which seems 
quite a bit more expensive than what we have now. Especially on UP, but I 
guess you can make it conditional on CONFIG_SMP (but that won't help 
generic kernels).

				Linus
