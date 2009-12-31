Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbZLaCld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbZLaCld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 21:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbZLaCld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 21:41:33 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:38860 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbZLaClc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 21:41:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ku2JLBuytB55ayE4tzYtbVajY7Mxa6Xhb1g172ng4VcW1U+6klOGymA8lkvB2NEsK9
         tTu/Hq0Qreyb7PGdkJ89QYm9F1AtbLx6s8TaB6eLJdANlyykveI9jNKksF6QGUN9vW27
         Mh0kuVgHpiXwNOalI8l721KCnC1NkKx7xPevQ=
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.0912301619500.3369@sister.anvils>
References: <ceeec51bdc2be64416e05ca16da52a126b598e17.1258773030.git.minchan.kim@gmail.com>
	 <ae2928fe7bb3d94a7ca18d3b3274fdfeb009803a.1258773030.git.minchan.kim@gmail.com>
	 <4B38876F.6010204@gmail.com>
	 <alpine.LSU.2.00.0912301619500.3369@sister.anvils>
Date: Thu, 31 Dec 2009 11:41:31 +0900
Message-ID: <28c262360912301841r3ed43d31yc677fbc3a01fe5bb@mail.gmail.com>
Subject: Re: [PATCH 2/3 -mmotm-2009-12-10-17-19] Count zero page as file_rss
From: Minchan Kim <minchan.kim@gmail.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 1:49 AM, Hugh Dickins
<hugh.dickins@tiscali.co.uk> wrote:
> On Mon, 28 Dec 2009, Minchan Kim wrote:
>> I missed Hugh.
>
> Thank you: it is sweet of you to say so :)
>
>>
>> Minchan Kim wrote:
>> > Long time ago, we counted zero page as file_rss.
>> > But after reinstanted zero page, we don't do it.
>> > It means rss of process would be smaller than old.
>> >
>> > It could chage OOM victim selection.
>
> Eh?  We don't use rss for OOM victim selection, we use total_vm.
>
> I know that's under discussion, and there are good arguments on
> both sides (I incline to the rss side, but see David's point about
> predictability); but here you seem to be making an argument for
> back-compatibility, yet there is no such issue in OOM victim selection.

Sorry, I totally confused that.

>
> And if we do decide that rss is appropriate for OOM victim selection,
> then we would prefer to keep the ZERO_PAGE out of rss, wouldn't we?

If we start to use RSS, it's good that keep zero page out of rss in OOM aspect.
But I am not sure it's good in smap aspect.
Some smap user might want to know max memory usage in process.
Zero page has a possibility to change real rss.

>
>> >
>> > Kame reported following as
>> > "Before starting zero-page works, I checked "questions" in lkml and
>> > found some reports that some applications start to go OOM after zero-page
>> > removal.
>> >
>> > For me, I know one of my customer's application depends on behavior of
>> > zero page (on RHEL5). So, I tried to add again it before RHEL6 because
>> > I think removal of zero-page corrupts compatibility."
>> >
>> > So how about adding zero page as file_rss again for compatibility?
>
> I think not.

At least,  we had accounted zero page as file_rss until remove zero page.
That was my concern.
I think we have to fix this for above compatibility regardless of OOM issue.

>
> KAMEZAWA-san can correct me (when he returns in the New Year) if I'm
> wrong, but I don't think his customer's OOMs had anything to do with
> whether the ZERO_PAGE was counted in file_rss or not: the OOMs came
> from the fact that many pages were being used up where just the one
> ZERO_PAGE had been good before.  Wouldn't he have complained if the
> zero_pfn patches hadn't solved that problem?
>
> You are right that I completely overlooked the issue of whether to
> include the ZERO_PAGE in rss counts (now being a !vm_normal_page,
> it was just natural to leave it out); and I overlooked the fact that
> it used to be counted into file_rss in the old days (being !PageAnon).
>
> So I'm certainly at fault for that, and thank you for bringing the
> issue to attention; but once considered, I can't actually see a good
> reason why we should add code to count ZERO_PAGEs into file_rss now.
> And if this patch falls, then 1/3 and 3/3 would fall also.
>
> And the patch below would be incomplete anyway, wouldn't it?
> There would need to be a matching change to zap_pte_range(),
> but I don't see that.

Thanks.
If we think this patch is need, I will repost path with fix it.

What do you think?

-- 
Kind regards,
Minchan Kim
