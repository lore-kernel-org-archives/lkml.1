Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbYGVBqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbYGVBqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 21:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYGVBqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 21:46:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806AbYGVBqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 21:46:07 -0400
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, systemtap@sourceware.org
Subject: Re: [RFC] fix kallsyms to allow discrimination of local symbols
References: <1216676595.3433.80.camel@localhost.localdomain>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Mon, 21 Jul 2008 21:44:38 -0400
In-Reply-To: <1216676595.3433.80.camel@localhost.localdomain> (James Bottomley's message of "Mon, 21 Jul 2008 16:43:14 -0500")
Message-ID: <y0mprp68zg9.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


James Bottomley <James.Bottomley@HansenPartnership.com> writes:

> [...]  Fix all of this by prefixing local symbols with the actual C
> file name they occur in separated by '|' (I had to use '|' since ':'
> is already in use for module prefixes in kallsyms lookups.  [...]
> Comments?

Can we take some time to review how we got here?


- You disprefer systemtap's use of an established, non-deprecated API
  for placing kernel probes.  (We calculate addresses by a mixture of
  elf-analysis and runtime user-space lookup means.  That's partly
  since kallsyms_lookup was unexported over our objections.)  There is
  nothing outright broken (e.g. incorrect numbers) with what systemtap
  has been doing for years.

- You argue that symbols+offset kprobing is better.  We can see that,
  in some sense, but ...

- I explain that we are used to final address calculating, as we'll
  have to do that regardless for user-space probes.  Plus we need to
  work with kernels that predate the symbol+offset kprobe api
  extension.  So this change would not simplify systemtap in any way.
  You do not respond.

- I offer _stext+offset (for the kernel) and (.text*)+offset (for
  modules) kprobes: basically to use the "better" symbol+offset
  kprobes api, but use the same single reference addresses we already
  do, and leaving just the final addition to the kernel.  You do not
  respond materially.

- You argue that it cannot only be any symbol+offset ... but the actual
  nearest symbol+offset.  But that doesn't work for local symbols.  So
  you fix that to the nearest globally visible symbol+offset.  But this
  requires:
  - yet more extra work and code from systemtap
  - extension to the kernel build system, and kallsyms runtime data to
    fix the current local-symbol-ambiguity problem
  - storage of all that new file name data in permanent unswappable
    kernel data (>>100kB, if done simply prefixing local symbol names
    file file names).
  - possible further complications related to filename string matching

- You have yet to invent a scheme to allow offloading *data* address
  calculations to the kernel.  Without that (and perhaps more),
  systemtap will *still* have to fetch same base _stext etc.
  addresses at run time that it currently does -- even if it did not
  use them to compute kprobes addresses.


In total, this path would end up with both systemtap and the kernel
more complex, larger and a bit slower too.  Does that still seem an
acceptable cost, just to get systemtap to change its preferred kprobes
api?


- FChE
