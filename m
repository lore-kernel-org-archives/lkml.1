Return-Path: <linux-kernel-owner+w=401wt.eu-S965987AbXCPWUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965987AbXCPWUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 18:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965994AbXCPWUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 18:20:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965987AbXCPWUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 18:20:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@muc.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Ulrich Drepper <drepper@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [patch 17/26] Xen-paravirt_ops: Add nosegneg capability to the
 vsyscall page notes
In-Reply-To: Jeremy Fitzhardinge's message of  Friday, 16 March 2007 14:56:24 -0700 <45FB1288.5080909@goop.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20070316222000.8186E1801C5@magilla.sf.frob.com>
Date: Fri, 16 Mar 2007 15:20:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not quite sure what you're suggesting here though.  Do you mean one of:
> 
> NOTE_KERNELCAP_BEGIN(1, 1)
> NOTE_KERNELCAP(0, "nosegneg")
> NOTE_KERNELCAP_END
> 
> or
> 
> NOTE_KERNELCAP_BEGIN(1, 2)
> NOTE_KERNELCAP(1, "nosegneg")
> NOTE_KERNELCAP_END
> 
> is the correct thing to use?

Yes.  (Sorry about the typo, 1 and 0 are close enough aren't they? ;-)

> > Some pre-release glibc's (before 2.4) had a bug in the code that parses
> > this, and would crash parsing the correct note.  Using the wrong bit value
> > with nonmatching mask worked around this.  IIRC, no glibc release ever
> > included the buggy version of the code.  In nonbuggy glibc, the mismatched
> > value causes the "nosegneg" to be omitted from the directory search (under
> > LD_LIBRARY_PATH and default directories), though ldconfig-based lookups
> > will work (the most common case).
> 
> Are you saying that one of the corrected forms might cause old glibcs to
> crash, or just ignore nosegneg?

Yes, the affected glibc crashed with the canonical form (the first above).
I'm not sure such a glibc exists in the wild today, maybe only in some FC5
test releases (I CC'd Jakub so he can verify that at least as far as FC).
Rik van Riel discovered that the s/0/1/ tweak sufficed for common daily use
(i.e. ld.so.cache hits), and did that temporarily when he was hacking on
Xen Linux kernels for Fedora, but reverted it after we fixed glibc.

The uncorrected form causes current (correct) glibc to ignore nosegneg 
(for cache misses).

Looking at the buggy version of the code, I think it will not crash with
the second form above, just avoid using bit 0.  (But I wouldn't swear to it
without testing it.)  The second form should certainly be fine with the
current glibc.  Just make sure that "kernelcap 1 nosegneg" is used in the
ld.so.conf.d file, to match 1 in the NOTE_KERNELCAP first arg.


Thanks,
Roland
