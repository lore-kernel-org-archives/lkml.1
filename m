Return-Path: <linux-kernel-owner+w=401wt.eu-S1759568AbXEJQS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759568AbXEJQS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 12:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbXEJQSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 12:18:52 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:31311 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbXEJQSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 12:18:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=r54pTLczH95qyTsTWzG50uT7qzxzGUGkU/Wi4OmWYHSBIf1mObvnXlgj1jRJ4oglNi4gBRUA0zhsECsjFAvggMjMlDXHdB/gyI9b2KFzaHSaPTWGhdjco9gDkH+LhvP6DYJin8whfwrNDrGx1JFKz557Azl2oJoWMTIV9DIeW1I=
Message-ID: <464345DC.4000105@gmail.com>
Date: Thu, 10 May 2007 18:18:36 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <greg@kroah.com>, Chris Rankin <rankincj@yahoo.com>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH] driver-core: don't free devt_attr till the device is
 released
References: <Pine.LNX.4.44L0.0705101150100.3498-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0705101150100.3498-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Thu, 10 May 2007, Tejun Heo wrote:
> 
>> Currently, devt_attr for the "dev" file is freed immediately on device
>> removal, but if the "dev" sysfs file is open when a device is removed,
>> sysfs will access its attribute structure for further access including
>> close resulting in jumping to garbled address.  Fix it by postponing
>> freeing devt_attr to device release time.
>>
>> Note that devt_attr for class_device is already freed on release.
>>
>> This bug is reported by Chris Rankin as bugzilla bug#8198.
>>
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
>> Cc: Chris Rankin <rankincj@yahoo.com>
>> ---
>> Applies well to 2.6.20 and 21.  As sysfs-immediate-disconnect doesn't
>> seem to be included in 2.6.22, this should be included in linus#master
>> too (applies well there as well).
> 
> Although sysfs-immediate-disconnect may not be included in 2.6.22, the old 
> attribute-orphan code by Oliver Neukum is present there and also in 
> 2.6.21.  Shouldn't that suffice?

sysfs_release() still needs to deference attr->owner to put it, so I
think there's the same problem even with attribute-orphan.  We end up
calling module_put() on garbage.

-- 
tejun
