Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbZBOSUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbZBOSUq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 13:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbZBOSUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 13:20:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:6327 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920AbZBOSUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 13:20:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NFvED6XwxH7fOK2/Jzbn3Jo7SKT364fsB6GaOJmI/zi1P4TCq/6jC6Uno4RVtuLBXj
         qnogItkFLbuB2RfbzhxpC09tUFUMqlHvZSm58nYyXN/FpQMf+ggQEtuxiauFPENNAur1
         N90rHdkO6GuIUphJ7Sv9izNUWHy2oqgzufSKs=
From: Andreas Robinson <andr345@gmail.com>
To: sam@ravnborg.org, rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/6] module, kbuild: Faster boot with custom kernel.
Date: Sun, 15 Feb 2009 19:20:22 +0100
Message-Id: <1234722028-8110-1-git-send-email-andr345@gmail.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

as you know, systems with custom kernels boot faster, since they don't
need an initramfs or have to install modules. But, building a custom
kernel it is not really practical if you are releasing a distro, for
example.

This patchset aims to eventually solve that problem. It lets you link
external modules statically to the kernel and achive much the same
effect as changing the configuration and recompiling. You only need a
small part of a precompiled kernel tree (20-30MB, debug syms stripped)
and it's fast (15 seconds or less on an ordinary desktop PC).

Status: "Works for me", but has a bunch of TODOs (see below).
However, I hope you can comment on the bits that are done so far.

Thanks,
Andreas

Patches
-------

The patches are against 2.6.29-rc5.

The implementation is quite straightforward. I hope you think the commit
messages in the patches are clear enough.

TODOs
-----

- A makefile target that copies and prunes the tree to minimal
  size. Work in progress.

- Arch-specific changes to kbuild. X86 is done though still ugly so
  it is not included yet. I need to work some more on it first.

- Documentation.

- Proper testing.

How to use this thing in its current state
------------------------------------------

- Enable the new configuration option and build the kernel.
- Install and reboot.
- Collect the pathnames of the loaded modules in a text file
  in the order you want the kernel to initialize them.

  I use the this script. It is a bit slow, but works well
  enough.  (When I remember to run updatedb first.)

-------------8<---------------------------------- 
#!/bin/sh
k_ver="2.6.29-rc4"
for module in `tac /proc/modules`
do
        modname=`echo $module | cut -f 1 -d ' ' | sed -e s/[-_]/[-_]?/g`
        locate --regex /lib/modules/$k_ver/.*/$modname.ko
done
-------------8<----------------------------------

- Preprocess the modules named in the text file
  (called modules.lst here). Run from the kernel tree root:

  scripts/ld_extmodules.sh modules.lst output.o
  
- Relink the kernel:

  e.g make vmlinux L=1 EXTOBJ=output.o
  or 
  make bzImage L=1 EXTOBJ=output.o

- Install it.

- Move the linked modules from /lib/modules/*
  to some other location and run depmod.
  This has to be done so that udev won't try to
  insert them a second time.

- Enjoy.

