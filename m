Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbZLAT2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbZLAT2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 14:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbZLAT2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 14:28:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbZLAT2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 14:28:23 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
X-Fcc: ~/Mail/utrace
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Veaceslav Falico <vfalico@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       utrace-devel@redhat.com, Jan Kratochvil <jan.kratochvil@redhat.com>
Subject: Re: powerpc: syscall_dotrace() && retcode (Was: powerpc: fork &&
	stepping)
In-Reply-To: Oleg Nesterov's message of  Monday, 30 November 2009 21:01:36 +0100 <20091130200136.GB11764@redhat.com>
References: <20091126145051.GB4382@redhat.com>
	<20091126172524.GA14768@redhat.com>
	<20091126182226.GF12355@darkmag.usersys.redhat.com>
	<20091126202312.GA21945@redhat.com>
	<19214.63688.860929.962005@cargo.ozlabs.ibm.com>
	<20091126223703.GA28556@redhat.com>
	<20091127174627.GB26193@darkmag.usersys.redhat.com>
	<20091128073049.GD23108@in.ibm.com>
	<20091129210716.GA19205@redhat.com>
	<1259536501.2076.39.camel@pasglop>
	<20091130200136.GB11764@redhat.com>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20091201192750.4A1291DE@magilla.sf.frob.com>
Date: Tue,  1 Dec 2009 11:27:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't really intend to impose any new requirements on the arch behavior
here.  It's up to the arch folks to decide.  It does simplify life somewhat
on x86 that you can change the registers at the syscall-entry stop and then
after skipping the syscall, those registers will be unchanged from what you
set.  But it's never been that way on every other arch, and it doesn't need
to be.  The arch requirement on the tracehook_report_syscall_entry() return
value handling is that it make the syscall not be run, and that the
register state then left be compatible with using syscall_rollback() at the
tracehook_report_syscall_exit() spot.

As to what you get from ptrace explicitly fiddling with registers at
syscall entry, that has always been arch-specific before and we haven't
done anything to change that situation.  On every arch, there is some way
to change the syscall number to be run, and changing it to a known-bogus
number (e.g. -1) makes sure no syscall runs.  On every arch, it's possible
at the tracehook_report_syscall_exit() spot to change the registers to
exactly whatever you want userland to see.  That's enough as it stands to
make it possible to do whatever you want, some way or other.

If the powerpc maintainers want to change the behavior here, that is fine
by me.  But there is no need for that just to satisfy general ptrace
cleanups (or utrace).  Normal concerns require that no such change break
the ptrace behavior that userland could have relied on in the past.

So off hand I don't see a reason to change at all.  If every arch were to
change so that registers changed at syscall-entry were left unmolested by
aborting the syscall, then that might be a new consistency worth having.
But short of that, I don't really see a benefit.

All this implies that the ptrace-tests case relating to this needs to be
tailored differently for powerpc and each other arch so it expects and
verifies exactly the arch-specific behavior that's been seen in the past.


Thanks,
Roland
