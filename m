Return-Path: <linux-kernel-owner+w=401wt.eu-S1753596AbZAFCVs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbZAFCVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:21:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbZAFCVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:21:40 -0500
Received: from rn-out-0910.google.com ([64.233.170.189]:58169 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZAFCVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:21:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=k5r9VGrhllmTrVsLUY/8TqU4rEKqGGACvk4ieYjiz/yxTj23Hr2aQJbJ+2G2MEwMHU
         Cjtww8tnuyItO7KSfB2Va8S09ETp9EzfdoiOvjrs7okIjCGtWIcwQTm78Qq05C7bs6bC
         KDsxim1n6uxEQihBpNb2VdGqtvRvqA1Ta/5J4=
Message-ID: <1f1b08da0901051821q31a5c98akc5165aac36c6201e@mail.gmail.com>
Date: Mon, 5 Jan 2009 18:21:36 -0800
From: "john stultz-lkml" <johnstul.lkml@gmail.com>
To: "Chris Adams" <cmadams@hiwaay.net>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: "Linas Vepstas" <linasvepstas@gmail.com>, linux-kernel@vger.kernel.org,
       "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20090103002114.GA1538533@hiwaay.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	 <20090103002114.GA1538533@hiwaay.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 2, 2009 at 4:21 PM, Chris Adams <cmadams@hiwaay.net> wrote:
> Once upon a time, Linas Vepstas <linasvepstas@gmail.com> said:
>> Below follows a summary of the reported crashes. I'm ignoring the
>> zillions of "mine didn't crash" reports, or the "you're a paranoid
>> conspiracy theorist, its random chance" reports.
>
> I have reproduced this and got a stack trace (this is with Fedora 8 and
> kernel kernel-2.6.26.6-49.fc8.x86_64):
>
[snip]
> Basically (to my untrained eye), the leap second code is called from the
> timer interrupt handler, which holds xtime_lock.  The leap second code
> does a printk to notify about the leap second.  The printk code tries to
> wake up klogd (I assume to prioritize kernel messages), and (under some
> conditions), the scheduler attempts to get the current time, which tries
> to get xtime_lock => deadlock.

This analysis looks correct to me.

Grrrr. This has bit us a few times since the "no printk while holding
the xtime lock" restriction was added.

Thomas: Do you think this warrents adding a check to the printk path
to make sure the xtime lock isn't held? This way we can at least get a
warning when someone accidentally adds a printk or calls a function
that does while holding the xtime_lock.

thanks
-john
