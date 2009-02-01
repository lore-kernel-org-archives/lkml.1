Return-Path: <linux-kernel-owner+w=401wt.eu-S1756528AbZBAWce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528AbZBAWce (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 17:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbZBAWcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 17:32:20 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:18170 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbZBAWcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 17:32:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=T/ipjJ+Okhq93SyBYvV28Lek29qMc2Gcw8ziqS8uOeg5R3xK9gJvAZfRQut/2tSvb3
         YNl3HmKP4UfXCw9oC/GVajldcpKtCYEk0dCnuYOZKBsVvjqeHEUiZfiNQDJ2y3++KTf+
         Mll6R19HRxarzdLyhmpo+lVPUb6HF09UzOlyo=
MIME-Version: 1.0
Date: Sun, 1 Feb 2009 14:32:18 -0800
Message-ID: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com>
Subject: main thread pthread_exit/sys_exit bug!
From: Kaz Kylheku <kkylheku@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Basically, if you call pthread_exit from the main thread of a process, and keep
other threads running, the behavior is ugly.

I logged this initially as a bug against glibc, but then resolved it
with a kernel patch against linux 2.6.26:

Please see:

http://sources.redhat.com/bugzilla/show_bug.cgi?id=9804

I've known about this for some time, first having reproduced it on 2.6.17;
finally got around to fixing it.

When the main thread of a POSIX threads process calls pthread_exit, the process
should stick around until all the other threads do the same, or until one of
them calls _exit or exit, or until the process terminates abnormally.  During
this time, it would be nice if the process behaved normally: if it did not
appear defunct in the process list and if POSIX job control was possible on it.

An easy way to achieve this is to insert a wait into the top of sys_exit, so
that do_exit is not called unless all the other threads have terminated.  This
is another special case like do_group_exit. In the group exit, we zap the other
threads. In this case, we must not zap the other threads, but neither should we
fall through do_exit and become defunct!

The patch involves a controversial move: returning -ERESTARTSYS from sys_exit.
This is because the main thread may be stuck in sys_exit and have to respond to
a signal, and then go back to sys_exit. It appears to be working fine.
