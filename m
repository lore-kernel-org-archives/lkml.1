Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbXJEIBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbXJEIBM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 04:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752609AbXJEIA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 04:00:57 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:40221 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbXJEIA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 04:00:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=sddyZosy7Zz7+ViKIdzDPEK1ENyr4OOuQ8oSgdxtS3a9RRxHO3sHSkZJo5X/p8qPJ7aixONq7fnNOs714i3K3W+MUa7PftliF0SrAGi5eTHU4aECPH/RmTNXjgYzo9QQoh7mOciwW7L658Fqsz9+fdKKCl4fgxcGm+nBacNYgxM=
Message-ID: <4705EF30.8010002@gmail.com>
Date: Fri, 05 Oct 2007 17:00:48 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: ebiederm@xmission.com, cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 3/4] sysfs: divorce sysfs from kobject and driver	model
References: <11902755392688-git-send-email-htejun@gmail.com> <20070925221736.GA3566@kroah.com> <46FB956B.8000205@gmail.com> <20071005061812.GA16914@kroah.com>
In-Reply-To: <20071005061812.GA16914@kroah.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

I think this definitely needs more discussion, so here we go...

Greg KH wrote:
>> 1. What is a kobject?
[--snip--]
>> The functionality served by kobject can be broken down into the
>> following two.
>>
>> F-a. To serve as an entity both subsystems can share lifespan
>> management.  ie. both subsystems reference count on kobject.
>>
>> F-b. To serve as an entity both subsystems can base their internal
>> representation on.  (base object in OO term).
> 
> Yes, those are two functions, I can agree with.
> 
[--snip--]
>> 3. Where does that leave kobject?
>>
>> If you combine #1 and #2, both functionalities become questionable.
>>
>> F-a. sysfs no longer plays role in lifespan management of driver model
>> object.  This functionality is exactly what's killed by #2.
> 
> Yes, but a kobject is still needed internally for the lifespan
> management.

Yes, exactly - "internally" to the driver model (or drivers which ride
along).  To sysfs, it has no function other than being an opaque token.

[--snip--]
>> IMHO, both L-a and L-b contribute only to obfuscation of the driver
>> model and sysfs.
> 
> No.  I think you are missing a number of things that kobjects provide
> and allow:
> 	- a structurual heirachy of devices.  Combine kobjects with
> 	  ksets and ktypes, and you have a very powerful system to
> 	  categorize objects and their representation to each other.

Yes, which only needs to be used _inside_ the driver model
implementation proper.

> 	- a consistant and easy interface to userspace through
> 	  uevents/hotplug of the creation and removal of these objects.
> 	  This keeps the different parts of the kernel that need this
> 	  interface from having to create it every time on their own.

Things can be much easier than now.  Also, the above paragraph is
inconsistent with the rest of your argument or am I misunderstanding
what you mean by the above paragraph?

> 	- a way to easily create and export attributes in sysfs
> 	  automatically.

This is and should be the function of the driver model not kobjects.
Removing kobject from the interface doesn't change anything about this.

> 	- a way to provide working reference counting for a variety of
> 	  different objects.

To me, this just feels wrong and does more harm than it helps.  I really
think we shouldn't have multi-role flash light at the core of our driver
model (inside driver model proper, no problem, but not as exported
interface).

> All of those are still needed for the kernel.

For #1 and #3, I agree if you limit the scope to driver model proper but
I am not arguing kobject and all its friends should be abolished.  I'm
arguing that there is no reason to export it as API because it doesn't
add any value exported.

For #4, I don't know.  This can be a matter of taste but I don't think
#4 alone stands as justification for kobject as external API.

For #2, I might be misundertanding.  Please elaborate if I am.  For
uevent issue, I'll talk about more later.

So, I honestly don't think the above four arguments successfully counter
the original arguments.  If I'm missing something, feel free to hammer
me into enlightenment.  :-)

>> 4. So?
>>
>> From #3, as kobject no longer serves any valid purpose to sysfs, it's
>> natural conclusion to try to remove kobject from sysfs, which of course
>> brings up the question of conversion cost.
> 
> I don't mind the removal of kobjects from sysfs in order to make sysfs
> and kobjects work better/simpler.  However the majority of the patches
> you created to do this end up with more code overall, and are of no
> benifit to the current users of sysfs and kobjects in the kernel.
> 
>> 95+% of sysfs users use it through driver model which wraps sysfs
>> interface and exports it as a part of driver model.  For these,
>> conversion only needs to happen inside the driver model, so we
>> definitely can do that.
> 
> But what would that benifit the driver model?

There is no code reduction or functionality improvement yet because all
of them are still using the compatibility interface.  Properly
converted, sysfs handling code all over the kernel can be _much_
simplified and more robust.  I bet there are numerous bugs in sysfs
creation failure handling path all over mid/low level drivers.  New
interface makes those bugs much less likely.

>> The rest isn't great in number and, much more importantly, many of those
>> suffer from the current interface which is painful to use independently.
>>  For example, kernel/module.c does all the kobject dances including
>> defining a subsystem just to ignore everything else and use it as an
>> opaque token to sysfs (kset_find_obj doesn't count, a generic map or
>> sysfs with sysfs_dirent interface can do that just as well).
> 
> I will not deny that the current use of kobjects/ksets/ktypes (subsystem
> is now gone) is difficult and extreemly painful.  I am currently working
> to fix this issue.  But don't think that the reason this is hard to use
> means that it should be abolished alltogether.
> 
> Rather, it means that this interface to using kobjects needs to be fixed
> and made easier, not circumvented.

