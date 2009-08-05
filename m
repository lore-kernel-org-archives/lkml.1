Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbZHEURt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbZHEURt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 16:17:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZHEURs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 16:17:48 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62035 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbZHEURs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 16:17:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YvKkcJzVwAwr4GSEDAvjXsP15kvS9jcUlRB597Mvh0AjYuA+D5fN8vJc/72v3WE7Bm
         H4AmTuRi4uGn9aphY+0CHQ/m9UPX7tsHUuz+4kirxqWgNGbC8TRJrYcPQlJYGaFhoEsF
         O8O0Li4VSPKCNiCiFFBO3XV2ZHZ1rtB9gKJMw=
MIME-Version: 1.0
In-Reply-To: <200908052205.14222.rjw@sisk.pl>
References: <20090803163304.GF5002@laptop> <20090805093758.GE5854@laptop>
	 <200908052047.26293.rjw@sisk.pl> <200908052205.14222.rjw@sisk.pl>
Date: Wed, 5 Aug 2009 22:17:47 +0200
Message-ID: <74d0deb30908051317o61b31117t35aaf8b9f02710d7@mail.gmail.com>
Subject: Re: [PATCH] PM: Add convenience macro to make switching to dev_pm_ops 
	less error-prone
From: pHilipp Zabel <philipp.zabel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Albin Tonnerre <albin.tonnerre@free-electrons.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Daniel Mack <daniel@caiaq.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 5, 2009 at 10:05 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> On Wednesday 05 August 2009, Rafael J. Wysocki wrote:
>> On Wednesday 05 August 2009, Albin Tonnerre wrote:
>> > On Tue, Aug 04, 2009 at 09:55:33PM -0700, Dmitry Torokhov wrote :
>> > > On Tue, Aug 04, 2009 at 11:36:12AM +0200, Albin Tonnerre wrote:
>> > > > In a number of cases, the .suspend, .freeze, .poweroff and .resume,
>> > > > .thaw, .restore functions are identical. However, they all need to be
>> > > > assigned to avoid regressionsm as the previous code called .suspend
>> > > > resp. .resume in all those cases. SIMPLE_PM_OPS allows to deal with
>> > > > this case.
>> >
>> >
>> > > I'd much rather have conversions done with a bit more analysis now that
>> > > our framework is more flexible and we can have specialized routines for
>> > > hibernation and suspend.
>> >
>> > I still think that even though they can, quite a number of drivers won't
>> > /need/ to have different functions for this, but maybe I'm mistaken.
>> >
>> > > Maybe we should try changing from run-time to build time warning so that
>> > > users are not overly concerned with it?
>> >
>> > I'm not sure that solves the problem. The fact is that even for developers, it's
>> > easy to overlook that assiging only the .suspend and .resume fields is probably
>> > a mistake.
>>
>> I agree, so I'm going to take the patch.
>>
>> I'll add a comment describing what the macro is for, though.
>
> Strictly speaking, I'm going to add the appended patch to the linux-next
> branch of the suspend-2.6 tree.
>
> Thanks,
> Rafael
>
> ---
> From: Albin Tonnerre <albin.tonnerre@free-electrons.com>
> Subject: PM: Add convenience macro to make switching to dev_pm_ops less error-prone
>
> In a number of cases, the .suspend, .freeze, .poweroff and .resume,
> .thaw, .restore functions are identical. However, they all need to be
> assigned to avoid regressionsm as the previous code called .suspend
> resp. .resume in all those cases. SIMPLE_DEV_PM_OPS helps to deal
> with this case.
>
> [rjw: Changed the name of the macro and added the comment explaining its
>  purpose.]
>
> Signed-off-by: Albin Tonnerre <albin.tonnerre@free-electrons.com>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  include/linux/pm.h |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> Index: linux-2.6/include/linux/pm.h
> ===================================================================
> --- linux-2.6.orig/include/linux/pm.h
> +++ linux-2.6/include/linux/pm.h
> @@ -184,6 +184,20 @@ struct dev_pm_ops {
>        int (*restore_noirq)(struct device *dev);
>  };
>
> +/*
> + * Use this if you want to use the same suspend and resume callbacks for suspend
> + * to RAM and hibernation.
> + */
> +#define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
> +struct dev_pm_ops name = { \
> +       .suspend = suspend_fn, \
> +       .resume = resume_fn, \
> +       .freeze = suspend_fn, \
> +       .thaw = resume_fn, \
> +       .poweroff = suspend_fn, \
> +       .resume = resume_fn, \

I think that second .resume was intended to be .restore instead.

regards
Philipp
