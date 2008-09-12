Return-Path: <linux-kernel-owner+w=401wt.eu-S1755247AbYILKRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247AbYILKRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 06:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752613AbYILKRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 06:17:14 -0400
Received: from nebensachen.de ([195.34.83.29]:42471 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591AbYILKRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 06:17:12 -0400
X-Hashcash: 1:20:080912:htejun@gmail.com::x9z84vS/ffPqWRvc:01CUg
X-Hashcash: 1:20:080912:valdis.kletnieks@vt.edu::Ttn5jC51DzJsSeDr:000000000000000000000000000000000000007K/j
X-Hashcash: 1:20:080912:alan@lxorguk.ukuu.org.uk::U0rq7bxvE2SD8VRz:0000000000000000000000000000000000000AEnB
X-Hashcash: 1:20:080912:akpm@linux-foundation.org::DMMEQWZAm28ZKeMr:0000000000000000000000000000000000001Jn5
X-Hashcash: 1:20:080912:bzolnier@gmail.com::mEq7nf8a/eOux8kT:00000000000000000000000000000000000000000004BEy
X-Hashcash: 1:20:080912:jeff@garzik.org::FnvafjTKKBhIehQJ:005ldB
X-Hashcash: 1:20:080912:randy.dunlap@oracle.com::1gchntZkt0R7wYUh:000000000000000000000000000000000000000jet
X-Hashcash: 1:20:080912:linux-ide@vger.kernel.org::x5x+adRpGkHB91nB:0000000000000000000000000000000000002OUW
X-Hashcash: 1:20:080912:linux-kernel@vger.kernel.org::kUN6pjVXwx1EJHAA:0000000000000000000000000000000001UiC
From: Elias Oltmanns <eo@nebensachen.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
References: <87wshzplvk.fsf@denkblock.local> <48BA969C.4060207@gmail.com>
	<87abetmaap.fsf@denkblock.local> <48BBA8D1.8020604@gmail.com>
	<87myirly1p.fsf@denkblock.local> <48BC1BB8.2030007@gmail.com>
	<87fxoh0yil.fsf@denkblock.local> <48BFA528.2040305@gmail.com>
	<87ej3zrf3o.fsf@denkblock.local> <48C0F2F8.1040308@gmail.com>
	<87ej3snm3s.fsf@denkblock.local> <48C7DC55.30002@gmail.com>
	<8763p3ol55.fsf@denkblock.local> <48C82CB1.2070308@gmail.com>
	<871vzrogpz.fsf@denkblock.local> <48C850AA.2030409@gmail.com>
	<87k5diq35g.fsf@denkblock.local> <48C91458.7090503@gmail.com>
	<48C9168C.4090101@gmail.com> <25227.1221157727@
	turing-police.cc.vt.edu> <48C9A8D3.60408@gmail.com>
Date: Fri, 12 Sep 2008 12:15:22 +0200
In-Reply-To: <48C9A8D3.60408@gmail.com> (Tejun Heo's message of "Fri, 12 Sep
	2008 01:25:07 +0200")
Message-ID: <87prn9y8jp.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> wrote:
> Valdis.Kletnieks@vt.edu wrote:
>> On Thu, 11 Sep 2008 15:01:00 +0200, Tejun Heo said:
>
>>> Ah.. just one more thing.
>>>
>>> I think it would be easier on the application if the written timeout
>>> value is cropped if it's over the maximum instead of failing the
>>> write.
>> 
>> Which is better, failing the write so the application *knows* there is a
>> problem, or letting the application proceed with a totally incorrect idea of
>> what the value is set to?
>
> It depends.  As -EINVAL either results in program failure or no
> protection for the event.
>
>> For instance, what happens if the program tries to set 100, it's silently
>> clamped to 10, and it then tries to set a timer for itself to '90% of the
>> value'?  It might be in for an unpleasant surprise when it finds out that
>> it's overshot by 81....
>
> Hitting the limit would be a pretty rare occasion and which way we go
> it's not gonna be too pretty.  e.g. Let's say a program calculates
> timeout according to some algorithm which 99.9% of the time stays in
> the limit but once in the blue moon hits the ceiling.  Given the
> characteristics of the problem and very high limit value, I think it's
> better to have cropped value.
>
> How about returning -OVERFLOW while still setting the timeout to the
> maximum?

Yes, that makes sense. I'll take care to document it that way:
-EINVAL for values < -2, -EOVERFLOW for values > 30000.

Once we have smoothed things out wrt the ide patch, I'll repost the
whole series against a recent linux-next tree, so it can be queued up
for 2.6.28. By the way, the ide patch I've just posted does pretty much
what libata should be aiming for in the long run. Hopefully, it'll work
out as expected. Anyway, I'm really grateful to Bart and you for holding
my hand so patiently with all this.

Also, I'll backport the patches to 2.6.27 and make appropriate changes
to hdapsd, so we can get feedback from a wider range of testers. Since
there has been no comment from Jeff as yet, I'll wait with that until
the patches have been merged though.

Regards,

Elias
