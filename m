Return-Path: <linux-kernel-owner+w=401wt.eu-S934568AbZAPN3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934568AbZAPN3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 08:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762468AbZAPN3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 08:29:03 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:61070 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762119AbZAPN3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 08:29:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references:x-google-sender-auth;
        b=GXbC8Y1MU/6jnYiiFyYrPFLF5c2Dpbu2YYuU63M2/HNvUcoVy+yHOd5Xf8MurTywXo
         AmTrWv9TUTVAZM8i040r7mZtW7sYSIdqzUxwlHzrP+xaqsRsemDJnyhKPRtLTBqce5PU
         P+ZessWSIdjXLyh3TKRI6jaTB9njcYURBbXFM=
Message-ID: <2accc2ff0901160528m31effcc9rc49418b4c826caf6@mail.gmail.com>
Date: Fri, 16 Jan 2009 08:28:58 -0500
From: "Nelson Castillo" <arhuaco@freaks-unidos.net>
Reply-To: arhuaco@freaks-unidos.net
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] Add touchscreen filter API
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
       andy@openmoko.com
In-Reply-To: <20090115225532.8491d671.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090113233743.26361.14313.stgit@fugue.noexisteestedominiotanlargo.biz>
	 <20090113233939.26361.18138.stgit@fugue.noexisteestedominiotanlargo.biz>
	 <20090115154716.63de462f.akpm@linux-foundation.org>
	 <2accc2ff0901152105g7223c1c4xd993950453d3b2f3@mail.gmail.com>
	 <20090115225532.8491d671.akpm@linux-foundation.org>
X-Google-Sender-Auth: 96e460eadecbea8a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2009 at 1:55 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 16 Jan 2009 00:05:20 -0500 "Nelson Castillo" <arhuaco@freaks-unidos.net> wrote:
>
>> On Thu, Jan 15, 2009 at 6:47 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> > On Tue, 13 Jan 2009 18:39:39 -0500
>> > Nelson <arhuaco@freaks-unidos.net> wrote:
>> >
>> >> From: Nelson Castillo <arhuaco@freaks-unidos.net>
>> >>
>> >> Generic filters are not useful by themselves. They define an API that
>> >> actual filters have to implement.
>> >>
>> >> Signed-off-by: Nelson Castillo <arhuaco@freaks-unidos.net>
>> >> ---
>>
>> (cut)
>>
>> >> +int ts_filter_create_chain(struct platform_device *pdev,
>> >> +                        struct ts_filter_api **api, void **config,
>> >> +                        struct ts_filter **list, int count_coords)
>> >> +{
>> >> +     int count = 0;
>> >> +     struct ts_filter *last = NULL;
>> >> +
>> >> +     if (!api)
>> >> +             return 0;
>> >> +
>> >> +     while (*api && count < MAX_TS_FILTER_CHAIN) {
>> >
>> >Why does MAX_TS_FILTER_CHAIN exist?  Why impose limits?
>>
>> "api" is actually a static array that is not zero_terminated by
>> convention. It can be zero-terminated, though. This check avoids
>> overrunning the loop if MAX_TS_FILTER_CHAIN filters are used.
>>
>> This snippet is taken from mach-gta02.c (link below) and
>> "filter_sequence" is what
>> we pass as the "api" array.
>>
>> static struct s3c2410_ts_mach_info gta02_ts_cfg = {
>>         .delay = 10000,
>>         .presc = 0xff, /* slow as we can go */
>>         .filter_sequence = {
>>                 [0] = &ts_filter_group_api,
>>                 [1] = &ts_filter_median_api,
>>                 [2] = &ts_filter_mean_api,
>>                 [3] = &ts_filter_linear_api,
>>         },
>>         .filter_config = {
>>                 [0] = &gta02_ts_group_config,
>>                 [1] = &gta02_ts_median_config,
>>                 [2] = &gta02_ts_mean_config,
>>                 [3] = &gta02_ts_linear_config,
>>         },
>> };
>
> so...  change the interface to require that the array be
> null-terminated, then fix callers.
>
> Null-terminating variable-length arrays in this manner is a quite
> common paradigm in the kernel.

Sure. We will change it.

>> >> diff --git a/drivers/input/touchscreen/ts_filter.c b/drivers/input/touchscreen/ts_filter.c
>> >> new file mode 100644
>> >> index 0000000..1508388
>> >> --- /dev/null
>> >> +++ b/drivers/input/touchscreen/ts_filter.c
>> >
>> > Confused.  Nothing appears to use the two functions which this file adds.
>>
>> http://git.openmoko.org/?p=kernel.git;a=shortlog;h=stable-tracking
>>
>> This branch is tracking the upstream Linux kernel and patches are
>> rebased/updated
>> when things change upstream. Openmoko has been doing this since one
>> goal is to be able to use upstream kernels with no patches for OM
>> devices.
>>
>> This is the driver can use the filters (s3c2410_ts.c) if they are
>> defined in the machine configuration:
>>
>> http://git.openmoko.org/?p=kernel.git;a=blob_plain;f=drivers/input/touchscreen/s3c2410_ts.c;hb=stable-tracking
>>
>> We are ready to send this driver upstream but before we need to trim
>> this file (mach-gta02.c) and send it:
>>
>> http://git.openmoko.org/?p=kernel.git;a=blob_plain;f=arch/arm/mach-s3c2440/mach-gta02.c;hb=stable-tracking
>>
>> We are depending on this mach-gta02.c file now and a streamlined
>> version of it must be sent upstream so that we can start adding
>> drivers. This file in turn depends on patches that are being sent
>> upstream also.
>>
>> Thus we have a chicken and egg problem and we decided to send the
>> filters for review because they are in the stable-tracking branch and
>> they need to be suitable for upstream inclusion / included upstream.
>
> Please hold off on the unused code until some code which actually uses
> is is submitted as well.

Sure, thanks for the review.
