Return-Path: <linux-kernel-owner+w=401wt.eu-S1758093AbZKXPYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758093AbZKXPYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758083AbZKXPYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:24:20 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:36705 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463AbZKXPYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:24:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=FF0pasXSjnusyil/qgLBhT4uVADLyOPAPu6yhFWAKzzB42kRLTWlpny/xzeKIrsU2J
         guiK6C50epA53OV7xIY2+mdO+YawzoTTJqdUdSCcWRy18pkuU1yOx3GopzKQVoLG4IKn
         4euexO5UbhtvPYGw85/hQfG/NslCxevNDFP7s=
MIME-Version: 1.0
In-Reply-To: <20091124143340.GA9595@redhat.com>
References: <200911241449.20715.czoccolo@gmail.com>
	 <20091124143340.GA9595@redhat.com>
Date: Tue, 24 Nov 2009 16:24:23 +0100
Message-ID: <4e5e476b0911240724x42346177t5d2335cf5171dd15@mail.gmail.com>
Subject: Re: [PATCH 3/4] cfq-iosched: idling on deep seeky sync queues
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
On Tue, Nov 24, 2009 at 3:33 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi Corrado,
>
> Thinking more about it. This clearing of flag when idle expires might
> create issues with queues which sent down requests with a burst initially
> forcing to set "deep" flag and then fall back to low depth. In that case,
> enable_idle will continue to be 1 and we will be driving queue depth as 1.
>
> This is a theoritical explanation looking at the patch. I don't know if
> in real life we have workloads who do this frequently. At least for my
> testing, this patch did make sure we don't switch between workload type
> of queue very frequently.
>
I thought at this scenario when developing the patch, but considered
it too infrequent (and not so costly) to justify the added complexity
of having a moving average.

For me, wasting an idle time is something to be punished for, while
driving the queue at lower depth is not, if the requests are coming
timely.

> May be keeping a track of average queue depth of a seeky process might
> help here like thinktime. If average queue depth is less over a period of
> time, we move the queue to sync-noidle group to achieve better throughput
> overall and if average queue depth is high, make is sync-idle.
>
> Currently we seem to be taking queue depth into account only for enabling
> the flag. We don't want too frequent switching of "deep" flag, so some
> kind of slow moving average might help.
>
Averages can still change in the middle of a slice.
A simpler way could be to reset the deep flag after a full slice, if
the depth never reached the threshold during that slice.

> Thanks
> Vivek
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
