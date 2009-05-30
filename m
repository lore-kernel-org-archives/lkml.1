Return-Path: <linux-kernel-owner+w=401wt.eu-S932464AbZE3OUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbZE3OUU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 10:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758124AbZE3OUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 10:20:08 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54445 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839AbZE3OUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 10:20:07 -0400
Subject: Re: [PATCH 04/24] sysfs: Normalize removing sysfs directories.
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
In-Reply-To: <m1d49qoi1o.fsf@fess.ebiederm.org>
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>
	 <1243551665-23596-4-git-send-email-ebiederm@xmission.com>
	 <4A1FA777.3040200@kernel.org> <m1zlcvdf7j.fsf@fess.ebiederm.org>
	 <4A210DEF.2030203@kernel.org>  <m1d49qoi1o.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Sat, 30 May 2009 14:19:59 +0000
Message-Id: <1243693199.5223.5.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-05-30 at 06:07 -0700, Eric W. Biederman wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
> > Eric W. Biederman wrote:
> >>   Also, I'm quite uncomfortable with these things
> >>> being done in non-atomic manner.  It can be made to work but things
> >>> like this can lead to subtle race conditions and with the kind of
> >>> layering we put on top of sysfs (kobject, driver model, driver
> >>> midlayers and so on), it isn't all that easy to verify what's going
> >>> on, so NACK for this one.
> >> 
> >> Total nonsense.
> >> 
> >> Mucking about with sysfs after we start deleting a directory is a bug.
> >> At worst my change makes a buggy race slightly less deterministic.
> >> 
> >> I am not ready to consider keeping the current unnecessary atomic
> >> removal step.  That unnecessary atomicity makes the following patches
> >> more difficult, and requires a lot of unnecessary retesting.
> >> 
> >> What do you think the extra unnecessary atomicity helps protect?
> >
> > It's just not a clean API.  When people are trying to code things way
> > up in the stack, they aren't likely to look up the code to see what
> > assumptions are being made especially when the stack is deep and
> > complex and sysfs is near the bottom of the tall stack.  IMHO
> > implementing the usually expected semantics at this depth is worth
> > every effort.  It's just good implementation style which might look
> > like wasted effort but will harden the stack in the long run.  Plus,
> > it's not like making it atomic is difficult or anything.
> 
> I guess we are going to have to disagree on this one.
> 
> My take is simply that a correct user has to wait until no one else
> can find the kobject before calling kobject_del.  At which point
> races are impossible, and it doesn't matter if sysfs_mutex is held
> across the entire operation.

I'm afraid this one isn't a valid assumption.  If you look in SCSI,
you'll see we do get objects after they've been removed from visibility.
We use it as part of the state model for how our objects work (objects
removed from visibility are dying, but we still need them to be findable
(and gettable).

Now, this could be altered as part of an object lifetime rewrite of SCSI
(and I suspect a few other subsystems) but it's certainly an open
question of whether the pain is worth the gain.

James


