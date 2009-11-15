Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbZKOQEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbZKOQEK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 11:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbZKOQEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 11:04:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:59717 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbZKOQEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 11:04:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 0/4] compat-ioctl.c diet
Date: Sun, 15 Nov 2009 16:04:06 +0000
Message-Id: <1258301050-26900-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
X-Provags-ID: V01U2FsdGVkX18Z8Jmncb5fm+G3gaZGyncu/D3VGwgk8TYvPlq
 s4Bv9aKZabSf18YRcFtlgVkUogbJ6vnU05IzdbII5gp2KVgZdf
 nHOsym+UV1KlrmT7WTNug==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've spent some time on making the compat ioctl code significantly smaller.
Removing the tty and socket level ioctl handling from common code
in linux-next helps a bit, but mostly just moves code to other places
but does not save much in an allyesconfig.


This is the output of /usr/bin/size on the fs/compat_ioctl.o
file in different versions:

2.6.32-rc7:
   text    data     bss     dec     hex filename
  13335   17792    2080   33207    81b7 obj/fs/compat_ioctl.o
linux-next:
   8877   14696    2080   25653    6435 obj/fs/compat_ioctl.o
Simplifying the remaining code (this series):
   7572    2144       4    9720    25f8 obj/fs/compat_ioctl.o
Moving more handlers directly into driver (future series):
   4817    1740       4    6561    19a1 obj/fs/compat_ioctl.o

There are a few dependencies on code in other trees, so this
series doesn't currently apply cleanly anywhere except my
own tree.

The final series of patches that I'll post separately
depends on this one as well and touches most of the drivers
that currently require a conversion function in fs/compat_ioctl.c
that no other driver uses. Moving those conversions into
the drivers simplifies the common code and keeps the
native and compat versions closer.

	Arnd <><

---

Arnd Bergmann (4):
  compat_ioctl: inline all conversion handlers
  compat_ioctl: simplify calling of handlers
  compat_ioctl: simplify lookup table
  compat_ioctl: pass compat pointer directly to handlers

 fs/compat_ioctl.c |  471 +++++++++++++++++++++++++----------------------------
 1 files changed, 220 insertions(+), 251 deletions(-)

