Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbYJNWcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbYJNWcf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 18:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYJNWc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 18:32:26 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:17674 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbYJNWcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 18:32:25 -0400
Message-ID: <ac3eb2510810141532m508fab47v8abc87f09ffa4cc7@mail.gmail.com>
Date: Wed, 15 Oct 2008 00:32:23 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Peter Osterlund" <petero2@telia.com>
Subject: Re: pktcdvd -> sysfs warning with 2.6.27
Cc: "Greg KH" <greg@kroah.com>, Nix <nix@esperi.org.uk>,
       linux-kernel@vger.kernel.org, a.zummo@towertech.it
In-Reply-To: <m3d4i32bs8.fsf@telia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <87vdvyngni.fsf@hades.wkstn.nix> <20081012181700.GA21072@kroah.com>
	 <87prm4mbgy.fsf@hades.wkstn.nix> <20081013214747.GA15765@kroah.com>
	 <m34p3f926s.fsf@telia.com>
	 <ac3eb2510810140138u438b3935ia134fe8e5dbb795a@mail.gmail.com>
	 <1223976041.5394.6.camel@nga.site> <m3d4i32bs8.fsf@telia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2008 at 9:53 PM, Peter Osterlund <petero2@telia.com> wrote:
> Kay Sievers <kay.sievers@vrfy.org> writes:
>> On Tue, 2008-10-14 at 10:38 +0200, Kay Sievers wrote:
>>> On Tue, Oct 14, 2008 at 7:27 AM, Peter Osterlund <petero2@telia.com> wrote:
>>> > Greg KH <greg@kroah.com> writes:
>>> >
>>> >> Both of those should get "real" majors assigned to them.  It's not ok to
>>> >> randomly go grabbing major:minor numbers like this for code that is in
>>> >> mainline.
>>> >
>>> > It's not about random grabbing. It's about getting a dynamically
>>> > assigned number. The pktcdvd driver once had static numbers, but at
>>> > the time when the driver was merged into the mainline kernel, dynamic
>>> > numbers were considered better. Therefore I changed the driver to use
>>> > dynamic numbers.
>>>
>>> The pktcdvd driver allocates a dynamic block major, which is fine. But
>>> doesn't it use the same number, and now not allocated, for the char
>>> devices it uses? That looks like something that needs to fixed, right?
>>>
>>>   static void pkt_sysfs_dev_new(struct pktcdvd_device *pd)
>>>   {
>>>     if (class_pktcdvd) {
>>>       pd->dev = device_create_drvdata(class_pktcdvd, NULL,
>>>                                                 pd->pkt_dev, NULL,
>>>                                                 "%s", pd->name);
>>
>> Something similar to this, with error checking, might be needed. It has
>> two independent majors now in block and char:
>>   $ grep pkt /proc/devices
>>   251 pktcdvd-char
>>   252 pktcdvd
>
> Maybe, but that character device would not be used for anything,
> besides creating sub-directories in /sys/class/pktcdvd. The driver
> implements a block device, not a character device.

Ah, if the char device nodes are dead anyway, care to change it to
MKDEV(0, 0), so we get rid of the warnings? This should also go into
-stable I guess, after it's fixed in the current tree.

> Is it possible to create a custom directory in sysfs corresponding to
> a block device? A directory /sys/block/pktcdvd0 is apparently created
> automatically, but is it possible to extend that directory with driver
> specific data?

A named (will automatically created in a subdir) sysfs attribute group
below the block device maybe?
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=include/linux/sysfs.h;h=37fa24152bd810f7d9dd67b685e738179b5bfdf9;hb=HEAD#l33

Thanks,
Kay
