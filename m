Return-Path: <linux-kernel-owner+w=401wt.eu-S1032363AbXFHWur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032363AbXFHWur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbXFHWuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:50:40 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:41797 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936AbXFHWuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:50:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: will_schmidt@vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Anton Blanchard <anton@samba.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] [PATCH i386] during VM oom condition, kill all threads in process group
References: <20070605174831.21740.33119.stgit@farscape.rchland.ibm.com>
	<20070607153459.2a1b3230.akpm@linux-foundation.org>
	<20070607231621.GB32549@kryten>
	<20070607171018.d51fc5da.akpm@linux-foundation.org>
	<1181330358.21409.31.camel@farscape.rchland.ibm.com>
	<20070608123230.520655f5.akpm@linux-foundation.org>
	<1181337147.21409.42.camel@farscape.rchland.ibm.com>
Date: Fri, 08 Jun 2007 16:48:41 -0600
In-Reply-To: <1181337147.21409.42.camel@farscape.rchland.ibm.com> (Will
	Schmidt's message of "Fri, 08 Jun 2007 16:12:26 -0500")
Message-ID: <m1abvarrjq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Will Schmidt <will_schmidt@vnet.ibm.com> writes:

> On Fri, 2007-06-08 at 12:32 -0700, Andrew Morton wrote:
>> On Fri, 08 Jun 2007 14:19:18 -0500
>> Will Schmidt <will_schmidt@vnet.ibm.com> wrote:
>> 
>> > > > > zap_other_threads() requires tasklist_lock.
>> > 
>
>> In fact, it's probably the case that rcu_read_lock() is now sufficient
>> locking coverage for zap_other_threads() (cc's people).
>> 
>> It had better be, because do_group_exit() forgot to take tasklist_lock.  It
>> is perhaps relying upon spin_lock()'s hidden rcu_read_lock() properties
>> without so much as a code comment, which would be somewhat nasty of it.
>
>> You could perhaps just call do_group_exit() from within the fault
>> handler,
>> btw.
>
> Yup, so looks like I can actually replace the existing do_exit() call
> with do_group_exit().   I'll sit on this for a bit to give other folks a
> chance to comment on which lock call is sufficient, read_lock() or
> rcu_read_lock(), etc;  and do_group_exit()'s issue with taking
> tasklist_lock. 

No.  The rcu_read_lock is not sufficient.
Yes.  sighand->siglock is enough, and we explicitly take it in
do_group_exit before calling zap_other_threads.

Unless I have completely miss-understood this thread.

Eric
