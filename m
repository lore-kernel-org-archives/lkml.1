Return-Path: <linux-kernel-owner+w=401wt.eu-S1755215AbYFXUV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbYFXUV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 16:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753291AbYFXUVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 16:21:46 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:16995 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbYFXUVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 16:21:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UNpOQ98UyYRRbUbZS4toLY3e9234GBo7ABt6oJlAGk4AbGmDu8u3TetI4GUAXtmPEH
         nUkiSw8YaSFiD02yuTztd4MWADxJDvgvtZsQ+wJPLeaTTwN5byjW3+5Mq+bmi6jM2/nJ
         JLE29+GAf9TnrI53ZVIybbkGDDDp0EjnKZHxQ=
Message-ID: <86802c440806241321g6c5cd64eoe504d6029de6fe5a@mail.gmail.com>
Date: Tue, 24 Jun 2008 13:21:44 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Bernhard Walle" <bwalle@suse.de>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2/3] e820_update_range(): Allow specifying ULLONG_MAX
Cc: x86@kernel.org, vgoyal@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <86802c440806241301x4d124335h2888de9e915208ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214318125-32619-1-git-send-email-bwalle@suse.de>
	 <1214318125-32619-3-git-send-email-bwalle@suse.de>
	 <86802c440806241301x4d124335h2888de9e915208ae@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 1:01 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Tue, Jun 24, 2008 at 7:35 AM, Bernhard Walle <bwalle@suse.de> wrote:
>> Allow the specifying of ULLONG_MAX to limit the whole E820 map from the
>> specified start to the end. Without the patch, there would be integer
>> overflows.
>>
>>
>> Signed-off-by: Bernhard Walle <bwalle@suse.de>
>> ---
>>  arch/x86/kernel/e820.c |   11 +++++++++--
>>  1 files changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>> index e466073..7d1109b 100644
>> --- a/arch/x86/kernel/e820.c
>> +++ b/arch/x86/kernel/e820.c
>> @@ -397,6 +397,9 @@ int __init copy_e820_map(struct e820entry *biosmap, int nr_map)
>>        return __copy_e820_map(biosmap, nr_map);
>>  }
>>
>> +/*
>> + * Pass size == ULLONG_MAX to update until the end.
>> + */
>>  u64 __init e820_update_range(u64 start, u64 size, unsigned old_type,
>>                                unsigned new_type)
>>  {
>> @@ -412,14 +415,18 @@ u64 __init e820_update_range(u64 start, u64 size, unsigned old_type,
>>                        continue;
>>                /* totally covered? */
>>                if (ei->addr >= start &&
>> -                   (ei->addr + ei->size) <= (start + size)) {
>> +                   (((ei->addr + ei->size) <= (start + size)) ||
>> +                           (size == ULLONG_MAX))) {
>>                        ei->type = new_type;
>>                        real_updated_size += ei->size;
>>                        continue;
>>                }
>>                /* partially covered */
>>                final_start = max(start, ei->addr);
>> -               final_end = min(start + size, ei->addr + ei->size);
>> +               if (size == ULLONG_MAX)
>> +                       final_end = ei->addr + ei->size;
>> +               else
>> +                       final_end = min(start + size, ei->addr + ei->size);
>>                if (final_start >= final_end)
>>                        continue;
>>                ei->size -= final_end - final_start;
>> --
>
>
> it seems we should let the caller to use
> e820_update_range(start, ULLONG_MAX - size,....)
>
> so you don't need to touch this func.

or add sanitary check before using size in this func like
if (size > ULLONG_MAX - start)
     size = ULLONG_MAX - start;

e820_remove_range need to the same thing

YH
