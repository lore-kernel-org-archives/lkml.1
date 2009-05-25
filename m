Return-Path: <linux-kernel-owner+w=401wt.eu-S1754656AbZEYAjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656AbZEYAjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 20:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbZEYAjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 20:39:37 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51455 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbZEYAjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 20:39:37 -0400
Message-Id: <200905250039.n4P0dSIE058041@www262.sakura.ne.jp>
Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v2)
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 25 May 2009 09:39:28 +0900
References: <20090503215615.GA1368@ucw.cz> <200905041524.GGH52160.FFFVMSJOOLtHOQ@I-love.SAKURA.ne.jp> <200905062116.HCI09807.VOFFHFSMOLOtQJ@I-love.SAKURA.ne.jp> <200905142108.JIF10080.OOFHJVFtOSQMFL@I-love.SAKURA.ne.jp> <alpine.LRH.2.00.0905151146320.5937@tundra.namei.org> <200905162107.HCE17153.HLSFMtOOFVFOJQ@I-love.SAKURA.ne.jp> <200905250037.n4P0bFwe057503@www262.sakura.ne.jp>
In-Reply-To: <200905250037.n4P0bFwe057503@www262.sakura.ne.jp>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 24052009 #2024277, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------- Forwarded Message
 From: "Serge E. Hallyn" <serue@us.ibm.com>
 To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
 Cc: haradats@nttdata.co.jp, takedakn@nttdata.co.jp,James Morris <jmorris@namei.org>
 Subject: Re: [PATCH] TOMOYO: Add garbage collector support. (v2)
 Date: Thu, 21 May 2009 17:23:13 -0500

Quoting Tetsuo Handa (penguin-kernel@I-love.SAKURA.ne.jp):
> The key points are:
> 
>   (1) Should TOMOYO avoid sleeping operations inside a semaphore?

Seems like an obvious win.

>   (2) Should TOMOYO have GC support?

Well if your only audience is meant to be tiny embedded systems which
will never update policy, then heck maybe not.  But it certainly is
weird not to.

However, the way you went about it here is weird too.  The big
cookie list that pins items, instead of refcounts, is very un-linuxy.
Is there a reason why you can't use more of a read-copy-update
approach?  Keep a refcount on the objects, get rid of ->is_deleted,
remove the objects from their list instead of setting is_deleted
(so that after one rcu cycle no new readers can come in and increment
the refcount), wait an rcu cycle, and then free if refcount is 0?
See linux-2.6/Documentation/RCU/* for documentation.

In particular, the
	list_for_each over tomoyo_pattenrs, domains, whatever {
		tomoyo_used_by_cookie
where tomoyo_used_by_cookie then walks every cookie, meaning every
tomoyo object, seems hugely expensive to me.  I know it's only at
policy load, but...

So anyway, I'm torn between not asking for a huge effort to
fundamentally change the way you do your memory management, vs.
making the Tomoyo code a lot more linux-y, and therefore a lot
easier for other kernel people to read/review/maintain/update.

So yes, you might be able to get more review of your patch
if you split it up into:

	1. move allocations outside of semaphore
	2. add proper refcounting
	3. get rid of ->is_deleted

Hah, as I type that, I finally realize why your code fell out this
way :)  You needed is_deleted to keep invalid domains from being
used, but didn't want to properly free them bc you didn't have GC.
So yes, get rid of ->is_deleted, add refcounting, maybe use rcu
rules to clearly distinguish objects which can no longer be
accessed by anyone else, then free such objects.

A pair of more general things I noticed:

1. tomoyo_real_domain: just return task_cred_xxx(task, security)  ?

2. tomoyo_init() after your patch: you don't catch -ENOMEM?

thanks,
-serge

PS - I'll be out of touch for a few days after tonight.

------- End of Forwarded Message
