Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbYGLKcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbYGLKcp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 06:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYGLKch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 06:32:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:62606 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbYGLKcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 06:32:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=R6eQ2dLGVK6moHhSfu5H9KJ9n/g+TuQ4cWCVK1m7J/bz4Yg1ftRN86KIhHWP/DTIDQ
         F/Evv0DTYAcWD3/mbi65c67mA29zJH3cS1bZ7BfeGx7kl1W9Gd28dmBB0xab3WkYdX50
         xlcNx1uLx96FQfBmOGOPdlvnzGtr/58cpkkp4=
Message-ID: <4878883F.10004@gmail.com>
Date: Sat, 12 Jul 2008 13:32:31 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>,
       Arjan van de Ven <arjan@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] x86_64: fix delayed signals
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu> <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807111102450.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807111337060.2873@woody.linux-foundation.org> <alpine.LFD.1.10.0807111617470.3459@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807111617470.3459@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-07-12 02:22, Linus Torvalds wrote:
> On Fri, 11 Jul 2008, Linus Torvalds wrote:
>   
>> No, after testing more, I think Edwin is right.
>>     
>
> Naah. It is true that there is a huge delay in doing
>
> 	ls -l /usr/bin
>
> and then pressing ^C, but after having hit my head against this for a 
> while, I realized that it has nothing to do with the kernel.
>
> Doing an "strace ls" showed that ls doesn't play any games with signals 
> etc, which fooled me into looking for a kernel reason. 
>
> HOWEVER, it looks like at least fedora does a
>
> 	alias ls='ls --color=auto'
>
> and it turns out that if you do that --color=auto, then ls will indeed 
> catch all normal signals and set a "please stop now" flag, instead of 
> dying immediately. The reason is probably to avoiding leaving the terminal 
> with some odd color if interrupted in an inconvenient place.
>
> So I was chasing this latency thing totally unnecessarily. It's in user 
> space (or at least _my_ particular issue was).
>
> Other user cases may obviously be elsewhere.

Thanks for looking into the problem.
I did some more testing, and here are my results so far (with my
testcase of running dd and find):

On my 32-bit box (slow disks, SMP, XFS filesystem) 2.6.26-rc9 behaves
the same as 2.6.26-rc8, I can reliably reproduce a 2-3 second latency
[1] between pressing ^C the first time, and the shell returning (on the
text console too).
Using ftrace available from tip/master, I see up to 3 seconds of delay
between kill_pgrp and detach_pid (and during that time I can press ^C
again, leading to 2-3 kill_pgrp calls)

On my 64-bit box (2 disks in raid-0, UP, reiserfs filesystem) 2.6.25 and
2.6.26-rc9 behave the same, and most of the time (10-20 times in a row)
find responds to ^C instantly.
However in _some_ cases find doesn't respond to ^C for a very long time
(~30 seconds), and when this happens I can't do anything else but switch
consoles,
starting another process (latencytop -d) hangs, and so does any other
external command.
I have tried to get a latencytop output from the 64-bit box, but I
couldn't reproduce the long latency when latencytop was running.
I have reproduced the latency after launching/killing find 20+ times,
but after I started latencytop I couldn't reproduce.
But I can no longer reproduce it now, even if I stop latencytop (and
latencytop sysctl _is_ 0).

I haven't yet tried ftrace on this box, and neither did I try Roland's
patch yet. I will try that now, and hopefuly come back with some numbers
shortly.


[1]
I switch to text console, then I run this script in the background:

cd /debug/tracing
echo kill_pgrp detach_pid\
     >set_ftrace_filter
echo ftrace >current_tracer
echo 1 >tracing_enabled
sleep 60
echo 0 >tracing_enabled
cat trace >/tmp/trace.out
cat latency_trace >/tmp/latencytrace.out

Then I run this script in the background, and wait until in shows
'Waiting for dd to finish':
dd if=/dev/zero of=xt bs=100M count=4&
dd if=/dev/zero of=yt bs=100M count=4&
rm xt
rm yt
echo "Waiting for dd to finish..."
wait  %1 %2
echo "Done"

