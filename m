Return-Path: <linux-kernel-owner+w=401wt.eu-S1758455AbZDIIWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758455AbZDIIWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 04:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758116AbZDIIWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 04:22:10 -0400
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:48233 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757980AbZDIIWH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 04:22:07 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-05.arcor-online.net 55005332ACD
Message-ID: <21685897.1239265325322.JavaMail.ngmail@webmail14.arcor-online.net>
Date: Thu, 9 Apr 2009 10:22:05 +0200 (CEST)
From: "M. Koehrer" <mathias_koehrer@arcor.de>
To: linux-kernel@vger.kernel.org
Subject: Issue with clock_nanosleep(), TIMER_ABSTIME and
 CONFIG_CC_OPTIMIZE_FOR_SIZE not set
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-ngMessageSubType: MessageSubType_MAIL
X-WebmailclientIP: 213.68.15.100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!
I am using kernel 2.6.29.1 from kernel.org on a Debian 5.0 (Lenny) system (Intel Core2Quad).
GCC is 4.3.2
I have not set CONFIG_CC_OPT_SIZE.

When I use clock_nanosleep with TIMER_ABSTIME with gdb and stop the execution by CTRL-C,
I cannot continue the execution of my program when it interrupted the clock_nanosleep call.

When I set the kernel config parameter CONFIG_CC_OPT_SIZE everything is fine.
There seems to be an optimization issue that is related to the clock_nanosleep system call.

Some more remarks:
When I use relative times (mode set to 0) everything works fine in both cases.
CONFIG_TICK_ONESHOT=y
CONFIG_HIGH_RES_TIMERS=y


Here is my tiny test program that demonstrates the behaviour:
Let it run in gdb, interrupt it (CTRL-C) and try to continue "c".

***************** BEGIN ************************
#define _GNU_SOURCE
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <sys/syscall.h>
#include <linux/unistd.h>

const clockid_t CLOCK_TO_USE=CLOCK_MONOTONIC;
static int clock_nanosleep2(clockid_t clock_id, int flags, const struct timespec *req,
                struct timespec *rem)
{
    return syscall(__NR_clock_nanosleep, clock_id, flags, req, rem);
}

int main(void)
{
    int i;
    struct timespec ts;
    clock_gettime(CLOCK_TO_USE, &ts);

    for (i=0; i<=1000; i++)
    {
        ts.tv_sec++;
        clock_nanosleep2(CLOCK_TO_USE, TIMER_ABSTIME, &ts, NULL);
        // clock_nanosleep(CLOCK_TO_USE, TIMER_ABSTIME, &ts, NULL);
        printf("%i\n",i);
    }

    return 0;
}

/* Build with
   gcc test_clock_nanosleep.c -g -Wall -lrt
*/
**************** END *******************

Thanks for all feedback on that issue

Regards

Mathias

-- 
Mathias Koehrer
mathias_koehrer@arcor.de


Zerreißen Sie die Netze der Phisher, Hacker und Betrüger!
Ihre Internet-Sicherheits-Seiten auf Arcor.de bieten alle Infos und Hilfsmittel, die Sie zum sicheren Surfen brauchen! Play it safe!
http://www.arcor.de/footer-sicherheit/
