Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbZG0SNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbZG0SNo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbZG0SNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:13:44 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:56819 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbZG0SNn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:13:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KoHbkZy0W0GEy4R7jazkX3ViEAk8fz/AV1JYbsd+wliQmx8KfATSzFHl/TjnKRKzgl
         o99xZvTAEjDhGpFgSAyE3ANmRGUlmu89Gv+3yy86Cyy6dGSk5kN795nnMALudcVXgnXz
         1zo/yR5U0UNGF2WpItoPp3rmCcv407rVmL6so=
MIME-Version: 1.0
In-Reply-To: <20090727174852.GA3137@suse.de>
References: <8bd0f97a0907262320y3c5c3505h5d47d5c51025a536@mail.gmail.com> 
	<20090727174852.GA3137@suse.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 27 Jul 2009 14:13:23 -0400
Message-ID: <8bd0f97a0907271113u5d4723c0wb87b8a4f76b3b4d4@mail.gmail.com>
Subject: Re: early platform drivers vs resource lookup by name
To: Greg KH <gregkh@suse.de>
Cc: damm@igel.co.jp, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 13:48, Greg KH wrote:
> On Mon, Jul 27, 2009 at 02:20:06AM -0400, Mike Frysinger wrote:
>> ive been toying with the new early platform driver framework and
>> noticed a not-so-friendly feature wrt resource handling.  the
>> platform_device_add() function will take care of making sure that
>> every resource's name field is not NULL:
>> int platform_device_add(struct platform_device *pdev)
>> {
>> ...
>>         if (r->name == NULL)
>>             r->name = dev_name(&pdev->dev);
>> ...
>>
>> unfortunately, the early_platform_add_devices() function does not have
>> similar code.  this leads to NULL pointer crashes if you attempt to
>> use any of the "byname" resource functions (e.g.
>> platform_get_resource_byname) and the resources in question arent
>> fully named.
>>
>> is the simple fix here to add a resource loop to
>> early_platform_add_devices() that makes sure all the name fields are
>> non-NULL ?
>
> I really do not know, what do you think would resolve this best for you?

i think the r->name setting is a little hacky, but i assume it was
added in the first place for a reason, so having the early code follow
suite would probably be the least painful

otherwise platform_get_resource_byname() could be fixed by doing:
        if (r->name && type == resource_type(r) && !strcmp(r->name, name))
            return r;

but who knows what other functions are lurking that assuming r->name
is always set ...
-mike
