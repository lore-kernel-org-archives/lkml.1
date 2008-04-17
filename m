Return-Path: <linux-kernel-owner+w=401wt.eu-S933034AbYDQRcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbYDQRcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763781AbYDQRb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:31:57 -0400
Received: from rv-out-0708.google.com ([209.85.198.248]:37617 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751795AbYDQRb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=E9fk0Q7AbTEfoC8v4oJILS6ITvhWNOiPFyhV360KKLo6SQhXrhLHB5Lz4DqTVnqCAzoQzjtoY6IQaSxIdoDYIiI9eupx0kWX+ApSkxW3lUxyD79p/1+vlHDprljBvBo7L4MR5N/+hLuqIDKnlVLP/lxzjgsgGJCbpuqAiOqc+28=
Message-ID: <a72f6a3c0804171031qbba17d6pb470119d5f2ff010@mail.gmail.com>
Date: Thu, 17 Apr 2008 18:31:56 +0100
From: "Jack Harvard" <jack.harvard@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: gettimeofday() in 2.6.24
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I was trying to figure out how gettimeofday() measures time in
2.6.24-arm2, in which a free-running timer is added to improve the
resolution of gettimeofday() from 10ms to us, I can trace down to
do_gettimeofday() as follows:

http://lxr.linux.no/linux+v2.6.24/arch/arm/kernel/time.c#L240
 239#ifndef CONFIG_GENERIC_TIME
 240void do_gettimeofday(struct timeval *tv)
 241{
 242        unsigned long flags;
 243        unsigned long seq;
 244        unsigned long usec, sec;
 245
 246        do {
 247                seq = read_seqbegin_irqsave(&xtime_lock, flags);
 248                usec = system_timer->offset();
 249                sec = xtime.tv_sec;
 250                usec += xtime.tv_nsec / 1000;
 251        } while (read_seqretry_irqrestore(&xtime_lock, seq, flags));
 252
 253        /* usec may have gone up a lot: be safe */
 254        while (usec >= 1000000) {
 255                usec -= 1000000;
 256                sec++;
 257        }
 258
 259        tv->tv_sec = sec;
 260        tv->tv_usec = usec;
 261}
 262
 263EXPORT_SYMBOL(do_gettimeofday);

but I haven't quite figured out how gettimeofday() actually gets time
from this added timer, also how xtime is updated?

Thanks, Jack
