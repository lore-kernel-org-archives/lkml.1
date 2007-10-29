Return-Path: <linux-kernel-owner+w=401wt.eu-S1756219AbXJ2SDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219AbXJ2SDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbXJ2SDn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:03:43 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:43212 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbXJ2SDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:03:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Emelyanov <xemul@openvz.org>,
       "Sukadev Bhattiprolu [imap]" <sukadev@us.ibm.com>
Subject: Re: [PATCH] pidns: Limit kill -1 and cap_set_all
References: <m1y7dp22d4.fsf@ebiederm.dsl.xmission.com>
	<alpine.LFD.0.999.0710261105440.30120@woody.linux-foundation.org>
	<m1r6jhzmov.fsf_-_@ebiederm.dsl.xmission.com>
	<m1k5p9zk6b.fsf_-_@ebiederm.dsl.xmission.com>
	<1193673738.24087.176.camel@localhost>
Date: Mon, 29 Oct 2007 11:59:48 -0600
In-Reply-To: <1193673738.24087.176.camel@localhost> (Dave Hansen's message of
	"Mon, 29 Oct 2007 09:02:18 -0700")
Message-ID: <m1pryxpzsb.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <haveblue@us.ibm.com> writes:

> On Fri, 2007-10-26 at 14:37 -0600, Eric W. Biederman wrote:
>> 
>> +static int pid_in_pid_ns(struct pid *pid, struct pid_namespace *ns)
>> +{
>> +       return pid && (ns->level <= pid->level) &&
>> +               pid->numbers[ns->level].ns == ns;
>> +}
>
> Could we blow this out a little bit?  (I think the blown-out version
> lends itself to being better commented, and easier to read.)  Also, can
> we think of any better name for this?  It seems a bit funky that:
>
> 	pid_in_pid_ns(mypid, &init_pid_ns);
>
> would _ever_ return 0.

It can't.

> So, it isn't truly a test for belonging *in* a
> namespace, but having that namespace be the lowest level one. 

No.  It is precisely a test for being in a namespace.
We first check ns->level to make certain it doesn't fall out
of the array, and then we check to see if the namespace we
are looking for is at that level.

pid->numbers[0].ns == &init_pid_ns.

> I think
> Suka toyed with calling it an "active" or "primary" pid namespace.  That
> differentiated mere membership in a pid namespace from the one that
> actually molds that pid's view of the world.

What we want for the test is a test for membership.


> static int pid_in_pid_ns(struct pid *pid, struct pid_namespace *ns)
> {
> 	if (!pid)
> 		return 0;
> 	if (ns->level > pid->level)
> 		return 0;
> 	if (pid->numbers[ns->level].ns != ns)
> 		return 0;
> 	return 1;
> }

I don't have a problem with that.  The rest of the checks for
this in kernel/pid.c are in the same form.

Eric

