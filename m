Return-Path: <linux-kernel-owner+w=401wt.eu-S1752664AbXJVWHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbXJVWHO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 18:07:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbXJVWHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 18:07:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbXJVWG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 18:06:59 -0400
Message-ID: <471D1EF6.6030503@redhat.com>
Date: Mon, 22 Oct 2007 18:06:46 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <greg@kroah.com>, Pete Zaitcev <zaitcev@redhat.com>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: Oops in make_class_name in 2.6.22.1 on Fedora
References: <Pine.LNX.4.44L0.0709111106140.3852-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0709111106140.3852-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2007 11:11 AM, Alan Stern wrote:
>>>
>>> I do not seem to be able to find an answer, sorry.
>>> Do you happen to remember if this was fixed after 2.6.22.1:
>>>
>>> localhost kernel: EIP is at make_class_name+0x27/0x7a
>>> localhost kernel:  [<c05586f1>] class_device_del+0x97/0x119
>>> localhost kernel:  [<c055877b>] class_device_unregister+0x8/0x10
>>> localhost kernel:  [<e08735f4>] __scsi_remove_device+0x1d/0x60 [scsi_mod]
>>> localhost kernel:  [<e08711ae>] scsi_forget_host+0x2d/0x4a [scsi_mod]
>>> localhost kernel:  [<e086c49c>] scsi_remove_host+0x65/0xd5 [scsi_mod]
>>> localhost kernel:  [<e0e76775>] storage_disconnect+0xe/0x16 [usb_storage]
>>> localhost kernel:  [<c056f8b8>] usb_unbind_interface+0x44/0x85
>>> localhost kernel:  [<c0557df7>] __device_release_driver+0x6e/0x8b
>>>
>>> Obviously a known bug but all I see is users reporting it. In my case
>>> it's this:
>>>  https://bugzilla.redhat.com/show_bug.cgi?id=253424
>>> I saw Alan giving it a try here:
>>>  http://lkml.org/lkml/2007/7/12/259
>> I think this was a scsi problem that has been fixed, but don't really
>> remember the exact commit.
> 
> Yes.  There are some bugs in the SCSI async-scanning code, and there is
> a patch to fix them:
> 
> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=a93a091df8232fad60867d41fbc3be855a0b78f2
> 
> It is scheduled for 2.6.24.  For now, people can work around the bug by 
> disabling CONFIG_SCSI_SCAN_ASYNC.
> 

The bug still happens with that patch applied and CONFIG_SCSI_SCAN_ASYNC
enabled. In the marked line, class_dev->class->name is NULL and this causes
the oops in make_class_name().


static void remove_deprecated_class_device_links(struct class_device *class_dev)
{
        char *class_name;

        if (!class_dev->dev)
                return;

===>>   class_name = make_class_name(class_dev->class->name, &class_dev->kobj);
        if (class_name)
                sysfs_remove_link(&class_dev->dev->kobj, class_name);
        kfree(class_name);
}

