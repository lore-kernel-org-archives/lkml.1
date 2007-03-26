Return-Path: <linux-kernel-owner+w=401wt.eu-S1751474AbXCZLZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbXCZLZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751752AbXCZLZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:25:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57584 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbXCZLZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:25:44 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070326024143.a226c9b2.akpm@linux-foundation.org> 
References: <20070326024143.a226c9b2.akpm@linux-foundation.org>  <1174904637.32691.86.camel@roc-desktop> 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bryan.wu@analog.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error bug 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Mon, 26 Mar 2007 12:25:18 +0100
Message-ID: <6017.1174908318@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> Offending patch is
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/broken-out/nommu-hide-vm_mm-in-nommu-mode.patch,
> which seems rather dumb.  Or at least, its changelog does a good job of
> making it look dumb.

vm_mm is always NULL under NOMMU as it currently stands.  As far as I know,
this has been true since the NOMMU mm stuff was first included (I'm not sure
the VMAs of the first NOMMU mm code *had* a vm_mm).  Hugh (I think it was)
suggested that since this was always NULL, then it should be excised from the
struct in NOMMU-mode.

The reason is that, at the moment, VMAs are a global *shared* resource in
NOMMU-mode.  Each process has a list of global VMAs that it subscribes to, but
that's it.  This (a) slightly reduces the amount of metadata allocated
(possibly), and (b) makes sharing of executables and libraries much easier.

I have started on a patch to make VMAs non-shared, but it's not trivial.  In
NOMMU-mode, there needs to be something to pin the memory a private mapping
uses that isn't required in MMU-mode.  In the shared VMA thing, the VMA itself
can pin that memory...

I wonder if revoke_mm() is something that you can't do in NOMMU-mode.  What
does it do?

David

