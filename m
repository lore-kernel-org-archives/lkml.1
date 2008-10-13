Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbYJMIOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbYJMIOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755003AbYJMIN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:13:58 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:43394 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976AbYJMIN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:13:57 -0400
Message-ID: <48F30315.1070909@fr.ibm.com>
Date: Mon, 13 Oct 2008 10:13:09 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dave Hansen <dave@linux.vnet.ibm.com>, jeremy@goop.org, arnd@arndb.de,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Oren Laadan <orenl@cs.columbia.edu>, Andrey Mirkin <major@openvz.org>
Subject: Re: [RFC v6][PATCH 0/9] Kernel based checkpoint/restart
References: <1223461197-11513-1-git-send-email-orenl@cs.columbia.edu>	<20081009124658.GE2952@elte.hu> <1223557122.11830.14.camel@nimitz>	<20081009131701.GA21112@elte.hu> <1223559246.11830.23.camel@nimitz>	<20081009134415.GA12135@elte.hu> <1223571036.11830.32.camel@nimitz> <20081010153951.GD28977@elte.hu>
In-Reply-To: <20081010153951.GD28977@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Dave Hansen <dave@linux.vnet.ibm.com> wrote:
> 
>> On Thu, 2008-10-09 at 15:44 +0200, Ingo Molnar wrote:
>>> there might be races as well, especially with proxy state - and 
>>> current->flags updates are not serialized.
>>>
>>> So maybe it should be a completely separate flag after all? Stick it 
>>> into the end of task_struct perhaps.
>> What do you mean by proxy state?  nsproxy?
> 
> it's a concept: one task installing some state into another task (which 
> state must be restored after a checkpoint event), while that other task 
> is running. Such as a pi-futex state for example.
> 
> So a task can acquire state not just by its own doing, but via some 
> other task too.

thinking aloud,

hmm, that's rather complex, because we have to take into account the 
kernel stack, no ? This is what Andrey was trying to solve in his patchset 
back in September :

	http://lkml.org/lkml/2008/9/3/96

the restart phase simulates a clone and switch_to to (not) restore the kernel 
stack. right ? 

the self checkpoint and self restore syscalls, like Oren is proposing, are 
simpler but they require the process cooperation to be triggered. we could
image doing that in a special signal handler which would allow us to jump
in the right task context. 

I don't have any preference but looking at the code of the different patchsets
there are some tricky areas and I'm wondering which path is easier, safer, 
and portable. 

C.

