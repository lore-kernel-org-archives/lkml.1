Return-Path: <linux-kernel-owner+w=401wt.eu-S1754683AbZKBKmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbZKBKmI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 05:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbZKBKmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 05:42:07 -0500
Received: from smtp-out.google.com ([216.239.33.17]:54469 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbZKBKmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 05:42:06 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=FMI2QVjkNJhSTzsfekA0KRk6Pl13wCHkxOq8gIN+XKaLZma+bWK8Eym/nH9h6v3YO
	uRetByNLyQHorChE588mg==
Date: Mon, 2 Nov 2009 02:42:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>, vedran.furac@gmail.com
Subject: Re: [PATCH] oom_kill: use rss value instead of vm size for badness
In-Reply-To: <2f11576a0911010529t688ed152qbb72c87c85869c45@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0911020237440.13146@chino.kir.corp.google.com>
References: <20091028175846.49a1d29c.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910280206430.7122@chino.kir.corp.google.com> <abbed627532b26d8d96990e2f95c02fc.squirrel@webmail-b.css.fujitsu.com> <20091029100042.973328d3.kamezawa.hiroyu@jp.fujitsu.com>
 <alpine.DEB.2.00.0910290125390.11476@chino.kir.corp.google.com> <2f11576a0911010529t688ed152qbb72c87c85869c45@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Nov 2009, KOSAKI Motohiro wrote:

> > total_vm
> > 673222 test
> > 195695 krunner
> > 168881 plasma-desktop
> > 130567 ktorrent
> > 127081 knotify4
> > 125881 icedove-bin
> > 123036 akregator
> > 121869 firefox-bin
> >
> > rss
> > 672271 test
> > 42192 Xorg
> > 30763 firefox-bin
> > 13292 icedove-bin
> > 10208 ktorrent
> > 9260 akregator
> > 8859 plasma-desktop
> > 7528 krunner
> >
> > firefox-bin seems much more preferred in this case than total_vm, but Xorg
> > still ranks very high with this patch compared to the current
> > implementation.
> 
> Hi David,
> 
> I'm very interesting your pointing out. thanks good testing.
> So, I'd like to clarify your point a bit.
> 
> following are badness list on my desktop environment (x86_64 6GB mem).
> it show Xorg have pretty small badness score. Do you know why such
> different happen?
> 

I don't know specifically what's different on your machine than Vedran's, 
my data is simply a collection of the /proc/sys/vm/oom_dump_tasks output 
from Vedran's oom log.

I guess we could add a call to badness() for the oom_dump_tasks tasklist 
dump to get a clearer picture so we know the score for each thread group 
leader.  Anything else would be speculation at this point, though.

> score    pid        comm
> ==============================
> 56382   3241    run-mozilla.sh
> 23345   3289    run-mozilla.sh
> 21461   3050    gnome-do
> 20079   2867    gnome-session
> 14016   3258    firefox
> 9212    3306    firefox
> 8468    3115    gnome-do
> 6902    3325    emacs
> 6783    3212    tomboy
> 4865    2968    python
> 4861    2948    nautilus
> 4221    1       init
> (snip about 100line)
> 548     2590    Xorg
> 

Are these scores with your rss patch or without?  If it's without the 
patch, this is understandable since Xorg didn't appear highly in Vedran's 
log either.
