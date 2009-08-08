Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbZHHG4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbZHHG4X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 02:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZHHG4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 02:56:23 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59584 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbZHHG4W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 02:56:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FdUom0DBxlxhjjfOHflJcUhyfRVtBZKueFCacaqvP1K1W6Ywg2DjpuldESaXOWWPOc
         JtmdL8ASzLNv8BmeCSS0aYsRGn67zLstEk+N+398TiP2YYfaqEKUoXjpqbha0Szjszks
         glUGm+dUWQ68e9dJWnR8+INPr7ZyVhBAb5y0U=
MIME-Version: 1.0
In-Reply-To: <87y6pvi5qp.fsf@devron.myhome.or.jp>
References: <4A7CAF28.8020908@gmail.com> <87y6pvi5qp.fsf@devron.myhome.or.jp>
Date: Sat, 8 Aug 2009 09:56:21 +0300
X-Google-Sender-Auth: ac99648244d0ee76
Message-ID: <84144f020908072356r5cc3100dp79a6a508bafec7c7@mail.gmail.com>
Subject: Re: [PATCH] fat: Read buffer overflow
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Roel Kluin <roel.kluin@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hirofumi-san,

Roel Kluin <roel.kluin@gmail.com> writes:
>> If len is less or equal to 0, this results in a read of s[-1].
>>
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> ---
>> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
>> index 6f27853..114ff6d 100644
>> --- a/fs/fat/namei_vfat.c
>> +++ b/fs/fat/namei_vfat.c
>> @@ -202,6 +202,9 @@ static inline int vfat_is_used_badchars(const wchar_t *s, int len)
>>  {
>>       int i;
>>
>> +     if (len <= 0)
>> +             return -EINVAL;
>> +
>>       for (i = 0; i < len; i++)
>>               if (vfat_bad_char(s[i]))
>>                       return -EINVAL;

On Sat, Aug 8, 2009 at 2:06 AM, OGAWA
Hirofumi<hirofumi@mail.parknet.co.jp> wrote:
> Um..., what case is this possible? vfat_add_entry() checks (len == 0).
> And if xlate_to_uni() couldn't convert name, it should return the error.

Yes, but we pass "ulen" to vfat_is_used_badchars(). The value of
"ulen" is a returned in the "longlen" argument of xlate_to_uni() which
in turn is calculated as follows for the UTF-8 case:

  int name_len = strlen(name);
  *outlen = utf8s_to_utf16s(name, PATH_MAX, (wchar_t *) outname);
  *outlen -= (name_len - len);
  *longlen = *outlen;

Maybe "*outlen" can never be negative because of some invariants that
I don't see but it's so non-obvious to me that I'd like to see the
explicit check in vfat_is_used_badchars().

                        Pekka
