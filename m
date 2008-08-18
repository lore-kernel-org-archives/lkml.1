Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbYHROJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbYHROJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbYHROJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:09:39 -0400
Received: from sacred.ru ([62.205.161.221]:45842 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbYHROJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:09:39 -0400
Message-ID: <48A98293.5080109@openvz.org>
Date: Mon, 18 Aug 2008 18:09:23 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] binfmt_misc.c: avoid potential kernel stack overflow
References: <20080818112849.GA4951@localhost.localdomain>
In-Reply-To: <20080818112849.GA4951@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 18 Aug 2008 18:09:21 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Put lkml in Cc. The original message is beyond)

Oops! My fault. The problem is that in case of modularized binfmt,
the appropriate binary handler gets registered _before_ the script
one and sets the misc_bang flag even too early.

Thus when we launch a script the load_misc_binary sets this bang,
then returns error, since the binary is actually a script, then the
load_script_binary successfully loads the script, then it loads the
misc binary again, which exits with the -ENOEXEC error due to bang 
set.

This patch helped my box, what about yours?

diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 7562053..8d7e88e 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -120,8 +120,6 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	if (bprm->misc_bang)
 		goto _ret;
 
-	bprm->misc_bang = 1;
-
 	/* to keep locking time low, we copy the interpreter string */
 	read_lock(&entries_lock);
 	fmt = check_file(bprm);
@@ -199,6 +197,8 @@ static int load_misc_binary(struct linux_binprm *bprm, struct pt_regs *regs)
 	if (retval < 0)
 		goto _error;
 
+	bprm->misc_bang = 1;
+
 	retval = search_binary_handler (bprm, regs);
 	if (retval < 0)
 		goto _error;

> On Tue, Apr 29, 2008 at 12:59:24AM -0700, Pavel Emelyanov wrote:
>> This can be triggered with root help only, but...
>>
>> Register the ":text:E::txt::/root/cat.txt:' rule in binfmt_misc (by root) and
>> try launching the cat.txt file (by anyone) :) The result is - the endless
>> recursion in the load_misc_binary -> open_exec -> load_misc_binary chain and
>> stack overflow.
>>
>> There's a similar problem with binfmt_script, and there's a sh_bang memner on
>> linux_binprm structure to handle this, but simply raising this in binfmt_misc
>> may break some setups when the interpreter of some misc binaries is a script.
>>
>> So the proposal is to turn sh_bang into a bit, add a new one (the misc_bang)
>> and raise it in load_misc_binary.  After this, even if we set up the misc ->
>> script -> misc loop for binfmts one of them will step on its own bang and
>> exit.
> 
> This patch causes problem in some cases, if the kernel compiled with 
> CONFIG_BINFMT_MISC=m:
> 
> $ pwd
> /tmp/chroot
> $ cat test0.c 
> #include <stdio.h>
> 
> int main(void)
> {
>         printf("test\n");
>         return 0;
> }
> $ gcc test0.c -o test0 -static
> $ sudo sh -c 'echo ":test:M::123::/test0:" > /proc/sys/fs/binfmt_misc/register'
> $ cat test1
> 123
> $ cat test2
> #!/test1
> $ sudo chroot /tmp/chroot /test2
> chroot: cannot run command `/test2': No such file or directory
> $ sudo strace chroot /tmp/chroot /test2
> ...
> execve("/test2", ["/test2"], [/* 54 vars */]) = -1 ENOEXEC (Exec format error)
> ...
> 
> This test works fine if I revert the patch or compile with CONFIG_BINFMT_MISC=y.
> 

