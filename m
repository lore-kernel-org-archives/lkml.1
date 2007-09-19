Return-Path: <linux-kernel-owner+w=401wt.eu-S1759124AbXISWyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759124AbXISWyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 18:54:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbXISWxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 18:53:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482AbXISWxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 18:53:43 -0400
Message-ID: <46F1A870.2020109@redhat.com>
Date: Wed, 19 Sep 2007 18:53:36 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Frantisek Rysanek <Frantisek.Rysanek@post.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [newbie:] Bonnie++2 hangs recent 2.6 kernels? Bash keeps looping
 in waitpid(), eating 100% CPU
References: <46E96951.10344.29AE6546@localhost> <46EABE19.27660.2EE1940D@localhost>
In-Reply-To: <46EABE19.27660.2EE1940D@localhost>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2007 11:00 AM, Frantisek Rysanek wrote:
> Dear Mr. Piggin,
> 
> thanks for your response in the first place :-)
> 
> On 13 Sep 2007 at 2:30, Nick Piggin wrote:
>> Can you see if it is looping in userspace or kernel? Can you kill -9
>> the process?
>>
> I can't run any command. Any command hangs or coredumps.
> 
>> Are you able to test with the latest 2.6.23-rc kernel? If not (or if it
>> still has the same problem), then can you get the output of sysrq+T
>> and three sysrq+P calls, please? (this might help work out where in
>> kernel it is spinning).
>>
> I've compiled 2.6.23-rc6, enabled serial console and captured 
> the output of sysrq+P (on the affected virtual VGA console)
> and sysrq+T. 
> 
> http://www.fccps.cz/download/adv/frr/bonnie/2.6.23-rc6.txt
> 
> The interesting bit of information, related to the erratic "bash" 
> processes, is always a single line, such as:
> 
> bash          R running      0  2358      1
> 
> I've also taken a photo of `top` running
> on another virtual console. I can't get any data out of the
> affected box, as I can't run any shell commands...
> 
> http://www.fccps.cz/download/adv/frr/bonnie/top.jpg
> 

Looks like process 2382 is stuck with the kernel trying to send
SIGBUS to that bash process, here:

int
force_sig_info(int sig, struct siginfo *info, struct task_struct *t)
{
        unsigned long int flags;
        int ret, blocked, ignored;
        struct k_sigaction *action;

====>   spin_lock_irqsave(&t->sighand->siglock, flags);

