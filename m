Return-Path: <linux-kernel-owner+w=401wt.eu-S1756950AbXJZAxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950AbXJZAxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 20:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbXJZAxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 20:53:47 -0400
Received: from mcclure-nat.wal.novell.com ([130.57.22.22]:25351 "EHLO
	mcclure.wal.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752706AbXJZAxr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 20:53:47 -0400
X-Greylist: delayed 1210 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Oct 2007 20:53:46 EDT
Message-Id: <4720FD380200005A0002CCB1@mcclure.wal.novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Thu, 25 Oct 2007 20:33:21 -0400
From: "Gregory Haskins" <ghaskins@novell.com>
To: <rostedt@goodmis.org>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <dmitry.adamushko@gmail.com>,
       <dvhltc@us.ibm.com>, <linux-kernel@vger.kernel.org>,
       <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH 2/3] RT: Cache cpus_allowed weight for optimizing
	migration
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Steven Rostedt <rostedt@goodmis.org> 10/25/07 8:03 PM >>>
>
>> Why do you think moving the logic to pick_next_highest is a better
>> design?  To be honest, I haven't really studied your new logic in
>> push_rt_tasks to understand why you might feel this way.  If you can
>> make the case that it is better in the other location then I agree with
>> you that we should move it there in this patch, and potentially adjust
>> it later.  Until then, I see no problem with it being here.
>
>Ah, after reading the comment in your code, I might know where our
>miscommunication is from.  When you hit a task that can't migrate, you
>simply stop and don't bother looking for a lowest rq to place it on.
>
>I'm saying to do one better. Put the code in the pick_next_highest_task_rt
>and _skip_ rt tasks with nr_cpus_allowed == 1. So we can then look to
>migrate another RT task that is lower in priority than a bounded RT task.
>
>Does this clear up what I'm trying to say?

Ah, yes.  That is quite brilliant, actually.  

>BTW, stop looking for a lowest_rq isn't really an optimization here. Since
>we only look at cpus that are in the tasks cpu affinity mask and we skip
>the cpu that it currently is on. So we don't even take a lock in that
>case.

You are, of course, completely correct.  This patch historically was after cpupri, and this change is relevant in that case only.   Since cpupri doesnt have the nice property as yours where its limited to cpus_allowed, it helps to stop the search on that special case.  In the current alg, its just redundant .text and it should be removed.


>and _skip_ rt tasks with nr_cpus_allowed == 1. So we can then look to
>migrate another RT task that is lower in priority than a bounded RT task.
>
>Does this clear up what I'm trying to say?

Ah, yes.  That is quite brilliant, actually.  

>BTW, stop looking for a lowest_rq isn't really an optimization here. Since
>we only look at cpus that are in the tasks cpu affinity mask and we skip
>the cpu that it currently is on. So we don't even take a lock in that
>case.

You are, of course, completely correct.  This patch historically was after cpupri.  This change is relevant in that case only since cpupri doesnt have the nice property as yours where its limited to cpus_allowed, it helps to stop the search on that special case.  In the current alg, its just redundant .text and it should be removed.

I will make those changes and submit a new patch.

Thanks for setting me straight!
-Greg
