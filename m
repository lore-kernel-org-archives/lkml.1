Return-Path: <linux-kernel-owner+w=401wt.eu-S965232AbZLHAhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965232AbZLHAhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 19:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965184AbZLHAhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 19:37:34 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53005 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964886AbZLHAhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 19:37:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oSwZFcN/FCClVd0/+DA98g5NjF3IltrLQz/VmtjRKqGBCmHa9Yj48NisTmQjBc2wZR
         hLnT+ZWQqxDuLxdUCrMmVX2/jISrSFx9IaWkmsrr/EDDSK0XUbmNqK18MtMSpmJadTFC
         7DL3RtNa/iG3bpDvt1H6Ex3y1rgpAIyqR21yA=
MIME-Version: 1.0
In-Reply-To: <20091203145018.GG26702@csn.ul.ie>
References: <200912012253.08522.rjw@sisk.pl> <20091202122019.GD1457@csn.ul.ie>
	 <4B16797C.3010304@tuffmail.co.uk> <20091202211107.GA20830@elf.ucw.cz>
	 <20091202220718.GI1457@csn.ul.ie> <20091202221524.GB20830@elf.ucw.cz>
	 <20091202222516.GD26702@csn.ul.ie> <20091203075301.GA29440@elf.ucw.cz>
	 <4B17B5B8.1060105@tuffmail.co.uk> <20091203145018.GG26702@csn.ul.ie>
Date: Tue, 8 Dec 2009 00:37:36 +0000
Message-ID: <9b2b86520912071637v6957ed24ie0f67acf6785ab08@mail.gmail.com>
Subject: Re: [PATCH] uswsusp: automatically free the in-memory image once 
	s2disk has finished with it
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/3/09, Mel Gorman <mel@csn.ul.ie> wrote:
> On Thu, Dec 03, 2009 at 12:57:28PM +0000, Alan Jenkins wrote:
>> Pavel Machek wrote:
>>> On Wed 2009-12-02 22:25:16, Mel Gorman wrote:
>>>
>>>> On Wed, Dec 02, 2009 at 11:15:24PM +0100, Pavel Machek wrote:
>>>>
>>>>> On Wed 2009-12-02 22:07:18, Mel Gorman wrote:
>>>>>
>>>>>> On Wed, Dec 02, 2009 at 10:11:07PM +0100, Pavel Machek wrote:
>>>>>>
>>>>>>> On Wed 2009-12-02 14:28:12, Alan Jenkins wrote:
>>>>>>>
>>>>>>>> The original in-kernel suspend (swsusp) frees the in-memory
>>>>>>>> hibernation
>>>>>>>> image before powering off the machine.  s2disk doesn't, so there is
>>>>>>>> _much_ less free memory when it tries to power off.
>>>>>>>>
>>>>>>>> This is a gratuitous difference.  The userspace suspend interface
>>>>>>>> /dev/snapshot only allows the hibernation image to be read once.
>>>>>>>> Once the s2disk program has read the last page, we can free the
>>>>>>>> entire
>>>>>>>> image.
>>>>>>>>
>>>>>>>> This avoids a hang after writing the hibernation image which was
>>>>>>>> triggered by commit 5f8dcc21211a3d4e3a7a5ca366b469fb88117f61
>>>>>>>> "page-allocator: split per-cpu list into one-list-per-migrate-type":
>>>>>>>>
>>>>>>> Yes, you work around page-allocator hang. But is it right thing to
>>>>>>> do?

