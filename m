Return-Path: <linux-kernel-owner+w=401wt.eu-S1030323AbXDKUCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030323AbXDKUCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030339AbXDKUCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:02:40 -0400
Received: from main.gmane.org ([80.91.229.2]:43764 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030323AbXDKUCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:02:39 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: init's children list is long and slows reaping children.
Date: Wed, 11 Apr 2007 15:55:42 -0400
Message-ID: <461D3D3E.2060709@tmr.com>
References: <46159987.6090006@redhat.com> <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org> <m1hcru9rki.fsf@ebiederm.dsl.xmission.com> <20070406104301.GB19755@lnx-holt.americas.sgi.com> <m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com> <20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu> <m11wix73ut.fsf@ebiederm.dsl.xmission.com> <20070410134814.GA28016@elte.hu> <m17iskz3i8.fsf@ebiederm.dsl.xmission.com> <20070410164441.GB104@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
X-Gmane-NNTP-Posting-Host: mail.tmr.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <20070410164441.GB104@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 04/10, Eric W. Biederman wrote:
> 
>> I'm trying to remember what the story is now.  There is a nasty
>> race somewhere with reparenting, a threaded parent setting SIGCHLD to
>> SIGIGN, and non-default signals that results in an zombie that no one
>> can wait for and reap.  It requires being reparented twice to trigger.
> 
> reparent_thread:
> 
> 	...
> 
>         /* If we'd notified the old parent about this child's death,
>          * also notify the new parent.
>          */
>         if (!traced && p->exit_state == EXIT_ZOMBIE &&
>             p->exit_signal != -1 && thread_group_empty(p))
>                 do_notify_parent(p, p->exit_signal);
> 
> We notified /sbin/init. If it ignores SIGCHLD, we should release the task.
> We don't do this.
> 
> The best fix I believe is to cleanup the forget_original_parent/reparent_thread
> interaction and factor out this "exit_state == EXIT_ZOMBIE && exit_signal == -1"
> checks.
> 
As long as the original parent is preserved for getppid(). There are 
programs out there which communicate between the parent and child with 
signals, and if the original parent dies, it undesirable to have the 
child getppid() and start sending signals to a program not expecting 
them. Invites undefined behavior.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

