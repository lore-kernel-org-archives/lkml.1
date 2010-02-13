Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab0BMVav (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 16:30:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758110Ab0BMV3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 16:29:46 -0500
Message-ID: <4B7719AC.6040901@redhat.com>
Date: Sat, 13 Feb 2010 22:29:16 +0100
From: Michael Stefaniuc <mstefani@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: prasad@linux.vnet.ibm.com
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: Regression in ptrace (Wine) starting with 2.6.33-rc1
References: <4B743149.4000707@redhat.com> <20100211182224.GC4915@nowhere> <4B745F5C.5050001@redhat.com> <20100213173323.GB3778@in.ibm.com>
In-Reply-To: <20100213173323.GB3778@in.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2010 06:33 PM, K.Prasad wrote:
> On Thu, Feb 11, 2010 at 08:49:48PM +0100, Michael Stefaniuc wrote:
>> On 02/11/2010 07:22 PM, Frederic Weisbecker wrote:
>>> On Thu, Feb 11, 2010 at 05:33:13PM +0100, Michael Stefaniuc wrote:
>>>> 2.6.33-rc1 broke ptrace for Wine, specifically the setting of the debug
>>>> registers. This is visible in the Wine ntdll exception tests failing on
>>>> 2.6.33-rcX while they work just fine in 2.6.32.
>>>>
>>>> A regression test resulted in:
>>>> 72f674d203cd230426437cdcf7dd6f681dad8b0d is the first bad commit
>>>> commit 72f674d203cd230426437cdcf7dd6f681dad8b0d
>>>> Author: K.Prasad<prasad@linux.vnet.ibm.com>
>>>> Date:   Mon Jun 1 23:45:48 2009 +0530
>>>>
>>>>       hw-breakpoints: modify Ptrace routines to access breakpoint registers
>>>>
>>
>>> Thanks a lot for your report. Is there an easy way to reproduce
>>> this?
>> Yes, the bug is 100% reproducible. Even the "stack overflow" bytes are
>> always constant on my two boxes: 932 bytes on my Atom and 1588 bytes on
>> my Q9450 with a x86_64 kernel.
>>
>> Either grab wine-1.1.38 from
>> http://sourceforge.net/projects/wine/files/Source/ or from git
>>    git clone git://source.winehq.org/git/wine.git
>> configure
>> make
>> cd dlls/ntdll/tests/
>> make exception.ok
>>
>
> Can you be more specific with details - such as what was the desired
> action/return value of ptrace that your testcase wanted but did not
> happen (after the patch applied)? What is the other regression that
> you found as a result of another patch in the hw-breakpoint patch
> series?
>
> I am able to see a user-space stackdump upon a 'make exception.ok',
> which isn't easy enough (atleast for me) to narrow down to the purported
> ptrace defect.
Here is a discussion I had with the Wine maintainer on what that
specific test does exactly:
<julliard> puk: the test changes the debug regs in the context, which 
makes the server use ptrace to change the debug regs in the test process
<puk> cool
<puk> so i basically just do an strace on the server
<julliard> then it does a GetContext to verify that they have been set 
correctly
<julliard> yes all the ptrace calls are in the server
<puk> and capture what ptrace returns
<puk> let me guess GetContext uses ptrace too?
<julliard> yes
<julliard> if it even gets to that point, it sounded like it was 
crashing inside the exception handler

The wineserver is basically the "kernel space" in Wine.

Test setup:
-----------
# Start the wineserver and and attach to it
wineserver
strace -p $wineserver_pid >& strace.out
# Run the test
cd dlls/ntdll/tests/
make exception.ok

Results 2.6.33-rcX:
-------------------
ptrace(PTRACE_ATTACH, 18036, 0, 0)      = 0
ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg), 
0x42424242) = 0
ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg) + 4, 0) = 0
ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg) + 8, 0) = 0
ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg) + 12, 
0) = 0
ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg) + 24, 
0) = 0
ptrace(PTRACE_POKEUSER, 18036, offsetof(struct user, u_debugreg) + 28, 
0x155) = -1 EINVAL (Invalid argument)

Results 2.6.32:
---------------
trace(PTRACE_ATTACH, 3077, 0, 0)       = 0
ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg), 
0x42424242) = 0
ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg) + 4, 0) = 0
ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg) + 8, 0) = 0
ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg) + 12, 0) = 0
ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg) + 24, 0) = 0
ptrace(PTRACE_POKEUSER, 3077, offsetof(struct user, u_debugreg) + 28, 
0x155) = 0

So it looks like something in the setting of DR7 is broken or at least
changed behavior. The function in Wine that does those calls is
set_thread_context() from server/ptrace.c .

I'll try to see if I can reproduce the other regression; as it is hidden 
at the moment by this regression.

Thanks for looking at the problem.
bye
         michael
