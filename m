Return-Path: <linux-kernel-owner+w=401wt.eu-S1764947AbYD1DeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764947AbYD1DeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 23:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762303AbYD1DeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 23:34:14 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:40274 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbYD1DeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 23:34:13 -0400
From: Roland Dreier <rdreier@cisco.com>
To: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
Subject: Build failure (with insane config)
X-Message-Flag: Warning: May contain useful information
Date: Sun, 27 Apr 2008 20:34:12 -0700
Message-ID: <adahcdm3b63.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 28 Apr 2008 03:34:12.0941 (UTC) FILETIME=[BA2867D0:01C8A8E0]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For x86-64, arch/x86/lib/Makefile has:

        lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o

so in particular ip_compute_csum() (from csum-partial_64.c) gets put in
libs, so even though it is exported, it gets thrown away at link time if
there are no non-modular users.

However, if someone has an insane config with CONFIG_NET=n and
CONFIG_VIDEO_BT848=m, then ip_compute_csum() gets discarded but the
modular code in drivers/media/video/bt8xx/bttv-cards.c calls it and...

        ERROR: "ip_compute_csum" [drivers/media/video/bt8xx/bttv.ko] undefined!

I guess one fix is just to put at least csum-partial_64.c in obj-y
instead; it does seem broken to have files with EXPORT_SYMBOL() be
lib-y, since it is really an invitation for this problem.  Other ideas
would be for bttv to depend on or select CONFIG_NET.

[It's a long story why I noticed this problem, but maybe we want to fix
it to save people doing randconfig test builds or something like that.
Or maybe we don't really care, since the class of real systems with
video capture cards but no networking is probably quite small]

 - R.
