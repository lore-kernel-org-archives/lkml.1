Return-Path: <linux-kernel-owner+w=401wt.eu-S1751367AbZG0GE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751367AbZG0GE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 02:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbZG0GE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 02:04:29 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:52071 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZG0GE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 02:04:28 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Add function to convert between calendar time and broken-down time for universal use
References: <4A5C3BC0.6020701@cn.fujitsu.com>
	<20090714151040.b7b3b26d.akpm@linux-foundation.org>
	<20090718115019.GH1433@ucw.cz>
	<04e101ca08e5$be078fa0$808410ac@zhaoleiwin>
	<20090719202018.497f7ec1.akpm@linux-foundation.org>
	<4A643EFE.7090103@cn.fujitsu.com> <4A643F36.5090200@cn.fujitsu.com>
	<87ocr9mi8h.fsf@devron.myhome.or.jp> <4A6D1BCF.1030109@cn.fujitsu.com>
Date: Mon, 27 Jul 2009 15:04:21 +0900
In-Reply-To: <4A6D1BCF.1030109@cn.fujitsu.com> (zhaolei@cn.fujitsu.com's
	message of "Mon, 27 Jul 2009 11:15:27 +0800")
Message-ID: <87k51u8xwa.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zhaolei <zhaolei@cn.fujitsu.com> writes:

>>> +	/* the number of years since 1900 */
>>> +	int tm_year;
>> 
>> Why isn't this "long"? "int" can overflow.
>
> I selected int to make it same with user-space struct tm.
>
> In 32-bit machine, long have same length with int, and still can overflow,
> It we want to avoid it in all platform, we should use long long,
> and make division complex.
>
> Maybe make it same with user-space struct tm is ok.

time_t is also "long" on 32-bit machine, it does overflow?

>>> +	/* the number of days since Sunday, in the range 0 to 6 */
>>> +	int tm_wday;
>>> +	/* the number of days since January 1, in the range 0 to 365 */
>>> +	int tm_yday;
>>> +};
>> 
>> Those are needed? 
>
> Those are not needed by FAT-fs's code, but as a library,
> I keep them for generic use and keep same with user-space struct tm.

Yes. But, if there is no users, why need? I guess it makes slow thing,
and it is slow than FAT's one (because FAT's one is optimized for
FAT's timestamp range more or less).

>>> +static inline struct tm *localtime_r(__kernel_time_t totalsecs,
>>> +				     struct tm *result)
>>> +{
>>> +	return __offtime(totalsecs, -sys_tz.tz_minuteswest * 60, result);
>>> +}
>> 
>> I think those are confusable. The real function of those needs to handle
>> timezone database. Especially, sys_tz.tz_minuteswest in localtime_r() is
>> known as wrong.
>> 
>> Are you going to fix it? Otherwise I don't think it would not be good to
>> use it easily as generic function like this.
>
> Actually, it is hard to select.
>
> I don't schedule to introduce complex timezone database into kernel,
> but as you said, localtime() without timezone database is not complete.
> But localtime_r is easy to use and understood, it is similar with
> userspace same-name function...

Actually it is both (gmtime() is also needed to handle timezone).

I worry someone uses it and display/export to userland. After that, the
user will report the bug of it.

>>> +/*
>>> + * Nonzero if YEAR is a leap year (every 4 years,
>>> + * except every 100th isn't, and every 400th is).
>>> + */
>>> +static int __isleap(unsigned int year)
>> 
>> long year. This breaks negative time_t.

Please "long year".

>>> +struct tm *__offtime(__kernel_time_t totalsecs, int offset, struct tm *result)
>>> +{
>> 
>> So, I suggest to consolidate this code only, and don't provide
>> gmtime_r()/localtime_r(), and use more good function name for
>> __offtime() (I'm not sure, however, personally I feel __offtime is not
>> obvious what's doing).
>
> What about just use gmtime_r(rename __offtime->gmtime_r)?

gmtime() also need to handle timezone actually.

> In fact I think both way(hode original localtime/gmtime or delete them) have
> merit and demerit.
> Hode them will make it easy to use, delete them will make function more exact.

Yes. But, how do you handle bug report?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
