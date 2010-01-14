Return-Path: <linux-kernel-owner+w=401wt.eu-S1756166Ab0ANVtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab0ANVtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 16:49:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755489Ab0ANVtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 16:49:21 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:61979 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187Ab0ANVtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 16:49:20 -0500
Message-ID: <044387d146c2f91cb7f593736fcce28f.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <ca2dc2821001141308s5a552447yb887f619231f449@mail.gmail.com>
References: <200912142122.nBELMW7d001243@mustang.cs.nmsu.edu>
    <20091216103423.GE1377@ucw.cz>
    <alpine.LNX.2.00.0912161504360.3755@pobox.suse.cz>
    <7f9100aac5f9b06ec78efff25c7a5a71.squirrel@intranet.cs.nmsu.edu>
    <20100104224817.GA21695@elf.ucw.cz>
    <45a44e481001041614i35ceef84q5f12a068e2f0b97b@mail.gmail.com>
    <ca2dc2821001141308s5a552447yb887f619231f449@mail.gmail.com>
Date: Thu, 14 Jan 2010 14:48:41 -0700
Subject: Re: [PATCH] Logitech G13 driver (fixed cc list --- ignore others)
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>
Cc: "Jaya Kumar" <jayakumar.lkml@gmail.com>, "Pavel Machek" <pavel@ucw.cz>,
       "Jiri Kosina" <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       krzysztof.h1@wp.pl, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-usb@vger.kernel.org, "Oliver Neukum" <oliver@neukum.org>,
       linux-input@vger.kernel.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miguel Ojeda wrote:
> On Tue, Jan 5, 2010 at 1:14 AM, Jaya Kumar <jayakumar.lkml@gmail.com>
> wrote:
>> On Tue, Jan 5, 2010 at 6:48 AM, Pavel Machek <pavel@ucw.cz> wrote:
>>>
>>> Ok, but I guess you should cc auxdisplay people in future.
>>
>> Hi Pavel,
>>
>> I just looked at the drivers/auxdisplay directory and got a bit
>> confused. The reason I got confused is because auxdisplay is actually
>> an fbdev driver but it is outside of the drivers/video directory. It
>> looks like there has only been 1 commit and that was for the Samsung
>> KS0108 controller. It also sort of uses platform support but the way
>> it is abstracted is odd to my thinking. The controller is ks0108, so
>> in my mind that would be the code that would be platform independent,
>> and then that would use a board specific IO driver to push data (eg:
>> parport or gpio or usb). I think in the long term it would probably
>> make sense to write a cleaner approach with a drivers/video/ks0108.c
>> which is cleanly platform independent (and back within fbdev proper)
>> and then a board specific driver in the appropriate location that
>> handles the IO.
>
> I wrote long ago the driver(s) and people that reviewed it thought it
> was better to keep it outside. I think that if someone else is going
> to need ks0108, then I agree: we should write a independent driver.
>
> It should not be hard, it is an easy controller to play with and the
> code is already there. I would try to do it; however, I am not sure if
> I would be the most appropriate person to code such generic driver, as
> I know almost nothing about all drivers/video/* stuff and the ways of
> making it truly generic for future video/ users. Still, I will help
> gladly.
>

When I started to look at writing the G13 framebuffer the first code I
looked at was the cfag12864b, and started off trying to adapt it.

However, as I was digging through the video/* directory looking for
something (I forget now what) I came across the hecubafb and patterned the
G13 after it instead.

In moving between the two, the biggest difference was that I was able to
strip out alot of the workqueue code you had since all that was provided
by defio. Otherwise, the general structure was almost identical.

In particular, what would change is the lower half of cfag12864b.c and you
would be able to eliminate almost everything from the /* Update work */
and below comment with the exception of cfag12864b_update().

cfag12864b_update() would become almost analogous to the g13_fb_update() I
have in the G13 driver which is triggered by the deferred_io member of the
fb_deferred_io structure.

You would have something like:

/* Callback from deferred IO workqueue */
static void cfag12864b_deferred_io(struct fb_info *info, struct list_head
*pagelist)
{
	cfag12864b_update(info->par);
}

static struct fb_deferred_io cfag12864b_defio = {
	.delay = HZ / CFAG12864B_UPDATE_RATE_DEFAULT,
	.deferred_io = cfag12864b_deferred_io,
};


The other major change is that you could eliminate the periodic memcmp()
to see if the buffer has change since the deferred_io is only going to
trigger on a page write fault.

But, that isn't a major change in the code... only in performance.

---

Rick