Then I start  'find / >/dev/null 2>/dev/null, and type ^C after about a
second'.
trace and latencytrace outputs below (for the 32-bit box):

# tracer: ftrace
#
#           TASK-PID   CPU#    TIMESTAMP  FUNCTION
#              | |      |          |         |
        events/0-9     [00]   450.146629: kill_pgrp <-n_tty_receive_buf
            bash-5821  [00]   450.386653: detach_pid <-release_task
        events/0-9     [00]   451.631327: kill_pgrp <-n_tty_receive_buf
        events/0-9     [00]   452.394820: kill_pgrp <-n_tty_receive_buf
        events/0-9     [00]   453.127932: kill_pgrp <-n_tty_receive_buf
            bash-5821  [00]   453.143686: detach_pid <-release_task
            bash-5821  [00]   453.143686: detach_pid <-release_task
            bash-5821  [00]   453.143686: detach_pid <-release_task
^^^^^^^^^^^^ I had to press ^C 3 times here, and there is a ~2 sec delay

        events/0-9     [00]   454.164452: kill_pgrp <-n_tty_receive_buf
        events/0-9     [00]   455.027774: kill_pgrp <-n_tty_receive_buf
        events/0-9     [00]   455.762679: kill_pgrp <-n_tty_receive_buf
            bash-5821  [00]   455.770332: detach_pid <-release_task
            bash-5821  [00]   455.770332: detach_pid <-release_task
            bash-5821  [00]   455.770332: detach_pid <-release_task
^^^^^^^ again,  a 1 second delay
        events/0-9     [00]   456.718620: kill_pgrp <-n_tty_receive_buf
            bash-5821  [00]   456.862658: detach_pid <-release_task
            bash-5821  [00]   456.862658: detach_pid <-release_task
            bash-5821  [00]   456.862658: detach_pid <-release_task
        events/0-9     [00]   457.880204: kill_pgrp <-n_tty_receive_buf
            bash-5821  [00]   457.908467: detach_pid <-release_task
            bash-5821  [00]   457.908467: detach_pid <-release_task
            bash-5821  [00]   457.908467: detach_pid <-release_task
        events/0-9     [00]   459.238903: kill_pgrp <-n_tty_receive_buf
            bash-5821  [00]   460.081542: detach_pid <-release_task
            bash-5821  [00]   460.081542: detach_pid <-release_task
            bash-5821  [00]   460.081542: detach_pid <-release_task
        events/0-9     [00]   460.083701: kill_pgrp <-n_tty_receive_buf
        events/0-9     [00]   462.246407: kill_pgrp <-n_tty_receive_buf
        events/0-9     [00]   462.975581: kill_pgrp <-n_tty_receive_buf
            bash-5821  [00]   463.583139: detach_pid <-release_task
^^^^^^^^^^^^^^^^^^^ 3.5 second delay here
            bash-5821  [00]   463.583139: detach_pid <-release_task
            bash-5821  [00]   463.583139: detach_pid <-release_task
        events/0-9     [00]   463.699181: kill_pgrp <-n_tty_receive_buf
        events/0-9     [00]   464.735022: kill_pgrp <-n_tty_receive_buf
            bash-5821  [00]   465.094654: detach_pid <-release_task
            bash-5821  [00]   465.094654: detach_pid <-release_task
            bash-5821  [00]   465.094654: detach_pid <-release_task
        events/0-9     [00]   466.537663: kill_pgrp <-n_tty_receive_buf
            bash-5821  [00]   466.945909: detach_pid <-release_task

# tracer: ftrace
#
ftrace latency trace v1.1.5 on 2.6.26-rc9-tip-01669-g639a570
--------------------------------------------------------------------
 latency: 0 us, #210/210, CPU#0 | (M:unknown VP:0, KP:0, SP:0 HP:0 #P:2)
    -----------------
    | task: -0 (uid:0 nice:0 policy:0 rt_prio:0)
    -----------------

