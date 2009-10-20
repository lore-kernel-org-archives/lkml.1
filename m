Return-Path: <linux-kernel-owner+w=401wt.eu-S1751766AbZJTScZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbZJTScZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 14:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbZJTScY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 14:32:24 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58692 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbZJTScX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 14:32:23 -0400
Date: Tue, 20 Oct 2009 11:33:29 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, Oren Laadan <orenl@librato.com>,
       Daniel Lezcano <daniel.lezcano@free.fr>, randy.dunlap@oracle.com,
       arnd@arndb.de, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, kosaki.motohiro@jp.fujitsu.com,
       hpa@zytor.com, mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
Message-ID: <20091020183329.GB22646@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com> <4AD8C7E4.9000903@free.fr> <20091016194451.GA28706@us.ibm.com> <4ADCCD68.9030003@free.fr> <4ADCDE7F.4090501@librato.com> <20091020005125.GG27627@count0.beaverton.ibm.com> <m1vdiad9jd.fsf@fess.ebiederm.org> <20091020040315.GA26632@us.ibm.com> <m1iqeauyvl.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1iqeauyvl.fsf@fess.ebiederm.org>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman [ebiederm@xmission.com] wrote:
| > Could you clarify ? How is the call to alloc_pidmap() from clone3() different
| > from the call from clone() itself ?
| 
| I think it is totally inappropriate to assign pids in a pid namespace
| where there are user space processes already running.

Honestly, I don't understand why it is inappropriate or how this differs
from normal clone() - which also assigns pids in own and ancestor pid
namespaces.

| 
| > | How we handle a clone extension depends critically on if we want to
| > | create a processes for restart in user space or kernel space.
| > | 
| > | Could some one give me or point me at a strong case for creating the
| > | processes for restart in user space?
| >
| > There has been a lot of discussion on this with reference to the
| > Checkpoint/Restart patchset. See http://lkml.org/lkml/2009/4/13/401
| > for instance.
| 
| Just read it.  Thank you.

Sorry. I should have mentioned the reason here. (Like you mention below),
flexibility is the main reason.

| Now I am certain clone_with_pids() is not useful functionality to be
| exporting to userspace.
| 
| The only real argument in favor of doing this in user space is greater
| flexibility.  I can see checkpointing/restoring a single thread process
| without a pid namespace.  Anything more and you are just asking for
| trouble.
| 
| A design that weakens security.  Increases maintenance costs.  All for
| an unreliable result seems like a bad one to me.
| 
| > | The pid assignment code is currently ugly.  I asked that we just pass
| > | in the min max pid pids that already exist into the core pid
| > | assignment function and a constrained min/max that only admits a
| > | single pid when we are allocating a struct pid for restart.  That was
| > | not done and now we have a weird abortion with unnecessary special cases.
| >
| > I did post a version of the patch attemptint to implement that. As
| > pointed out in:
| >
| > 	http://lkml.org/lkml/2009/8/17/445
| >
| > we would need more checks in alloc_pidmap() to cover cases like min or max
| > being invalid or min being greater than max or max being greater than pid_max
| > etc. Those checks also made the code ugly (imo).
| 
| If you need more checks you are doing it wrong.  The code already has min
| and max values, and even a start value.  I was just strongly suggesting
| we generalize where we get the values from, and then we have not special
| cases. 

Well, if alloc_pidmap(pid_ns, min, max) does not have to check the
parameters passed in (ie assumes that callers pass it in correctly)
it might be simple. But when user specifies the pid, the 

	min == max == user's target pid

so we will need to check the values either here or in callers.

Yes the code already has values and a start value. But these are
controlled by alloc_pidmap() and not passed in from the user space.

alloc_pidmap() needs to assign the next available pid or a specific
target pid.  Generalizing it to alloc a pid in a range seemed be a
bit of an over kill for currently known usages.

I will post a version of the patch outside this patchset with min
and max parameters and we can see if it can be optimized/beautified.

Sukadev
