Return-Path: <linux-kernel-owner+w=401wt.eu-S1765837AbYETLFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765837AbYETLFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 07:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765625AbYETLFZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 07:05:25 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:43460 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765598AbYETLFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 07:05:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GqkChPsBOSZtQkQpYIH3PyHqGF0isw5DJOZ/nRz50gtrqGZR2W13ZHwcksnzjTomvx7IxE3J59NA8P0rHSQvHgaagDyINaJies2r9IHC9mDKRNT++W8cNpO8uFIZkSK3PApUdIiGcUurzAyrMt4w/ZnS7KZhrFksxMEAyn3lPz8=
Message-ID: <a8e1da0805200405t10fae448w589449e75a5abec6@mail.gmail.com>
Date: Tue, 20 May 2008 19:05:21 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3][-mm] add class_reclassify macro
Cc: greg@kroah.com, matthew@wil.cx, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20080520030232.fc91b64e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080520095553.GA3201@darkstar.te-china.tietoenator.com>
	 <20080520030232.fc91b64e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 6:02 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 20 May 2008 17:55:54 +0800 Dave Young <hidave.darkstar@gmail.com> wrote:
>
>> Converting class semaphore to mutex cause lockdep warnings due to
>> class_interface_register/unregister will possible call device_add/del
>
> Shouldn't we just fix that?

Andrew, could you tell more?

>
>> For the class_interface users here add a class_reclassify macro to
>> reclassify the lock class of their struct class.
>>
>> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>>
>> ---
>> include/linux/device.h |    7 +++++++
>> 1 file changed, 7 insertions(+)
>>
>> --- linux/include/linux/device.h      2008-05-19 12:29:54.000000000 +0800
>> +++ linux.new/include/linux/device.h  2008-05-19 14:42:25.000000000 +0800
>> @@ -529,4 +529,11 @@ extern const char *dev_driver_string(str
>>       MODULE_ALIAS("char-major-" __stringify(major) "-" __stringify(minor))
>>  #define MODULE_ALIAS_CHARDEV_MAJOR(major) \
>>       MODULE_ALIAS("char-major-" __stringify(major) "-*")
>> +
>> +#define class_reclassify(class)                                              \
>> +do {                                                                 \
>> +     static struct lock_class_key    class_key;                      \
>> +     lockdep_set_class_and_name(&(class)->mutex, &class_key,         \
>> +                              (class)->name);                        \
>> +} while (0)
>>  #endif /* _DEVICE_H_ */
>
> I think it would need a lavish comment explaining what it is for, and
> the reasons for its existence.

Yes, will do.

>
> Perhaps this should be a kernel-wide thing in lockdep.h.  But then that
> would invite people to use it, and it looks like a bad thing.

I agree.
There's wellmeant lockdep warnings for some safe code logic every some time.
Yes, this macro violates the lockdep class-based rules, but it can act
as just supplementary. And it could help some users.

>
> device.h does not include lockdep.h, so putting this here assumes that
> callees have already included lockdep.h.  This is the sort of
> assumption which leads to compilation errors.
>
My wrong, thanks.

Regards
dave
