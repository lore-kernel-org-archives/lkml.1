Return-Path: <linux-kernel-owner+w=401wt.eu-S1754614Ab0AYSCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab0AYSCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 13:02:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461Ab0AYSCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 13:02:35 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:41133 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab0AYSCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 13:02:34 -0500
Message-ID: <8512e098224714ed7d54c62b46346796.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <alpine.LNX.2.00.1001251758230.30977@pobox.suse.cz>
References: <201001202047.o0KKlMTr014003@mustang.cs.nmsu.edu>
    <201001202219.12058.oliver@neukum.org>
    <acd6dfcf4391c081f861d430c0b45311.squirrel@intranet.cs.nmsu.edu>
    <alpine.LNX.2.00.1001251758230.30977@pobox.suse.cz>
Date: Mon, 25 Jan 2010 11:02:18 -0700
Subject: Re: [PATCH] hid: Logitech G13 driver 0.0.4
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Jiri Kosina" <jkosina@suse.cz>
Cc: "Oliver Neukum" <oliver@neukum.org>, linux-kernel@vger.kernel.org,
       felipe.balbi@nokia.com, pavel@ucw.cz, jayakumar.lkml@gmail.com,
       linux-fbdev@vger.kernel.org, krzysztof.h1@wp.pl,
       akpm@linux-foundation.org, linux-usb@vger.kernel.org,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Mon, 25 Jan 2010, Rick L. Vinyard, Jr. wrote:
>
>> > Am Mittwoch, 20. Januar 2010 21:47:22 schrieb Rick L. Vinyard Jr.:
>> >> +       if (copy_from_user(dst, buf, count))
>> >> +               err = -EFAULT;
>> >> +
>> >> +       if (!err)
>> >> +               *ppos += count;
>> >> +
>> >> +       g13_fb_update(par);
>> >> +
>> >> +       return (err) ? err : count;
>> >
>> > Do you really want to go on if you get -EFAULT?
>> >
>>
>> Since the hecubafb driver (which I based this portion of the g13 driver
>> on) uses the same approach I tried to justify it myself when I first saw
>> it.
>>
>> I don't know if this was the intent of the hecubafb author, but this is
>> the way I saw it.
>>
>> By this point the copy_from_user() has failed. If it resulted in a
>> partial
>> copy to dst then continuing on to an update can't hurt, and would reduce
>> display jitter if a re-write occurs from userspace. If a re-write
>> doesn't
>> occur the virtual framebuffer is hosed anyways as dst is is the
>> underlying
>> framebuffer.
>>
>> Given that, the worst-case consequence seems to be an unnecessary update
>> to the device display.
>
> Well, it's quite questionable (and I'd say unexpected) behavior to go on
> even if userspace passes wild pointers to kernel.
>

I agree. It was something that stuck out as an oddity, so I did look into
it more and it seemed like it was the standard behavior for several
drivers such as hecubafb, arcfb, xen-fbfront, metronomefb, broadsheetfb,
et. al.

I don't have a problem changing it. In fact, it appears that this code is
largely replicated from fb_sys_write() in hecubafb, et. al.

The only differences appear to be:

fb_sys_write:
   total_size = info->screen_size;

   if (total_size == 0)
      total_size = info->fix.smem_len;

...

   if (info->fbops->fb_sync)
      info->fbops->fb_sync(info);

hecubafb:
   total_size = info->fix.smem_len;

But, in the drivers screen_size and fb_sync are NULL anyway, so I'm not
sure why these drivers are explicitly modifying the write().

The approach taken by xen-fbfront seems to be even better in that it
relies on fb_sys_write():

static ssize_t xenfb_write(struct fb_info *p, const char __user *buf,
			size_t count, loff_t *ppos)
{
	struct xenfb_info *info = p->par;
	ssize_t res;

	res = fb_sys_write(p, buf, count, ppos);
	xenfb_refresh(info, 0, 0, info->page->width, info->page->height);
	return res;
}

But, if EFAULT is an issue I should modify the g13 version slightly to
account for the fact that fb_sys_write() could return EFAULT or EPERM
without modifying the buffer.

static ssize_t g13_fb_write(struct fb_info *info, const char __user *buf,
			    size_t count, loff_t *ppos)
{
	struct g13_data *par = info->par;
	ssize_t res;

	res = fb_sys_write(p, buf, count, ppos);
	if ( res != -EFAULT && res != -EPERM )
                g13_fb_update(par);
        return res;
}

The reason why I didn't put it as the following:
	if ( res >= 0 )
                g13_fb_update(par);

is because it appears there are two conditions that fb_sys_write() will
continue on to the copy_from_user() but still return an error code. In
these cases -EFBIG and -ENOSPEC are returned but it is possible the buffer
has still been modified.

Again, like I said, I don't have a problem changing it. If it's wrong,
it's wrong no matter how many other drivers may take the same approach.

My intuition tells me it's wrong, but at the same time I'd like to know if
there's a reason behind the other drivers also ignoring the EFAULT. Or,
perhaps it simply started in one driver and everyone else patterned after
it just like I did the g13 driver.


