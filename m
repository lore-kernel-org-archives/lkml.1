Return-Path: <linux-kernel-owner+w=401wt.eu-S1752561AbZL0RPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbZL0RPF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 12:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752402AbZL0RPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 12:15:01 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:34857 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbZL0RPB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 12:15:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iX9u5oCAAQkci/Sa9lgZ1jSUByPsIJkciPrZq69bQojFhGjLQ2eSGqv9D+T/TAgNni
         bU2sFjqhbXM7vMuR0PT99GolY0X0EbK0ID2QiB+essY2g1Zk47IrjX4LNriACDBA2wHn
         seaibUbDxQVdgFPxV5Hw7UVknPn5HS4d6fqzA=
MIME-Version: 1.0
In-Reply-To: <200912181455.34664.bzolnier@gmail.com>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	 <200912171618.32882.bzolnier@gmail.com>
	 <alpine.LRH.2.00.0912181400130.21496@twin.jikos.cz>
	 <200912181455.34664.bzolnier@gmail.com>
Date: Sun, 27 Dec 2009 12:15:00 -0500
Message-ID: <9e4733910912270915k6299f6f4pc2bb81685eef29c6@mail.gmail.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
From: Jon Smirl <jonsmirl@gmail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 8:55 AM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Friday 18 December 2009 02:04:37 pm Jiri Kosina wrote:
>> On Thu, 17 Dec 2009, Bartlomiej Zolnierkiewicz wrote:
>>
>> > > > I like this patch, this is actually what I wanted to do.
>> > >
>> > > I have nothing against a switch, but it had better default to off.
>> > >
>> > > The whole 80-char limit is insane. It results in insane "fixes". Just
>> > > about every time somebody "improves" a patch due to the warning, the
>> > > result is worse than the original patch.
>> >
>> > Examples? :)
>>
>> balance_leaf() in fs/reiserfs/do_balan.c
>>
>> Example picked totally at random:
>>
>>       set_le_ih_k_offset(ih,
>>                          le_ih_k_offset(ih) +
>>                          (tb->
>>                           lbytes <<
>>                           (is_indirect_le_ih
>>                            (ih) ? tb->tb_sb->
>>                            s_blocksize_bits -
>>                            UNFM_P_SHIFT :
>>                            0)));
>>
>> See how everything is nicely aligned to 80 cols?
>
> I see but the above code is an utter crap anyway.
>
> Firstly what kind of a function parameter is that:
>
>   le_ih_k_offset(ih) + (tb->lbytes << (is_indirect_le_ih(ih) ? tb->tb_sb->s_blocksize_bits - UNFM_P_SHIFT : 0))
>
> ?
>
> [ BTW 'tb->tb_sb->s_blocksize_bits - UNFM_P_SHIFT' construct is used five
>  times in balance_leaf() and is a likely candidate for helper / macro. ]
>
> More importantly the whole balance_leaf() function is almost 1400 LOC (!)
> big and impossible to read: code for handling particular 'switch' blocks
> should be factored out into separate functions etc.
>
> The point I was making is that the once we remove the limit we don't have
> other tool to _automatically_ point suspicious code areas (yes, I would
> also prefer intelligent static code checker over dumb limit but it simply

A static code checker (like sparse) could do much more intelligent
wrapping analysis.  Maybe someone will take this up as a thesis
project and provide a replacement for indent. Post example
reformattings to LKML until the formatting gods are satisfied.

The problem I see is that C statements that over over 50 chars or so
should be flagged if they aren't declarations or strings. That's an
independent problem from excessive nesting. Tools like ident aren't
smart enough to separate these problems and flags the combination of
statement length and nesting.

I'd be a lot happier if someone simply patched out all of the trailing
whitespace that has gotten in to the kernel tree over the years.
jonsmirl@terra:~/fs$ grep -rI [[:space:]]$ * | wc
  47804  231898 2888009

> not here as things are today and dumb limit works surprisingly well most
> of the time -- please note how that the structural problem with the code
> example given is immediately visible with the current limit).
>
>> Generally, don't look at this function after having a good lunch you want
>> to keep. You have been warned.
>
> No worries, I visit dark places (ide, staging, ..) and come back alive.. ;)
>
> --
> Bartlomiej Zolnierkiewicz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Jon Smirl
jonsmirl@gmail.com