#                _------=> CPU#           
#               / _-----=> irqs-off       
#              | / _----=> need-resched   
#              || / _---=> hardirq/softirq
#              ||| / _--=> preempt-depth  
#              |||| /                     
#              |||||     delay            
#  cmd     pid ||||| time  |   caller     
#     \   /    |||||   \   |   /          
kstopmac-6225  0d..3   10us : detach_pid (release_task)
kstopmac-6225  0d..3   10us : detach_pid (release_task)
kstopmac-6225  0d..3   10us : detach_pid (release_task)
    init-1     0d..3   10us : detach_pid (release_task)
    init-1     0d..3   10us : detach_pid (release_task)
    init-1     0d..3   10us!: detach_pid (release_task)
      sh-6228  1d..3 3944272us+: detach_pid (release_task)
      sh-6228  1d..3 3944273us : detach_pid (release_task)
      sh-6228  1d..3 3944274us!: detach_pid (release_task)
      sh-6228  1d..3 3945744us+: detach_pid (release_task)
      sh-6228  1d..3 3945745us : detach_pid (release_task)
      sh-6228  1d..3 3945746us!: detach_pid (release_task)
hal-syst-6233  0d..3 4156674us : detach_pid (release_task)
hal-syst-6233  0d..3 4156674us : detach_pid (release_task)
hal-syst-6233  0d..3 4156674us!: detach_pid (release_task)
hald-run-5416  0d..3 4160008us : detach_pid (release_task)
hald-run-5416  0d..3 4160008us : detach_pid (release_task)
hald-run-5416  0d..3 4160008us!: detach_pid (release_task)
events/0-9     0.... 9523335us!: kill_pgrp (n_tty_receive_buf)
    bash-5821  0d..3 9763359us : detach_pid (release_task)
    bash-5821  0d..3 9763359us : detach_pid (release_task)
    bash-5821  0d..3 9763359us!: detach_pid (release_task)
hal-syst-6236  0d..3 10167777us : detach_pid (release_task)
hal-syst-6236  0d..3 10167779us : detach_pid (release_task)
hal-syst-6236  0d..3 10167779us!: detach_pid (release_task)
hald-run-5416  0d..3 10172764us : detach_pid (release_task)
hald-run-5416  0d..3 10172765us : detach_pid (release_task)
hald-run-5416  0d..3 10172765us!: detach_pid (release_task)
events/0-9     0.... 11008033us!: kill_pgrp (n_tty_receive_buf)
events/0-9     0.... 11771525us!: kill_pgrp (n_tty_receive_buf)
events/0-9     0.... 12504637us!: kill_pgrp (n_tty_receive_buf)
    bash-5821  0d..3 12520392us : detach_pid (release_task)
    bash-5821  0d..3 12520392us : detach_pid (release_task)
    bash-5821  0d..3 12520392us!: detach_pid (release_task)
events/0-9     0.... 13541157us!: kill_pgrp (n_tty_receive_buf)
events/0-9     0.... 14404479us!: kill_pgrp (n_tty_receive_buf)
events/0-9     0.... 15139385us!: kill_pgrp (n_tty_receive_buf)
    bash-5821  0d..3 15147037us : detach_pid (release_task)
    bash-5821  0d..3 15147037us : detach_pid (release_task)
    bash-5821  0d..3 15147037us!: detach_pid (release_task)
events/0-9     0.... 16095325us!: kill_pgrp (n_tty_receive_buf)
hal-syst-6242  0d..3 16180193us : detach_pid (release_task)
hal-syst-6242  0d..3 16180193us : detach_pid (release_task)
hal-syst-6242  0d..3 16180193us!: detach_pid (release_task)
hald-run-5416  0d..3 16183420us : detach_pid (release_task)
hald-run-5416  0d..3 16183420us : detach_pid (release_task)
hald-run-5416  0d..3 16183420us!: detach_pid (release_task)
    bash-5821  0d..3 16239363us : detach_pid (release_task)
    bash-5821  0d..3 16239363us : detach_pid (release_task)
    bash-5821  0d..3 16239363us!: detach_pid (release_task)
