Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbZIRNQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbZIRNQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 09:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbZIRNQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 09:16:13 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:38040 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbZIRNQM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 09:16:12 -0400
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Greg Kroah-Hartmann <greg@kroah.com>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	<ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 18 Sep 2009 06:16:08 -0700
In-Reply-To: <ac3eb2510909170503n1da43ea0u7c900f2f6f647fdc@mail.gmail.com> (Kay Sievers's message of "Thu\, 17 Sep 2009 14\:03\:09 +0200")
Message-ID: <m163bgz947.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kay Sievers <kay.sievers@vrfy.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH] Remove broken by design and by implementation devtmpfs  maintenance disaster
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers <kay.sievers@vrfy.org> writes:

> On Thu, Sep 17, 2009 at 10:23, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> devtmpfs has numerous problems.  The once I see from a quick review.
>> - devtmpfs steals i_private from tmpfs (a layering/maintenance horror)
>
> I can't see the horror.

You can't you aren't a filesystem and you are playing with filesystem
private internal bits.   If I got that close to a woman I would have
to marry her.  In the device layer there have been a bunch of structures
introduced  bus_type_private, driver_private, class_private, device_private
to prevent people from abusing your private data.  Like you are abusing
vfs data.

>> - devtmpfs is missing calls to mnt_want_write.
>
> If you think we miss something, we are glad to add it, if you point it out.

I just did.

>> - device_add does not clean up it's devtmpfs node on error
>
> That's fixable, if the remove event is not already taking care of it.

Sure.  I never said the code was unfixable.

>> - The filesystem does not live under fs/ where it can be found.
>> - The Kconfig entry is not under Filesystems.
>
> It's a special-purpose superblock, not a filesystem. The filesystem is
> still 100% tmpfs. Devtmpfs is just a companion to the driver core's
> sysfs, hence the code is in the driver core. The code does not
> implement any kind of filesystem, it just populates a tmpfs
> superblock.

Yes that explains why you call register_filesystem and have fs
at the end of the name.

>> - The fundamental justification for devtmpfs is bogus.
>>  devtmpfs is not faster nor does it solve the hotplug problem.
>
> It's not about speed, as stated many many times. Please read the archives.
>
>>  * A static dev is faster.
>
> A static /dev is unreliable and unpredictable, and can not be used in
> any not very limited and controlled environment. It's pure theory for
> the systems out there, it just does not work with todays dynamic
> major/minors. You will never know which actual kernel device you open
> from your static /dev entries. Unless someone converts the many
> subsytems across the entire kernel, this is just not an option to even
> think about.
>
> Eric, ever wondered why all the people working in hotplug area,
> maintaining todays systems, and even the ones who wrote udev, want
> this? And only people who have never written any code in hotplug land
> like to object to it? There seems a big disconnect here.

I am.  I just had to rewrite pciehp because it totally fails on the
systems I care about.  I am now figuring out how to merge that back in.
There are some pretty big problems in the device core right now.

>>  * Dynamically creating dev entries (in userspace) is not slow.
>
> Again, it's not about speed, it's about simplicity, reliability and
> synchronous vs. asynchronous behavior.
>
>>    Fundamentally it should be the same amount of time as it is the
>>    same amount of work.
>
> It's the synchronous context of sysfs. It's not interesting to compare
> the overall work. We create the device in /sys, there is no reason not
> to provide the device node at the same time.
>
>>  * People actively write/depend on udev rules to the file names in /dev.
>
> No, the sysfs names give the the device names. And udev can overwrite
> the kernel supplied names, which it doesn't. That all still works the
> same way with devtmpfs. Udev runs just fine on top of it. It even
> removes the kernel created device node if asked for.

sysfs overrides the kernel supplied device names all of the time.
In the general case those overrides are called symlinks.  But a rose
by any other name...


>>    Perhaps they are just for the creation of symlink to the filenames
>>    specified in Documentation/devices.txt but regardless device names
>>    not documented in Documentation/devices.txt are used in the real
>>    world. (i.e. udev still handles naming).
>
> No, udev does not name devices, it's the kernel. There have been a few
> trivial exceptions, but they are all in the kernel today. Please make
> yourself familiar how things work.

I have.  You notice I have sent udev patches?

>>  * If you are truly dealing with hotplug events in userspace
>>    it is necessary to listen to uevents and react which
>>    last I checked is role of udev.
>
> I don't understand. Udev applies the final policy including
> permissions/ownership, just as before. There is no differrence. It's
> just that you can bring up a box without complex userspace to
> bootstrap /dev. And that's a big win on its own. And things like
> "modprobe loop; losetup /dev/loop0" will just work, which it doesn't
> with todays async udev. Again, please make yourself familiar how
> things work, and what the problems are.

The modprobe loop example is interesting, I have not seen that one before.


>> - Once everyone starts using devtmpfs it will be a serious technical
>>  problem for containers.
>
> This is not different from todays udev or sysfs. Also udev runs fine
> with plain tmpfs.

That has been no ability to discuss design alternatives in this process
so it was completely impossible to have any discussion on this.

As for sysfs it is only the broken in tree version that problem.

>> - Reportedly devtmpfs is mandatory in the latest version of Suse
>>  so claiming it is experimental and if unsure say N seems like
>>  the wrong advice, and a serious misnomer.
>
> openSUSE uses it, but it runs fine without devtmpfs.

For how many days will that be true?


>> Who places a filesystem in drivers/core/ and not even
>> in the filesystem Kconfig menu?
>
> As stated, it's a special-purpose superblock, and not a filesystem at all.

Bogus.

>
>> Additionally Greg KH and Kay Sievers have a bad track record of fixing
>> filesystem bugs in sysfs, which I see no reason will not continue with
>> devtmpfs.
>
> Oh, interesting. Any points to working fixes we missed?
>
> Your last series was way over the top, you did not even boot a box
> with it and it broke things in obvious ways when I ran it. I thought
> we applied all your working fixes, and asked you to rebase the rest,
> and skip the stuff that caused the breakage. I think you never did.
> Some of the things showed problems in other subsystem which needed to
> be fixed, and some of these things got fixed. So please send out a
> rebased _and_ tested series again.

My problem is not with how my patches have been treated.  Rather my problem
is the fact that when errors were pointed out I was the only one to step
up to fixing them.  Why should I be the only one stepping up?

My problem is that instead of fixing bugs you are off adding strange weird
features and adding more bugs.

Eric
