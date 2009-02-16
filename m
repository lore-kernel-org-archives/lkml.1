Return-Path: <linux-kernel-owner+w=401wt.eu-S1757150AbZBPIMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbZBPIMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 03:12:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbZBPIMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 03:12:24 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:59971 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbZBPIMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 03:12:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i3341ZsmGux1hUfmGA1MmoLs0SrjWem+GrDrwS+tbd1nvSIhAqzf7xs2hXNniju3yZ
         eTBXFn6e6dc4IcgyxhtJ21zpR/ZlXSoYqZveKCHKIS+pMeB9ZZXzqqW79tLyWLW5Ipgw
         J3S28Kl7uBZiJ+OXxxg2ZTyjph+2OS2PZrKbY=
MIME-Version: 1.0
In-Reply-To: <20090216072711.GJ30821@kernel.dk>
References: <8f53421d0902151605v56c92642ib8c2dcf34fd92ad1@mail.gmail.com>
	 <8f53421d0902151607w2985dce6yc1bef7e717166fc@mail.gmail.com>
	 <20090216072711.GJ30821@kernel.dk>
Date: Mon, 16 Feb 2009 10:12:21 +0200
Message-ID: <8f53421d0902160012y219b4737u37f3cfb0913b228f@mail.gmail.com>
Subject: Re: [Bug 12713] Hang on resume from hibernation, apparently as result 
	of 213d9417fec
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: pavel@suse.cz, rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 9:27 AM, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Mon, Feb 16 2009, Michael S. Tsirkin wrote:
>> On Mon, Feb 16, 2009 at 2:05 AM, Michael S. Tsirkin
>> <m.s.tsirkin@gmail.com> wrote:
>> > Summary: seem to need to revert 213d9417fec62ef4c3675621b9364a667954d4dd
>> > to fix resume from hibernation. Bugzilla entry created:
>> > http://bugzilla.kernel.org/show_bug.cgi?id=12713
>>
>> Looking over this, I see something strange in the commit in question:
>>
>> diff --git a/include/linux/bio.h b/include/linux/bio.h
>> index 5175aa3..f53568c 100644
>> --- a/include/linux/bio.h
>> +++ b/include/linux/bio.h
>> @@ -163,12 +163,15 @@ struct bio {
>>  #define BIO_RW         0       /* Must match RW in req flags (blkdev.h) */
>>  #define BIO_RW_AHEAD   1       /* Must match FAILFAST in req flags */
>>  #define BIO_RW_BARRIER 2
>> -#define BIO_RW_SYNC    3
>> -#define BIO_RW_META    4
>> -#define BIO_RW_DISCARD 5
>> -#define BIO_RW_FAILFAST_DEV            6
>> -#define BIO_RW_FAILFAST_TRANSPORT      7
>> -#define BIO_RW_FAILFAST_DRIVER         8
>> +#define BIO_RW_SYNCIO  3
>> +#define BIO_RW_UNPLUG  4
>> +#define BIO_RW_META    5
>> +#define BIO_RW_DISCARD 6
>> +#define BIO_RW_FAILFAST_DEV            7
>> +#define BIO_RW_FAILFAST_TRANSPORT      8
>> +#define BIO_RW_FAILFAST_DRIVER         9
>> +
>> +#define BIO_RW_SYNC    (BIO_RW_SYNCIO | BIO_RW_UNPLUG)
>>
>>  /*
>>   * upper 16 bits of bi_rw define the io priority of this bio
>>
>> I haven't read the code in depth, but taking running numbers and doing
>> bitwise "or"
>> on them looks a bit strange to me.
>> So here BIO_RW_SYNC is (3 | 4) = 7, that is the same as BIO_RW_FAILFAST_DEV.
>> So for example bio_failfast_dev and bio_sync are the same.
>>
>> Jens, could you comment on this please? Is this intentional?
>
> That's clearly a braino, you can't OR the shift values of course. I'll
> get it fixed up asap!

Cool, send me a patch, I'll test.

> --
> Jens Axboe
>
>
