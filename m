Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbXLSFMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbXLSFMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 00:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbXLSFMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 00:12:20 -0500
Received: from ozlabs.org ([203.10.76.45]:55113 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602AbXLSFMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 00:12:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Srinivasa Ds <srinivasa@in.ibm.com>
Subject: Re: [RFC] [patch 1/2] add non_init_kernel_text_address
Date: Wed, 19 Dec 2007 16:11:51 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: ananth@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>
References: <200712141225.30099.srinivasa@in.ibm.com> <47676CB7.4060203@in.ibm.com> <200712181823.54382.rusty@rustcorp.com.au>
In-Reply-To: <200712181823.54382.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712191611.52239.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 December 2007 18:23:53 Rusty Russell wrote:
> On Tuesday 18 December 2007 17:46:15 Srinivasa Ds wrote:
> > Rusty Russell wrote:
> > > The downside is that this might make backtraces through (discarded)
> > > init functions harder to read on some archs.
> >
> > I think it is better to make use of new function than sacrificing
> > __init function symbol information in backtrace.
>
> Perhaps, but two new functions is v. ugly.  I'll try to come up with
> something neater, and audit all the callers.

Actually, given that we already have this same issue with modules (you won't
see the discarded init sections in backtraces) where it's a more frequent
issue, I can't justify adding a "discarded_sections" flag to all callers.

So here's a repeat of my original patch:

Subject: Don't report discarded init pages as kernel text.

Current code could cause a bug in symbol_put_addr() if an arch used
kmalloc module text: we might think the symbol belongs to the core
kernel.

The downside is that this might make backtraces through (discarded)
init functions harder to read on some archs, but we already have that
issue for modules and noone has complained.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 0eabf082c13a kernel/extable.c
--- a/kernel/extable.c	Tue Dec 18 13:51:13 2007 +1100
+++ b/kernel/extable.c	Tue Dec 18 15:53:01 2007 +1100
@@ -46,7 +46,8 @@ int core_kernel_text(unsigned long addr)
 	    addr <= (unsigned long)_etext)
 		return 1;
 
-	if (addr >= (unsigned long)_sinittext &&
+	if (system_state == SYSTEM_BOOTING &&
+	    addr >= (unsigned long)_sinittext &&
 	    addr <= (unsigned long)_einittext)
 		return 1;
 	return 0;
