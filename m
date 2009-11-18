Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbZKRQ6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbZKRQ6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:58:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757703AbZKRQ6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:58:24 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:43780 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835AbZKRQ6X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:58:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UE3pemOMzVZkNhyrF3NohqhhymQUwQW/cmd43J4C4Rdh84Lv9EfIicY3nFiZBz3j8s
         NkII1fYqmVXE2eniJT0KXnu+Zaiq1j12OO2+iFzftqNM1YGogqgwOQ8IvOYUSOcsVPWi
         c/BycWfDJtix0vWLI7TyglchLCSU33TnvLvyk=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0911181034150.3036-100000@iolanthe.rowland.org>
References: <200911181527.18791.oliver@neukum.org>
	 <Pine.LNX.4.44L0.0911181034150.3036-100000@iolanthe.rowland.org>
Date: Wed, 18 Nov 2009 09:58:29 -0700
Message-ID: <f9d2a5e10911180858j7cf6f244m91cfa0725997182d@mail.gmail.com>
Subject: Re: Use of usb_find_interface in open is racy
From: Russ Dill <russ.dill@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 8:35 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 18 Nov 2009, Oliver Neukum wrote:
>
>> Am Mittwoch, 18. November 2009 11:41:25 schrieb Jiri Kosina:
>> > > User space receives the hotplug event for the class device, makes the
>> > > device node and notifies another program that opens the device node.
>> > > The program opens the device node which calls into usb_open and then
>> > > skel_open. skel_open calls usb_find_interface. usb_find_interfaces
>> > > searches the klist_devices of skel_driver, finds no device associated
>> > > with the minor number and returns NULL. skel_open returns -ENODEV.
>> > >
>> > > Control returns to really_probe and really_probe calls driver_bound
>> > > which adds the device to the list of devices associated with
>> > > skel_driver (klist_devices).
>> > >
>> > > I'm not sure what the right way to solve this is. A call to
>> > > wait_for_device_probe() in the skel_open call before calling
>> > > usb_find_interface fixes the problem, but it is a rather large hammer.
>> >
>>
>> Device core code is hard to follow, but I tried.
>> How about simply covering all of usb_register_dev() with minor_rwsem?
>
> That won't help.  The window is between the end of usb_register_dev()
> and the end of skel_probe(), during which time the mutex isn't held.
>

Like I said above, the window goes all the way till the device gets
added to the klist_devices on the driver.
