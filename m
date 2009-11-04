Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbZKDStL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbZKDStL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 13:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750816AbZKDStJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 13:49:09 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:42880 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbZKDStI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 13:49:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J5DJ8/E3Ve9ojX61okJI2SZh5hPJjehlv2b0WMi9K3JMxUrLJHyPg18a26C3nNsTLQ
         c3GqCi2vgrUOhuEgufaq3gLrRTcQ/FCb9IasQxWPXqtX4d8Mo+/DB/ri+mJWZ/2VrTze
         C1aa9Xz3MokSwOJpS+qZ8PyNkl3DB54e8Dduw=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0911041025350.31845@localhost.localdomain>
References: <20091102174536.12512.56685.stgit@bob.kio>
	 <20091104102026.5698a9b4@jbarnes-piketon>
	 <alpine.LFD.2.01.0911041025350.31845@localhost.localdomain>
Date: Wed, 4 Nov 2009 10:49:13 -0800
Message-ID: <86802c440911041049g592770dqc69b0ce34ea04a10@mail.gmail.com>
Subject: Re: [PATCH] resources: when allocate_resource() fails, leave resource 
	untouched
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>, jbarnes@virtuousgeek.org
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 4, 2009 at 10:29 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Wed, 4 Nov 2009, Jesse Barnes wrote:
>>
>> Seems like a reasonable change to me.  Linus is usually the gatekeeper
>> for resource.c.
>
> I'm certainly ok with this one. I wouldn't be surprised if it even allows
> for better code generation, apart from leaving resources untouched when
> allocation fails. So:
>
>        Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> It was apparently sent to Andrew, but I can certainly take it. Or you can
> take it into the PCI tree. Or we can leave it in -mm. Anything goes. Just
> tell me.
>

looks should be put into pci tree.

two of patches that is releasing not big enough range from leaf bridge
could be user.

don't need the "save and restore" trick anymore.

YH

@@ -57,10 +100,23 @@ static void pbus_assign_resources_sorted
        for (list = head.next; list;) {
                res = list->res;
                idx = res - &list->dev->resource[0];
+               /* save the size at first */
+               size = resource_size(res);
                if (pci_assign_resource(list->dev, idx)) {
-                       res->start = 0;
-                       res->end = 0;
-                       res->flags = 0;
+                       if (fail_head && !list->dev->subordinate &&
+                           !pci_is_root_bus(list->dev->bus)) {
+                               /*
+                                * device need to keep flags and size
+                                * for second try
+                                */
+                               res->start = 0;
+                               res->end   = size - 1;
+                               add_to_failed_list(fail_head, list->dev, res);
+                       } else {
+                               res->start = 0;
+                               res->end = 0;
+                               res->flags = 0;
+                       }
                }
                tmp = list;
                list = list->next;
