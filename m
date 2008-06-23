Return-Path: <linux-kernel-owner+w=401wt.eu-S1762859AbYFWUPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762859AbYFWUPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757844AbYFWUPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:15:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39944 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757492AbYFWUPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:15:38 -0400
Date: Mon, 23 Jun 2008 22:15:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Abhishek Sagar <sagar.abhishek@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] ftrace: prevent ftrace modifications while being
	kprobe'd
Message-ID: <20080623201525.GA10386@elte.hu>
References: <485D45AB.3000405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <485D45AB.3000405@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Abhishek Sagar <sagar.abhishek@gmail.com> wrote:

> Hi Steven/Ingo,
> 
> These patches address the problem of kprobe registration interfering 
> with dynamic ftrace. A kprobe registered on an mcount call-site can 
> modify that address multiple times during its duration of probing. At 
> the same time, ftrace may simultaneously modify these locations. This 
> could be fatal especially if ftrace modifies the call-site during a 
> kprobe registration on it (between arch_prepare_kprobe and 
> arch_arm_kprobe in __register_kprobe to be more precise). So as a 
> "fix", I've disabled any updates on the mcount call-site while it's 
> being kprobe'd.

applied to tip/tracing/ftrace, thanks Abhishek.

note that i had to do a number of fixups to themerge, and there was one 
chunk which did not merge cleanly and i left it out for now:

@@ -435,8 +502,12 @@ static void ftrace_replace_code(int enable)
                                continue;

                        /* ignore updates to this record's mcount site */
-                       if (get_kprobe((void *)rec->ip))
+                       if (get_kprobe((void *)rec->ip)) {
+                               freeze_record(rec);
                                continue;
+                       } else {
+                               unfreeze_record(rec);
+                       }

please send a delta patch against tip/tracing/ftrace to get that kprobes 
fix. You can pick up -tip via:

 http://people.redhat.com/mingo/tip.git/README

	Ingo
