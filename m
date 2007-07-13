Return-Path: <linux-kernel-owner+w=401wt.eu-S1762621AbXGMS4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762621AbXGMS4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 14:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761268AbXGMS4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 14:56:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51842 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760162AbXGMS4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 14:56:33 -0400
Date: Fri, 13 Jul 2007 20:56:00 +0200 (CEST)
From: Bodo Eggert <7eggert@gmx.de>
To: linux-kernel@vger.kernel.org, 7eggert@gmx.de
Subject: [PATCH 0/3][try 1] init: enable system-on-initramfs
Message-ID: <Pine.LNX.4.58.0707132039080.3222@be1.lrz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1/ZTxKiCOiZS+svrIAoX75L/ltyDlpErDGpak7
 v6i213ZDGqu4x7uxOSiZGcm/iTepNFSn4m0MyT4VhDgIqiX4eI
 jq6ThxpdRjG6+Q3RtUE+w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I toyed with setting up a diskless system in initramfs. In the process, I
came across some things:

1)  There is no way to have the kernel not mount a filesystem,
    unless you use /init or rdinit=.

1a) In the process of writing these patches, I found prepare_namespace not to
    be called if /init is present. prepare_namespace will call
    security_sb_post_mountroot after mounting the root fs. I did not yet see
    a way to call this from /init, and grepping kinit for "security" did not
    help, too.

   This is probably a bug, but using the features of this patchset, you'll
   avoid hitting it. Therefore this patchset does nothing about that.
 
2)  If you want to use tmpfs, you need a script which essentially duplicates
    the work the kernel just did: Mount the root fs, unpack or move the files.
    Using tmpfs instead for the first root mount is as cheap as using ramfs,
    as long as tmpfs is used anyway (and most likely it is).

2a) I figured if you prepared the root fs to contain a running system, you
    woud probably also set up a runnable system on it. Therefore I changed
    the default to boot from tmpfs if there was no /init nor a root= option.
    (If there is a /init, it will be executed as usural.)

    Unfortunately the way I do it, this will override the rdev setting, but
    that should be OK, since rdev is dead. Isn't it?

3)  While I was at it, I figured I would not need most of the init/mount*
    code anymore. Therefore I made patch 3, which ifdefs it out as far as
    possible while still aiming for a small change.

Patch 1 adds the capability to use root=rootfs.
Patch 2 adds the capability to use tmpfs for root, default root=rootfs.
        ramfs becomes optional if rootfs=tmpfs.
Patch 3 allows to remove the capability of automounting filesystems.

All patches appyl to 2.6.22.1
-- 
Fun things to slip into your budget
Remuneration compensation upgrade. (otherwise called a pay raise).
