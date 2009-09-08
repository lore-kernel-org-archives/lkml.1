Return-Path: <linux-kernel-owner+w=401wt.eu-S1751514AbZIHQXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbZIHQXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 12:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbZIHQXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 12:23:24 -0400
Received: from mail-iw0-f175.google.com ([209.85.223.175]:47456 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZIHQXX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 12:23:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=bB5D9d8lg+ugf3ufZ0KafzOmKgWkneIYxEAuIGBB10d3ra1iYO9DEOiwx+Kpd4O91N
         mSOiug/MpZCz3hZffCyZBt+EswEDKUO4JSD8tZMLGXi5WG2wyh9fnb1SRTaMF9j5Xxmy
         ZuTlCQUv66AKyXyAOcVvJPbrq3fIpRvXWLecw=
MIME-Version: 1.0
In-Reply-To: <1252426288.12145.112.camel@pc1117.cambridge.arm.com>
References: <1252111494-7593-1-git-send-email-lrodriguez@atheros.com> 
	<1252111494-7593-3-git-send-email-lrodriguez@atheros.com> 
	<1252426288.12145.112.camel@pc1117.cambridge.arm.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 8 Sep 2009 09:16:56 -0700
X-Google-Sender-Auth: 4ec500bdd6d0c2c3
Message-ID: <43e72e890909080916j159c5fadgda3f2c87aa3b965@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] kmemleak: add clear command support
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, penberg@cs.helsinki.fi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 8, 2009 at 9:11 AM, Catalin Marinas<catalin.marinas@arm.com> wrote:
> On Fri, 2009-09-04 at 17:44 -0700, Luis R. Rodriguez wrote:
>>  /*
>> + * We use grey instead of black to ensure we can do future
>> + * scans on the same objects. If we did not do future scans
>> + * these black objects could potentially contain references to
>> + * newly allocated objects in the future and we'd end up with
>> + * false positives.
>> + */
>> +static void kmemleak_clear(void)
>> +{
>> +     struct kmemleak_object *object;
>> +     unsigned long flags;
>> +
>> +     stop_scan_thread();
>> +
>> +     rcu_read_lock();
>> +     list_for_each_entry_rcu(object, &object_list, object_list) {
>> +             spin_lock_irqsave(&object->lock, flags);
>> +             if ((object->flags & OBJECT_REPORTED) &&
>> +                 unreferenced_object(object))
>> +                     object->min_count = -1;
>> +             spin_unlock_irqrestore(&object->lock, flags);
>> +     }
>> +     rcu_read_unlock();
>> +
>> +     start_scan_thread();
>> +}
>
> Do we need to stop and start the scanning thread here? When starting it,
> it will trigger a memory scan automatically. I don't think we want this
> as a side-effect, so I dropped these lines from your patch.

OK thanks.

> Also you set min_count to -1 here which means black object, so a
> subsequent patch corrects it. I'll set min_count to 0 here in case
> anyone bisects over it.

Dah, thanks for catching that, seems I only fixed the named set.

  Luis
