Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbYJJJkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbYJJJkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:40:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752668AbYJJJj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 05:39:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37272 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbYJJJj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 05:39:58 -0400
Date: Fri, 10 Oct 2008 11:39:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>, stable@kernel.org
Cc: Theodore Tso <tytso@mit.edu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       David Smith <dsmith@redhat.com>, Roland McGrath <roland@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Wenji Huang <wenji.huang@oracle.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Subject: Re: [PATCH] Marker depmod fix core kernel list
Message-ID: <20081010093901.GC13996@elte.hu>
References: <E1Klq8Z-0003Vd-L6@closure.thunk.org> <20081003195436.GA13506@Krystal> <20081004152456.GB23398@mit.edu> <20081006040820.GB26148@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081006040820.GB26148@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Greg KH <greg@kroah.com> wrote:

> On Sat, Oct 04, 2008 at 11:24:56AM -0400, Theodore Tso wrote:
> > On Fri, Oct 03, 2008 at 03:54:36PM -0400, Mathieu Desnoyers wrote:
> > > Here is a fix that should take care if this problem. Given I am not the
> > > modpost expert, let's see if I can get an ACK from Sam.
> > 
> > Tested-by: "Theodore Ts'o" <tytso@mit.edu>
> > 
> > It works, thanks!!  Can we get this pushed to Linus before 2.6.28
> > opens?  This is technically a regression since it was broken around
> > 2.6.27-rc1.
> 
> If it misses .27, can someone forward it to stable@kernel.org when it
> goes into Linus's tree?
> 
> thanks,

the patch went upstream without a Cc: <stable@kernel.org> tag, so i'm 
sending it here as a backport request. The upstream commit is below.

	Ingo

--------------->
>From 87f3b6b6fbcbfa715f0d0db3e7a63e65716a6d4e Mon Sep 17 00:00:00 2001
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Mon, 6 Oct 2008 09:30:12 -0400
Subject: [PATCH] Marker depmod fix core kernel list

* Theodore Ts'o (tytso@mit.edu) wrote:
>
> I've been playing with adding some markers into ext4 to see if they
> could be useful in solving some problems along with Systemtap.  It
> appears, though, that as of 2.6.27-rc8, markers defined in code which is
> compiled directly into the kernel (i.e., not as modules) don't show up
> in Module.markers:
>
> kvm_trace_entryexit arch/x86/kvm/kvm-intel  %u %p %u %u %u %u %u %u
> kvm_trace_handler arch/x86/kvm/kvm-intel  %u %p %u %u %u %u %u %u
> kvm_trace_entryexit arch/x86/kvm/kvm-amd  %u %p %u %u %u %u %u %u
> kvm_trace_handler arch/x86/kvm/kvm-amd  %u %p %u %u %u %u %u %u
>
> (Note the lack of any of the kernel_sched_* markers, and the markers I
> added for ext4_* and jbd2_* are missing as wel.)
>
> Systemtap apparently depends on in-kernel trace_mark being recorded in
> Module.markers, and apparently it's been claimed that it used to be
> there.  Is this a bug in systemtap, or in how Module.markers is getting
> built?   And is there a file that contains the equivalent information
> for markers located in non-modules code?

I think the problem comes from "markers: fix duplicate modpost entry"
(commit d35cb360c29956510b2fe1a953bd4968536f7216)

Especially :

  -   add_marker(mod, marker, fmt);
  +   if (!mod->skip)
  +     add_marker(mod, marker, fmt);
    }
    return;
   fail:

Here is a fix that should take care if this problem.

Thanks for the bug report!

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Tested-by: "Theodore Ts'o" <tytso@mit.edu>
CC: Greg KH <greg@kroah.com>
CC: David Smith <dsmith@redhat.com>
CC: Roland McGrath <roland@redhat.com>
CC: Sam Ravnborg <sam@ravnborg.org>
CC: Wenji Huang <wenji.huang@oracle.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 scripts/mod/modpost.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 418cd7d..8e0de6a 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1986,11 +1986,13 @@ static void read_markers(const char *fname)
 
 		mod = find_module(modname);
 		if (!mod) {
-			if (is_vmlinux(modname))
-				have_vmlinux = 1;
 			mod = new_module(NOFAIL(strdup(modname)));
 			mod->skip = 1;
 		}
+		if (is_vmlinux(modname)) {
+			have_vmlinux = 1;
+			mod->skip = 0;
+		}
 
 		if (!mod->skip)
 			add_marker(mod, marker, fmt);