events/0-9     0.... 17256910us!: kill_pgrp (n_tty_receive_buf)
    bash-5821  0d..3 17285172us : detach_pid (release_task)
    bash-5821  0d..3 17285172us : detach_pid (release_task)
    bash-5821  0d..3 17285172us!: detach_pid (release_task)
events/0-9     0.... 18615608us!: kill_pgrp (n_tty_receive_buf)
    bash-5821  0d..3 19458248us : detach_pid (release_task)
    bash-5821  0d..3 19458248us : detach_pid (release_task)
    bash-5821  0d..3 19458248us!: detach_pid (release_task)
events/0-9     0.... 19460406us!: kill_pgrp (n_tty_receive_buf)
events/0-9     0.... 21623112us!: kill_pgrp (n_tty_receive_buf)
hal-syst-6247  0d..3 22194451us : detach_pid (release_task)
hal-syst-6247  0d..3 22194453us : detach_pid (release_task)
hal-syst-6247  0d..3 22194453us!: detach_pid (release_task)
hald-run-5416  0d..3 22199518us : detach_pid (release_task)
hald-run-5416  0d..3 22199520us : detach_pid (release_task)
hald-run-5416  0d..3 22199520us!: detach_pid (release_task)
events/0-9     0.... 22352287us!: kill_pgrp (n_tty_receive_buf)
    bash-5821  0d..3 22959844us : detach_pid (release_task)
    bash-5821  0d..3 22959844us : detach_pid (release_task)
    bash-5821  0d..3 22959844us!: detach_pid (release_task)
events/0-9     0.... 23075886us!: kill_pgrp (n_tty_receive_buf)
events/0-9     0.... 24111727us!: kill_pgrp (n_tty_receive_buf)
    bash-5821  0d..3 24471359us : detach_pid (release_task)
    bash-5821  0d..3 24471359us : detach_pid (release_task)
    bash-5821  0d..3 24471359us!: detach_pid (release_task)
events/0-9     0.... 25914368us!: kill_pgrp (n_tty_receive_buf)
    bash-5821  0d..3 26322615us : detach_pid (release_task)
    bash-5821  0d..3 26322615us : detach_pid (release_task)
    bash-5821  0d..3 26322615us!: detach_pid (release_task)
hal-syst-6252  0d..3 28207618us : detach_pid (release_task)
hal-syst-6252  0d..3 28207619us : detach_pid (release_task)
hal-syst-6252  0d..3 28207620us!: detach_pid (release_task)
hald-run-5416  0d..3 28212746us : detach_pid (release_task)
hald-run-5416  0d..3 28212747us : detach_pid (release_task)
hald-run-5416  0d..3 28212748us!: detach_pid (release_task)
events/0-9     0.... 28473354us!: kill_pgrp (n_tty_receive_buf)
events/0-9     0.... 29208378us!: kill_pgrp (n_tty_receive_buf)
 pdflush-236   1d..3 29463682us+: detach_pid (release_task)
 pdflush-236   1d..3 29463684us : detach_pid (release_task)
 pdflush-236   1d..3 29463685us!: detach_pid (release_task)
    bash-5821  0d..3 29633203us : detach_pid (release_task)
    bash-5821  0d..3 29633203us : detach_pid (release_task)
    bash-5821  0d..3 29633203us!: detach_pid (release_task)
events/0-9     0.... 31177193us!: kill_pgrp (n_tty_receive_buf)
events/0-9     0.... 32081149us!: kill_pgrp (n_tty_receive_buf)
    bash-5821  0d..3 32096726us : detach_pid (release_task)
    bash-5821  0d..3 32096726us : detach_pid (release_task)
    bash-5821  0d..3 32096726us!: detach_pid (release_task)
