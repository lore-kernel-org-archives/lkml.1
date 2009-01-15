Return-Path: <linux-kernel-owner+w=401wt.eu-S1756408AbZAOJC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408AbZAOJC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbZAOJB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:01:59 -0500
Received: from mail-ew0-f31.google.com ([209.85.219.31]:46311 "EHLO
	mail-ew0-f31.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZAOJB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:01:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dJxyvQeclxknE6PvhEPA/OeCVtMYojtIAUWYwdhGiKF7iQNGXZ3j3sz+Pm/QJe6ZZH
         +chcTUK89JYwajZ2tx7RsCnp7b37u1/TeH1MHQJOJMro8SabfLe5AowcnP504JLvEu7V
         JB2HmOb5gaKrH+kQgPxHihhS8F7+EbQhXGyzM=
Date: Thu, 15 Jan 2009 09:01:20 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Denys Fedoryschenko <denys@visp.net.lb>, Chris Caputo <ccaputo@alt.net>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Badalian Vyacheslav <slavon@bigtelecom.ru>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: deadlocks if use htb
Message-ID: <20090115090120.GE4190@ff.dom.local>
References: <20081010090426.GA6054@ff.dom.local> <200901141417.58667.denys@visp.net.lb> <1231937404.14825.4.camel@laptop> <200901141505.46929.denys@visp.net.lb> <20090114131257.GC6117@ff.dom.local> <1231938929.14825.6.camel@laptop> <20090114132603.GD6117@ff.dom.local> <1231939946.14825.9.camel@laptop> <20090114141311.GA6643@ff.dom.local> <1231943283.14825.14.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231943283.14825.14.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 03:28:03PM +0100, Peter Zijlstra wrote:
...
> Right, found all that...
> 
> Can't spot anything obviously wrong though.. hrtimer_start*() does
> remove_hrtimer() which checks STATE_ENQUEUED, STATE_PENDING and pulls it
> off the relevant list before it continues the enqueue.
> 
> However a loop in enqueue_hrtimer() would suggest a corrupted RB-tree,
> but I cannot find an RB-op that doesn't hold base-lock.
> 

I've revisited it yesterday, and if I don't miss something, there is
possible a scenario similar to this:

cpu1:				cpu2:

run_hrtimer_pending
spin_unlock
restart = fn(timer)

				hrtimer_start
				enqueue_hrtimer

				hrtimer_start
				remove_hrtimer
				(the HRTIMER_STATE_CALLBACK is removed)

				switch_hrtimer_base
spin_lock
(not this hrtimer's anymore)
__remove_hrtimer
list_add_tail			enqueue_hrtimer


Jarek P.
