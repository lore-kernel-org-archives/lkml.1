Return-Path: <linux-kernel-owner+w=401wt.eu-S1758488AbZLGS2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488AbZLGS2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758444AbZLGS2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:28:44 -0500
Received: from twilight.fidra.de ([88.198.14.164]:55745 "EHLO
	twilight.fidra.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757943AbZLGS2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:28:41 -0500
X-Greylist: delayed 1919 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Dec 2009 13:28:40 EST
From: Volker Lanz <vl@fidra.de>
To: linux-kernel@vger.kernel.org
Subject: [BISECTED, REGRESSION] Successful resume from suspend but freezes after I/O
Date: Mon, 7 Dec 2009 18:56:48 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.28-17-generic; KDE/4.3.2; x86_64; ; )
Cc: yinghai@kernel.org, mingo@elte.hu
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200912071856.48125.vl@fidra.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

updating to my distro's new 2.6.31 kernel on an x86_64 quad core machine with 
6 GB of RAM I noticed resuming from suspend still worked as before, but the 
machine will now reproducably freeze (have to hard reset) afterwards as soon 
as I do something disk I/O heavy, though the problem is probably not related 
to disk activity at all.

A current mainline 2.6.32 checkout shows the same behaviour.

I git-bisected the problem to this commit:


-----------------------------------------------------------------------------
commit 78a8b35bc7abf8b8333d6f625e08c0f7cc1c3742
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Thu Mar 12 22:36:01 2009 -0700

    x86: make e820_update_range() handle small range update

    Impact: enhance e820 code to handle more cases

    Try to handle new range which could be covered by one entry.

    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Cc: jbeulich@novell.com
    LKML-Reference: <49B9F0C1.10402@kernel.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
-----------------------------------------------------------------------------


A kernel built from this revision does not boot, so the first booting kernel 
to show the problem actually seems to be:


-----------------------------------------------------------------------------
commit 6d7942dc2a70a7e74c352107b150265602671588
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Sat Mar 14 14:32:41 2009 -0700

    x86: fix 64k corruption-check

    Impact: fix boot crash

    Need to exit early if the addr is far above 64k.

    The crash got exposed by:

      78a8b35: x86: make e820_update_range() handle small range update

    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Cc: <stable@kernel.org>
    LKML-Reference: <49BC2279.2030101@kernel.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
-----------------------------------------------------------------------------


The last kernel to work without problems thus seems to be this one:


-----------------------------------------------------------------------------
commit 773e673de27297d07d852e7e9bfd1a695cae1da2
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Thu Mar 12 21:35:18 2009 -0700

    x86: fix e820_update_range()

    Impact: fix left range size on head

    | commit 5c0e6f035df983210e4d22213aed624ced502d3d
    |    x86: fix code paths used by update_mptable
    |    Impact: fix crashes under Xen due to unrobust e820 code

    fixes one e820 bug, but introduces another bug.

    Need to update size for left range at first in case it is header.

    also add __e820_add_region take more parameter.

    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Cc: jbeulich@novell.com
    LKML-Reference: <49B9E286.502@kernel.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
-----------------------------------------------------------------------------


The problem is 100% reproducable on this machine: Resuming and then copying 
/usr/ to $HOME will freeze after a few hundred MB have been copied. Earlier 
kernels worked fine for the last couple of months.

What additional information is required to help diagnose and hopefully fix the 
problem?


Volker

