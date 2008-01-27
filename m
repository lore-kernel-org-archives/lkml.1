Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbYA0UHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbYA0UHU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 15:07:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYA0UHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 15:07:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:35903 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbYA0UHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 15:07:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=YmzhKlFtd+IOiaGGnwPwNoDZ+OMrvWzaTHiifXI//UK6lSNR5URRfdYZowNA8gR5TO7h1BK9XSkO5jY9E8oYs0TG9tN0y71LWHQ9Ye6uf/Bo4fCdXlkmtjVVeLuYBPXU0xVfyK2i28w+In5HNEmyU0cvHN3DfZngsr6IrwIVTR8=
Message-ID: <19f34abd0801271207j377fba5bg92cedceedbdd228@mail.gmail.com>
Date: Sun, 27 Jan 2008 21:07:01 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Jim Houston" <jim.houston@ccur.com>
Subject: lib/idr.c: initialize struct idr_layer
Cc: "Ingo Molnar" <mingo@elte.hu>, "Tejun Heo" <htejun@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am testing my kmemcheck patches, and it has come up with a couple of
uses of uninitialized memory in lib/idr.c. These are (the line numbers
may differ slightly):

line 135 (sub_alloc): bm = ~p->bitmap;
p->bitmap is uninitialized

line 171 (sub_alloc): if (!p->ary[m]) {
p->ary is uninitialized

line 249 (idr_get_new_above_int): pa[0]->count++;
pa[0]->count is uninitialized

I cannot guarantee that these are truly errors, but I would be
grateful if you could help me confirm/deny the validity of the
reports. Personally, I can get rid of the errors using this patch:

diff --git a/lib/idr.c b/lib/idr.c
index afbb0b1..dd28ee5 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -39,12 +39,16 @@ static struct idr_layer *alloc_layer(struct idr *idp)
 {
        struct idr_layer *p;
        unsigned long flags;
+       int i;

        spin_lock_irqsave(&idp->lock, flags);
        if ((p = idp->id_free)) {
                idp->id_free = p->ary[0];
                idp->id_free_cnt--;
-               p->ary[0] = NULL;
+               p->bitmap = 0;
+               for(i = 0; i < ARRAY_SIZE(p->ary); ++i)
+                       p->ary[i] = NULL;
+               p->count = 0;
        }
        spin_unlock_irqrestore(&idp->lock, flags);
        return(p);


Thanks a lot.

Vegard
