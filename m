Return-Path: <linux-kernel-owner+w=401wt.eu-S1761854AbXGVR3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761854AbXGVR3S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 13:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756645AbXGVR27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 13:28:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46589 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548AbXGVR26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 13:28:58 -0400
Date: Sun, 22 Jul 2007 18:28:56 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: ak@suse.de, linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: sparse breakage (x86_64: Add vDSO for x86-64 with gettimeofday/clock_gettime/getcpu)
Message-ID: <20070722172856.GC21668@ftp.linux.org.uk>
References: <20070722160809.GA5803@martell.zuzino.mipt.ru> <20070722170657.GB21668@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070722170657.GB21668@ftp.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2007 at 06:06:57PM +0100, Al Viro wrote:
> On Sun, Jul 22, 2007 at 08:08:09PM +0400, Alexey Dobriyan wrote:
> > Andi, with new vDSO code sparse fails to check with usual invocation here:
> 
> Fucks with CF and not in a good way...
> 
> CF := $(PROFILING) -mcmodel=small -fPIC -g0 -O2 -fasynchronous-unwind-tables -m64
> 
> $(obj)/vclock_gettime.o: CFLAGS = $(CF)
> $(obj)/vgetcpu.o: CFLAGS = $(CF)
> 
> s/CF/CCF/ in there (arch/x86_64/vdso/Makefile) fixes gcc problems; sparse
> ones remain and I'll look into that when I get some sleep (26 hours uptime
> right now).  I think I have a good idea of what's going on there, but
> I'd rather not touch that code until tonight.
> 
> For now just rename the variable in makefile (obviously the right thing
> to do) and that will give you sparse runs not aborted at that point.

Actually,

ed evaluate.c <<EOF
/evaluate_member_dereference
/examine_symbol_type/m/ctype =
w
q
EOF

ought to take care of sparse, AFAICS.  IOW, in evaluate_member_dereference()
we need to do examine_symbol_type(ctype) before checking ctype->type, etc.
As it is, we end up with SYM_TYPEOF node there and it's not expanded until
we'd checked if we have SYM_STRUCT.  We would, after expansion, but we don't
do it until too late.

I haven't checked if that's causes any regressions, but it looks
straightforward enough to be a plausible fix.  I won't test it until
tonight, though (see above).  Minimal testcase is
struct foo {int x;} v;
typeof(v) *p;
void bar(void)
{
        p->x = 0;
}
and any serious regression testing should get both the sparse tests and
comparing kernel builds with and without that fix...
