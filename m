Return-Path: <linux-kernel-owner+w=401wt.eu-S1750855AbXCOTQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750855AbXCOTQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbXCOTQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:16:13 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:33285 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbXCOTQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:16:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Catalin Marinas" <catalin.marinas@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: Possible "struct pid" leak from tty_io.c
References: <b0943d9e0703080927hde01f7dt9ae06433e0c87549@mail.gmail.com>
	<m13b4f7ggy.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703090844i6459372auba8e408ccce0c1f0@mail.gmail.com>
	<m1lki64a3i.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703120807t796e6c62k2422a93f6161db3a@mail.gmail.com>
	<m1veh5q6s7.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703140259p773b0eb8p9c142d33934e64ff@mail.gmail.com>
	<m1wt1jq45w.fsf@ebiederm.dsl.xmission.com>
	<b0943d9e0703141008o4d6cb243r7bc328d79cccfa2e@mail.gmail.com>
Date: Thu, 15 Mar 2007 13:15:47 -0600
In-Reply-To: <b0943d9e0703141008o4d6cb243r7bc328d79cccfa2e@mail.gmail.com>
	(Catalin Marinas's message of "Wed, 14 Mar 2007 17:08:34 +0000")
Message-ID: <m1r6rqnwrg.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Catalin Marinas" <catalin.marinas@gmail.com> writes:

> On 14/03/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
>> How does this look?
>
> It seems to fix the leak. I looked at the logs and proc_set_tty calls
> put_pid twice for pid 245 (the unresolved leak) and get_pid for pid
> 296, which is later passed to put_pid via do_tty_hangup.

I can see where this would.  Now I do have a concern that proc_set_tty.
With my current foggy recollections of the semantics of how SIGHUP is
sent I think both callers of proc_set_tty are buggy.  We steal away
the tty and don't send SIGHUP to the old users of the tty.

For flush_unauthorized files making that case looks fairly easy.
For tiocsctty this it looks more difficult.

I need to carefully read through what the rules are again to be certain.
There are legitimate cases for not sending SIGHUP.

> I still get the "error attempted to write to tty [0x00000000] = NULL"
> when debugging is enabled in tty_io.c but it seems harmless.

Yes.  I think that is the last vestiges of a recent tty layer debugging
session.  The code is 8 dec 2006, and came in when we started testing
for NULL and making a NULL tty there harmless.

I remember walking through disassociate_ctty several months ago and
not finding any bugs, but I might look again.

So anyway I almost have this.

Eric
