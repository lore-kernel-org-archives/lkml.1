Return-Path: <linux-kernel-owner+w=401wt.eu-S1759879AbZEFMRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879AbZEFMRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757941AbZEFMQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:16:52 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:56934 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754471AbZEFMQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:16:51 -0400
To: pavel@ucw.cz
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO 1/2] tomoyo: add Documentation/tomoyo.txt
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200904130204.n3D24JNk095583@www262.sakura.ne.jp>
	<20090501102438.GA7470@elf.ucw.cz>
	<200905012207.BFC60616.QStOHOMJFOLFFV@I-love.SAKURA.ne.jp>
	<20090503215615.GA1368@ucw.cz>
	<200905041524.GGH52160.FFFVMSJOOLtHOQ@I-love.SAKURA.ne.jp>
In-Reply-To: <200905041524.GGH52160.FFFVMSJOOLtHOQ@I-love.SAKURA.ne.jp>
Message-Id: <200905062116.HCI09807.VOFFHFSMOLOtQJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 6 May 2009 21:16:51 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> TOMOYO has cursors used for resuming list traversal from arbitrary elements.
> I tried to add refcounter to each element, but the code became too ugly to
> maintain. Thus, I simplified list traversal by guaranteeing all elements
> pointed by cursors are permanent. As of now, we can't release memory used by
> the deleted element because we don't manage the list of cursors to make sure
> that there is no cursor which refers the deleted element.

Just for information, I tried to implement some garbage collector.
http://svn.sourceforge.jp/cgi-bin/viewcvs.cgi/trunk/2.2.x/tomoyo-lsm/patches/tomoyo-gc.patch?view=
markup&revision=2506&root=tomoyo
Not checked the patch for details, but I think it is less ugly than
my previous implementation.

Rough estimate is shown below.


(1) Current implementation, booted CentOS 5.3 with learning mode.

Memory: 492736k/524288k available (4730k kernel code, 30668k reserved, 4947k data, 1668k init, 0k 
highmem)

# ccs-savepolicy -u
Shared:      135168
Private:     208896
Dynamic:        704
Total:       344768


(2a) With the patch above, booted CentOS 5.3 with learning mode.

Memory: 492736k/524288k available (4732k kernel code, 30676k reserved, 4953k data, 1668k init, 0k 
highmem)

# ccs-savepolicy -u
Shared:      333280
Private:     200000
Dynamic:        704
Total:       533984

(2b) With the patch above, removed policy as much as possible after (2a).

# ccs-savepolicy -u
Shared:        2400
Private:       1120
Dynamic:        704
Total:         4224


The difference comes from mainly how TOMOYO keeps string data.

Case 1 embeds multiple strings into kmalloc(PAGE_SIZE), but can't kfree().
By not implementing garbage collector, we can save about 200kB of RAM
if an administrator does not delete current policy.

Case 2a and 2b use kstrdup() for each string, and can kfree().
By implementing garbage collector, we can release about 520kB of RAM
if an administrator completely deletes current policy.

Please remember that in case 1, reloading the policy which was loaded in the
past will not consume memory (because it simply clears is_deleted flag instead
of allocating memory).
The amount of memory finally saved depends on how large policy changes occur.
