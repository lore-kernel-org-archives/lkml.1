Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYEPKTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYEPKTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 06:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbYEPKTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 06:19:16 -0400
Received: from sacred.ru ([62.205.161.221]:58408 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275AbYEPKTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 06:19:15 -0400
Message-ID: <482D5EE8.6050207@openvz.org>
Date: Fri, 16 May 2008 14:16:08 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/10] Make bsd process accounting work in pid namespaces
References: <482C15FE.7070300@openvz.org> <20080515194304.31309426.akpm@linux-foundation.org>
In-Reply-To: <20080515194304.31309426.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 16 May 2008 14:18:30 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 15 May 2008 14:52:46 +0400 Pavel Emelyanov <xemul@openvz.org> wrote:
> 
>> fter I fixed access to task->tgid in kernel/acct.c, Oleg 
>> pointed out some bad side effects with this accounting vs pid 
>> namespaces interaction. I.e. when some task in pid namespace 
>> sets this accounting up, this blocks all the others from doing 
>> the same. Restricting this to init namespace only could help, 
>> but didn't look as a grace solution.
>>
>> So here is the approach to make this accounting work with pid
>> namespaces properly.
> 
> We still have this silliness in acct_file_reopen():
> 
> 		spin_unlock(&acct_lock);
> 		do_acct_process(acct, old_ns, old_acct);
> 		filp_close(old_acct, NULL);
> 		spin_lock(&acct_lock);
> 
> Was this lock-dropping safe before?
> 
> Is it safe now?

Yup :)

> To work this out, we'd need to know what acct_lock protects.  What does
> acct_lock protect?

It protected the acct_glbls state before this set. This re-lock was OK 
before wrt. acct_glbls members and still such now.

After the set it still does so and (!) also protects the list of those
bsd_acct_struct-s, that have a file opened.

So, as far as the list is concerned. There are two places, that walk this
list under this lock and call acct_file_reopen - the acct_auto_close and the
acct_auto_close_mnt - both perform "goto restart" to start the iteration
from the very beginning, so this re-lock doesn't affect this list integrity.
List modifications (add/del) always happen under this lock.


Thanks,
Pavel
