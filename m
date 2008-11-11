Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbYKKHcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbYKKHcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 02:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbYKKHcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 02:32:25 -0500
Received: from ms1.nttdata.co.jp ([163.135.193.232]:42917 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbYKKHcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 02:32:24 -0500
Message-ID: <49193505.20905@nttdata.co.jp>
Date: Tue, 11 Nov 2008 16:32:21 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.17) Gecko/20080914 Thunderbird/2.0.0.17 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: haradats@nttdata.co.jp, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, penguin-kernel@I-love.SAKURA.ne.jp
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 05/11] Memory and pathname management
 functions.
References: <20081104060847.086543472@nttdata.co.jp>	<20081104060949.942652091@nttdata.co.jp>	<20081105151217.4e8d11a9.akpm@linux-foundation.org>	<49180E29.2060004@nttdata.co.jp>	<20081110210405.d43458f3.akpm@linux-foundation.org>	<4919277F.9050206@nttdata.co.jp> <20081110224609.4906d89f.akpm@linux-foundation.org>
In-Reply-To: <20081110224609.4906d89f.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Nov 2008 07:32:21.0909 (UTC) FILETIME=[A26CA450:01C943CF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> Are you saying "make the callers of tmy_alloc() tolerable with
>> uninitialized memory"?
> 
> Well.  That would be a desirable objective.  I can understand the
> reasons for taking the easy way out.  Given that Tomoyo doesn't seem to
> ever free memory again, one hopes that this function doesn't get called
> a lot, so the performance impact of zeroing out all that memory should
> be negligible.
> 
> I think.  Maybe I misinterpreted tmy_alloc(), and perhaps it _is_
> called frequently?
It is called whenever open() / mkdir() / unlink() etc. are called,
but not when read() / write() are called.
Frequency of open() / mkdir() / unlink() etc. are much lower than frequency of
read() / write().
Main cost of pathname based access control is strcmp()ing (or even regexp()ing)
over the list of strings, therefore zeroing buffer for pathname is relatively
negligible.

>>>> Creating pseudo files for each variables is fine, though I don't see
>>>> advantage by changing from
>>>> "echo Shared: 16777216 > /sys/kernel/security/tomoyo/meminfo" to
>>>> "echo 16777216 > /sys/kernel/security/tomoyo/quota/shared_memory".
>>> Well for starters, the existing interface is ugly as sin and will make
>>> kernel developers unhappy.
>>>
>>> There is a pretty strict one-value-per-file rule in sysfs files, and
>>> "multiple tagged values in one file" violates that a lot.
>> /sys/kernel/security/ is not sysfs but securityfs.
>> Does "one-value-per-file rule" also apply to securityfs?
> 
> It should apply.  It's not so much a matter of rules and regulations. 
> One needs to look at the underlying _reasons_ why those rules came
> about.  We got ourselves into a sticky mess with procfs with all sorts
> of ad-hoc data presentation and input formatting.  It's inconsistent,
> complex, makes tool writing harder, etc.
> 
> So we recognised our mistakes and when sysfs (otherwise known as procfs
> V2 :)) came about we decided that sysfs files should not make the same
> mistakes.
> 
> So, logically, that thinking should apply to all new pseudo-fs files. 
> Even, in fact, ones which are in /proc!
Well, regarding memory usage, it is easy to follow "one-value-per-file rule".
But regarding policy information (which is managed as lists),
"one-value-per-file rule" is not suitable. I think none of SELinux, SMACK,
AppArmor, TOMOYO create "one pseudo file for one value".
This /sys/kernel/security/tomoyo/ interface is used by only TOMOYO's management
programs, and not by generic programs.

Regards,

