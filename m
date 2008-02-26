Return-Path: <linux-kernel-owner+w=401wt.eu-S1758461AbYBZAwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758461AbYBZAwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 19:52:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbYBZAwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 19:52:38 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:17497 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbYBZAwh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 19:52:37 -0500
Message-Id: <47C31AC3.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 25 Feb 2008 17:45:07 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <bill.huey@gmail.com>,
       <rostedt@goodmis.org>, <kevin@hilman.org>, <tglx@linutronix.de>,
       <cminyard@mvista.com>, <dsingleton@mvista.com>, <dwalker@mvista.com>,
       "Moiz Kohari" <MKohari@novell.com>,
       "Peter Morreale" <PMorreale@novell.com>,
       "Sven Dietrich" <SDietrich@novell.com>, <dsaxena@plexity.net>,
       <acme@redhat.com>, <ak@suse.de>, <gregkh@suse.de>, <npiggin@suse.de>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: [(RT RFC) PATCH v2 3/9] rearrange rt_spin_lock sleep
References: <20080225155959.11268.35541.stgit@novell1.haskins.net>
 <20080225160053.11268.60719.stgit@novell1.haskins.net>
 <20080225215454.GF2659@elf.ucw.cz>
In-Reply-To: <20080225215454.GF2659@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Mon, Feb 25, 2008 at  4:54 PM, in message
<20080225215454.GF2659@elf.ucw.cz>, Pavel Machek <pavel@ucw.cz> wrote: 
> Hi!
> 
>> @@ -720,7 +728,8 @@ rt_spin_lock_slowlock(struct rt_mutex *lock)
>>  	 * saved_state accordingly. If we did not get a real wakeup
>>  	 * then we return with the saved state.
>>  	 */
>> -	saved_state = xchg(&current->state, TASK_UNINTERRUPTIBLE);
>> +	saved_state = current->state;
>> +	smp_mb();
>>  
>>  	for (;;) {
>>  		unsigned long saved_flags;
> 
> Please document what the barrier is good for.

Yeah, I think you are right that this isn't needed.  I think that is a relic from back when I was debugging some other problems.  Let me wrap my head around the implications of removing it, and either remove it or document appropriately.

> 
> Plus, you are replacing atomic operation with nonatomic; is that ok?

Yeah, I think so.  We are substituting a write with a read, and word reads are always atomic anyway IIUC (or is that only true on certain architectures)?  Note that we are moving the atomic-write to be done later in the update_current() calls.

-Greg



