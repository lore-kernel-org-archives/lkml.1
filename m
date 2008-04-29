Return-Path: <linux-kernel-owner+w=401wt.eu-S1756828AbYD2ICi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbYD2ICi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 04:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753640AbYD2ICX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 04:02:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39286
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753419AbYD2ICW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 04:02:22 -0400
Date: Tue, 29 Apr 2008 01:02:21 -0700 (PDT)
Message-Id: <20080429.010221.268320653.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Subject: kgdb with sw single-step...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While working on the sparc port of the new kgdb code in the tree I ran
across a fundamental issue with this stuff on cpus that do
single-stepping in software.

The short story is that since such sw single-stepping is using
globally visible state (the temporary breakpoint used), it does not
fare well in the presence of cpus other than the current one hitting
the single-step breakpoint.

This actually limits my ability to test using kgdbts fully, the
parallel tests often fail because the sw single-step emulation
in kgdbts runs into several issues including the one I'm
mentioning here.

The good news is that there is a mostly working solution possible.

When GDB is handling a normal threaded process, it handles other
threads tripping over the temporary single-step breakpoint by simply
holding them stopped until the thread that should have hit the
breakpoint, does hit it.

The kernel could do something similar, but this would require
something like:

1) The architecture kgdb support code implements the sw single
   step breakpoint logic, this is necessary in order to
   handle single stepping over branches, calls, and things
   of this nature.  (this is something the single-step
   emulation code in kgdbts doesn't even try to get right).

2) The kgdb stub implements the single-stepping command using
   the support code in #1.  When this happens, foreign cpus
   which have been captured are kept captured until the
   single-step breakpoint it hit by the primary kgdb cpu.

Of course, this means we'll need changes to how gdb talks over the
stub on these processors (mips, arm, sparc, etc.)  since currently gdb
will do all of the sw single-step breakpoint work.

Some architectures, like Alpha, do the single-stepping in the
ptrace implementation.  Basically it's doing all of the sw
single-step breakpoint work on the kernel side, instead of
in gdb.  Platforms like Alpha would therefore be readily adaptable
to the above scheme without any gdb changes.