hal-syst-6255  0d..3 34221092us : detach_pid (release_task)
hal-syst-6255  0d..3 34221094us : detach_pid (release_task)
hal-syst-6255  0d..3 34221095us!: detach_pid (release_task)
hald-run-5416  0d..3 34226008us+: detach_pid (release_task)
hald-run-5416  0d..3 34226009us : detach_pid (release_task)
hald-run-5416  0d..3 34226010us!: detach_pid (release_task)
events/0-9     0.... 34943377us!: kill_pgrp (n_tty_receive_buf)
    bash-5821  0d..3 34953441us : detach_pid (release_task)
    bash-5821  0d..3 34953441us : detach_pid (release_task)
    bash-5821  0d..3 34953441us!: detach_pid (release_task)
      sh-6228  1d..3 38434166us : detach_pid (release_task)
      sh-6228  1d..3 38434166us : detach_pid (release_task)
      sh-6228  1d..3 38434166us!: detach_pid (release_task)
      sh-6228  1d..3 38740305us+: detach_pid (release_task)
      sh-6228  1d..3 38740307us : detach_pid (release_task)
      sh-6228  1d..3 38740308us!: detach_pid (release_task)
    bash-5821  0d..3 38744188us : detach_pid (release_task)
    bash-5821  0d..3 38744188us : detach_pid (release_task)
    bash-5821  0d..3 38744188us!: detach_pid (release_task)
    bash-5821  0d..3 40161326us : detach_pid (release_task)
    bash-5821  0d..3 40161327us : detach_pid (release_task)
    bash-5821  0d..3 40161328us!: detach_pid (release_task)
hal-syst-6259  0d..3 40233791us : detach_pid (release_task)
hal-syst-6259  0d..3 40233792us : detach_pid (release_task)
hal-syst-6259  0d..3 40233793us!: detach_pid (release_task)
hald-run-5416  0d..3 40238677us : detach_pid (release_task)
hald-run-5416  0d..3 40238678us+: detach_pid (release_task)
hald-run-5416  0d..3 40238680us!: detach_pid (release_task)
    bash-5821  1d..3 43913077us : detach_pid (release_task)
    bash-5821  1d..3 43913077us : detach_pid (release_task)
    bash-5821  1d..3 43913077us!: detach_pid (release_task)
    bash-5821  0d..3 44968815us : detach_pid (release_task)
    bash-5821  0d..3 44968815us : detach_pid (release_task)
    bash-5821  0d..3 44968815us!: detach_pid (release_task)
