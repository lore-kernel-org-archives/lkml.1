Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbYJUTRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbYJUTRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbYJUTPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:15:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:44738 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755479AbYJUTPR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:15:17 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: kgdb-bugreport@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: kgdb 2.6.28 merge plans
Date: Tue, 21 Oct 2008 14:14:46 -0500
Message-Id: <1224616493-23237-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.0.2
X-OriginalArrivalTime: 21 Oct 2008 19:14:54.0076 (UTC) FILETIME=[4C6623C0:01C933B1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is late in the merge window, but these are plans for the kgdb
merges for 2.6.28.

* The blackfin folks needed some changes to the kgdb core
  to allow some more flexibility
* Another kgdboc I/O drivers is ready for merge
* The CONSOLE_POLL API has been extended to allow for
  an RX poll call back from a low level serial driver
* kgdboc will request/allocate a tty so as to sync with
  the user space with respect to having only one
  invocation of the low level start up code.

To an end user there are a couple key differences with the enhanced
kgdboc.  There were numerous complaints that folks just wanted kgdboc
to work like the 8250_kgdb module where gdb could just connect and it
worked.  This is the new default behavior of kgdboc.  It will
intercept a control-c or the start of a gdb serial packet and
automatically jump into the debugger, much like the 8250_kgdb module.
The other difference is that with the tty allocation, kgdboc can also
now be configured on a non-console or inactive serial port.

After this patch set is applied the only thing that kgdboc cannot
currently do that the 8250_kgdb module could is perform debugging
before the tty and console kernel subsystems have been initialized in
the kernel.  It is likely that this can be accomplished a different
way in the future and the 8250_kgdb module will be deprecated and
never merged to the mainline kernel.

Final regression testing for these features is being completed in the
next day. Find the code at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Short log follows:

--- 
Atsushi Nemoto (1):
      kgdb: kgdboc console poll hooks for serial_txx9 uart

Jason Wessel (5):
      kgdb: Add the ability to schedule a breakpoint via a tasklet
      tty: Fix sparse static warning for tty_driver_lookup_tty
      kgdboc, tty: Add the rx polling call back capability
      kgdboc, 8250: Add the rx polling hook to 8250 driver
      kgdboc, tty: use tty open to start low level drivers

Sonic Zhang (1):
      kgdb: Make mem access function weak in kgdb.c andkgdb.h

 Documentation/DocBook/kgdb.tmpl |   49 ++++++++++++++---
 drivers/char/tty_io.c           |  105 +++++++++++++++++++++++++++++++-----
 drivers/serial/8250.c           |    4 ++
 drivers/serial/kgdboc.c         |   82 +++++++++++++++++++++++++++-
 drivers/serial/serial_core.c    |   24 ++++++++-
 drivers/serial/serial_txx9.c    |  113 +++++++++++++++++++++++++++++++-------
 include/linux/kgdb.h            |   43 ++++++++++++++-
 include/linux/serial_core.h     |    3 +
 include/linux/tty_driver.h      |    8 +++-
 kernel/kgdb.c                   |   33 ++++++++++-
 10 files changed, 413 insertions(+), 51 deletions(-)
