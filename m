Return-Path: <linux-kernel-owner+w=401wt.eu-S1754595AbYLCTI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbYLCTI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:08:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbYLCTIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:08:19 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53502 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752799AbYLCTIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:08:18 -0500
Date: Wed, 3 Dec 2008 20:06:48 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Al Viro <viro@zeniv.linux.org.uk>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: BUG? "Call fasync() functions without the BKL" is racy
Message-ID: <20081203190648.GA23893@redhat.com>
References: <20081128192508.GA21369@redhat.com> <4933CBB0.2060003@linux.intel.com> <20081201191555.GA21385@redhat.com> <20081201123405.51d20d84@bike.lwn.net> <20081202122939.GA3619@redhat.com> <493562B5.5020600@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493562B5.5020600@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02, Andi Kleen wrote:
>
>> Still I'd like to see the better fix for the long term, the only (afaics)
>> flag with the "side effect" is FASYNC, perhaps we can move it to (say)
>> ->f_mode, but this is ugly of course and still need serialization for the
>> pathes which play with FASYNC.
>
> I wonder if we need FASYNC at all. This could be gotten implicitely by
> looking at the fasync_list

Only if socket.

Serioulsy, I think the best (partial, yes) fix for now is to restore
lock_kernel() in setfl() and change ioctl_fioxxx() accordingly.
At least this protect us from tty too.


I agree with Jonathan, we need the lock to protect ->f_flags, but
this needs changes. Personally, I do not like the global mutex,
perhaps we can use some "unused" bit in struct file. Say, ->f_mode
is never changed (afaics), we can place it here. Now, any code
which changes ->f_flags can do

	if (test_and_set_bit(FLAGS_LOCK_BIT))
		return;

	whatever();

	->f_flags = new_flags;

	clear_bit(FLAGS_LOCK_BIT);

No need to disable preemption, we never spin waiting for the
lock bit. If it is locked - somebody else updates ->f_flags,
we can pretend it does this after us. This can confuse F_GETFL
after F_SETFL (if F_SETFL "fails"), but I think in that case
user-space is wrong anyway, it must not do F_GETFL in parallel.

Not that I think this is very good idea though ;)

Oleg.

