Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab0CEHuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 02:50:14 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:52531 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653Ab0CEHuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 02:50:11 -0500
To: Garrett Cooper <yanegomi@gmail.com>
Cc: Shi Weihua <shiwh@cn.fujitsu.com>,
       Rishikesh K Rajak <risrajak@linux.vnet.ibm.com>,
       LTP <ltp-list@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [LTP] [PATCH] sysctl03: sysctl returns EACCES after 2.6.33-rc1
References: <4B7BA24F.2010705@linux.vnet.ibm.com>
	<364299f41002170910i336abf6eh72acbcbec9b72e7b@mail.gmail.com>
	<20100218042532.GC13013@rishikesh.in.ibm.com>
	<4B822F2E.9030609@cn.fujitsu.com>
	<364299f41002212344v4873843ej986f1b39ec3494df@mail.gmail.com>
	<4B8333ED.5080709@cn.fujitsu.com>
	<364299f41002241718g4be216d1pbec918821b7027b0@mail.gmail.com>
	<4B8F716E.5070207@cn.fujitsu.com>
	<364299f41003041037s57f1d4bfr98c20ac7736b8905@mail.gmail.com>
	<m13a0fc11w.fsf@fess.ebiederm.org>
	<364299f41003042320n7437e4a2j219b32a0a5f8dc50@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 04 Mar 2010 23:50:05 -0800
In-Reply-To: <364299f41003042320n7437e4a2j219b32a0a5f8dc50@mail.gmail.com> (Garrett Cooper's message of "Thu\, 4 Mar 2010 23\:20\:52 -0800")
Message-ID: <m1pr3jky1e.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Garrett Cooper <yanegomi@gmail.com> writes:

> On Thu, Mar 4, 2010 at 11:57 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Garrett Cooper <yanegomi@gmail.com> writes:
>>>
>>> Wow... that's a fair amount of code refactoring and additions to the syscall.
>>>
>>> Yes, all of the issues with opening a directory and reading/writing
>>> now apply to sysctl(2), especially if someone attempts to read from a
>>> write-only descriptor, or vice versa.
>>
>> No mismatches of file descriptor modes and how the descriptor is
>> accessed can not occur.  There is a file descriptor but the file
>> descriptor is completely internal to binary_sysctl(), and it is opened
>> with the mode of what we are trying to use.  There are no user space
>> controllable parts there.
>>
>> Looking through the old sysctl code it appears that it was a bug that
>> kept it from returning EACCES.  The code has had this beautiful snippet
>> in it for ages:
>>
>> static int test_perm(int mode, int op)
>> {
>>        if (!current->euid)
>>                mode >>= 6;
>>        else if (in_egroup_p(0))
>>                mode >>= 3;
>>        if ((mode & op & 0007) == op)
>>                return 0;
>>        return -EACCES;
>> }
>
>     Wow. Took a second for me to stare and it and see what you mean,
> but yeah -- that is pretty dang awesome that it was always hardwired
> to return 0.

Sorry that wasn't clear without context.  What used to happen
where all of the callers of that function did:
if (test_perm(...))
   return -EPERM;

Instead of the much more conventional:

err = test_perm()
if (err)
   return err;

>> I admit that the manpage doesn't document EACCES but the manpage
>> has always said don't use sysctl(2) so...
>
>     Well, if someone bumbles across this later, it will be a confusing
> issue to work through. It's better to be documented instead of
> undocumented. I'll file the bug upstream to document this, but it
> would be nice to determine if there are any more immediate gaps which
> need to be addressed in the changes.

I think the linux test project may be nearly the only caller of sysctl(2)
at this point.  At least until recently there was one caller in arm
glibc.  But finding any program that uses sysctl(2) is nearly impossible.

>> You may see a slightly different error code from sysctl(2) on failure
>> but otherwise  sysctl(2) should be unchanged, and yes I did test it.
>> Of course I was not being picky about which error code I got on failure.
>
>     Hmmm.. ok. We just get 20 questions when something fails and it's
> not documented why it should fail in a particular manner :).

>> What exists today is simply a backwards compatibility wrapper of
>> sysctl(2) built on top of /proc/sys.  sysctl(2) was a practically
>> unmaintained bit-rotting pile, that was never adequately maintained or
>> tested.
>
>     Yeah, you're probably right (especially because Linux tends not to
> focus on sysctl(3) like the BSDs do).
>
>> At this point nothing should change again until such time as the code
>> is disabled/removed by default.
>
>     Hmmm... ok. I assume that sysctl(2) is going completely out the
> window in the future, in favor of what (just out of curiosity)? 100%
> sysfs only tunables maybe?

/proc/sys is going to stay.  Which is what people have actually used.
Even /sbin/sysctl has always used /proc/sys.  Nothing anyone actually
uses is going to go away.  Just the practically dead code that is the
syscall is slowly going away.  Since I have written the emulation layer
the need for it to disappear is less immediate than it once was, but I will
strongly discourage anyone from using it.

Eric