>> Here's a new datum:
>>
>> Applying this patch has left a less frequent hang.  So far it has
>> happened twice.  (Once playing last night, and once today testing
>> hibernation with KMS enabled).
>>
>> This hang happens at a different point.  It happens _before_ writing out
>> the hibernation image.  That is, I don't see the textual progress bar,
>> and if I force a power-cycle then it doesn't resume (and complains about
>> uncleanly unmounted filesystems).
>>
>> Here is the backtrace:
>>
>> [top of screen]
>> s2disk D c1c05580 0 5988 5809 0x00000000
>> ...
>> Call Trace:
>> ...
>> ? wait_for_common
>> ? default_wake_function
>> ? kthread_create
>> ? worker_thread
>> ? create_workqueue_thread
>> ? worker_thread
>> ? __create_workqueue_thread
>> ? stop_machine_create
>> ? disable_nonboot_cpus
>> ? hibernation_snapshot
>> ? snapshot_ioctl
>> ...
>> ? sys_ioctl
>>

> Can you reconfirm that backing out both of those patches makes this 100%
> reliable or is it just a lot harder to trigger. It does not even appear
> that it's locked up within the page allocator at this trace message.
> Assuming c1c05580 is where it's stuck at, where does addr2line say that
> is (requires CONFIG_DEBUG_INFO) ?

The new hang happened with only one patch applied (my "uswsusp:
automatically free the in-memory image once s2disk has finished with
it").

I was able to capture a longer version of the above backtrace by using
KMS [1].  This pre-writeout hang is similar to the post-writeout hang
which occurred on vanilla 2-6.32-rc8 [2].  In both cases the s2disk
process is hanging in disable_nonboot_cpus().  [Which is in turn
blocked on stop_machine_create(), which is apparently failing to
allocate pages for a new task].  The only difference is where
disable_nonboot_cpus() is called from.

And then, the problem went away :-(.  I was unable to reproduce either
hang, even using the same unpatched kernel binaries as before.  Sorry.

[1] Infrequent pre-writeout hang (new, longer backtrace):
<http://picasaweb.google.com/Alan.Christopher.Jenkins/Screenshots#5412613393538769410>

[2] Frequent post-writeout hang:
<http://picasaweb.google.com/Alan.Christopher.Jenkins/Screenshots#5410594126006567282>


> On Thu, Dec 03, 2009 at 12:57:28PM +0000, Alan Jenkins wrote:
>> It looks like hibernation_snapshot() calls disable_nonboot_cpus()
>> _before_ we allocate the hibernation image.  (I.e. before
>> swsusp_arch_suspend(), which calls swsusp_save()).
>>

Sorry, I was wrong here.  The hang occurs after "PM: Preallocating
image memory...".  So it's a bit less mysterious; we can expect to be
low on memory at this point (although it's still a mystery why we
should run out completely).

> I'm not that familiar with the area but considering where we are getting
> stuck and what the path affected, I thought it might be CPU related.
> There is a patch below that prints debugging messages to show how the
> CPU is being taken down with respect to PCP draining in case something
> has changed there. It also puts in some debugging code in the most
> likely place to be infinite looping due to the patch.
>
>> So I think Pavel's right, we still need to work out what's happening here.
>>
>
> Can you apply the following patch please and retry?
>
> Two things to watch out for. First, do either of the BUG_ON triggers?
> Second, for the TRACE messages, do they always appear in the order of
> "draining pages" and then "deleting pagesets"?

I went ahead and tried this, even though I couldn't reproduce the hang anymore.

It didn't BUG.  It didn't show any TRACEs either.  I guess the cpu
notifiers weren't called at all, since no cpu hotplug is necessary on
my uni-core system.

So...
It looks like I can't provide any more data.

I can confidently say that post-writeout hangs would be avoided by my
patch.   But I don't think we want to apply it, because it didn't
solve the pre-writeout hang - which appears to have a similar root
cause.  The post-writeout hang happened to be easier to reproduce, and
it was better in that it didn't cause data loss / fsck (the system
could still resume).

As a curious tester, I would favour not increasing PAGES_FOR_IO on
similar grounds.  Call me naive but 4Mb should be plenty, at least for
this system.  That said, I wouldn't mind if we reserve an extra 4Mb to
avoid the hang, _and then abort the hibernation if we actually have to
use it_.  (We can't simply print a warning message; no-one would see
it because it wouldn't survive the power-down).

Thanks
Alan
