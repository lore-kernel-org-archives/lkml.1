Return-Path: <linux-kernel-owner+w=401wt.eu-S1751587AbZG1DCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbZG1DCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 23:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbZG1DCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 23:02:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54151 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbZG1DCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 23:02:23 -0400
Message-ID: <4A6E6ADD.6090602@cn.fujitsu.com>
Date: Tue, 28 Jul 2009 11:05:01 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
CC: Pavel Machek <pavel@ucw.cz>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v3 1/2] Add function to convert between calendar time
 and broken-down time for universal use
References: <4A5C3BC0.6020701@cn.fujitsu.com>	<20090714151040.b7b3b26d.akpm@linux-foundation.org>	<20090718115019.GH1433@ucw.cz>	<04e101ca08e5$be078fa0$808410ac@zhaoleiwin>	<20090719202018.497f7ec1.akpm@linux-foundation.org>	<4A643EFE.7090103@cn.fujitsu.com> <4A643F36.5090200@cn.fujitsu.com>	<87ocr9mi8h.fsf@devron.myhome.or.jp> <4A6D1BCF.1030109@cn.fujitsu.com> <87k51u8xwa.fsf@devron.myhome.or.jp>
In-Reply-To: <87k51u8xwa.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> Zhaolei <zhaolei@cn.fujitsu.com> writes:
> 
>>>> +	/* the number of years since 1900 */
>>>> +	int tm_year;
>>> Why isn't this "long"? "int" can overflow.
>> I selected int to make it same with user-space struct tm.
>>
>> In 32-bit machine, long have same length with int, and still can overflow,
>> It we want to avoid it in all platform, we should use long long,
>> and make division complex.
>>
>> Maybe make it same with user-space struct tm is ok.
> 
> time_t is also "long" on 32-bit machine, it does overflow?

Hello, Ogawa-san:
CC: Andrew, ingo:

Yes, time_t on 32-bit machine will overflow on year-2038.
So tm.tm_year will NEVER overflow on 32-bit machine.

And in 64-bit machine, int type of tm.tm_year will overflow in
year 2,147,485,548, Is that enough?

I also like your suggestion to use long for year, so gmtime/localtime
will never return false on both 32 and 64 bit machine.

(btw, I don't understand why time_t is long, it have different length(limit)
in different arch, and make disunity)

>>>> +	/* the number of days since Sunday, in the range 0 to 6 */
>>>> +	int tm_wday;
>>>> +	/* the number of days since January 1, in the range 0 to 365 */
>>>> +	int tm_yday;
>>>> +};
>>> Those are needed? 
>> Those are not needed by FAT-fs's code, but as a library,
>> I keep them for generic use and keep same with user-space struct tm.
> 
> Yes. But, if there is no users, why need?
> I guess it makes slow thing, and it is slow than FAT's one
> (because FAT's one is optimized for FAT's timestamp range more or less).

There is no users of printk("%pf"), why not remove this?
And at least, I found one: drivers/char/efirtc.c
If I continue searching, maybe more.

>>>> +static inline struct tm *localtime_r(__kernel_time_t totalsecs,
>>>> +				     struct tm *result)
>>>> +{
>>>> +	return __offtime(totalsecs, -sys_tz.tz_minuteswest * 60, result);
>>>> +}
>>> I think those are confusable. The real function of those needs to handle
>>> timezone database. Especially, sys_tz.tz_minuteswest in localtime_r() is
>>> known as wrong.
>>>
>>> Are you going to fix it? Otherwise I don't think it would not be good to
>>> use it easily as generic function like this.
>> Actually, it is hard to select.
>>
>> I don't schedule to introduce complex timezone database into kernel,
>> but as you said, localtime() without timezone database is not complete.
>> But localtime_r is easy to use and understood, it is similar with
>> userspace same-name function...
> 
> Actually it is both (gmtime() is also needed to handle timezone).
> 
> I worry someone uses it and display/export to userland. After that, the
> user will report the bug of it.

IHMO, user of these functions should understand what these functions is and
use these functions for right way.
If we give user a cdrom, it is user's responsibility not using is as cup stand.

At least, there function can make following source a fairy:
fs/ncpfs/dir.c
fs/smbfs/proc.c
fs/fat/misc.c
fs/udf/udftime.c
fs/cifs/netmisc.c
net/netfilter/xt_time.c
drivers/scsi/ips.c
...

It is different with user-land just because it lakes of large-complex locale
database.

>>>> +/*
>>>> + * Nonzero if YEAR is a leap year (every 4 years,
>>>> + * except every 100th isn't, and every 400th is).
>>>> + */
>>>> +static int __isleap(unsigned int year)
>>> long year. This breaks negative time_t.
> 
> Please "long year".

Ok, or int year(after we get conclusion of long/int).

>>>> +struct tm *__offtime(__kernel_time_t totalsecs, int offset, struct tm *result)
>>>> +{
>>> So, I suggest to consolidate this code only, and don't provide
>>> gmtime_r()/localtime_r(), and use more good function name for
>>> __offtime() (I'm not sure, however, personally I feel __offtime is not
>>> obvious what's doing).
>> What about just use gmtime_r(rename __offtime->gmtime_r)?
> 
> gmtime() also need to handle timezone actually.

So, maybe another function name as unmktime?

>> In fact I think both way(hode original localtime/gmtime or delete them) have
>> merit and demerit.
>> Hode them will make it easy to use, delete them will make function more exact.
> 
> Yes. But, how do you handle bug report?

I will thanks you for attention and reporting first, then discuss on LKML
about detail of this problem, and get a conclusion and fix.

Now we are in step2: discussing.
We need to get a best way to fix this to make users happy.

Thanks
Zhaolei

