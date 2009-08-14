Return-Path: <linux-kernel-owner+w=401wt.eu-S1755891AbZHNCzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbZHNCzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 22:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbZHNCzv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 22:55:51 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:9769 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbZHNCzu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 22:55:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BB0LyqjFfNwM4D0wt3UcMEOHyV+usWc3IU+Pr66gdG7TyDdH5pef+uZyHddYqxkHDP
         1CTelyfS61RasVZ31k3hMMRGyel4oIKU57KtTYEN0jzo+HmcxeTa28/G1r+vPQA0HUlu
         LpAIAPMy6D1bzsoZaHpDPtXJ8KUodkKmlsQJE=
MIME-Version: 1.0
In-Reply-To: <c1f41c620908130802x77886b15p766af4be070191cd@mail.gmail.com>
References: <200908060733.n767X6mN023120@imap1.linux-foundation.org>
	 <20090807134659.GA2093@darkstar>
	 <20090807094944.eed4bfb8.akpm@linux-foundation.org>
	 <a8e1da0908080313k65f51185u7329e293a95861a7@mail.gmail.com>
	 <20090811140824.GA2067@darkstar> <20090811234838.GA2008@darkstar>
	 <c1f41c620908130802x77886b15p766af4be070191cd@mail.gmail.com>
Date: Fri, 14 Aug 2009 10:55:50 +0800
Message-ID: <a8e1da0908131955w6d740be2nfdbaacbe23ca51a@mail.gmail.com>
Subject: Re: mmotm 2009-08-06-00-30 uploaded
From: Dave Young <hidave.darkstar@gmail.com>
To: Emmanuel Benisty <benisty.e@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 11:02 PM, Emmanuel Benisty<benisty.e@gmail.com> wrote:
> On Wed, Aug 12, 2009 at 6:48 AM, Dave Young<hidave.darkstar@gmail.com> wrote:
>> On Tue, Aug 11, 2009 at 10:08:24PM +0800, Dave Young wrote:
>>> On Sat, Aug 08, 2009 at 06:13:53PM +0800, Dave Young wrote:
>>> > On Sat, Aug 8, 2009 at 12:49 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
>>> > > On Fri, 7 Aug 2009 21:47:00 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
>>> > >
>>> > >> Hi, andrew
>>> > >>
>>> > >> Booting with this release, init (maybe getty?) reports something like:
>>> > >>
>>> > >> INIT: open /dev/console failed with input/output error
>>> > >>
>>> > >> 2.6.31-rc5 is fine.
>>> > >>
>>> > >> Any hints to find the root problem?
>>> > >
>>> > > Not really, sorry.  Might be tty changes in linux-next?
>>> >
>>> > I bisected linux-next, find following patch as a result
>>> >
>>> > commit 65b8c7d9be5862ff8ac839607b444b6f6b11d2fb
>>> > Author: Alan Cox <alan@linux.intel.com>
>>> > Date:   Thu Aug 6 09:58:02 2009 +1000
>>> >
>>> >     cyclades: use the full port_close function
>>> >
>>> > But, I did not select cyclades in my .config, nor do i have the hardware. Weird.
>>>
>>> The above result is wrong, it's a mistake.
>>>
>>> After a whole day's testing and debugging with linux-2.6 git tree and tty patch series, I found the patch causing this issue.
>>> --
>>> From: Alan Cox <alan@linux.intel.com>
>>> Subject: tty: make the kref destructor occur asynchronously
>>> --
>>>
>>> If we make the tty release in a work queue, then tty_reopen might fail with -EIO. I read the sysvinit source code, it will retry 5 times, if still failed, it will warning, then no output before login.
>>>
>>> My distribution is slackware 12.2
>>>
>>> I tested with following debug patch.
>>>
>>> --- linux-2.6.orig/drivers/char/tty_io.c      2009-08-11 21:29:03.000000000 +0800
>>> +++ linux-2.6/drivers/char/tty_io.c   2009-08-11 21:40:01.000000000 +0800
>>> @@ -1246,8 +1246,10 @@ static int tty_reopen(struct tty_struct
>>>  {
>>>       struct tty_driver *driver = tty->driver;
>>>
>>> -     if (test_bit(TTY_CLOSING, &tty->flags))
>>> +     if (test_bit(TTY_CLOSING, &tty->flags)) {
>>> +             printk(KERN_INFO "tty_io.c: closing\n");
>>>               return -EIO;
>>> +     }
>>>
>>>       if (driver->type == TTY_DRIVER_TYPE_PTY &&
>>>           driver->subtype == PTY_TYPE_MASTER) {
>>> @@ -1255,8 +1257,10 @@ static int tty_reopen(struct tty_struct
>>>                * special case for PTY masters: only one open permitted,
>>>                * and the slave side open count is incremented as well.
>>>                */
>>> -             if (tty->count)
>>> +             if (tty->count) {
>>> +                     printk(KERN_INFO "tty_io.c: open count %d\n", tty->count);
>>>                       return -EIO;
>>> +             }
>>>
>>>               tty->link->count++;
>>>       }
>>> @@ -1705,6 +1709,7 @@ static int __tty_open(struct inode *inod
>>>       int index;
>>>       dev_t device = inode->i_rdev;
>>>       unsigned saved_flags = filp->f_flags;
>>> +     static int t;
>>>
>>>       nonseekable_open(inode, filp);
>>>
>>> @@ -1778,8 +1783,15 @@ got_driver:
>>>
>>>       mutex_unlock(&tty_mutex);
>>>       tty_driver_kref_put(driver);
>>> -     if (IS_ERR(tty))
>>> +     if (IS_ERR(tty)) {
>>> +             int r = PTR_ERR(tty);
>>> +             if (t == 5) {
>>> +                     printk(KERN_INFO "%s: %d, %d, retval: %d\n", __FILE__, __LINE__, r, retval);
>>> +                     t =0;
>>> +             } else
>>> +                     t++;
>>>               return PTR_ERR(tty);
>>> +     }
>>>
>>>       filp->private_data = tty;
>>>       file_move(filp, &tty->tty_files);
>>>
>>>
>>
>> Here is a fix for that issue, please help to review.
>> --
>>
>> Due to tty release routines runs in workqueue now,
>> error like following will be reported while booting:
>>
>> INIT open /dev/console input/output error
>>
>> Opening a tty while closing not finished is what cause such problem.
>>
>> Fix it by flush hangup_work in such case and then call tty_init_dev.
>>
>>
>> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>> --
>> drivers/char/tty_io.c |   11 ++++++++---
>> 1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> --- linux-2.6.orig/drivers/char/tty_io.c        2009-08-12 07:12:31.000000000 +0800
>> +++ linux-2.6/drivers/char/tty_io.c     2009-08-12 07:31:30.000000000 +0800
>> @@ -1770,9 +1770,14 @@ got_driver:
>>        }
>>
>>        if (tty) {
>> -               retval = tty_reopen(tty);
>> -               if (retval)
>> -                       tty = ERR_PTR(retval);
>> +               if (test_bit(TTY_CLOSING, &tty->flags)) {
>> +                       flush_work(&tty->hangup_work);
>> +                       tty = tty_init_dev(driver, index, 0);
>> +               } else {
>> +                       retval = tty_reopen(tty);
>> +                       if (retval)
>> +                               tty = ERR_PTR(retval);
>> +               }
>>        } else
>>                tty = tty_init_dev(driver, index, 0);
>>
>
> Thanks Dave, I had the very same issue and your patch fixed it.
>

FIne, so I'm not the only person who have such problem. Thank you for testing.

-- 
Regards
dave
