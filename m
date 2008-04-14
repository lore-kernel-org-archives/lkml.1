Return-Path: <linux-kernel-owner+w=401wt.eu-S1758522AbYDNMcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522AbYDNMcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 08:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbYDNMcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 08:32:16 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:60953 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbYDNMcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 08:32:14 -0400
Date: Mon, 14 Apr 2008 16:30:48 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: David Fries <david@fries.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/35] W1: w1 core deadlock and oops fixes, ds2490 updates
Message-ID: <20080414123048.GC13385@2ka.mipt.ru>
References: <20080328122311.GA3613@spacedout.fries.net> <20080330112716.GB15122@2ka.mipt.ru> <20080413225632.GA14058@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413225632.GA14058@spacedout.fries.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, Apr 13, 2008 at 05:56:32PM -0500, David Fries (david@fries.net) wrote:
> I dug out a panic before I started modifying the driver, see the end
> of the message.  There is still a remaining oops.  Register the same
> sensor with two masters.  The serial id of the sensor is assumed to be
> unique and the sysfs code will cause an oops when the second sensor is
> registered.  If you have two master devices that are both doing bus
> searching, let one detect the sensor, the move it to the other master.
> The second master will detect the device before the first one times it
> out.  None of my patches address this.

This is first time you show me the oops, so I we can start thinking
about bug itself. Getting that you already have a fix and changes which
I agree with, we can proceed with them. The only stuff I complain about
it how you organized your patchset. There is no need to put multiple
revisions of the same file in several patches when each new change just
overwrite previous one, this complicates code review and digging into
changeset changelogs in case of problems.

> Could you be more specific on "really wrong, like what you call a
> deadlock was intended"?  I only use 'intended' once, and that is is
> patch 1 in "The slave reconnect was incorrectly coded."  That
> paragraph is describing a infinite loop inserting a slave driver, not
> unloading a device driver.

I had a gpio driver which worked really bad, since current source was
very weak and shared with different resource. It was not pure luck to
get data from it, but it did not work reliably. So there are all those
loops you see in reading path, having them in userspace would provide a
great feeling of really broken hardware (like that broked rom data you
see blacklisted in the driver), while it just did not worked 100%
reliably. Because of that I did not allow to forcedly stop
'transaction', since getting it right took lots of time, so we do want
that data, so no interrupt, so removing module stops...
Yes, this is really ugly, but it works and was added intentionally.
Now I think that for better quality and simplicity of the code we can
drop this behaviour.

> If something is really wrong with the descriptions I'll fix it.
> 
> > There is another problem with your submission - please split it into 3-5
> > patches which are logically compound, so that there would not be things
> > like: patch1: replace A with B, patch2: remove B and the like.
> 
> You must be talking about patch 14 and patch 15 w1_slave_read_id sort
> read bug.  That's the only place it does that.
> 
> I debated on how to submit
> patch 14 "w1_slave_read_id multiple short read bug"
> and
> patch 15 "w1_slave_read_id from bin_attribute to device_attribute"
> and I did it that way to first show what he bug was and fix it, then
> show how simple the code was using a different method.  I'll submit it
> in one patch.
> 
> > You also have lots of codying style issues in the patchset.
> Such as?

if( without space
a=b without spaces and the like. Pretty trivial, but I will be frowned
upon if accept that :)

> This was the overview e-mail, and it was long enough without going
> into details on each of the issues.  But here they are.

I agree with what you pointed is not correct, including 'deadlock', but
I already described why I did it that way. It does work and is ugly and
is probably wrong, so I agreed to remove this 'feature'.

The same applies to other bug fixes you provided: I agreew ith them
(even though some of them I see first time)

