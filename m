Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbXIIVve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbXIIVve (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 17:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbXIIVv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 17:51:26 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:49072 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbXIIVvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 17:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UZAUdDVJIgqaAjgY1MBLLAVOCN+kvHZsujCoWqMdoogNS1rxFVSE2UkIdXtCJ2RptFerYz6Ep6OZrfXw4Sc7QTQZyYvt3yVhjhvZwSlMmivXam7s1PcBUjiYc94yjtkLd7ro64fBq1lOSPAWGjilcn44xu+yoFIgqdMdZjNOFHU=
Message-ID: <46E46A77.9030900@gmail.com>
Date: Sun, 09 Sep 2007 23:49:43 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: regarding sysfs/kobject separation
References: <46DABD6A.2030708@gmail.com> <20070909145902.GA9194@kroah.com>
In-Reply-To: <20070909145902.GA9194@kroah.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
>> * much more compact and flexible interface based on sysfs_dirent instead
>> of kobject.
> 
> Why?  What would use this kind of interface?  Why would you want to
> create things in sysfs without a kobject?

Compulsory 1:1 mapping between kobject (thus driver model) and sysfs has
been a constant headache for more complex subsystems (e.g. SAS).  The
organization of internal implementation is directly visible to userland
making it part of API which shouldn't change.  For simpler drivers, this
is fine but for others it's too strict a restriction - internal
representation may have to change as implementation matures and the
desired userland view might differ from internal representation for
multiple reasons.

I'm not saying automatic representation is bad.  It's good enough for
90+% of cases and I'm not intending to change that but we still need
flexibility.

Another example would be libata.  libata currently is a SCSI driver and
as such its sysfs representation is tied to SCSI.  However, it's planned
to become an independent block driver and will thus have a separate
sysfs bus and device representation.  The problem is that such
fundamental structure change takes time but libata still needs sysfs
interface now.  Features which require sysfs interface are currently
being delayed or stuffed into SCSI sysfs interface, both of which are
far from the optimal situation.

Breaking the tight coupling between the driver model and sysfs
representation is a way to achieve that.  sysfs becomes an independent
facility which the driver model uses and, where needed, drivers can
override how it's used.  Breaking the tight coupling also makes the
design and implementation of driver model and sysfs more modular and
simpler.

Less pressing but still important is that the current interface is
needlessly cumbersome.  IMHO, it can be made much more intuitive for
driver writers.  More on this later.

>> * Backward compatibility is fully maintained.  All kobject based
>> interface is reimplemented in terms of the new interface.
> 
> This is a source level for the sysfs functions compatibility, right?  Or
> is this the userspace view of sysfs?  If the later one, why would that
> have changed?

Yeap, it's compatible both ways.  Keeping those intact has been of
course the top priority.  :-)

>> * Plugged creation and batched error handling.  Sysfs directories can be
>> 'plugged' on creation such that it can be made visible atomically after
>> all its subtrees are constructed.  Also, the user doesn't have to check
>> for failure at every step.  For example, the user can do the following.
>>
>> 	dir = sysfs_add_dir(parent, "my_dir", SYSFS_PLUGGED | 0777);
>> 	sysfs_add_file(dir, ...);
>> 	...
>> 	dir2 = sysfs_add_dir(dir, ...);
>> 	sysfs_add_link(dir, "link-to-dir2", dir2);
>> 	...
>> 	if (sysfs_check_batch_error(dir) == 0)
>> 		sysfs_unplug(dir);
>> 	else
>> 		sysfs_remove(dir);
>>
>> And all the nodes under and including @dir will show up atomically if
>> all operations succeeded or removed without ever bothering userland.
> 
> Is this really needed?  We work on kobjects and attributes today, and we
> can easily add and remove groups of attributes just fine.
> 
>> * Automatic symlink handling.  Symlink names can be formatted with the
>> name of its target.  e.g. if the symlink name is specified as
>> "link-%1:%0" and points to "devices/mybus0/mydev0", its name becomes
>> "link-mybus0-mydev0" && the symlink will be automatically renamed when
>> the target node or one of its ancestor is moved or renamed.  The symlink
>> is also plugged and removed together with its target.  So, once created,
>> the user doesn't have to care about the symlink.  sysfs will take care
>> of it.
> 
> This might be nice, it would take code out of kobject_move(), right?

And the above two are efforts to make life easier for driver writers so
that the overhead of using sysfs is minimal.  Both features don't
interfere with simple usages and when a driver writer wants to use them,
they don't have to do anything special.  They're just there.

>> * Move uevent support over to sysfs and bridging the current users.
>> This makes sense because sysfs hierarchy is all that userland can see
>> and sysfs users which don't use kobject also needs uevent support.
> 
> What sysfs users without kobjects?  Why?

Hopefully, it's explained now.  It's part of breaking the tight coupling
between internal driver implementation and userland representation.

>> * Convert device model (drivers/base/*) over to the new sysfs_dirent
>> based interface and make device/driver <-> sysfs association flexible.
>> Automatic sysfs association is a good thing.  In most cases, it makes
>> sense and makes drivers simpler but it also needs to be flexible such
>> that drivers with special needs can override how the device and driver
>> are represented to userland.  I think such flexibility can be achieved
>> without too much problem now that sysfs and kobject are separated.
> 
> Hm, I'll have to wait to see the code to understand what you mean by
> this one :)

The new interface is simpler, more orthogonal and flexible.  The whole
interface is consisted of 11 functions and of the 11 only 9 are needed
to achieve the same functionality the original 16 have.  The left two
are for plugged creation support.

Thanks.

-- 
tejun
