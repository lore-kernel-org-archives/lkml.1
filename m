Return-Path: <linux-kernel-owner+w=401wt.eu-S1752796AbZAPFFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796AbZAPFFe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 00:05:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbZAPFFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 00:05:23 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:54860 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbZAPFFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 00:05:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references:x-google-sender-auth;
        b=VCf/+c7yK0V6D0oDLwZZnY2U0tlDQeSwDOZU38U8Na4iE3UwS7YDi9YrOKM97+jcna
         adKittBOenXU3ItxaTcPOorDShpKC4VAASl2PYJDWuPMBRXGR6lDP1k+nrkhS8CZTiIi
         YPwF08bZMKZGqu3jGzApaRS5LFRFr8kGvBTYE=
Message-ID: <2accc2ff0901152105g7223c1c4xd993950453d3b2f3@mail.gmail.com>
Date: Fri, 16 Jan 2009 00:05:20 -0500
From: "Nelson Castillo" <arhuaco@freaks-unidos.net>
Reply-To: arhuaco@freaks-unidos.net
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] Add touchscreen filter API
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       andy@openmoko.com
In-Reply-To: <20090115154716.63de462f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090113233743.26361.14313.stgit@fugue.noexisteestedominiotanlargo.biz>
	 <20090113233939.26361.18138.stgit@fugue.noexisteestedominiotanlargo.biz>
	 <20090115154716.63de462f.akpm@linux-foundation.org>
X-Google-Sender-Auth: 04a8b9ed22aa6247
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 6:47 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 13 Jan 2009 18:39:39 -0500
> Nelson <arhuaco@freaks-unidos.net> wrote:
>
>> From: Nelson Castillo <arhuaco@freaks-unidos.net>
>>
>> Generic filters are not useful by themselves. They define an API that
>> actual filters have to implement.
>>
>> Signed-off-by: Nelson Castillo <arhuaco@freaks-unidos.net>
>> ---

(cut)

>> +int ts_filter_create_chain(struct platform_device *pdev,
>> +                        struct ts_filter_api **api, void **config,
>> +                        struct ts_filter **list, int count_coords)
>> +{
>> +     int count = 0;
>> +     struct ts_filter *last = NULL;
>> +
>> +     if (!api)
>> +             return 0;
>> +
>> +     while (*api && count < MAX_TS_FILTER_CHAIN) {
>
>Why does MAX_TS_FILTER_CHAIN exist?  Why impose limits?

"api" is actually a static array that is not zero_terminated by
convention. It can be zero-terminated, though. This check avoids
overrunning the loop if MAX_TS_FILTER_CHAIN filters are used.

This snippet is taken from mach-gta02.c (link below) and
"filter_sequence" is what
we pass as the "api" array.

static struct s3c2410_ts_mach_info gta02_ts_cfg = {
        .delay = 10000,
        .presc = 0xff, /* slow as we can go */
        .filter_sequence = {
                [0] = &ts_filter_group_api,
                [1] = &ts_filter_median_api,
                [2] = &ts_filter_mean_api,
                [3] = &ts_filter_linear_api,
        },
        .filter_config = {
                [0] = &gta02_ts_group_config,
                [1] = &gta02_ts_median_config,
                [2] = &gta02_ts_mean_config,
                [3] = &gta02_ts_linear_config,
        },
};

>> diff --git a/drivers/input/touchscreen/ts_filter.c b/drivers/input/touchscreen/ts_filter.c
>> new file mode 100644
>> index 0000000..1508388
>> --- /dev/null
>> +++ b/drivers/input/touchscreen/ts_filter.c
>
> Confused.  Nothing appears to use the two functions which this file adds.

http://git.openmoko.org/?p=kernel.git;a=shortlog;h=stable-tracking

This branch is tracking the upstream Linux kernel and patches are
rebased/updated
when things change upstream. Openmoko has been doing this since one
goal is to be able to use upstream kernels with no patches for OM
devices.

This is the driver can use the filters (s3c2410_ts.c) if they are
defined in the machine configuration:

http://git.openmoko.org/?p=kernel.git;a=blob_plain;f=drivers/input/touchscreen/s3c2410_ts.c;hb=stable-tracking

We are ready to send this driver upstream but before we need to trim
this file (mach-gta02.c) and send it:

http://git.openmoko.org/?p=kernel.git;a=blob_plain;f=arch/arm/mach-s3c2440/mach-gta02.c;hb=stable-tracking

We are depending on this mach-gta02.c file now and a streamlined
version of it must be sent upstream so that we can start adding
drivers. This file in turn depends on patches that are being sent
upstream also.

Thus we have a chicken and egg problem and we decided to send the
filters for review because they are in the stable-tracking branch and
they need to be suitable for upstream inclusion / included upstream.

>> @@ -0,0 +1,64 @@
(cut)
>> +void ts_filter_destroy_chain(struct platform_device *pdev,
>> +                          struct ts_filter **list)
>> +{
>> +     struct ts_filter **first;
>> +     int count = 0;
>> +
>> +     first = list;
>> +     while (*list && count++ < MAX_TS_FILTER_CHAIN) {
>> +             ((*list)->api->destroy)(pdev, *list);
>> +             list++;
>
> This is wrong, isn't it?  It's treating the list as an array.  Should
> advance to list->next.

It is actually an array. This name is misleading, we will change it.

struct ts_filter *tsf[MAX_TS_FILTER_CHAIN];

Defined here (s3c2410_ts.c : 113).

http://git.openmoko.org/?p=kernel.git;a=blob_plain;f=drivers/input/touchscreen/s3c2410_ts.c;hb=stable-tracking

>> +     }
>> +     *first = NULL;
>> +}
>> +EXPORT_SYMBOL_GPL(ts_filter_destroy_chain);
>
> The list should be proected by a lock to prevent corruption.  A single
> mutex which is static to this file should suffice.

Ok.

>> diff --git a/include/linux/ts_filter.h b/include/linux/ts_filter.h
>> new file mode 100644
>> index 0000000..1671044
>> --- /dev/null
>> +++ b/include/linux/ts_filter.h
>
> I think it would be better to put all the header files from this
> patchset into drivers/input/touchscreen/

Ok.

I will a little before resubmitting.

Thanks for your comments.
