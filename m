Return-Path: <linux-kernel-owner+w=401wt.eu-S1751325AbXCZNDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbXCZNDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 09:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbXCZNDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 09:03:05 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42448 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbXCZNDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 09:03:01 -0400
Message-ID: <4607C47B.2030909@hitachi.com>
Date: Mon, 26 Mar 2007 22:02:51 +0900
From: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja-JP; rv:1.4) 
    Gecko/20030624 Netscape/7.1 (ax)
X-Accept-Language: ja
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       kernel list <linux-kernel@vger.kernel.org>, Robin Holt <holt@sgi.com>,
       David Howells <dhowells@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>, Hideo AOKI <haoki@redhat.com>
Subject: Re: [PATCH 1/4] coredump: add an interface to control the core dump
    routine
References: <45E7AAFA.4070402@hitachi.com> <45E7AC6F.8080704@hitachi.com> 
    <20070302093419.GA2001@elf.ucw.cz>
In-Reply-To: <20070302093419.GA2001@elf.ucw.cz>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel, 
Thank you for your reply.
I'm sorry for my late reply.

I have discussed with my colleagues why you say "ugly" against my
procfs interface, then I noticed I may have misunderstood what you said.
Is the reason for saying "ugly" two interfaces, i.e. preexisting ulimit
(get/setrlimit) and my proc entry, exist to control core file size? 
If so, I'm sorry for taking your precious time by proceeding to the
discussion without enough understanding.

Assuming my presumption is true, I don't think it's so ugly because
there are other parameters to control core dumping such as dumpable
(controled by prctl(2)) and suid_dumpable (controled via
fs.suid_dumpable sysctl).
What would you think about that?

Anyway, here are the answers to what you pointed out.


Pavel Machek wrote:

>>This patch adds an interface to set/reset a flag which determines
>>anonymous shared memory segments should be dumped or not when a core
>>file is generated.
>>
>>/proc/<pid>/coredump_omit_anonymous_shared file is provided to access
>>the flag. You can change the flag status for a particular process by
>>writing to or reading from the file.
> 
> Yes. So, you used very different interface interface from ulimit,
> which means locking is hard.

I'd like to allow users to change the flag from other process.  So I
have to do locking even if it is hard.  You said this flexibility was
not an advantage before, but in some cases, it is needed.

Please assume the case where a process forks many children and they
share a huge shared memory.  Sometimes an end user wants to set 
coredump_omit_anon_shared flag to those processes except for a
particular child process.  With ulimit (setrlimit) interface,
the user can't do such setup without modifying the application
program.  But normal end user will not be able to modify the program.


> Plus, what you are doing can be done in userspace using google
> coredumper.

I think that the needs differ between userland core dumper user and
in-kernel core dumper user.  Pros and cons also differ.

Some of people (such as system admins, distro vendors, etc) need
highly reliable core dumper because they don't want to experience
same failures again and they don't hope that another failure is
caused by core dumping.  Userland core dumper is useful because
it is relatively easy to be customized, but its reliability highly
depends on the application programs.

If the stack for signal handlers is not set up carefully, if the
data used by userland core dumper has been destroyed, if
coredump_omit_anon_shared flag has been overwritten by bad data,
or if the address of functions have been destroyed, the userland
core dumper may fail to dump.  So in-kernel solutoin is required
by enterprise users.


>>+	if (down_write_trylock(&coredump_settings_sem)) {
>>+		set_coredump_omit_anon_shared(mm, (val != 0));
>>+		up_write(&coredump_settings_sem);
>>+	} else
>>+		ret = -EBUSY;
> 
> Now this is an ugly interface. "If user tries to write to /proc file
> while it is locked, return him spurious error.

I'm considering using the previous argument passing approach (preserves
the setting value into a local variable and then passes it to core dump
routines) or another approach which introduce a per-process flag to
indicate that core dump is ongoing.  Both of these approach never
produce spurious errors.

 
>>@@ -75,6 +77,8 @@ extern int suid_dumpable;
>> #define SUID_DUMP_USER		1	/* Dump as user of process */
>> #define SUID_DUMP_ROOT		2	/* Dump as root */
>> 
>>+extern struct rw_semaphore coredump_settings_sem;
>>+
>> /* Stack area protections */
>> #define EXSTACK_DEFAULT   0	/* Whatever the arch defaults to */
>> #define EXSTACK_DISABLE_X 1	/* Disable executable stacks */
> 
> Yep, very nice, if you used interface suited for the task (ulimit),
> you'd not have to invent new locking like this.

Using the above-stated approach, this semaphore becomes unnecessary.


Thanks,
-- 
Hidehiro Kawai
Hitachi, Ltd., Systems Development Laboratory

