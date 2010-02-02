Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab0BBFzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 00:55:54 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:46973 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab0BBFzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 00:55:50 -0500
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH][RFC] %pd - for printing dentry name
References: <20100201222511.GA12882@ZenIV.linux.org.uk>
	<alpine.LFD.2.00.1002011431490.3664@localhost.localdomain>
	<20100201231847.GC12882@ZenIV.linux.org.uk>
	<20100202010653.GD12882@ZenIV.linux.org.uk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 01 Feb 2010 21:55:42 -0800
In-Reply-To: <20100202010653.GD12882@ZenIV.linux.org.uk> (Al Viro's message of "Tue\, 2 Feb 2010 01\:06\:53 +0000")
Message-ID: <m1k4uwfag1.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Mon, Feb 01, 2010 at 11:18:47PM +0000, Al Viro wrote:
>
>> Ehh...  RCU will save you from stepping on freed memory, but it still will
>> leave the joy of half-updated string with length out of sync with it, etc.
>> We probably can get away with that, but we'll have to be a lot more careful
>> with the order of updating these suckers in d_move_locked et.al.
>> 
>> I don't know...  Note that if we end up adding something extra to struct
>> dentry, we might as well just add *another* spinlock, taken only under
>> ->d_lock and only in two places in dcache.c that change d_name.  That kind
>> of thing is trivial to enforce (just grep over the tree once in a while)
>> and if it shares the cacheline with d_lock, we shouldn't get any real overhead
>> in d_move()/d_materialise_unique().  I'm not particulary fond of that variant,
>> but it's at least guaranteed to be devoid of subtleties.
>> 
>> If RCU folks can come up with a sane suggestions that would be robust and
>> wouldn't bloat dentry - sure, I'm all for it.  If not...
>
> As the matter of fact, there's just *one* place that has any business [*]
> changing ->d_name contents of dentry that might be visible to somebody
> else.  fs/dcache.c::switch_names().
>
> So a very brute-force approach would be to add a new spinlock to dentry and
> have switch_names() grab it on dentry and target and drop when we are done,
> dname_string() grab it around the call of string() and pull the guts out
> through the nose to anyone who as much as mentions that lock outside of
> fs/dcache.c:switch_names() and lib/vsprintf.c:dname_string().

We already have rename_lock, which is only take for write in d_move_locked.

I wonder if there is an instruction sequence that could guarantee that the
string copy is done atomically from the perspective of another cpu,
d_iname fits nicely on a single cache line so it should be possible.  

That is a stronger guarantee than we need.   All we really need is the
guarantee that a reader will see the string null terminator.  dentries already
have rcu safe lifetimes.

Hmm.

We should be able to do:
        struct qstr *name;
        int len;
        char buf[MAX_LEN + 1];
        long seq;

        do {
		seq = read_seqbegin(&rename_lock);
        	rcu_read_lock();
	        name = rcu_dereference(dentry->d_name.name);
	        len = dentry->d_name.len;
                if (read_seqretry(&rename_lock, seq)
                	continue;
	        if (len > MAX_LEN)
	        	len = MAX_LEN;
		memcpy(buf, name, len);
	        buf[len] = '\0';
	        rcu_read_unlock();
	} while (read_seqretry(&rename_lock, seq));

I don't know if rcu bits are actually necessary as we are using the seqlock for
all of the heavy lifting.    In particular name and len are guaranteed to be consistent
with each other because of the seqlock, and the seqlock also guarantees that we will
not have an inconsistent state.

Eric
