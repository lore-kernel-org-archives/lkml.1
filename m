Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbZDNDRn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbZDNDRn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 23:17:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbZDNDRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 23:17:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:44294 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbZDNDRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 23:17:31 -0400
Message-ID: <49E4000E.10308@kernel.org>
Date: Tue, 14 Apr 2009 12:16:30 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
       Hugh Dickins <hugh@veritas.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC][PATCH 0/9] File descriptor hot-unplug support
References: <m1skkf761y.fsf@fess.ebiederm.org>
In-Reply-To: <m1skkf761y.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 03:15:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

Eric W. Biederman wrote:
> A couple of weeks ago I found myself looking at the uio, seeing that
> it does not support pci hot-unplug, and thinking "Great yet another
> implementation of hotunplug logic that needs to be added".
> 
> I decided to see what it would take to add a generic implementation of
> the code we have for supporting hot unplugging devices in sysfs, proc,
> sysctl, tty_io, and now almost in the tun driver.
> 
> Not long after I touched the tun driver and made it safe to delete the
> network device while still holding it's file descriptor open I someone
> else touch the code adding a different feature and my careful work
> went up in flames.  Which brought home another point at the best of it
> this is ultimately complex tricky code that subsystems should not need
> to worry about.

I like the way it's headed.  I'm trying to add similar 'revoke' or
'sever' mechanism at block and char device layers so that low level
drivers don't have to worry about object lifetimes and so on.  Doing
it at the file layer makes sense and can probably replace whatever
mechanism at the chardev.

The biggest obstacle was the extra in-use reference count overhead.  I
thought it could be solved by implementing generic percpu reference
count similar to the one used for module reference counting.  Hot path
overhead could be reduced to local_t cmpxchg (w/o LOCK prefix) on
per-cpu variable + one branch, which was pretty good.  The problem was
that space and access overhead for dynamic per-cpu variables wasn't
too good, so I started working on dynamic percpu allocator.

The dynamic per-cpu allocator is pretty close to completion.  Only
several archs need to be converted and it's likely to happen during
next few months.  The plan after that was 1. add per-cpu local_t
accessors (might replace local_t completely) 2. add generic per-cpu
reference counter and move module reference counting to it
3. implement block/chardev sever (or revoke) support.

I think #3 can be merged with what you're working on.  What do you
think?

Thanks.

-- 
tejun
