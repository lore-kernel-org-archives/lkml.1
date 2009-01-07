Return-Path: <linux-kernel-owner+w=401wt.eu-S1757021AbZAGJql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757021AbZAGJql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 04:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbZAGJqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 04:46:33 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:43304 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391AbZAGJqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 04:46:32 -0500
Message-ID: <496479EA.1020207@davidnewall.com>
Date: Wed, 07 Jan 2009 20:16:18 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Nick Andrew <nick@nick-andrew.net>, Linas Vepstas <linasvepstas@gmail.com>,
       david@lang.hm, Kyle Moffett <kyle@moffetthome.net>,
       Ben Goodger <goodgerster@gmail.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       Travis Crump <pretzalz@techhouse.org>, burdell@iruntheinter.net
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
References: <496076A9.7030907@davidnewall.com>	<f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>	<4960897D.5030603@davidnewall.com>	<alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>	<4961432A.80509@davidnewall.com>	<alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>	<49614835.7000505@davidnewall.com>	<3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>	<20090105143335.GC18055@mail.local.tull.net>	<4962BB13.7060304@davidnewall.com>	<20090106025125.GB28431@mail.local.tull.net> <20090106094058.64c89586@lxorguk.ukuu.org.uk>
In-Reply-To: <20090106094058.64c89586@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>        UTC  equivalent  to  conversion  on  the naive basis that leap seconds are ignored and all
>>        years divisible by 4 are leap years.  This value is not the same as the actual  number  of
>>        seconds between the time and the Epoch, because of leap seconds and because clocks are not
>>        required to be synchronized to a standard reference.
>>     
>
> I'm not sure what you are quoting from but it is out of date on the
> subject of leap years.
>   

The range of signed 32-bit times is 1901 through 2039, which has only
one century, 2000, which is a leap year.  So the caveat for leap years
is correct but unnecessary.


So I've discoverd, at least on Ubuntu, something wonderful and
reassuring.  It already works exactly the way I think is correct.  Look:
I create a test timezone with no daylight saving and one leap second:

    davidn@takauji:~/timetest$ cat tz
    Zone testzone 0:00 0 XXX/YYY
    davidn@takauji:~/timetest$ cat leapseconds
    Leap 2008 Dec 31 23:59:59 + S
    davidn@takauji:~/timetest$ zic -d . -L leapseconds tz

Then the test program, which makes a time_t (what time() returns) for a
few seconds before the leap second, then counts off seconds...

    davidn@takauji:~/timetest$ cat timetest.c
    #include <time.h>
    #include <stdio.h>

    main() {

            setenv("TZ", ":/home/davidn/timetest/testzone", 1);

            struct tm tm1 = { 55, 59, 23, 31, 11, 108 };
            time_t t1 = mktime(&tm1);
            int i;
            for (i = 10; --i; t1++) printf("ctime(%ld) = %s", t1, ctime(&t1));

            return 0;
      

    }


Observe two 23:59:59's.  Apparently it could be better if the second
23:59:59 was 23:59:60, but I prefer it this way.

    davidn@takauji:~/timetest$ ./timetest
    ctime(1230767995) = Wed Dec 31 23:59:55 2008
    ctime(1230767996) = Wed Dec 31 23:59:56 2008
    ctime(1230767997) = Wed Dec 31 23:59:57 2008
    ctime(1230767998) = Wed Dec 31 23:59:58 2008
    ctime(1230767999) = Wed Dec 31 23:59:59 2008
    ctime(1230768000) = Wed Dec 31 23:59:59 2008
    ctime(1230768001) = Thu Jan 1 00:00:00 2009
    ctime(1230768002) = Thu Jan 1 00:00:01 2009
    ctime(1230768003) = Thu Jan 1 00:00:02 2009


Perhaps this is distribution-dependent, but even so, there's no need for
the kernel to drop the second (and it's wrong if it does.)
