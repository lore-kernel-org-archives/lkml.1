Return-Path: <linux-kernel-owner+w=401wt.eu-S1758895AbXLSCat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895AbXLSCat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 21:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbXLSCak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 21:30:40 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:34873 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743AbXLSCaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 21:30:39 -0500
Date: Tue, 18 Dec 2007 20:29:34 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [RFC/PATCH] 2.6.24-rcx: Make sys_poll() wait at least timeout ms
In-reply-to: <200712190206.56428.fzu@wemgehoertderstaat.de>
To: Karsten Wiese <fzu@wemgehoertderstaat.de>
Cc: linux-kernel@vger.kernel.org
Message-id: <4768820E.9050700@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.QbT8/KZb1MTA5+n7SD6kFi6mqso@ifi.uio.no>
 <47685F4B.8000207@shaw.ca> <200712190206.56428.fzu@wemgehoertderstaat.de>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karsten Wiese wrote:
> Am Mittwoch, 19. Dezember 2007 schrieb Robert Hancock:
>> That seems fishy. What is your value of HZ and what is the timeout value 
>> that was passed in the bad case?
> 
> HZ set to 250, timeout to 4ms.
> Time spent in poll() taken by clock_gettime(CLOCK_MONOTONIC, &time)
> before and after poll()call: i.e 62us.
> Time measured with hpet gave 166us once.

msecs_to_jiffies (kernel/time.c) has this:

#if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
	/*
	 * HZ is equal to or smaller than 1000, and 1000 is a nice
	 * round multiple of HZ, divide with the factor between them,
	 * but round upwards:
	 */
	return (m + (MSEC_PER_SEC / HZ) - 1) / (MSEC_PER_SEC / HZ);

With HZ=250 and m=4 this gives 7/4 or only 1 jiffy, which is not more 
than 4ms, but if we are already at near the end of the current jiffy it 
could be much less than that (potentially almost no time at all).

Maybe we could convert poll to use a hrtimer for this instead?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/
