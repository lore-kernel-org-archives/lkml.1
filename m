Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbXLFQHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbXLFQHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:07:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbXLFQHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:07:10 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:55261 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbXLFQHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:07:08 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Denis V. Lunev" <den@sw.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, marcus@better.se,
       containers@lists.osdl.org, devel@openvz.org,
       linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: Re: [PATCH] proc: Do not invalidate dentries with submounts
References: <20071205143518.GA24886@iris.sw.ru>
	<m1bq94t951.fsf@ebiederm.dsl.xmission.com> <4757CF70.3020508@sw.ru>
Date: Thu, 06 Dec 2007 09:05:02 -0700
In-Reply-To: <4757CF70.3020508@sw.ru> (Denis V. Lunev's message of "Thu, 06
	Dec 2007 13:31:12 +0300")
Message-ID: <m17ijru7v5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Denis V. Lunev" <den@sw.ru> writes:

> you have changed the behavior of revalidation by shadows. I think it
> will be better to restore it and keep new one for shadows (and below)
> only, which has been done by my yesterday patch.

- I think it is better to move forward rather then back.
- The old proc dentry caching behavior is actually too aggressive, and has
  problem corner cases.  Keeping the dentries when we have something mounted
  on top is a trade off that is the least of two evils.
- My change fixes the mount leak on all of /proc not just on /proc/generic.

What you did is a hack that restored the old slightly buggy behavior.  Which
is fine if we can't find anything better.  It is not code that is on the
path towards a /proc that properly caches it's dentries.

With the old behavior a random user space application can open a file or
a directory in /proc pinning it's dcache entry.  Then the module supplying
that open file can be removed and reinserted.  Until the user space application
removes reference to that /proc file all you will be able to find is the
version of the file from before /proc was removed.

That sounds like a way to trigger nasty behavior to me.  I would like
to remove that possibility from the kernel if I can.

Eric

