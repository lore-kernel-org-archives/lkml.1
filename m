Return-Path: <linux-kernel-owner+w=401wt.eu-S1757182AbYAHNvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182AbYAHNvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 08:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756312AbYAHNuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 08:50:54 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:49913 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755797AbYAHNuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 08:50:52 -0500
To: indan@nul.nu
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, w@1wt.eu,
       serue@us.ibm.com
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp>
	<200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp>
	<20080106062609.GC20753@1wt.eu>
	<200801070020.DGI17963.HOOJStVMOFFQLF@I-love.SAKURA.ne.jp>
	<51953.81.207.0.53.1199738255.squirrel@secure.samage.net>
In-Reply-To: <51953.81.207.0.53.1199738255.squirrel@secure.samage.net>
Message-Id: <200801082250.CBI21893.FOQMOtSJFLOHFV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 8 Jan 2008 22:50:49 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.


Indan Zupancic wrote:
> > I want to use this filesystem in case where a process with root privilege was
> > hijacked but the behavior of the hijacked process is still restricted by MAC.
> 
> 1) If the behaviour can be controlled, why can't the process be
>    disallowed to change anything badly in /dev? Like disallowing anything
>    from modifying existing nodes that weren't created by that process.
>    That would have practically the same effect as your filesystem,
>    won't it?
MAC system can prevent hijacked processes from changing anything badly in /dev .
But MAC system can't prevent hijacked processes from doing
"mv /dev/hda1 /dev/hda1.tmp; mv /dev/hda2 /dev/hda1; mv /dev/hda1.tmp /dev/hda2"
if permissions to rename device nodes in /dev are given to hijacked processes.
This is because MAC implementation doesn't check filename/attribute pairs.

But this filesystem can prevent hijacked processes from doing
"mv /dev/hda1 /dev/hda1.tmp; mv /dev/hda2 /dev/hda1; mv /dev/hda1.tmp /dev/hda2"
even if permissions to rename device nodes in /dev are given to hijacked processes.

This filesystem is not designed to
"forbid modifying nodes if that process needn't to modify nodes".
This filesystem is designed to
"forbid breaking filename/attribute pairs of nodes
even if that process need to (or permitted to) modify nodes".

>    Or phrased differently, if the MAC system used can't protect /dev, it
>    won't be able to protect other directories either, and if it can't
>    protect e.g. my homedir, doesn't it make the whole MAC system
>    ineffective? And if the MAC system used is ineffective, your
>    filesystem is useless and you've bigger problems to fix.
You can use "nodev" mount option to prevent attackers from opening device files.
You can use MAC system to prevent attackers from mounting partitions (other than
/dev partition) without "nodev" option.


> 2) The MAC system may not be able to guarantee certain combinations
>    of device names and properties, but isn't that policy that shouldn't
>    be in the kernel anyway? But if it is, shouldn't all device nodes be
>    checked? That is, shouldn't it be a global check instead of a filesystem
>    specific one?
I think the reason why MAC system doesn't handle filename/attributes pairs is that:

    Filename and its attributes pairs are conventionally considered as
    constant and reliable.

    It makes the MAC's policy syntax complicated to describe this attribute
    enforcement information in MAC's policy.

Thus, this should be a global check. But usually device nodes are only in /dev .



> 3) Code efficiency. Thousand lines of code just to close one very specific
>    attack, which can be done in lots of different other ways that all need
>    to be prevented by the MAC system. (mounting over it, intercepting open
>    calls, duping the fd, etc.) Is it worth it?
This filesystem is doing what MAC system is not doing.
So, please don't complain about inability of this filesystem to close all attacks.
You can use MAC system to prevent attackers from mounting other filesystem
over this filesystem.

The filename/attribute pairs are something like system call entry tables.
The application will go wrong if __NR_read is mapped to sys_write() and
__NR_write is mapped to sys_read().
Userland applications access special functionalities (e.g. /dev/zero and /dev/random)
by name (i.e. syscall numbers). Therefore, keeping the filename/attribute pairs
tamper-proof is important.

You recognize that there is a threat that device nodes may have irregular
attribute (e.g. /dev/null existing as a regular file), do you?
You don't deny implementing mechanisms somehow to avoid such threat, do you?
OK. Then the matter is the comparison of code efficiency.

This patch is less than 1100 lines in total.
Large part of this patch is for parsing and managing policy file.
If you try to extend every MAC implementation (SELinux, SMACK, AppArmor, TOMOYO)
so that they can handle filename/attributes pairs (i.e. expand policy file's syntax
and both in-kernel and userland data structures, manage strings with variant length
and non-printable characters etc.), I think that modification exceeds this patch.
I think guaranteeing filename/attribute pairs in filesystem layer can keep
MAC system implementation simple and compact.
http://www.mail-archive.com/linux-fsdevel@vger.kernel.org/msg10653.html


Thank you.
