Return-Path: <linux-kernel-owner+w=401wt.eu-S1752607AbZDNIvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbZDNIvn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 04:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbZDNIvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 04:51:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:52337 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbZDNIvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 04:51:31 -0400
Message-ID: <49E44E35.7050504@kernel.org>
Date: Tue, 14 Apr 2009 17:49:57 +0900
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
References: <m1skkf761y.fsf@fess.ebiederm.org> <49E4000E.10308@kernel.org>	<m13acbbs5u.fsf@fess.ebiederm.org> <49E43F1D.3070400@kernel.org> <m18wm38ws1.fsf@fess.ebiederm.org>
In-Reply-To: <m18wm38ws1.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 08:50:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

Eric W. Biederman wrote:
> Tejun Heo <tj@kernel.org> writes:
>> Eric W. Biederman wrote:
>>> Do you know of a case where we actually have multiple tasks accessing
>>> a file simultaneously?
>> I don't have anything at hand but multithread/process server accepting
>> on the same socket comes to mind.  I don't think it would be a very
>> rare thing.  If you confine the scope to character devices or sysfs,
>> it could be quite rare tho.
> 
> Yes.  I think I can safely exclude sockets, and not bother with
> reference counting them.
> 
> The only strong evidence I have that multi-threading on a single file
> descriptor is likely to be common is that we have pread and pwrite
> syscalls.  At the same time the number of races we have in struct file
> if it is accessed by multiple threads at the same time, suggests
> that at least for cases where you have an offset it doesn't happen often.
> 
> I cringe when I see per cpu counters for something like files that we
> are likely to have a lot of.  I keep imagining a quadratic explosion
> in data size.  In practice we are likely to have a small cpu count <=
> 8-16 cpus so it is likely ok.  Especially if we are only allocating 8
> bytes per cpu per file.  I guess in total that is at most 128K per file.
> 8bytes*16k cpus.  With the default system file-max on my systems 203871
> to 705863, it looks like we would max out at between 1M and 5M per cpu.
> Still a lot but survivable.

Not only that percpu refcnt is quite expensive to shut down too.  For
modules and devices, it doesn't really matter but using it for files
on FS would be pretty scary.

> Somewhere it all falls down, but only if you max out a very rare
> very large machine, and that seems to be case with just about everything.
> 
> Which all leads me to say that if we can avoid per cpu memory and not impact
> performance I want to do that.

Yeah, fully agreed there.

-- 
tejun
