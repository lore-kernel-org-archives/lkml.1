Return-Path: <linux-kernel-owner+w=401wt.eu-S1765758AbXHWTB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765758AbXHWTB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 15:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764769AbXHWTBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 15:01:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764447AbXHWTBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 15:01:51 -0400
Message-ID: <46CDD98F.2020208@redhat.com>
Date: Thu, 23 Aug 2007 15:01:35 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.6 (Macintosh/20070728)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Anand Jahagirdar <anandjigar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Fork Bombing Patch
References: <25ae38200708152324t4cbadc24ge05cd75f8f0e60e4@mail.gmail.com>	<46C4BC46.7000305@redhat.com>	<25ae38200708200724sbce2749m7eb27565d7c84e5e@mail.gmail.com>	<46C9A867.6090509@redhat.com>	<25ae38200708212317h7776768v33a82f646ac6b749@mail.gmail.com> <m3d4xeii2z.fsf@maximus.localdomain>
In-Reply-To: <m3d4xeii2z.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Hi,
> 
> "Anand Jahagirdar" <anandjigar@gmail.com> writes:
> 
>>    I am forwarding one more improved patch which i have modified as
>> per your suggestions. Insted of KERN_INFO i have used KERN_NOTICE and
>> i have added one more if block to check hard limit. how good it is?
> 
> Not very, still lacks "#ifdef CONFIG_something" and the required
> Kconfig change (or other runtime thing defaulting to "no printk").

Wrapping a single printk that's unrelated to debugging in an #ifdef 
CONFIG_* or a sysctl strikes me as abuse of those configuration 
facilities.  Where would we draw the line for other patches wanting to 
do similar things?

I realized that even checking the hard limit it insufficient, because 
that can be lowered (but not raised) by unprivileged processes.  If we 
can't do this unconditionally (and we can't, because the log pollution 
would be intolerable for many people) then we shouldn't do it at all.

Anand -- I appreciate the effort, but I think you should reconsider 
precisely what problem you're trying to solve here.  This approach can't 
tell the difference between legitimate self-regulation of resource 
utilization and a real attack.  Worse, in the event of a real attack, it 
could be used to make it more difficult for the administrator to notice 
something much more serious than a forkbomb.

I suspect that userspace might be a better place to solve this problem. 
  You could run your monitoring app with elevated or even realtime 
priority to ensure it will still function, and you have much more 
freedom in making the reporting configurable.  You can also look at much 
more data than we could ever allow in fork.c, and possibly detect 
attacks that this patch would miss if a clever attacker stayed just 
below the limit.

	-- Chris
