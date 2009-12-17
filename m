Return-Path: <linux-kernel-owner+w=401wt.eu-S935084AbZLQBY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935084AbZLQBY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763778AbZLQBX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:23:57 -0500
Received: from lists.laptop.org ([18.85.2.145]:46252 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763771AbZLQBXv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:23:51 -0500
Date: Wed, 16 Dec 2009 20:25:40 -0500
From: Michael Stone <michael@laptop.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Michael Stone <michael@laptop.org>, Ulrich Drepper <drepper@gmail.com>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>
Subject: Re: [PATCH] Security: Add prctl(PR_{GET,SET}_NETWORK) interface.
Message-ID: <20091217012540.GA2609@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20091216155938.GG15031@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wed, Dec 16, 2009 at 10:32:43AM -0500, Michael Stone wrote:
>> Daniel Bernstein has observed [1] that security-conscious userland processes
>> may benefit from the ability to irrevocably remove their ability to create,
>> bind, connect to, or send messages except in the case of previously
>> connected sockets or AF_UNIX filesystem sockets. We provide this facility by
>> implementing support for a new prctl(PR_SET_NETWORK) flag named
>> PR_NETWORK_OFF.
>> 
>> This facility is particularly attractive to security platforms like OLPC
>> Bitfrost [2] and to isolation programs like Rainbow [3] and Plash [4].
> 
> What would stop them from ptracing someone else running under the same
> uid who still has the network access? 

Just like in the (revised from last year) rlimits version, there's a hunk in
the prctl_network semantics patch which disables networking-via-ptrace() like
so:

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 23bd09c..5b38db0 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -151,6 +151,8 @@ int __ptrace_may_access(struct task_struct *task, unsigned int mode)
                dumpable = get_dumpable(task->mm);
        if (!dumpable && !capable(CAP_SYS_PTRACE))
                return -EPERM;
+       if (current->network)
+               return -EPERM;

        return security_ptrace_access_check(task, mode);
  }

More questions?

Regards, and thanks for your interest,

Michael
