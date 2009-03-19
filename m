Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbZCSD0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbZCSD0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 23:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbZCSDZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 23:25:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:37141 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbZCSDZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 23:25:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=r2IO4x/WL8X9Li5jfy9XOaTDa3y2yfmZjE90YXpJFXszusA12jvVlYYJWRVqKwfgPS
         2Aevq7V9rowX9xkYikhK3CNLMTmFOqk/ddgAhGRa0E6xWEbByYTcNKmX26WMiEre6N9/
         HAoSqyNvzcNcU3DlWV/oHl/eJQyzG2zImUPuE=
MIME-Version: 1.0
In-Reply-To: <b6a2187b0903181958ke11abe7tdcbc4efeb950954d@mail.gmail.com>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera>
	 <b6a2187b0903141958u9dae0fdk1f44b387108b99e4@mail.gmail.com>
	 <b6a2187b0903142006u546fad9eme66f9ea7b464b81f@mail.gmail.com>
	 <1237140665.24621.2.camel@johannes.local>
	 <alpine.LFD.2.00.0903151136310.3131@localhost.localdomain>
	 <1237143683.24621.7.camel@johannes.local>
	 <20090315202603.GA9077@elte.hu>
	 <b6a2187b0903160624gb9d207dv301506e589d93ed4@mail.gmail.com>
	 <1237317742.31814.28.camel@johannes.local>
	 <b6a2187b0903181958ke11abe7tdcbc4efeb950954d@mail.gmail.com>
Date: Thu, 19 Mar 2009 11:25:44 +0800
Message-ID: <b6a2187b0903182025y5552900cu6213a4f4eafeb6e6@mail.gmail.com>
Subject: Re: 2.6.29-rc8: Reported regressions from 2.6.28
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 10:58 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
> I've tracked down to the sequence of iwconfig that causes it to fail.

> This loop only works 8 of 10 times with/without the patch.
>        iwconfig wlan0 mode Managed essid xxx key restricted xxx
>        iwconfig wlan0 ap auto channel auto  # auto outside loop
>        for((i = 0; i < 5; i++))
>        do
>                iwconfig wlan0 | grep -q "Not-Associated"
>                [ $? -ne 0 ] && break
>                echo ".\c"
>                sleep 1
>        done


I've modified it a little, and now it works 100% without patch, by
using "iwlist scan" instead of "sleep 1" ...
        iwconfig wlan0 mode Managed essid xxx key restricted xxx
        iwconfig wlan0 ap auto channel auto  # auto outside loop
        for((i = 0; i < 5; i++))
        do
                iwlist wlan0 scan >/dev/null  #use scan instead of sleep
                iwconfig $DEV | grep -q "Access Point: Not-Associated"
                [ $? -ne 0 ] && break
                echo ".\c"
        done


So, this will work for older kernel and well as 2.6.29-rc8.

Rafael, can we close the case? It's the iwconfig sequence that used to
work on 2.6.28-rc3 but now needs to be updated for 2.6.29-rc8.

Thanks,
Jeff.
