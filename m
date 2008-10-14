Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYJNF3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYJNF3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 01:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750958AbYJNF3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 01:29:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:46491 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbYJNF3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 01:29:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xdYLPLRKn5eXqAfdD/qQ7n+lt5z4ZseGdrXSX861fTpDRfZYDO+C8k5Mu6k+4g/mUP
         532dN5EJ5e2UG/iejmlL8ShPHIaxqoJBF19cxh1b+gSyV3Mf6upT2RQviGmqbicQdQe/
         BPz+MsyXed8FCwqPoWZClmMmvJo6qGiwriSZs=
Message-ID: <86802c440810132229j3f72d09ao9f28928ba01b767f@mail.gmail.com>
Date: Mon, 13 Oct 2008 22:29:31 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Tony Luck" <tony.luck@intel.com>, "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: split e820 reserved entries record to late v4 - fix v7
Cc: "Andrew Morton" <akpm@linux-foundation.org>, tglx@linutronix.de,
       hpa@zytor.com, jbarnes@virtuousgeek.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <12c511ca0810131332h6e5468abk3dfc511f0b25cbe6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1220254284-29532-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080904190457.GB24990@elte.hu>
	 <20080904121627.bc182da7.akpm@linux-foundation.org>
	 <86802c440809041222q244e1adaj16b80f1590053bcf@mail.gmail.com>
	 <12c511ca0810131332h6e5468abk3dfc511f0b25cbe6@mail.gmail.com>
X-Google-Sender-Auth: 2560cb66def5e91b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 1:32 PM, Tony Luck <tony.luck@intel.com> wrote:
> On Thu, Sep 4, 2008 at 12:22 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> On Thu, Sep 4, 2008 at 12:16 PM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>>> On Thu, 4 Sep 2008 21:04:57 +0200
>>> Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>>> +             printk(KERN_DEBUG "    __reserve_region_with_split: (%s) [%llx, %llx], res: (%s) [%llx, %llx]\n",
>>>> +                      conflict->name, conflict->start, conflict->end,
>>>> +                      name, start, end);
>>>

Ingo, how come following patch getting lost?

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
