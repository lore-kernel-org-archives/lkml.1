Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbZGUDku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbZGUDku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 23:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbZGUDkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 23:40:49 -0400
Received: from smtp-out.google.com ([216.239.45.13]:41798 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754602AbZGUDkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 23:40:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=DactWK6b/t0tgVoxi92VOOjVQ/7N9omVyhmJSK3t+Rv/MUL+vcb57Ah5Jwpv3UdT2
	qRxaVIKIiqihOOmidbtOw==
Date: Mon, 20 Jul 2009 20:40:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Menage <menage@google.com>
cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mel@csn.ul.ie, npiggin@suse.de
Subject: Re: [PATCH] copy over oom_adj value at fork time
In-Reply-To: <6599ad830907201452h5b57a444mf4be96e194cb737@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0907202030400.25770@chino.kir.corp.google.com>
References: <200906020557.n525v6KO004302@imap1.linux-foundation.org> <6599ad830907141752n5c701f9ap2a87df0a7f4f6ff3@mail.gmail.com> <20090714210557.0f983c37@bree.surriel.com> <6599ad830907141815x64e74a6ek1499f6032cea6f5@mail.gmail.com>
 <6599ad830907161629p54783716p7246e030b8da00fe@mail.gmail.com> <alpine.DEB.2.00.0907170225570.15373@chino.kir.corp.google.com> <6599ad830907171303v255a0d65t64885d37c41b764a@mail.gmail.com> <alpine.DEB.2.00.0907171559290.30600@chino.kir.corp.google.com>
 <6599ad830907201452h5b57a444mf4be96e194cb737@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jul 2009, Paul Menage wrote:

> > My patches don't merely address threads that have an oom_adj value of
> > OOM_DISABLE while others sharing the same memory do not, they address a
> > consistency issue whereas those threads may all share memory but have
> > radically different oom_adj values: that means that only the highest
> > oom_adj value amongst them is actually used by the oom killer and all
> > other oom_adj values set by the user for those threads are wrong.
> 
> But these patches change an API that has existed for at least 4 years
> (i.e. before git history exists) and the change is known to break some
> apps that relied on the existing API.

Such applications (none have been mentioned) should be modified to comply 
with how the oom killer uses oom_adj values, which is identical for all 
tasks sharing the same mm_struct.  That prevents inconsistent states such 
as being able to elevate /proc/pid/oom_adj to 16 so that pid is targeted 
first because of its massive /proc/pid/oom_score when, in actuality, it 
may be OOM_DISABLE because it shares memory with an OOM_DISABLE parent and 
cannot be killed.  It is inappropriate for the kernel to report completely 
erroneous oom scores, which the old behavior allowed, so the end result is 
your userspace will need to be fixed.