> > Please reorganize your patches into something like this:
> > 1. threads changes
> > 2. master device removal changes (remove slaves which are on the bus
> > master being removed) and related things
> > 3. ds2490 changes
> > 4. cleanups
> > 
> > or something like that, reviewing 35 small patches which are removing
> > things past another is not a really good time...
> 
> You want me to take 35 patches and merge them down to 4?  There were a
> lot of issues in here, and I don't have an automagic patch reorder
> tool.  If you want to review fewer patches apply 1-6, do a diff and
> look at that.
> 
> Documentation/SubmittingPatches '3) Separate your changes.' It goes on
> to specifically separate out bug fixes and performance enhancements.

Your changes overwrite each other, and some times adds something or
remove something to accomplish requested goal. I specially pointed to
one of them in your last patchset, which you marked rfc and not for
merge. Change separation does not mean all commits should be sent as
independent patch, logical changes should be combined. When patch 2
overwrite patch1 and does something similar, combine them.
Bug fixes to bug fixes, features to features. If some overwrite fix a
bug, send that overwrite.

> You requested in another e-mail to merge patch 1-6.  The deadlocks in
> 1 is clearly a bug.  6 block (instead of sleeping with a timeout) is a
> performance enhancement.  5 might be a deadlock, but it's not at all
> related to 1.  2 and 3 have nothing to do with any of the above.
> Logically this come out to be a bunch of patches.

I roughly pointed how to organize them. My main intention was to
logically separate changes, not sending every single commit in different
patch.

> On Mon, Jan 21, 2008 at 06:56:35PM -0800, Andrew Morton wrote:
> > On Mon, 21 Jan 2008 20:47:19 -0600 David Fries <david@fries.net> wrote:
> > > Thanks.  Question, at what point should I just submit these one liner,
> > > but independent bugs in one patch?
> > 
> > You shouldn't, unless they are dependent in both directions.
> 
> If Andrew Morton is going to say no for independent one line bugs, I'm
> going to say No (for a bunch of complicated sometimes overlapping
> bugs, features, and performance enhancements) as well.  Besides I have
> something like 27KB in 664 lines of descriptions, if I tried to merge
> the changes down there's no way I could figure out which patch lines
> went with what descriptions, and no one else could either.

I think I have to note that again: if some feature overwrite fix the
bug, then just send that overwrite, since it was original goal. Instead
you send number of one-line fixes, and then overwrite them. Less changes
we have (presumbly they are logically separated and do not break each
others), less time we will spend reviewing code, searching for wrong
commit, checking for bugs.

I understand that you do not want to do that just because you already
have cvs sommit log which you send to me, but this also means that I
will need to do that for your changes and then resubmit.

> w1_master_driver w1_bus_master1: Family 21 for 21.34c0000039c5.ba is not registered.
> Failed to read 1-wire data from 0x02: err=-110.
> Failed to read 1-wire data from 0x02: err=-110.
> usb 2-3: USB disconnect, address 5
> w1_master_driver w1_bus_master1: Waiting for w1_bus_master1 to become free: refcnt=1.
> w1_slave_release: Releasing 81-00000020bbd0.
> w1_slave_release: Releasing 21-34c0000039c5.
> w1_slave_release: Releasing 28-0000000e84a2.
> w1_slave_release: Releasing 81-00000020bbd0.

> usb 2-3: new full speed USB device using ohci_hcd and address 8
> usb 2-3: device descriptor read/64, error -62
> hub 2-0:1.0: Cannot enable port 3.  Maybe the USB cable is bad?
> hub 2-0:1.0: Cannot enable port 3.  Maybe the USB cable is bad?
> hub 2-0:1.0: Cannot enable port 3.  Maybe the USB cable is bad?
> hub 2-0:1.0: Cannot enable port 3.  Maybe the USB cable is bad?
> usb 2-3: new full speed USB device using ohci_hcd and address 12
> usb 2-3: configuration #1 chosen from 1 choice
> usb 2-3: USB disconnect, address 12
> BUG: unable to handle kernel NULL pointer dereference at virtual address 0000000c

Does this happen only when you remove and plug ds9490 back to the
socket? We could fix it rather quickly, but I'm glad you fixed it
yourself :)




-- 
	Evgeniy Polyakov
