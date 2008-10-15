Return-Path: <linux-kernel-owner+w=401wt.eu-S1753820AbYJOPQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbYJOPQd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 11:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbYJOPQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 11:16:22 -0400
Received: from xenbox.codefidence.com ([92.48.73.16]:40833 "EHLO
	xenbox.codefidence.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbYJOPQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 11:16:21 -0400
Message-ID: <48F60942.8040209@codefidence.com>
Date: Wed, 15 Oct 2008 17:16:18 +0200
From: Gilad Ben-Yossef <gilad@codefidence.com>
Organization: Codefidence Ltd.
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Peter Teoh <htmldeveloper@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with set_current_state() and schedule()
References: <804dabb00810150750sb54377dhc83841dedee0f72b@mail.gmail.com>
In-Reply-To: <804dabb00810150750sb54377dhc83841dedee0f72b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Teoh wrote:

> I am puzzled over this:
>
> The module just consist of three function:
>
> static int myfunction(void)
> {
>        dbg("%s - enter....", __FUNCTION__);
>
>        while (!kthread_should_stop()) {
>                dbg("%s - executing....", __FUNCTION__);
>                set_current_state(TASK_INTERRUPTIBLE);
>                printk("sssssssssssssssssssssssssssssssss\n");
>
>
>                schedule(); ======>       ////// removed for part 2
>                printk("sssssssssssssssssssssssssssssssss\n");======>//////
> removed for part 2
>
>
>                msleep(1000);
>                schedule();
>        }
>        return 0;
>        dbg("%s exit", __FUNCTION__);
> ...
>   
> For part 1:
>
> After printing one line, the program never seemed to continue anymore.
>   why?   It got stuck in the first schedule().
>   
You set the state of your task to TASK_INTERRUPTIBLE, that is, not valid 
to run and then call scheduler to give control to some other task. You 
don't include any code that actually sets the task state back to 
TASK_RUNNING, that is legible for scheduling so the schedule will never 
enter your task again. It effectively sleeps for ever.

You either need to use schedule_timeout with some delay or have some 
other means to set your task state back to TASK_RUNNING or better yet, 
use wait_event and friends and don't call schedule() directly.

> For part 2:
>
> Just remove the "remove for part 2".   And u can immediately see that
> it starts to loop forever.   So effectively there is only one
> schedule() in the while loop.
>   

> Why?
>   
Thats' because msleep() changes your task state to TASK_RUNNING when it 
finishes sleeping, so you're calling the scheduler with a TASK_RUNNING 
state and it will schedule your task back sometime (perhaps even 
immediately).
> I am quite puzzled......thanks in advance for the help.   :-).
>
>   
Go read chapter 7 of "Linux Device Drivers, Third Edition" :-)

Gilad


-- 
Gilad Ben-Yossef 
Chief Coffee Drinker

Codefidence Ltd.
The code is free, your time isn't.(TM)

Web:    http://codefidence.com
Email:  gilad@codefidence.com
Office: +972-8-9316883 ext. 201
Fax:    +972-8-9316885
Mobile: +972-52-8260388

	The Doctor: Don't worry, Reinette, just a nightmare. 
	Everyone has nightmares. Even monsters from under the 
	bed have nightmares, don't you, monster?
	Reinette: What do monsters have nightmares about?
	The Doctor: Me! 

