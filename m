Return-Path: <linux-kernel-owner+w=401wt.eu-S1760793AbYARNRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760793AbYARNRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 08:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbYARNQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 08:16:57 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:46333 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754812AbYARNQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 08:16:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=EHk24A/UHugQHBgavXOvLO4GBe0ev2361TX22hu0V3S65hswNcOpGy07E6yNyf3Z0n8j588Xo49ZT3m2CExiJrAYhZTXaPgtk0+MjtXqG7mav4crMIWlBsQQrguF2DqfzTFctaeZt/P7vXk1IG0pbvGfcthqdzGhx7KDyDo/Rig=
Message-ID: <4790A6C0.7070002@gmail.com>
Date: Fri, 18 Jan 2008 08:16:48 -0500
From: Gregory Haskins <gregory.haskins.ml@gmail.com>
Reply-To: gregory.haskins@gmail.com
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux@sundmangroup.com
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       rostedt@goodmis.org
Subject: Re: SCHED_FIFO & system()
References: <37593.147.11.3.128.1200565147.squirrel@www.sundmangroup.com>
In-Reply-To: <37593.147.11.3.128.1200565147.squirrel@www.sundmangroup.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux@sundmangroup.com wrote:
> Hello,
> I have some strange behavior in one of my systems.
> 
> I have a real-time kernel thread under SCHED_FIFO which is running every
> 10ms.
> It is blocking on a semaphore and released by a timer interrupt every 10ms.
> Generally this works really well.
> 
> However, there is a module in the system that makes a / system() / call
> from c-code in user-space;
> 
>   system("run_my_script");
> 
> By calling and running a bash script. Independent of how the actual
> script looks like the real time kernel thread does not get scheduled under
> the time of 80ms -- the time it takes for the system() call to finish.
> 
> I can see when running a LTT session that the wake_up event occurs for
> the real time thread 10ms into the system call but nevertheless the real
> time kernel thread does not get scheduled.
> 
> The thread that calls system("run_my_script") is configured as SCHED_OTHER.
> 
> The Kernel is 2.6.21.
> 
> 
> Anybody who recognize this or similar situations?


Hi,
   I am not sure if this is whats happening to you (*), but there is a 
known problem in the mainline tree related to the system allowing lower 
priority threads to stay on the CPU under certain circumstances.

You can see the problem happening with the following test:

http://rt.wiki.kernel.org/index.php/Preemption_Test

and I know the problem goes back to at least 2.6.16.

Steven Rostedt and I submitted some patches to address the issue, and 
they have been accepted into Ingo's sched-devel tree.  I would suggest 
trying your code against Ingo's tree and see if the problem persists. 
You can get it from:

git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git

In the event that this does fix your issue, I will defer to Ingo for 
if/when he plans to push these upstream.

(*) I have no information on whether the futex-plist implemetation was 
pulled from the tree to cause your regression.  It is possible that the 
changes between 22 and 23 are just tickling your environment enough to 
bring out this RT-preempt issue.

HTH!

Regards,
-Greg
