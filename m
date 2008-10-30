Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbYJ3Sa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbYJ3Sa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 14:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbYJ3SaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 14:30:17 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:48675 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbYJ3SaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 14:30:15 -0400
Message-ID: <4909FCCE.2020501@cs.columbia.edu>
Date: Thu, 30 Oct 2008 14:28:30 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Louis.Rilling@kerlabs.com
CC: Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Daniel Lezcano <dlezcano@fr.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       containers@lists.linux-foundation.org, Andrey Mirkin <major@openvz.org>
Subject: Re: [Devel] Re: [PATCH 0/9] OpenVZ kernel based checkpointing/restart
References: <1220439476-16465-1-git-send-email-major@openvz.org>	<200810271707.13580.major@openvz.org>	<4905D2AD.1070309@cs.columbia.edu>	<200810300902.47067.major@openvz.org>	<20081030114747.GL15171@hawkmoon.kerlabs.com>	<1225386524.12673.284.camel@nimitz> <20081030180133.GN15171@hawkmoon.kerlabs.com>
In-Reply-To: <20081030180133.GN15171@hawkmoon.kerlabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Louis Rilling wrote:
> On Thu, Oct 30, 2008 at 10:08:44AM -0700, Dave Hansen wrote:
>> On Thu, 2008-10-30 at 12:47 +0100, Louis Rilling wrote:
>>> 1) this prevents userspace from doing weird things, like changing the task tree
>>> and let the kernel detect it and deal with the mess this creates (think about
>>> two threads being restarted in separate processes that do not even share their
>>> parents). But one can argue that userspace can change the checkpoint image as
>>> well, so that the kernel must check for such weird things anyway.
>> To me, this is one of the strongest arguments out there for doing
>> restart as much as possible with existing user<->kernel APIs.  Having
>> the kernel detect and clean up userspace's messes is not going to work.
>> We might as well just do things in the kernel rather than do that.
>>
>> What we *should* do is leverage all of the existing APIs that we already
>> have instead of creating completely new code paths into which my butter
>> fingers can introduce new kernel bugs.
>>
>>> 2) restart will be more efficient with respect to shared objects.
>> Can you quantify this?  Which objects?  How much more efficient?
> 
> Quantify? No. I expect that investigating both approaches will show us numbers.
> Unless Oren already has some?

I do have some. it's pretty quick :)  see the usenix 2007 paper...
the new implementation will be faster, though.

> 
> Which objects? I think that two kinds will especially matter: objects usually
> shared only inside a thread group (mm_struct, fs_struct, files_struct,
> signal_struct and sighand_struct), and individual file descriptors. The point is
> to avoid creating new structures before destroying them because the restarted
> task shares them with a previously restarted one.

all the forks in the user space will be done with CLONE_VM etc, to avoid
exactly that sort of overhead.

in any event, my experience is that this is not the dominant factor in the
restart time.

> 
> Concerning individual file descriptors, limiting the number of open files before
> calling sys_restart() may avoid these useless creations/destructions (actually
> the "useless" work mainly consists in managing ref counts since file descriptors
> are shared after fork()).
> 
> Concerning thread-shared structures, it is probably easy for userspace to guess
> which clone flags to use when restarting threads, but
> 1) kernel-space will have to check that the sharing is correct anyway, and

ok. that's not a lot of work :p
(see more below)

> 2) kernel-space will have to fix it anyway if structures are not shared in an
> obvious manner between tasks (think about A creating B with shared files_struct,
> B creating C with shared files_struct, B unsharing its files_struct, and then
> checkpoint).
> 
> So, with a userspace implementation, useless structures will be created anyway,
> and optimizing the common cases (regular threads) just duplicates kernel's work
> of checking which shared structure to use for each task to restart.
> With a kernel-space implementation, all useless creations can be avoided, and no
> duplicate work is needed.

they can also be avoided in user space - you "optimistically" create everything
shared to begin with, and in the kernel (inside sys_restart) you "unshare" and
create the necessary resources on demand - just like you would do with kernel
based process creation.

in this case, the extra work is only ref-counting, and then sys_restart will
unconditionally attach the right shared resource to the restarting process
(the "right" shared resource will be found, of course, in the shared pool).

this way, you don't even need to check what the user gave you - you simply
ignore overwrite it.

> 
> That said, numbers may show us that useless creations are not so
> time-consuming, but we won't know before seeing them...

yes, odds are that you are right.

Oren

