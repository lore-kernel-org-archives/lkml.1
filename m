Return-Path: <linux-kernel-owner+w=401wt.eu-S1756038AbZLHPZW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038AbZLHPZW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:25:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbZLHPZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:25:21 -0500
Received: from www.tglx.de ([62.245.132.106]:52990 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755998AbZLHPZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:25:20 -0500
To: Eric Paris <eparis@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, arjan@infradead.org, greg@kroah.com,
       tytso@mit.edu, akpm@linux-foundation.org
Subject: Re: [PATCH =-v3 07/21] fanotify: fastpath to ignore certain in core inodes
From: John Ogness <dazukocode@ogness.net>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
	<20081112161103.25434.30104.stgit@paris.rdu.redhat.com>
	<20081112165055.GB19669@infradead.org>
	<20081112165638.54c38c5c@lxorguk.ukuu.org.uk>
	<20081112165820.GA26217@infradead.org>
	<1226523149.3353.23.camel@localhost.localdomain>
Date: Tue, 08 Dec 2009 16:22:42 +0100
In-Reply-To: <1226523149.3353.23.camel@localhost.localdomain> (Eric Paris's message of "Wed\, 12 Nov 2008 15\:52\:29 -0500")
Message-ID: <80skblmqwt.fsf@merkur.tec.linutronix.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-11-12, Eric Paris <eparis@redhat.com> wrote:
> Kernel Build on a 32 way machine:
> Stock kernel: 9 minutes 12 seconds
> fanotify no in kernel fastpath: 95 minutes 12 seconds
> Only events AV wants with in kernel fastpath: 10 minutes 35 seconds

Can you provide the number of calls into the listeners for each type of
fanotify event? It would provide a better picture of the scope of the
issue.

I find your non-fastpath numbers quite alarming.

The DazukoFS stackable filesystem can also be used for userspace
listeners to acknowledge/handle filesystem events. (I only mention
DazukoFS here so that there is some kind of metric comparison that can
be used.) I find a 15% overhead in communication to be too
expensive. And a 934.7% performance hit is... well...

The DazukoFS stackable filesystem only provides file open events, but
its numbers may still be of interest here:

kernel build on tmpfs:          72m36.884s
kernel build on tmpfs+DazukoFS: 75m30.569s

That is an overhead of 4%. Your results show that fanotify (with
fastpaths!) has an overhead of 15%.

My test was done using Linux 2.6.32 and DazukoFS 3.1.2. The Linux source
and build were located on tmpfs to minimize hard drive hits. The machine
was a 600MHz PowerPC, which is why the build times were so long.

During the test, the DazukoFS listeners recorded a total of 991,907 file
open events.

IMHO event filtering should happen in userspace. My experience is that
the context switches can be quite cheap. Perhaps if we know which
fanotify events (and how many) occur within your test, we can begin to
understand why your results are what they are.

John Ogness
