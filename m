Return-Path: <linux-kernel-owner+w=401wt.eu-S1755080AbYJHKCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755080AbYJHKCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 06:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYJHKCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 06:02:03 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:59721 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbYJHKCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:02:01 -0400
Message-ID: <48EC847A.5060900@cs.columbia.edu>
Date: Wed, 08 Oct 2008 05:59:22 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: dave@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [RFC v5][PATCH 0/9] Kernel based checkpoint/restart
References: <1221347167-9956-1-git-send-email-orenl@cs.columbia.edu> <20080917141601.GA14010@us.ibm.com>
In-Reply-To: <20080917141601.GA14010@us.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Serge E. Hallyn wrote:
> Quoting Oren Laadan (orenl@cs.columbia.edu):
>> These patches implement basic checkpoint-restart [CR]. This version (v5)
>> supports basic tasks with simple private memory, and open files (regular
>> files and directories only). The main changes include rework of memory
>> restart code and response to feedback. See original announcements below.
>>
>> Oren.
> 
> At the kernel summit, it was asked whether at some point this CR work
> could be used as the basis for a new suspend to disk implementation.
> I answered that we don't plan to handle kernel threads.  In your
> experience, are there any reasons why eventually we couldn't eventually
> handle kernel threads?
> 
> -serge

As far as I can see, there isn't an inherent reason not to handle
kernel threads. However, I never looked deep into the problem.

The main issue that I can see with it is similar to what the
hibernation developers must tackle anyway - how to freeze kernel
threads when some of them may still be needed to take the system
down.

Assuming that is solved, then we're left with how to freeze the
kernel threads in a state that makes sense for a restart; for
regular tasks this is right before going back to user-land (*),
for kernel threads it may not be the best place :)

(*) however, tasks that are ptraced or in the middle of a vfork
will require special treatment - since upon freezing they cannot
be forced to that convenient position; so upon restart there must
be special code to make their behavior after restart compatible
with what they would have done originally - probably by emulation
as opposed to rebuilding their old kernel stack. For instance,
if a task was stopped due to ptrace before return from a syscall,
then upon restart it should return to that exact state.

So I'd assume that kernel threads could be treated in a similar
manner by special-casing, if necessary.

Question: I'd assume that at least for some of the kernel threads
a simple re-launch at restart will do; how many really require that
we save and restore their state ?

Oren

