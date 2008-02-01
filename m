Return-Path: <linux-kernel-owner+w=401wt.eu-S1755325AbYBAI3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbYBAI3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 03:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYBAI3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 03:29:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753472AbYBAI3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 03:29:11 -0500
Date: Fri, 1 Feb 2008 00:28:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: Linux Security Modules List 
	<linux-security-module@vger.kernel.org>,
       linux-kernel@vger.kernel.org, "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH] per-process securebits
Message-Id: <20080201002837.d84fc029.akpm@linux-foundation.org>
In-Reply-To: <47A2D439.9050704@kernel.org>
References: <47A2D439.9050704@kernel.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Feb 2008 00:11:37 -0800 "Andrew G. Morgan" <morgan@kernel.org> wrote:

> [This patch represents a no-op unless CONFIG_SECURITY_FILE_CAPABILITIES
>  is enabled at configure time.]

Patches like this scare the pants off me.

I'd have to recommend that distributors not enable this feature (if we
merge it) until they have 100% convinced themselves that it is 100%
correct.

Can you please provide us with a reprise of

- what was the bug which caused us to cripple capability inheritance back
  in the days of yore?  (Some sendmail thing?)

- Why was that security hole considered unfixable?

- How does this change avoid reintroducing that hole?

> Filesystem capability support makes it possible to do away with
> (set)uid-0 based privilege and use capabilities instead. That is, with
> filesystem support for capabilities but without this present patch,
> it is (conceptually) possible to manage a system with capabilities
> alone and never need to obtain privilege via (set)uid-0.
> 
> Of course, conceptually isn't quite the same as currently possible
> since few user applications, certainly not enough to run a viable
> system, are currently prepared to leverage capabilities to exercise
> privilege. Further, many applications exist that may never get
> upgraded in this way, and the kernel will continue to want to support
> their setuid-0 base privilege needs.

Are you saying that plain old setuid(0) apps will fail to work with
CONFIG_SECURITY_FILE_CAPABILITIES=y?

> Where pure-capability applications evolve and replace setuid-0
> binaries, it is desirable that there be a mechanisms by which they
> can contain their privilege. In addition to leveraging the per-process
> bounding and inheritable sets, this should include suppressing the
> privilege of the uid-0 superuser from the process' tree of children.
> 
> The feature added by this patch can be leveraged to suppress the
> privilege associated with (set)uid-0. This suppression requires
> CAP_SETPCAP to initiate, and only immediately affects the 'current'
> process (it is inherited through fork()/exec()). This
> reimplementation differs significantly from the historical support for
> securebits which was system-wide, unwieldy and which has ultimately
> withered to a dead relic in the source of the modern kernel.
> 
> With this patch applied a process, that is capable(CAP_SETPCAP), can
> now drop all legacy privilege (through uid=0) for itself and all
> subsequently fork()'d/exec()'d children with:
> 
>   prctl(PR_SET_SECUREBITS, 0x2f);
> 
> Applying the following patch to progs/capsh.c from libcap-2.05
> adds support for this new prctl interface to capsh.c:
> 
> ...
>
> Acked-by: Serge Hallyn <serue@us.ibm.com>

Really?  I'd feel a lot more comfortable if yesterday's version 1 had led
to a stream of comments from suitably-knowledgeable kernel developers which
indicated that those developers had scrutinised this code from every
conceivable angle and had declared themselves 100% happy with it.

Maybe I'm over-reacting here.  Feel free to tell me if I am :) But as I
told you outside the bathroom today: I _really_ don't want to read about
this patch on bugtraq two years hence.

