Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbZG0DMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbZG0DMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 23:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbZG0DMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 23:12:47 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59898 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755491AbZG0DMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 23:12:46 -0400
Message-ID: <4A6D1BCF.1030109@cn.fujitsu.com>
Date: Mon, 27 Jul 2009 11:15:27 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Machek <pavel@ucw.cz>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH v3 1/2] Add function to convert between calendar time
 and broken-down time for universal use
References: <4A5C3BC0.6020701@cn.fujitsu.com>	<20090714151040.b7b3b26d.akpm@linux-foundation.org>	<20090718115019.GH1433@ucw.cz>	<04e101ca08e5$be078fa0$808410ac@zhaoleiwin>	<20090719202018.497f7ec1.akpm@linux-foundation.org>	<4A643EFE.7090103@cn.fujitsu.com> <4A643F36.5090200@cn.fujitsu.com> <87ocr9mi8h.fsf@devron.myhome.or.jp>
In-Reply-To: <87ocr9mi8h.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi wrote:
> Zhaolei <zhaolei@cn.fujitsu.com> writes:
> 
>> +/*
>> + * Similar to the struct tm in userspace <time.h>, but it needs to be here so
>> + * that the kernel source is self contained.
>> + */
>> +struct tm {
>> +	/*
>> +	 * the number of seconds after the minute, normally in the range
>> +	 * 0 to 59, but can be up to 60 to allow for leap seconds
>> +	 */
>> +	int tm_sec;
>> +	/* the number of minutes after the hour, in the range 0 to 59*/
>> +	int tm_min;
>> +	/* the number of hours past midnight, in the range 0 to 23 */
>> +	int tm_hour;
>> +	/* the day of the month, in the range 1 to 31 */
>> +	int tm_mday;
>> +	/* the number of months since January, in the range 0 to 11 */
>> +	int tm_mon;
>> +	/* the number of years since 1900 */
>> +	int tm_year;
> 
> Why isn't this "long"? "int" can overflow.

Hello, OGAWA-san:

Thanks for your review.

I selected int to make it same with user-space struct tm.

In 32-bit machine, long have same length with int, and still can overflow,
It we want to avoid it in all platform, we should use long long,
and make division complex.

Maybe make it same with user-space struct tm is ok.

>> +	/* the number of days since Sunday, in the range 0 to 6 */
>> +	int tm_wday;
>> +	/* the number of days since January 1, in the range 0 to 365 */
>> +	int tm_yday;
>> +};
> 
> Those are needed? 

Those are not needed by FAT-fs's code, but as a library,
I keep them for generic use and keep same with user-space struct tm.

>> +
>> +extern struct tm *__offtime(__kernel_time_t totalsecs, int offset,
>> +			    struct tm *result);
> 
> Why isn't time_t simply, not __kernel_time_t?

Yes, thanks.
It should be time_t.
I will fix it.

>> +/**
>> + * gmtime_r - converts the calendar time to UTC broken-down time
>> + *
>> + * @totalsecs	the number of seconds elapsed since 00:00:00 on January 1, 1970,
>> + *		Coordinated Universal Time (UTC).
>> + * @result	pointer to struct tm variable to receive broken-down time
>> + *
>> + * Return a pointer to the broken-down time result on success,
>> + * and NULL on when the year does not fit into an integer.
>> + *
>> + * Similar to the gmtime_r() in glibc, broken-down time is expressed in
>> + * Coordinated Universal Time (UTC).
>> + */
>> +static inline struct tm *gmtime_r(__kernel_time_t totalsecs, struct tm *result)
>> +{
>> +	return __offtime(totalsecs, 0, result);
>> +}
>> +
>> +/**
>> + * localtime_r - converts the calendar time to local broken-down time
>> + *
>> + * @totalsecs	the number of seconds elapsed since 00:00:00 on January 1, 1970,
>> + *		Coordinated Universal Time (UTC).
>> + * @result	pointer to struct tm variable to receive broken-down time
>> + *
>> + * Return a pointer to the broken-down time result on success,
>> + * and NULL on when the year does not fit into an integer.
>> + *
>> + * Similar to the localtime_r() in glibc, broken-down time is expressed
>> + * relative to sys_tz.
>> + */
>> +static inline struct tm *localtime_r(__kernel_time_t totalsecs,
>> +				     struct tm *result)
>> +{
>> +	return __offtime(totalsecs, -sys_tz.tz_minuteswest * 60, result);
>> +}
> 
> I think those are confusable. The real function of those needs to handle
> timezone database. Especially, sys_tz.tz_minuteswest in localtime_r() is
> known as wrong.
> 
> Are you going to fix it? Otherwise I don't think it would not be good to
> use it easily as generic function like this.

Actually, it is hard to select.

I don't schedule to introduce complex timezone database into kernel,
but as you said, localtime() without timezone database is not complete.
But localtime_r is easy to use and understood, it is similar with
userspace same-name function...

>> +/*
>> + * Nonzero if YEAR is a leap year (every 4 years,
>> + * except every 100th isn't, and every 400th is).
>> + */
>> +static int __isleap(unsigned int year)
> 
> long year. This breaks negative time_t.
> 
>> +{
>> +	return (year) % 4 == 0 && ((year) % 100 != 0 || (year) % 400 == 0);
>> +}
> 
>> +/**
>> + * __offtime - converts the calendar time to local broken-down time
>> + *
>> + * @totalsecs	the number of seconds elapsed since 00:00:00 on January 1, 1970,
>> + *		Coordinated Universal Time (UTC).
>> + * @offset	offset seconds adding to totalsecs.
>> + * @result	pointer to struct tm variable to receive broken-down time
>> + *
>> + * Return a pointer to the broken-down time result on success,
>> + * and NULL on when the year does not fit into an integer.
>> + *
>> + * This function is for internal use, call gmtime_r() and localtime_r() instead.
>> + */ 
>> +struct tm *__offtime(__kernel_time_t totalsecs, int offset, struct tm *result)
>> +{
> 
> So, I suggest to consolidate this code only, and don't provide
> gmtime_r()/localtime_r(), and use more good function name for
> __offtime() (I'm not sure, however, personally I feel __offtime is not
> obvious what's doing).

What about just use gmtime_r(rename __offtime->gmtime_r)?

In fact I think both way(hode original localtime/gmtime or delete them) have
merit and demerit.
Hode them will make it easy to use, delete them will make function more exact.

Hi, Andrew
What is your opinion?

Thanks
Zhaolei

