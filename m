Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbYHaBgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbYHaBgs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 21:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbYHaBgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 21:36:40 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:58660 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779AbYHaBgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 21:36:39 -0400
X-Greylist: delayed 1334 seconds by postgrey-1.27 at vger.kernel.org; Sat, 30 Aug 2008 21:36:39 EDT
To: tmb@mandriva.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: kernel-2.6.27-rc5: soft lockup - CPU#X stuck for 61s!
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <48B94120.1010108@mandriva.org>
In-Reply-To: <48B94120.1010108@mandriva.org>
Message-Id: <200808311014.BCD13024.SOOtOMQVFFFJLH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Sun, 31 Aug 2008 10:14:21 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> Kernel: 2.6.27-rc5 + Mandriva patches
Yes, it is caused by TOMOYO patches.

> Call Trace:
>   [<ffffffff804d6b69>] ? _spin_lock+0x9/0x10
>   [<ffffffff803319c0>] ? ccs_realpath_from_dentry2+0x140/0x430
>   [<ffffffff802b7bc6>] ? ksize+0x16/0xc0
>   [<ffffffff80331d8f>] ? ccs_realpath_from_dentry+0x3f/0x60
>   [<ffffffff80331dff>] ? ccs_realpath_nofollow+0x4f/0x60
>   [<ffffffff803306de>] ? ccs_check_flags+0x1e/0x30
>   [<ffffffff8032c888>] ? find_next_domain+0x98/0x970
>   [<ffffffff8029c6b2>] ? handle_mm_fault+0x322/0x960
>   [<ffffffff8029adb7>] ? follow_page+0x2f7/0x350
>   [<ffffffff8029cdf8>] ? get_user_pages+0x108/0x450
>   [<ffffffff802b7bc6>] ? ksize+0x16/0xc0
>   [<ffffffff8032da76>] ? search_binary_handler_with_transition+0x406/0x4d0
>   [<ffffffff802c5c0d>] ? do_execve+0x1fd/0x240
>   [<ffffffff8020a2d9>] ? sys_execve+0x49/0x70
>   [<ffffffff8020ca4a>] ? stub_execve+0x6a/0xc0
Inside ccs_realpath_from_dentry2(), it will take dcache_lock and vfsmount_lock
lock. But, the order of calling spin_lock(&dcache_lock); and
spin_lock(&vfsmount_lock); was reversed by AppArmor's patches.
See __d_path() in fs/dcache.c in the patch
http://svn.mandriva.com/cgi-bin/viewvc.cgi/packages/cooker/kernel/branches/rebase-to-2.6.27/PATCHES/patches/security-apparmor-2.6.27.patch?revision=276651&view=markup

The solution is to reverse the order in TOMOYO's patches.
It is solved in TOMOYO 1.6.4 . You can download it from
http://svn.sourceforge.jp/cgi-bin/viewcvs.cgi/trunk/1.6.x/ccs-patch/?root=tomoyo&rev=1499

I responded to Mandriva's kernel maintainers, so it will be solved shortly.

Regards.
