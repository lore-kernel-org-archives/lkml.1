Return-Path: <linux-kernel-owner+w=401wt.eu-S932584AbZE3PvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584AbZE3PvW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 11:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759595AbZE3PvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 11:51:13 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59968 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759012AbZE3PvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 11:51:12 -0400
Subject: Re: [PATCH 04/24] sysfs: Normalize removing sysfs directories.
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
In-Reply-To: <m1bppaei52.fsf@fess.ebiederm.org>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
	 <1243551665-23596-4-git-send-email-ebiederm@xmission.com>
	 <4A1FA777.3040200@kernel.org> <m1zlcvdf7j.fsf@fess.ebiederm.org>
	 <4A210DEF.2030203@kernel.org> <m1d49qoi1o.fsf@fess.ebiederm.org>
	 <1243693199.5223.5.camel@mulgrave.int.hansenpartnership.com>
	 <m1bppaei52.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Sat, 30 May 2009 15:51:07 +0000
Message-Id: <1243698667.5223.12.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-30 at 08:15 -0700, Eric W. Biederman wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> > On Sat, 2009-05-30 at 06:07 -0700, Eric W. Biederman wrote:
> >> Tejun Heo <tj@kernel.org> writes:
> >> 
> >> > Eric W. Biederman wrote:
> >> >>   Also, I'm quite uncomfortable with these things
> >> >>> being done in non-atomic manner.  It can be made to work but things
> >> >>> like this can lead to subtle race conditions and with the kind of
> >> >>> layering we put on top of sysfs (kobject, driver model, driver
> >> >>> midlayers and so on), it isn't all that easy to verify what's going
> >> >>> on, so NACK for this one.
> >> >> 
> >> >> Total nonsense.
> >> >> 
> >> >> Mucking about with sysfs after we start deleting a directory is a bug.
> >> >> At worst my change makes a buggy race slightly less deterministic.
> >> >> 
> >> >> I am not ready to consider keeping the current unnecessary atomic
> >> >> removal step.  That unnecessary atomicity makes the following patches
> >> >> more difficult, and requires a lot of unnecessary retesting.
> >> >> 
> >> >> What do you think the extra unnecessary atomicity helps protect?
> >> >
> >> > It's just not a clean API.  When people are trying to code things way
> >> > up in the stack, they aren't likely to look up the code to see what
> >> > assumptions are being made especially when the stack is deep and
> >> > complex and sysfs is near the bottom of the tall stack.  IMHO
> >> > implementing the usually expected semantics at this depth is worth
> >> > every effort.  It's just good implementation style which might look
> >> > like wasted effort but will harden the stack in the long run.  Plus,
> >> > it's not like making it atomic is difficult or anything.
> >> 
> >> I guess we are going to have to disagree on this one.
> >> 
> >> My take is simply that a correct user has to wait until no one else
> >> can find the kobject before calling kobject_del.  At which point
> >> races are impossible, and it doesn't matter if sysfs_mutex is held
> >> across the entire operation.
> >
> > I'm afraid this one isn't a valid assumption.  If you look in SCSI,
> > you'll see we do get objects after they've been removed from visibility.
> > We use it as part of the state model for how our objects work (objects
> > removed from visibility are dying, but we still need them to be findable
> > (and gettable).
> 
> I was not precise enough.  It appears I overlooked the fact that
> kobject_del is not always called from kobject_put by way of
> kobject_release.

OK ... just so you understand, I'm thinking about the device model
rather than kobjects.  device_del() can't be called from release methods
because they're often called from interrupt context and the mutex
requirements in device_del() mean it needs user context.

> Strictly the requirement is that after kobject_del we don't add,
> remove or otherwise manipulate sysfs attributes.  That is we don't
> call any of:
> 
> sysfs_add_file
> sysfs_create_file
> sysfs_create_bin_file
> sysfs_remove_file
> sysfs_remove_bin_file
> sysfs_create_link
> sysfs_remove_link
> sysfs_create_group
> sysfs_remove_group
> sysfs_create_subdir
> sysfs_remove_subdir
> 
> 
> Those all either oops or BUG today if you try it.  So I can't see how
> a subsystem could depend on those working.

It doesn't; you've altered your requirement.  We can fully buy into this
new relaxed one.

> Also there is sysfs_remove_dir (on a subdirectory) aka kobject_del on
> a child object after kobject_del on the parent object.
> 
> As best I can tell that only works by fluke today.

Yes, that's an artifact of the fact that the reference counted lifecycle
is on release ... del just happens at a certain point in it.  We don't
hold any counters that tell us what the visibility of our children are,
so it's possible to make a parent invisible by calling del simply
because you don't know.

> > Now, this could be altered as part of an object lifetime rewrite of SCSI
> > (and I suspect a few other subsystems) but it's certainly an open
> > question of whether the pain is worth the gain.
> 
> I won't tell you that sysfs, the kobject layer, or the device layer
> are the best thing since sliced bread.  I'm just trying to simplify
> the code and get the bugs out.

James


