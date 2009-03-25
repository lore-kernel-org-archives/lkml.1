Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbZCYXEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbZCYXEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 19:04:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbZCYXD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 19:03:58 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:21809 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbZCYXD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 19:03:57 -0400
Date: Wed, 25 Mar 2009 17:03:54 -0600
From: Alex Chiang <achiang@hp.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: htejun@gmail.com, greg@kroah.com, cornelia.huck@de.ibm.com,
       kay.sievers@vrfy.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] sysfs: allow suicide
Message-ID: <20090325230354.GB11447@ldl.fc.hp.com>
References: <20090325035707.15921.42150.stgit@bob.kio> <Pine.LNX.4.44L0.0903251036450.3462-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903251036450.3462-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Stern <stern@rowland.harvard.edu>:
> On Tue, 24 Mar 2009, Alex Chiang wrote:
> 
> > Hi all,
> > 
> > This is a refreshed version of the patch series Tejun posted quite a while
> > ago that allowed sysfs attributes to commit suicide directly:
> > 
> > 	http://thread.gmane.org/gmane.linux.kernel/582130/
> 
> > The most contentious part is patch 1/3, wherein sysfs abuses the
> > module notifier call chain, and basically prevents all module unloads
> > until suicidal sysfs attributes have completed.
> > 
> > This is poison of a different flavor from last time. The earlier version
> > of this series modified the module API and created an interface that
> > allowed anyone to inhibit module unload.
> > 
> > This time, only sysfs is allowed to be so... special. Which is a slight
> > improvement, but the question as to whether sysfs should be allowed to
> > do something like this is unresolved.
> 
> I tend to agree with Eric that this feels a little like a band-aid, and 
> a more general solution would be preferable.  But I don't have one to 
> offer, and getting the immediate problems fixed is also important.

Well, getting the sysfs callback off the global workqueue is an
immediate fix that:

	- introduces no conceptual change
	- fixes the lockdep false positive
	- doesn't try to be clever with references

If the consensus here is that this suicide patch series is simply
a band-aid, then I think my other patch will have solved the
problem as much as possible without getting mired in a
conversation about truth and beauty.

> Why change the inhibit-module-unload interface?  This new approach
> seems a lot more complicated than needed; a simple rwsem should work
> okay.  Exposing it to the entire kernel when only sysfs uses it doesn't 
> matter -- there must be plenty of EXPORTed symbols with only one user.

My concern was more the other way around, that exposing a
sledgehammer interface to anyone who wants to inhibit module
unload might not seem like such a wise choice.

I felt that going through the blocking notifier call chain was a
little more proper, in the sense of, "ok well we're going to
allow this inhibit-unload but we know exactly who's doing it".

But that seems irrelevant now.
 
> Which reminds me...  What happens if two different processes write to
> the same suicidal sysfs attribute at the same time?

Good question; I didn't test that with Tejun's patches.

Using the callback mechanism, and a recent patch I wrote that
Greg accepted for 2.6.30, we only allow one in-flight callback
per sysfs attribute/kobject at a time. The loser of the race gets
-EAGAIN while the remove is occurring, and then when the
attribute goes away, gets "file not found" (or something
similar).

Thanks.

/ac

