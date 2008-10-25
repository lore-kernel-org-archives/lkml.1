Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbYJYAT2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbYJYAT2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 20:19:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbYJYATU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 20:19:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:8831 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYJYATT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 20:19:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=twO4tOR/DhNet/Nzp0oOtHPGOQen8G29gCVpKLnIwa6un8LnzaaiZyrP8gm8vTjT+h
         oAHsfPyvA8Q2lqaOvrNasievQGjfebuwgYFVs2ahUX0oNaUQLtPfITg8jmQC+zPakgNQ
         YMRy97BsWnXJRQwlqEjHhyGrKVcqiM/nrri0k=
Message-ID: <86802c440810241719l3e045a8fl33fd5f348857324e@mail.gmail.com>
Date: Fri, 24 Oct 2008 17:19:17 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: oops while booting with recent git kernel
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>,
       "Arkadiusz Miskiewicz" <a.miskiewicz@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200810250029.35880.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810121227.09114.a.miskiewicz@gmail.com>
	 <19f34abd0810132130r524c252q3fb5c520c34cf51@mail.gmail.com>
	 <200810250029.35880.rjw@sisk.pl>
X-Google-Sender-Auth: 1ceb039385c352bc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2008 at 3:29 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, 14 of October 2008, Vegard Nossum wrote:
>> On Sun, Oct 12, 2008 at 12:27 PM, Arkadiusz Miskiewicz
>> <a.miskiewicz@gmail.com> wrote:
>> >
>> > Not sure if it's worth to report this before all initial merges happen but
>> > here it is anyway.
>> >
>> > git kernel with latest commit:
>> > commit fd048088306656824958e7783ffcee27e241b361
>> > Date:   Sat Oct 11 13:23:48 2008 -0700
>> >
>> > booted on thinkpad z60m results with such oops:
>> > http://carme.pld-linux.org/~arekm/img_2325_small.png
>> >
>> > Config used:
>> > http://carme.pld-linux.org/~arekm/img_2325_small.config
>>
>> Thanks for the report.
>>
>> It seems to be an instance of this (known bad) code:
>> http://lkml.org/lkml/2008/9/4/386
>>
>> So hopefully it will be fixed soon.
>
> Has it been fixed, actually?

should be fixed by in upstream.. already

commit 1cf44baad76b6f20f95ece397c6f643320aa44c9
Author: Ingo Molnar <mingo@elte.hu>
Date:   Thu Sep 4 21:26:06 2008 +0200

    IO resources: fix/remove printk

    Andrew Morton noticed that the printk in kernel/resource.c was buggy:

    | start and end have type resource_size_t.  Such types CANNOT be printed
    | unless cast to a known type.
    |
    | Because there is a %s following an incorrect %lld, the above code will
    | crash the machine.

    ... and it's probably quite unneeded as well, so remove it.

    Reported-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/resource.c b/kernel/resource.c
index 414d6fc..fc59dcc 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -549,13 +549,9 @@ static void __init
__reserve_region_with_split(struct resource *root,
        }

        if (!res) {
-               printk(KERN_DEBUG "    __reserve_region_with_split:
(%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
-                        conflict->name, conflict->start, conflict->end,
-                        name, start, end);
-
                /* failed, split and try again */

-               /* conflict coverred whole area */
+               /* conflict covered whole area */
                if (conflict->start <= start && conflict->end >= end)
                        return;


    Reported-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/kernel/resource.c b/kernel/resource.c
index 414d6fc..fc59dcc 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -549,13 +549,9 @@ static void __init
__reserve_region_with_split(struct resource *root,
        }

        if (!res) {
-               printk(KERN_DEBUG "    __reserve_region_with_split:
(%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
-                        conflict->name, conflict->start, conflict->end,
-                        name, start, end);
-
                /* failed, split and try again */

-               /* conflict coverred whole area */
+               /* conflict covered whole area */
                if (conflict->start <= start && conflict->end >= end)
                        return;
