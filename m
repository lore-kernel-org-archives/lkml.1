Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbZC3LZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbZC3LZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 07:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbZC3LZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 07:25:19 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:56559 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbZC3LZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 07:25:18 -0400
MIME-Version: 1.0
In-Reply-To: <20090330104952.26f03c13@hyperion.delvare>
References: <20090329174836.6de797d6@hyperion.delvare> <ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com> 
	<20090330104952.26f03c13@hyperion.delvare>
Date: Mon, 30 Mar 2009 13:24:59 +0200
Message-ID: <ac3eb2510903300424s2604d027h653a3f77163e0242@mail.gmail.com>
Subject: Re: Class device namespaces
From: Kay Sievers <kay.sievers@vrfy.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Michael E Brown <Michael_E_Brown@dell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 10:49, Jean Delvare <khali@linux-fr.org> wrote:
> On Sun, 29 Mar 2009 18:36:46 +0200, Kay Sievers wrote:
>> On Sun, Mar 29, 2009 at 17:48, Jean Delvare <khali@linux-fr.org> wrote:

>> You have multiple instances, which request a firmware file for the
>> same parent device at the same time? Can't they request the firmware
>> for the actual child instead of using the same parent?
>
> No, there's a single firmware request which collides with an i2c-dev
> class device name. The firmware request happens to use the parent
> device's name as its class device name, and it happens that both the
> i2c-adapter class and the i2c-dev class name their class devices the
> same way (which makes sense as they refer to the same thing,
> i2c-adapter for the kernel-space access and i2c-dev for the user-space
> access), and the latter is a child of the former. So when an
> i2c-adapter class device is used as the parent for a firmware request,
> and the i2c-dev driver is loaded, you get a collision.

Ah, I see. If you have a single firmware request, how about using the
bus parent device of your i2c device to request the file, instead of
the class parent device? Then you should get the glue directory, and
all should work.

If that does not work for some reason, we can make the firmware class
to add the "firmware-%s" prefix, like your patch did, only if the
parent is a class device, not a bus device. That should prevent the
breakage of tools making these wrong assumptions.

> Now that we have a use case which would justify that a class device
> child of another class device gets its own namespace, is there a chance
> to see it happen?

Maybe we could do that, and do it only in the case of a class device
uses a class device of a different class as a parent. We need to make
sure, that we don't insert "block" between the disk and the partition,
and the like. It would be kind of inconsistent though, because we
don't do the same thing for any bus devices.

It's very uncommon that class devices want to parent with a class
device of a different class. In most cases, the parent device class
should be converted to a bus, and also use proper device binding
logic. If device binding is not needed, then one of the classes may be
just not needed. Having inter-dependencies between different classes
of the same subsystem, and use each other as a parent sounds rather
strange to me, and I would need to be convinced, that the driver core
would need to work around such issues, and not the subsystem itself.
:)

Thanks,
Kay
