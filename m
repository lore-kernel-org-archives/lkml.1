Return-Path: <linux-kernel-owner+w=401wt.eu-S1757529AbZDKQt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529AbZDKQt5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 12:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756282AbZDKQtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 12:49:45 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40529 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888AbZDKQto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 12:49:44 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <m1skkf761y.fsf@fess.ebiederm.org>
	<20090411155852.GV26366@ZenIV.linux.org.uk>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 11 Apr 2009 09:49:36 -0700
In-Reply-To: <20090411155852.GV26366@ZenIV.linux.org.uk> (Al Viro's message of "Sat\, 11 Apr 2009 16\:58\:52 +0100")
Message-ID: <m1k55ryw2n.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: viro@ZenIV.linux.org.uk, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, adobriyan@gmail.com, tj@kernel.org, hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [RFC][PATCH 0/9] File descriptor hot-unplug support
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> On Sat, Apr 11, 2009 at 05:01:29AM -0700, Eric W. Biederman wrote:
>
>> A couple of weeks ago I found myself looking at the uio, seeing that
>> it does not support pci hot-unplug, and thinking "Great yet another
>> implementation of hotunplug logic that needs to be added".
>> 
>> I decided to see what it would take to add a generic implementation of
>> the code we have for supporting hot unplugging devices in sysfs, proc,
>> sysctl, tty_io, and now almost in the tun driver.
>> 
>> Not long after I touched the tun driver and made it safe to delete the
>> network device while still holding it's file descriptor open I someone
>> else touch the code adding a different feature and my careful work
>> went up in flames.  Which brought home another point at the best of it
>> this is ultimately complex tricky code that subsystems should not need
>> to worry about.
>> 
>> What makes this even more interesting is that in the presence of pci
>> hot-unplug it looks like most subsystems and most devices will have to
>> deal with the issue one way or another.
>
> Ehh...  The real mess is in things like "TTY in the middle of random
> ioctl" and there's another pile that won't be solved on struct file
> level - individual fs internals ;-/

I haven't tackled code with a noticeable number of ioctls yet.  But if
they are anything like what I have seen so far, a ref count to see
that you are in the still executing a function (so you don't pull the
rug out) from under it, and an additional method to say stop sleeping
and return should be sufficient.

>> This infrastructure could also be used to implement sys_revoke and
>> when I could not think of a better name I have drawn on that.
>
> Yes, that's more or less obvious direction for revoke(), but there's a
> problem with locking overhead that always scared me away from that.
> Maybe I'm wrong, though...  In any case, you want to carefully check
> the overhead and cacheline bouncing implications for things like pipes
> and sockets.  Hell knows, maybe it'll work out, but...

I took a careful look and I can't claim perfection at this stage but I
don't think there are any significant performance impacts from my
code.  Further I am confident that if someone finds some performance
issues I will be able to understand and address them without a redesign.

While working on this I took a good hard look at the overhead I have
added to single byte reads and writes (operations that are dominated
by any possible overhead I am adding) and currently I am within 2% of
the case without my refcounting/locking.

I would be interested in anyone running micro benchmarks against my
patches and giving me feedback.

The fact that in the common case only one task ever accesses a struct
file leaves a lot of room for optimization.

> Anyway, the really nasty part of revoke() (and true SAK, which is obviously
> related) is handling of deep-inside-the-driver ioctls.

I doubt I have solved all of the problems.  My goals are more modest
than a revoke that works for every possible file in the system.  I
just want a common implementation of refcounting and blocking
unregistration code that can be used to solve the common problem I see
in sysfs, sysctl, proc, etc.  I completely expect to need to modify
the code to take advantage of the infrastructure.  Patch 9/9 has an
example of that, modifying proc so that it uses the infrastructure
I add and removing 400 lines of code.

I do think that what I have built once it is in use will make a good
foundation for building the rest of revoke.  Mostly because I am solving
common problems once in a common way.

Eric