The thing is that functionality-wise, kobject and its friends don't
serve anything anymore outside of driver model implementation proper
(I'll talk about uevent later) and thus there is no reason to use it
outside of driver model implementation anymore in the long term.

If something is needed but bypassed, it's circumvented but that isn't
the case here.  kobject and its friends no longer have any essential
functionality in the exported API.  It's just a dead weight. (Any entity
in the driver model can and should use what the driver model exports, so
that part is irrelevant here.)

>> 5. Wouldn't that allow manifestation of random hierarchy all over sysfs?
>>
>> I really don't know whether it will or not but I don't agree interface
>> obfuscation is the right way to prevent that.  IMHO, if we need better
>> policing under /sys than regular review process can provide, we should
>> force it by clearly defined policies and documentation not by
>> obfuscation, which, BTW, can't really prevent anything.
> 
> No, I think that we have been lucky so far that it is so hard to get
> sysfs representation working properly for "raw" kobjects.  It has made
> people really think why they want to add things there, and usually just
> give up and go and put things into the proper place in the /sys/devices/
> tree.

I can agree to that.  Unfortunately, it also sometimes distorts driver
implementation because representing the proper picture is so difficult.
 libata attributes are under constant pressure to escape to SCSI and
block nodes (nothing bad has actually happened yet tho), new features
are being delayed and/or pushed to use different userland interface
(module parameter being the most common).  I know libata is a corner
case at the moment but a bit of flexibility would have been very helpful
for both developers and users.

> Also, not everything that people keep wanting to put in /sys should go
> there.  The perfict example of that is the recent BDI stuff.  It belongs
> in the driver tree, not in a new /sys/bdi/ location.  If sysfs were
> "easier" to use, then it would be abused this way.
> 
> The end goal for sysfs is to present a heirachy of devices that are in
> the kernel today.  It is not a replacement for everything that people
> feel they need to export to userspace in whatever form they want to.
> There are rules that need to be followed in the exportation of data, as
> userspace programs expect this.  The current kobject interface tries
> very hard to enforce those rules, and it needs to stay combined with
> sysfs that way.

Yes, fully agreed.  What I'm trying to argue is that obfuscation isn't
the optimal way to achieve that.  We can do it in saner and less painful
way.

[--snip--]
>> So, no, I don't agree to keeping kobject based interface to keep sysfs
>> hierarchy tidy.
> 
> I strongly object here.
> 
> I think that if your current patches are accepted, we will see a lot of
> new users of sysfs in ways that are not "standard" to how it is used
> today.  Things that rely on "close" happening to the sysfs file, or
> trees created that do not emit uevents.

Adding policies to prevent such usages to easy interface is the right
thing to do.  Currently, we don't even have defined policies for sysfs
outside of driver model.  The only thing is that it's difficult to
understand and painful to use.

I just don't really get how it's okay to keep kobject based interface
just to make things more difficult and solely depend on that artificial
difficulty for keeping the tree tidy.

We can enforce stronger rules with easier interface.  Just lemme know
the rules.  I'll enforce those rules in the sysfs core such that
changing those rules will have to go through driver model review chain.
 Wouldn't that be much better?

> A good example for why we need to keep things the same way today is the
> SLUB code.  It exports data through sysfs and automatically started
> exporting things through uevents.  People realized this and can now
> easily write tools that watch for those events to show things happening
> in the slab allocator.

Yes and sysfs restructuring when it's finished won't change that at all.
 Things will be better toward the same goal.  Remember that I said the
next step was moving uevent over to sysfs?  Uevent belongs to sysfs
because it's by design bound to userland visible representation of
kernel objects.  The current placement is awkward - kobject carries
uevent related fields whether it's needed or not, uevent suppression is
in struct device not in kobject and sysfs creation / uevent
synchronization is done in awkward way.

>> 6. Conclusion
>>
>> I think I said enough about why kobject based interface isn't such a
>> good idea anymore.  I'll try to cover why it's a good idea to move over
>> to new sysfs_dirent based interface.
>>
>> * It's a clean up and a big one at that.  It makes sysfs code and
>> interface much more straight-forward and its users will benefit too when
>> they are converted over to new interface.
> 
> I don't object to a clean up.  What I object to is the use by other code
> of sysfs by not using kobjects.  I feel that if you really want to do
> that, then go write a new filesystem for that kind of thing.  We have
> already done this with debugfs and securityfs.  I really want to enforce
> the kobject interface to the users of sysfs.
> 
> Now if we can keep that enforcement of sysfs, then I have no objections
> to cleaning up the internal interface between sysfs and kobjects, and
> the overall fixing of the kobject/kset/ktype code.  That is all good
> things overall.

I think what's missing here is why we need to enforce kobject interface.
 It certainly isn't for kobject itself's sake, right?  Originally, it
served a valid purpose for interaction with sysfs.  Also, by the virtue
of being difficult to use, it limited the usage of sysfs.

My arguments here are...

1. kobject no longer has such valid purpose as far as sysfs is
concerned, which was its biggest out-of-driver-model functionality.
And, in the long term, I don't see any reason why kobject needs to be
visible outside of driver model.

2. I'm all for keeping the tree tidy but I think it's better and more
cleanly done by well defined policies clearly stated in the
documentation and enforced by code such that changing sysfs hierarchy
always goes through driver model review chain.

3. In this series, all that happened was implementing new interface and
features and reimplement original interface in terms of them.  As such,
there is no code clean up out of sysfs.  In fact, sysfs gained
considerable amount of code.  Considering wide spread use of sysfs, I'm
pretty sure the net code amount and complexity will drop considerably
with future API user conversions.

Hopefully, I stated things clearer this time.  If you disagree, please
try to convince me.  I'm listening and I think we really need to
establish consensus on this subject.

Thanks a lot.

-- 
tejun
