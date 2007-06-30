Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbXF3Uwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbXF3Uwr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 16:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbXF3Uwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 16:52:38 -0400
Received: from science.horizon.com ([192.35.100.1]:17700 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752570AbXF3Uwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 16:52:37 -0400
Date: 30 Jun 2007 16:52:35 -0400
Message-ID: <20070630205235.6638.qmail@science.horizon.com>
From: linux@horizon.com
To: davidel@xmailserver.org, linux-kernel@vger.kernel.org
Subject: A simpler variant on sys_indirect?
Cc: linux@horizon.com, torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was just thinking, while sys_indirect is an interesting way to add
features to a system call, the argument marshalling in user space is a
bit of a pain.

An alternate idea would be to instead have a "prefix system call" that
sets some flags that apply to the next system call made by that thread
only.  They wouldn't be global mode flags that would mess up libraries.

Maybe I've just been programming x86s too long, but this seems
like a nicer mental model.

The downsides are that you need to save and restore the prefix flags
across signal delivery, and you have a second user/kernel/user transition.

Most of the options seem to be applied to system calls that resolve
path names.  While that is certainly a very important code path, it's
also of non-trivial length, even with the dcache.  How much would one
extra kernel entry bloat the budget?

And if the kernel entry overhead IS a problem, wouldn't you want to
batch together the non-prefix system calls as well, using something like
the syslet ideas that were kicked around recently?  That would
allow less than 1 kernel entry per system call, even with prefixes.

Oh!  That suggests an interesting possibility that solves the signal
handling problem as well:
- Make a separate prefix system call, BUT
- The flags are reset on each return to user space, THUS
- You *have* to use a batch-system-call mechanism for the prefix
  system calls to do anything.

Of course, this takes us right back to the beginning with respect to
messy user-space argument marshalling.  But at least it's only one
indirect system call mechanism, not two.  Wrapping indirect system call
mechanism #1 (to set syscall options) in indirect system call mechanism
#2 (to batch system calls) seems like a bit of a nightmare.

I'm not at all sure that these are good ideas, but they're not obviously
bad ones, to me.  Is it worth looking for synergy between various
"indirect system call" ideas?
