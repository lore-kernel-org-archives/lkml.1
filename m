Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbYK3P4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbYK3P4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 10:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYK3P4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 10:56:11 -0500
Received: from ik-out-1112.google.com ([66.249.90.179]:34749 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYK3P4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 10:56:10 -0500
Message-ID: <ac3eb2510811300756icbf6fe5x3c41c7fc9f870db1@mail.gmail.com>
Date: Sun, 30 Nov 2008 16:56:08 +0100
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] fix pktcdvd breakage from commit e105b8bfc769b0545b6f0f395179d1e43cbee822
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>, gregkh@suse.de,
       petero2@telia.com, linux-kernel@vger.kernel.org
In-Reply-To: <20081130145221.GD28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ac3eb2510811300441m2a551cc7nec0374bb7a707bb8@mail.gmail.com>
	 <ac3eb2510811300525n2e47ccap65e897ac1c4adab5@mail.gmail.com>
	 <20081130133229.GZ28946@ZenIV.linux.org.uk>
	 <20081130134048.GA28946@ZenIV.linux.org.uk>
	 <ac3eb2510811300544r2b228a85n86553d6657ac5578@mail.gmail.com>
	 <20081130135031.GB28946@ZenIV.linux.org.uk>
	 <ac3eb2510811300557u4922699du87a62cfd29020db1@mail.gmail.com>
	 <20081130141329.GC28946@ZenIV.linux.org.uk>
	 <ac3eb2510811300628t2bb40427p22e22e2ed671d9a9@mail.gmail.com>
	 <20081130145221.GD28946@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 30, 2008 at 15:52, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Nov 30, 2008 at 03:28:15PM +0100, Kay Sievers wrote:
>> > So we need to preserve the layout, with the easiest way probably being "add
>> > one more ktype and use kobject_init_and_add() instead of that device_create()".
>> > Sigh...
>>
>> What do you mean? We just need to replace the bogus "pd->pkt_dev" with
>> MKDEV(0, 0) and we are fine.
>
> Userland-visible change - right now cat /sys/class/pktcdvd/pktcdvd3/dev will
> give you dev_t of the block device in question.

True, it's visible, but it's incorrect dead information which should
be removed. Subsystem != "block is defined as S_IFCHR, and there is no
such char device for pktcdvd. In fact the "dev" file of the pktcdvd
class device points in many cases to a USB device, which must be
fixed.

The whole pktcdvd class is not used at all, besides for exporting a
few files. The "dev" file at the class device is just a bug, and the
MAJOR/MINOR uevent environment variables also. I doubt that there will
be any visible breakage in something that isn't already totally
broken. In short, I doubt, that anything that works today will stop
working if we remove the bugus "dev" file.

This seem like the simple and correct fix for the issue with /sys/dev/
and the broken non-existing but exported pkcdvd char device:
-               pd->dev = device_create(class_pktcdvd, NULL, pd->pkt_dev, NULL,
+               pd->dev = device_create(class_pktcdvd, NULL, MKDEV(0, 0), NULL,

Kay
