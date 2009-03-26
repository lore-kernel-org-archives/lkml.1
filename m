Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbZCZDgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbZCZDgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 23:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753783AbZCZDf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 23:35:59 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:41403 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbZCZDf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 23:35:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=C1gyb/3YlrKqaZXEmFZ66sBbfUppj9IRdH1GyKE3evjeWECOh4TZWSLE3pXSWlsNPk
         6gRLBQSYfYvdYPy+y/4r1Vn7yV3OCpDsP2x9q8LtydGNwQeSyoetqjJPExgDSFcTbOb6
         PJxDuNF2jtW0k35TE8tsq1S5TPsgbOM20KQ3o=
Message-ID: <49CAF840.2030308@gmail.com>
Date: Thu, 26 Mar 2009 12:36:32 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Alex Chiang <achiang@hp.com>, greg@kroah.com, cornelia.huck@de.ibm.com,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org, rusty@rustcorp.com.au,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] sysfs: allow suicide
References: <20090325035707.15921.42150.stgit@bob.kio>	<m13ad2xi46.fsf@fess.ebiederm.org>	<20090325225414.GA11447@ldl.fc.hp.com>	<m17i2dunao.fsf@fess.ebiederm.org> <49CADB45.3090501@gmail.com> <m163hxrnkb.fsf@fess.ebiederm.org>
In-Reply-To: <m163hxrnkb.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Eric W. Biederman wrote:
> Tejun Heo <htejun@gmail.com> writes:
> 
>> Thanks for the points.  I do agree that it could be a bit too clever,
>> but the thing is that protecting the code area from going underneath
>> something is a pretty special thing to begin with and I think it's
>> better to apply special solution rather than trying to work around it
>> using general mechanisms.  So, I actually think the global inhibit
>> thing is one of the better ways to deal with the nasty-in-nature
>> problem.
> 
> Protecting the data structures from going away is just as important,
> and the module_inhibit does not address that.

Yeap, I was talking about the code issue only.

> When I looked at it I could not see any touches of kobj in the sysfs
> code after we dropped the reference count in a strange place, but
> I haven't been able to convince myself that we will be safe.

The reference is dropped when the suiciding thread calls delete on the
sysfs node.  It forfeits its right to access the object when it
deletes it, which makes sense.  The things which are guaranteed after
deleting the base object are the code it's running off of and the
sysfs object itself.  I think it's pretty intuitive from user's POV.

> My view is that this is a general hotplug problem and not a sysfs
> problem.  Further I see inhibiting module reload as only solving
> have the problem as dropping the kobject reference opens a window to
> a use after free on the kobj.

kobject_del(obj); obj->whatever; isn't any different from kfree(p);
*p;.  If the caller accesses the object after deleting it, it's gonna
fail unless it already held a separate reference count.  There is no
window.

> The problem that I see is that we are missing support from the device
> model for hotunplug.  Running the device remove method from process
> context is required.  Typically hotplug controllers discover a
> device has been removed or will be removed in interrupt context.
> 
> Therefore every hotplug driver I have looked at has it's own workqueue
> to solve the problem of getting the notification of a hotplug event
> from an inappropriate context.
> 
> So the general problem that I see is that I need a solution to trigger
> a remove from interrupt context and that same solution will happen to
> work just fine for sysfs.

I think the problem is more driver domain specific and not quite sure
whether one size would fit all.  We have a lot of drivers in the tree.
I think the best approach would be trying to move upwards from the
bottom.  ie. Consolidate hotplug / error handling support from low
level drivers to specific driver subsystem, from driver subsystems to
higher layer (ie. block layer) and then see whether there can be more
commonalities which can be factored, but the chance is that once
things are pushed upwards enough, moving it into the kobject layer
probably wouldn't worth the trouble.  Well, it's all speculations at
this point tho.

Thanks.

-- 
tejun
