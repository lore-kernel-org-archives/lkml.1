Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbYH2Hs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbYH2Hs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 03:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbYH2HsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 03:48:08 -0400
Received: from mail-gx0-f29.google.com ([209.85.217.29]:54272 "EHLO
	mail-gx0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbYH2HsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 03:48:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=L2C6W0KXlFuvIeW2/RjJmf1NSATjEfKAf5MeiuqX+0abTXr+lp9fmfetPZWl2uAsbY
         J7rYI/BQbA/dKbKemr5m6Ovceec8S2tz9x7tgPh1yVrfU07Q4/IWijA87fHYfk9XUhEo
         JoAbDlxGKsP93LsgP5C4JYLnjiHQO1usL2wm4=
Message-ID: <3ae72650808290048v1a5d7e51pc68270b2a8d6faa@mail.gmail.com>
Date: Fri, 29 Aug 2008 09:48:02 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Tejun Heo" <tj@kernel.org>
Subject: Re: [PATCH 2/2] uevent: handle duplicate uevent_var keys properly
Cc: "Greg KH" <greg@kroah.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48B6D9B7.2050406@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48B6D28E.10006@kernel.org> <48B6D2C6.4010703@kernel.org>
	 <20080828164924.GB17475@kroah.com> <48B6D9B7.2050406@kernel.org>
X-Google-Sender-Auth: 68d089d21cba19df
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 19:00, Tejun Heo <tj@kernel.org> wrote:
> Greg KH wrote:
>> On Thu, Aug 28, 2008 at 06:31:02PM +0200, Tejun Heo wrote:
>>> add_uevent_var() appends the specified variable whether the new entry
>>> has duplicate key or not.  This patch makes add_uevent_var() to
>>> override the existing entry if an entry with the same key is added
>>> later.  This will be used by CUSE (character device in userland) to
>>> fake hotplug events.
>>
>> Hm, do you have any pointers to CUSE, that sounds interesting.
>
> I'm in the process of sending patches.  I'll cc you on the actual postings.
>
>> And how would this change interact with fake hotplug events?
>
> CUSE creates actual devices but those devices are all cuse class
> devices.  To play nicely with sysfs/hal, the ADD/REMOVE uevents should
> have about the same variables as the actual device including the
> SUBSYSTEM, so that's where the overriding comes in.  CUSE client tells
> CUSE that it needs to set such such envs for uevents and CUSE overrides
> uevents before sending it out so that sysfs/hal can be fooled.

Not sure if I understand that correctly. Remember, that there is a
symlink "subsystem" at each device, and udev, HAL, DeviceKit reads it.
If the uevent environment key "SUBSYSTEM" does not match the symlink
target, things will break horribly. So no device can be a member of
class "cuse" but carry a SUBSYSTEM value of a different class.

If that is how it works, I guess that must be solved differently, by
hooking into the subsystem code and create "virtual devices" at the
original class they fake, instead of their own "cuse" class. Possibly
by making cuse a "bus", and use the cuse device as a parent for the
"real" class device.

Thanks,
Kay
