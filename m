Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbZEDGYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbZEDGYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 02:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbZEDGYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 02:24:09 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:63679 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752126AbZEDGYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 02:24:08 -0400
To: pavel@ucw.cz
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO 1/2] tomoyo: add Documentation/tomoyo.txt
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20090410171001.GA26156@elf.ucw.cz>
	<200904130204.n3D24JNk095583@www262.sakura.ne.jp>
	<20090501102438.GA7470@elf.ucw.cz>
	<200905012207.BFC60616.QStOHOMJFOLFFV@I-love.SAKURA.ne.jp>
	<20090503215615.GA1368@ucw.cz>
In-Reply-To: <20090503215615.GA1368@ucw.cz>
Message-Id: <200905041524.GGH52160.FFFVMSJOOLtHOQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 4 May 2009 15:24:02 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> The document above says otherwise. 'There is no way except rebooting
> the system that can free unneeded memory' certainly looks like memory
> leak. Plus it sounds like if you change the policy, it will not free
> the old one, either.

Comments on documentation are also appreciated.
Let me explain it with below examle.

# echo 'allow_read /lib/libc-2.5.so' | ccs-loadpolicy -e
# echo 'delete allow_read /lib/libc-2.5.so' | ccs-loadpolicy -e
# echo 'allow_read /lib/libc-2.5.so' | ccs-loadpolicy -e
# echo 'allow_read /lib/libc-2.6.so' | ccs-loadpolicy -e

In the first line, new memory is allocated because that element has never been
added to the list before.
In the second line, memory used for the deleted element is not released.
In the third line, new memory is not allocated because that element has been
added in the past.
In the fourth line, new memory is allocated because that element has never been
added to the list before.

Memory which becomes garbage (which some people call as "memory leak") is
quite little because a sane administrator won't add random elements and delete
them.

TOMOYO has cursors used for resuming list traversal from arbitrary elements.
I tried to add refcounter to each element, but the code became too ugly to
maintain. Thus, I simplified list traversal by guaranteeing all elements
pointed by cursors are permanent. As of now, we can't release memory used by
the deleted element because we don't manage the list of cursors to make sure
that there is no cursor which refers the deleted element. But if we can find
a way to detect no longer referenced elements, we would be able to add some
garbage collector. (Before we start implementing garbage collector, I'd like to
hear end-user's opinion whether TOMOYO wants garbage collector or not.)

Thanks.
