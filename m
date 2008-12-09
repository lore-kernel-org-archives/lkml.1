Return-Path: <linux-kernel-owner+w=401wt.eu-S1755987AbYLIXH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbYLIXH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 18:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbYLIXHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 18:07:16 -0500
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:45341 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbYLIXHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 18:07:14 -0500
X-Greylist: delayed 4185 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Dec 2008 18:07:14 EST
Date: Tue, 9 Dec 2008 22:57:26 +0100 (CET)
From: Peter Osterlund <petero2@telia.com>
X-X-Sender: petero@quad.localdomain
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix pktcdvd breakage from commit
 e105b8bfc769b0545b6f0f395179d1e43cbee822
In-Reply-To: <1228534691.3428.1.camel@nga>
Message-ID: <alpine.LFD.1.10.0812092252590.12990@quad.localdomain>
References: <ac3eb2510811300441m2a551cc7nec0374bb7a707bb8@mail.gmail.com>  <20081130133229.GZ28946@ZenIV.linux.org.uk>  <20081130134048.GA28946@ZenIV.linux.org.uk>  <ac3eb2510811300544r2b228a85n86553d6657ac5578@mail.gmail.com>  <20081130135031.GB28946@ZenIV.linux.org.uk>
  <ac3eb2510811300557u4922699du87a62cfd29020db1@mail.gmail.com>  <20081130141329.GC28946@ZenIV.linux.org.uk>  <ac3eb2510811300628t2bb40427p22e22e2ed671d9a9@mail.gmail.com>  <20081130145221.GD28946@ZenIV.linux.org.uk>  <ac3eb2510811300756icbf6fe5x3c41c7fc9f870db1@mail.gmail.com>
  <ac3eb2510812041857j5e49a4ecsfd2f351f572fb350@mail.gmail.com> <1228534691.3428.1.camel@nga>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Dec 2008, Kay Sievers wrote:

> On Fri, 2008-12-05 at 03:57 +0100, Kay Sievers wrote:
>> On Sun, Nov 30, 2008 at 16:56, Kay Sievers <kay.sievers@vrfy.org> wrote:
>>> On Sun, Nov 30, 2008 at 15:52, Al Viro <viro@zeniv.linux.org.uk> wrote:
>>>> On Sun, Nov 30, 2008 at 03:28:15PM +0100, Kay Sievers wrote:
>>>>>> So we need to preserve the layout, with the easiest way probably being "add
>>>>>> one more ktype and use kobject_init_and_add() instead of that device_create()".
>>>>>> Sigh...
>>>>>
>>>>> What do you mean? We just need to replace the bogus "pd->pkt_dev" with
>>>>> MKDEV(0, 0) and we are fine.
>>>>
>>>> Userland-visible change - right now cat /sys/class/pktcdvd/pktcdvd3/dev will
>>>> give you dev_t of the block device in question.
>>>
>>> True, it's visible, but it's incorrect dead information which should
>>> be removed. Subsystem != "block is defined as S_IFCHR, and there is no
>>> such char device for pktcdvd. In fact the "dev" file of the pktcdvd
>>> class device points in many cases to a USB device, which must be
>>> fixed.
>>>
>>> The whole pktcdvd class is not used at all, besides for exporting a
>>> few files. The "dev" file at the class device is just a bug, and the
>>> MAJOR/MINOR uevent environment variables also. I doubt that there will
>>> be any visible breakage in something that isn't already totally
>>> broken. In short, I doubt, that anything that works today will stop
>>> working if we remove the bugus "dev" file.
>>>
>>> This seem like the simple and correct fix for the issue with /sys/dev/
>>> and the broken non-existing but exported pkcdvd char device:
>>> -               pd->dev = device_create(class_pktcdvd, NULL, pd->pkt_dev, NULL,
>>> +               pd->dev = device_create(class_pktcdvd, NULL, MKDEV(0, 0), NULL,
>>
>> Al, this bug still exists, right? Any objections to remove the dead char dev_t?
>
> Here is a patch.

I can confirm that this patch doesn't seem to cause any negative side 
effects on either pktsetup or pktcdvd, which are the only two user space 
programs I know of that care about the pktcdvd driver.

Acked-by: Peter Osterlund <petero2@telia.com>


> Thanks,
> Kay
>
>
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: pktcdvd: remove broken dev_t export of class devices
>
> The pktcdvd created class devices only export some sysfs files,
> but have no char dev_t registered in the driver.
>
> At class device creation time they copy the dev_t value of the
> block device to the char device, wich will register a new char
> device in the driver core and userspace, with a conflicting dev_t
> value.
>
> In many cases the class devices dev_t just points to a random
> USB device. This fixes the sysfs "duplicate entry" errors.
>
> Cc: petero2@telia.com
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> ---
> pktcdvd.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/drivers/block/pktcdvd.c
> +++ b/drivers/block/pktcdvd.c
> @@ -302,7 +302,7 @@ static struct kobj_type kobj_pkt_type_wqueue = {
> static void pkt_sysfs_dev_new(struct pktcdvd_device *pd)
> {
> 	if (class_pktcdvd) {
> -		pd->dev = device_create(class_pktcdvd, NULL, pd->pkt_dev, NULL,
> +		pd->dev = device_create(class_pktcdvd, NULL, MKDEV(0, 0), NULL,
> 					"%s", pd->name);
> 		if (IS_ERR(pd->dev))
> 			pd->dev = NULL;

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
