Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab0BRPE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 10:04:56 -0500
Received: from mail.windriver.com ([147.11.1.11]:40180 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756980Ab0BRPEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 10:04:53 -0500
Message-ID: <4B7D5704.6060504@windriver.com>
Date: Thu, 18 Feb 2010 09:04:36 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, mort@sgi.com, linux-arch@vger.kernel.org
Subject: Re: [PATCH 08/28] kdb: core for kgdb back end (2 of 2)
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com><1266014143-29444-9-git-send-email-jason.wessel@windriver.com> <m1zl37xhmm.fsf@fess.ebiederm.org>
In-Reply-To: <m1zl37xhmm.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Feb 2010 15:04:31.0603 (UTC) FILETIME=[ACA76C30:01CAB0AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Jason Wessel <jason.wessel@windriver.com> writes:
>
>   
>> This patch contains the hooks and instrumentation into kernel which
>> live outside the kernel/debug directory, which the kdb core
>> will call to run commands like lsmod, dmesg, bt etc...
>>     
>
> You know this dropping the locks from vmalloc_info and swap_info
> is down right ugly, and I don't believe it is safe.  That code
> was not designed to run while the write_lock is held.
>   

Perhaps we can find some middle ground.  I don't mind simply not
allowing the information to be queried from kdb if the locks are not
available. 

Which is less ugly you, making the swap_lock global or adding a function
to query it?


> How does kdb build if NOMMU is set?
>   

I did not see a kernel config option called NOMMU. 

Can you point me to a kernel config that uses this?   Or is it the case
that it is something like "# CONFIG_MMU is not set"?

Perhaps we just set kdb to work only when CONFIG_MMU is enabled?  It is
hard to say it works or not without a kernel configuration, file system
and hardware to test it with.

> Similarly with si_swapinfo.  What makes it safe to run the
> code without it's locks.  Safe as in no null pointer deferences
> or other nasties.
>
>   

It looks to me like the original kdb took the approach of calling the
setjmp() longjmp() and if there was any kind of fault, it long jumped
back to the original context.  Obviously that doesn't solve any kind of
problem with a list loop.

As I mentioned earlier, I think we should check for the lock and if it
isn't available you don't get to execute the function, else a separate
function has to be written that does the same thing safely.  I do not
see any value in making a separate function to safely print the
information at this time.  If you want to probe around, consider using a
gdb macro.


> I am not impressed with the mess you make of meminfo_proc_show.
> That looks like a maintenance hazard if I ever saw one.  An innocent
> change to get some additional info (that happens to take a lock)
> will cause kdb to deadlock.
>
>   

This code goes away if we expose a way to check for the lock.


Jason.
