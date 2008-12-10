Return-Path: <linux-kernel-owner+w=401wt.eu-S1755613AbYLJRnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613AbYLJRnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 12:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbYLJRnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 12:43:10 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:60384 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYLJRnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 12:43:09 -0500
Message-ID: <493FFE5E.2000404@colorfullife.com>
Date: Wed, 10 Dec 2008 18:37:34 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Holger Hoffstaette <holger@wizards.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: Nasty regression from .27.7 to .27.8: idle samba goes crazy
References: <pan.2008.12.08.06.18.57.357875@wizards.de> <200812080834.22924.rjw@sisk.pl> <pan.2008.12.08.08.07.29.439625@wizards.de> <493D4F5C.7020606@s5r6.in-berlin.de> <493D7349.10200@s5r6.in-berlin.de> <20081208222246.GA29232@sith.mimuw.edu.pl> <20081209123703.043067eb@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <20081209123703.043067eb@dhcp-100-2-144.bos.redhat.com>
Content-Type: multipart/mixed;
 boundary="------------030903030707060608030203"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030903030707060608030203
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Chuck Ebbert wrote:
> On Mon, 8 Dec 2008 23:22:46 +0100
> Jan Rekorajski <baggins@sith.mimuw.edu.pl> wrote:
>
>   
>> On Mon, 08 Dec 2008, Stefan Richter wrote:
>>
>>     
>>>>>> On Monday, 8 of December 2008, Holger Hoffstaette wrote:
>>>>>>             
>>>>>>> The system is a generic old single-core P4 box with a single SATA drive,
>>>>>>> Gentoo userland and Samba is 3.0.33 (in async mode). The kernel has no
>>>>>>> patches or binary drivers.
>>>>>>>               
>>> Holger, it may be unrelated to the issue, but to be sure:  Which network
>>> card driver do you use?
>>>       
>> I think you can safely rule out NIC, I'm also seeing this behaviour on a
>> brand new server with imap hanging in some busy-loop.
>> Network card in my case:
>> Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 12)
>>
>> What I observer was one CPU doing 100% system work, and the number of
>> timer interrupts went from 1k per second to 4k (for the whole system).
>>
>>     
Could you try the attached patch?
It should fix the bug.


--
    Manfred

--------------030903030707060608030203
Content-Type: text/plain;
 name="patch-idr-get_above_int"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-idr-get_above_int"

rom ae060e0b7bc071bd73dd5319b93c3344d9e10212 Mon Sep 17 00:00:00 2001
From: Manfred Spraul <manfred@colorfullife.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Cc: cebbert@redhat.com
Cc: airlied@gmail.com
Cc: akpm@linux-foundation.org
Bcc: manfred@colorfullife.com
Date: Wed, 10 Dec 2008 18:17:06 +0100
Subject: [PATCH] lib/idr.c: Fix bug introduced by RCU fix

The last patch to lib/idr.c caused a bug if idr_get_new_above() was
called on an empty idr:
Usually, nodes stay on the same layer. New layers are added to the top
of the tree.
The exception is idr_get_new_above() on an empty tree: In this case,
the new root node is first added on layer 0, then moved upwards.
p->layer was not updated.

As usual: You shall never rely on the source code comments, they
will only mislead you.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 lib/idr.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/lib/idr.c b/lib/idr.c
index 7a785a0..1c4f928 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -220,8 +220,14 @@ build_up:
 	 */
 	while ((layers < (MAX_LEVEL - 1)) && (id >= (1 << (layers*IDR_BITS)))) {
 		layers++;
-		if (!p->count)
+		if (!p->count) {
+			/* special case: if the tree is currently empty,
+			 * then we grow the tree by moving the top node
+			 * upwards.
+			 */
+			p->layer++;
 			continue;
+		}
 		if (!(new = get_from_free_list(idp))) {
 			/*
 			 * The allocation failed.  If we built part of
-- 
1.5.6.5


--------------030903030707060608030203--
