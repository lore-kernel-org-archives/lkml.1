Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbXI0SSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbXI0SSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 14:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759214AbXI0SSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 14:18:18 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:25740 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758844AbXI0SSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 14:18:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=UbaO73FE6AwO8D+tX91OUiXw5bzJjWv1StElLr8XKVwoPC7YUGOewVOH9ebN+AC/wNqBGSc47dwCH4IrNX52gxe98GXIHDyeRAX2j9IhU9VG644/eeZhYiiqkjlPRA+QlBMh+feh50qvRVTlY7TX87R4d8e0RUmUDNwaQa0Kecg=
Message-ID: <46FBA0E3.5090308@gmail.com>
Date: Thu, 27 Sep 2007 05:24:03 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: ebiederm@xmission.com, cornelia.huck@de.ibm.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET 4/4] sysfs: implement new features
References: <11902770971822-git-send-email-htejun@gmail.com> <20070925225005.GB26099@kroah.com>
In-Reply-To: <20070925225005.GB26099@kroah.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

Please read the other reply first.  We need some consensus there first.

Greg KH wrote:
>> * Notify pollers on file deactivation.
> 
> This looks nice.

Cool.

>> * Name-formatting for symlinks.  e.g. symlink pointing to
>>   /dira/dirb/leaf can be named as "symlink:%1-%0" and it will show up
>>   as "symlink:dirb-leaf".  This only applies when new interface is
>>   used.
> 
> Is this really necessary?  It looks like we are adding a "special" type
> of parser here that no one uses.

This is a package deal with the autorenaming.  More on this later.

>> * Autoremoval of symlinks when target is removed.  This only applies
>>   when new interface is used.
> 
> Nice.
> 
>> * Autorenaming of symlinks according to the name format string when
>>   target or one of its ancestors is renamed or moved.  This only
>>   applies when new interface is used.
> 
> Nice.

To rename symlink when its target or one of its ancestors is renamed or
moved, sysfs should be able to determine what should be the new name of
the symlink when it points to the new target, right?  So, we need
symlink name formatting to do this.

I think the implemented formatting scheme covers all symlinks.  Symlink
name formatting will also simplify callers.  No need to allocate name,
format and free it.  It can simply use constant string.

>> * Plugged operations.  Sysfs users can plug top node and build subtree
>>   gradually without revealing the process to userland.  When subtree
>>   is fully constructed, the top node can be unplugged and userland
>>   will see completely built subtree appearing at once.  If subtree
>>   creation fails in the process, the whole subtree can be removed by
>>   simply removing the top node.  There won't be any userland
>>   noticeable event.  This is to be combined with uevent_suppress
>>   mechanism of driver model.
> 
> Hm, but why?  Can't we do this today with the attribute groups?

Yes, we can.  This is the way to do it with the new interface.  More on
this below.

>> * Batch error handling.  A plugged node accumulates any error
>>   condition occurring below it and can return the first error when
>>   asked.  Also, all interface functions accepth ERR_PTR() value as
>>   sysfs_dirent parameter.  This means that constructs like the
>>   following can be used to replace the current group interface.
>>
>>   <<-- code -->>
>>   group = sysfs_add_dir(parent, "group_name", 0777 | SYSFS_PLUGGED, NULL);
>>   sysfs_add_file(group, "file0", 0777, file0_ops, file0_data);
>>   sysfs_add_file(group, "file1", 0777, file1_ops, file1_data);
>>   ...
>>   sysfs_add_file(group, "fileN", 0777, fileN_ops, fileN_data);
>>   rc = sysfs_check_batch_error(group);
>>   if (rc) {
>> 	sysfs_remove(group);
>> 	return rc;
>>   }
>>   sysfs_unplug(group);
>>   return 0;
>>   <<-- end of code -->>
>>
>>   The above will create a subdirectory "group_name" which contains N
>>   files and show them atomically to userland or remove them without
>>   letting userland notice if any failure happens.  This will simplify
>>   sysfs users quite a bit (not only for groups, other stuff too).
> 
> I'm still not sold on why this is needed.  It looks like a lot of extra
> work for something that we are already handling.

Plugged creation + batch error handling is a way to group operations and
commit them atomically under the new interface.  The problem of visible
partial creation / removal is mostly solved using
device->uevent_suppress but I think things can be improved for both
userland and kernel.

After uevent is moved into sysfs, uevent generation can be coupled with
grouped commit.  sysfs hierarchy and accompanying uevents will appear
atomically to userland and in-kernel users end up with simpler and less
buggy code - single error check at the end of all sysfs operations
instead of piece-by-piece construction coupled with the same amount of
unroll code which is usually buggy.  Maybe in (long) time, sysfs access
can be simplified for embedded systems or whatnot.

I don't really see much downside other than the added complexity and as
the added complexity will reduce complexity in the users, I think it's a
good trade off.

Thanks.

-- 
tejun

