Return-Path: <linux-kernel-owner+w=401wt.eu-S1758539AbYDXOso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539AbYDXOso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756123AbYDXOsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:48:30 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45386 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336AbYDXOs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:48:27 -0400
Date: Thu, 24 Apr 2008 09:48:23 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Toshiharu Harada <haradats@nttdata.co.jp>
Cc: linux-kernel@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>
Subject: Re: [TOMOYO #7 00/30] TOMOYO Linux 1.6.0 released
Message-ID: <20080424144823.GA12053@sergelap.austin.ibm.com>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp> <48101A71.3020403@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48101A71.3020403@nttdata.co.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Toshiharu Harada (haradats@nttdata.co.jp):
> After examining the feedback to our latest patches and some personal
> suggestions sent via e-mail, we came to realize we took totally
> wrong way to propose another access control implementation.
> I apologize for that and thank people for comments and suggestions
> from the bottom of my heart.
>
> The following Jonathan's LWN article is a real *great*, in-depth
> explanation of TOMOYO Linux and pathname-based security history.
>
> http://lwn.net/Articles/277833/
>
> As was described in the article, I am planning to take the Stephen's
> "option 2" approach.
>
>> 2) Submit patches to add new security hooks to the callers where the
>> vfsmount is already available (some have suggested moving the existing
>> security_inode hooks to the callers, but that would cause problems for
>> SELinux as I've posted elsewhere, so adding new hooks is preferable, and
>> then SELinux can just default to the dummy functions for those new
>> hooks).

Sounds good.  I suspect to satisfy some critics you'll still need to go
through the exercise of showing that one of TOMOYO's (valid) security
goals can't be met with the other options, but for me personally just
following this approach suffices.

thanks,
-serge

> This approach should not require large impacts on VFS and filesystems.
> The work is in progress. Our next patch will include:
> - new LSM hooks for TOMOYO Linux
> - the smallest set of hooks (to save reviewers' time)
>
> BTW, we have attended the ELC2008 and listened to the Andrew's keynote.
> Yes, we were encouraged deeply, again. We, TOMOYO Linux developers,
> are serious about getting our code into the mainline, we will
> continue working like Casey (and "ask him" in case of trouble).
>
> We will be back (with our new patches). :)
>
> Cheers,
> Toshiharu Harada
> NTT DATA CORPORATION
>
> On 4/4/2008 9:22 PM, Tetsuo Handa wrote:
>> What is TOMOYO Linux for?
>>   It is userland applications' charge to keep processes under control.
>>   This includes that userland applications restrict what programs are
>>   permitted to execute and what files are permitted to read/write
>>   by the application.
>>   Thus, the kernel does whatever asked by the userland applications.
>>   But userland applications often make mistakes such as buffer overflow,
>>   OS command injection, directory traversal etc.
>>   As a result, they can't always keep processes under control.
>>   TOMOYO Linux is developed to take partial charge of keeping processes
>>   under control, by teaching the kernel what programs are
>>   permitted to execute and what files are permitted to read/write
>>   by the application and letting the kernel check it once again.
>> Can TOMOYO Linux coexist with SELinux, SMACK, AppArmor etc. ?
>>   Yes. TOMOYO Linux 1.x is not using LSM because I want don't want to 
>> disable
>>   different access control implementations.
>>   TOMOYO Linux is good at dealing with the subject's request chains,
>>   while LSM is good at dealing with object's life-cycle.
>> What are new features of this release?
>>   This release reinforced execution parameter checks.
>>   Introduced execute handler mechanism.
>>     The usage of TOMOYO Linux is that understand what programs are 
>> executed and
>>     what files are opened by individual applications and let the kernel
>>     enforce them. Thus, assuming that all programs needed by individual
>>     applications are known by the time of enforcing, attempts to execute
>>     not ever observed application (e.g. /bin/sh) are considered to be 
>> attacks.
>>     Some shellcode (an exploit code used to execute /bin/sh) attempts to
>>     execute /bin/sh until the execution succeeds. One of such shellcodes 
>> is
>>     Samba's trans2open exploit. It attempts to execute /bin/sh from 
>> infinite
>>     loop. As a result, just rejecting execute request of /bin/sh triggers
>>     CPU power consumption problem (all CPU powers are eaten by the 
>> shellcode's
>>     infinite loop).
>>     But by using execute handler, you can run different programs instead 
>> of
>>     just rejecting execute request to redirect the process to somewhere 
>> else.
>>     This redirection mechanism is useful for deploying on demand honey 
>> pot.
>>     You can provide regular service in peacetime, and you can redirect
>>     the attacker trying to start /bin/sh to honey pot in wartime.
>>     Also, since the fact that a program which is different from the 
>> requested
>>     one is executed by execute handler is not notified to the caller 
>> process,
>>     you can use execute handler as a transparent validation interface
>>     like "Web Application Firewall" or "AntiVirus". You can monitor
>>     parameters passed to execve() and stdio to drop unwanted parameters or
>>     reject the execution of the program requested by the caller process.
>>   Introduced "struct linux_bprm" checks.
>>     Proper codes tends to setting up argv[] and envp[] when executing
>>     a new program. But shellcodes tend to not setting up argv[] and envp[]
>>     when executed using buffer overflows.
>>     Thus, it became possible to require specific argv[] and envp[] values
>>     when executing a program.
>>   Introduced environment variable names checks.
>>     Some environment variables (e.g. LD_PRELOAD) are used by attackers to 
>> make
>>     the application behave differently.
>>     Thus, it became possible to restrict acceptable environment variable's
>>     names passed to execve().
>>   And various usability enhancement like more detailed access logs and
>>   policy management by non root user.
>> Is TOMOYO Linux architecture independent?
>>   Yes. I think TOMOYO Linux doesn't contain architecture dependent code.
>>   TOMOYO Linux touches only surface of the kernel code.
>> Are older kernels supported?
>>   Yes. From 2.4.30 to 2.4.36 and from 2.6.11 to 2.6.25-rc7 are supported.
>>   Also, various distributions' latest kernels are supported.
>> Where's the web page?
>>   http://elinux.org/TomoyoLinux
>>   http://tomoyo.sourceforge.jp/wiki-e/?WhatIs
>>   http://sourceforge.jp/projects/tomoyo/document/fosdem2008.pdf
>>   TOMOYO Linux is compact and suits well to PC servers and embedded 
>> systems.
>>   There is a TOMOYO Linux presentation at CELF Embedded Linux Conference 
>> 2008
>>   held in California from April 15th to the 17th.
>> Thank you.
>
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