hal-syst-6263  0d..3 46247842us : detach_pid (release_task)
hal-syst-6263  0d..3 46247844us : detach_pid (release_task)
hal-syst-6263  0d..3 46247845us!: detach_pid (release_task)
hald-run-5416  0d..3 46252860us : detach_pid (release_task)
hald-run-5416  0d..3 46252861us : detach_pid (release_task)
hald-run-5416  0d..3 46252862us!: detach_pid (release_task)
nullmail-5260  1d..3 46591091us : detach_pid (release_task)
nullmail-5260  1d..3 46591092us : detach_pid (release_task)
nullmail-5260  1d..3 46591093us!: detach_pid (release_task)
nullmail-5260  1d..3 46594439us : detach_pid (release_task)
nullmail-5260  1d..3 46594439us : detach_pid (release_task)
nullmail-5260  1d..3 46594439us!: detach_pid (release_task)
nullmail-5260  1d..3 46596485us : detach_pid (release_task)
nullmail-5260  1d..3 46596486us : detach_pid (release_task)
nullmail-5260  1d..3 46596487us!: detach_pid (release_task)
nullmail-5260  1d..3 46599932us : detach_pid (release_task)
nullmail-5260  1d..3 46599933us : detach_pid (release_task)
nullmail-5260  1d..3 46599934us!: detach_pid (release_task)
nullmail-5260  0d..3 46627792us : detach_pid (release_task)
nullmail-5260  0d..3 46627792us : detach_pid (release_task)
nullmail-5260  0d..3 46627792us!: detach_pid (release_task)
nullmail-5260  0d..3 46636851us : detach_pid (release_task)
nullmail-5260  0d..3 46636851us : detach_pid (release_task)
nullmail-5260  0d..3 46636851us!: detach_pid (release_task)
nullmail-5260  0d..3 46647738us : detach_pid (release_task)
nullmail-5260  0d..3 46647740us : detach_pid (release_task)
nullmail-5260  0d..3 46647740us!: detach_pid (release_task)
nullmail-5260  0d..3 46656857us : detach_pid (release_task)
nullmail-5260  0d..3 46656857us : detach_pid (release_task)
nullmail-5260  0d..3 46656857us!: detach_pid (release_task)
nullmail-5260  0d..3 46666791us : detach_pid (release_task)
nullmail-5260  0d..3 46666791us : detach_pid (release_task)
nullmail-5260  0d..3 46666791us!: detach_pid (release_task)
nullmail-5260  0d..3 46680090us : detach_pid (release_task)
nullmail-5260  0d..3 46680090us : detach_pid (release_task)
nullmail-5260  0d..3 46680090us!: detach_pid (release_task)
nullmail-5260  0d..3 46683330us : detach_pid (release_task)
nullmail-5260  0d..3 46683330us : detach_pid (release_task)
nullmail-5260  0d..3 46683330us!: detach_pid (release_task)
nullmail-5260  1d..3 46684182us : detach_pid (release_task)
nullmail-5260  1d..3 46684182us : detach_pid (release_task)
nullmail-5260  1d..3 46684182us!: detach_pid (release_task)
nullmail-5260  1d..3 46687500us : detach_pid (release_task)
nullmail-5260  1d..3 46687500us : detach_pid (release_task)
nullmail-5260  1d..3 46687500us!: detach_pid (release_task)
nullmail-5260  1d..3 46692670us : detach_pid (release_task)
nullmail-5260  1d..3 46692670us : detach_pid (release_task)
nullmail-5260  1d..3 46692670us!: detach_pid (release_task)
    bash-5821  1d..3 47327646us : detach_pid (release_task)
    bash-5821  1d..3 47327647us : detach_pid (release_task)
    bash-5821  1d..3 47327648us!: detach_pid (release_task)
    bash-6280  1d..3 47331181us : detach_pid (release_task)
    bash-6280  1d..3 47331181us : detach_pid (release_task)
    bash-6280  1d..3 47331181us!: detach_pid (release_task)
    bash-5821  1d..3 47331699us : detach_pid (release_task)
    bash-5821  1d..3 47331700us : detach_pid (release_task)
    bash-5821  1d..3 47331701us!: detach_pid (release_task)
    bash-6282  1d..3 47334166us : detach_pid (release_task)
    bash-6282  1d..3 47334166us : detach_pid (release_task)
    bash-6282  1d..3 47334166us : detach_pid (release_task)
    bash-5821  1d..3 47334166us : detach_pid (release_task)
    bash-5821  1d..3 47334166us : detach_pid (release_task)
    bash-5821  1d..3 47334166us!: detach_pid (release_task)
hal-syst-6284  0d..3 52261078us : detach_pid (release_task)
hal-syst-6284  0d..3 52261079us : detach_pid (release_task)
hal-syst-6284  0d..3 52261080us!: detach_pid (release_task)
hald-run-5416  0d..3 52266033us+: detach_pid (release_task)
hald-run-5416  0d..3 52266034us : detach_pid (release_task)
hald-run-5416  0d..3 52266035us!: detach_pid (release_task)
hal-syst-6286  0d..3 58273784us : detach_pid (release_task)
hal-syst-6286  0d..3 58273786us : detach_pid (release_task)
hal-syst-6286  0d..3 58273786us!: detach_pid (release_task)
hald-run-5416  0d..3 58278681us : detach_pid (release_task)
hald-run-5416  0d..3 58278682us : detach_pid (release_task)
hald-run-5416  0d..3 58278683us!: detach_pid (release_task)
      sh-6224  0d..3 60000916us+: detach_pid (release_task)
      sh-6224  0d..3 60000918us : detach_pid (release_task)
      sh-6224  0d..3 60000919us : detach_pid (release_task)


vim:ft=help

Best regards,
--Edwin
