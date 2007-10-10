Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbXJJIiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbXJJIiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 04:38:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbXJJIh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 04:37:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:46052 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045AbXJJIh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 04:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=hjxPPd/c49yin2gJiHt7YLS1YCds27Na2EdqxxYdfhc2GujRTR3pdZWmTPTrtaP6lQXclQopOeHdVdOkVNT1TDw28LmQKPbsDSRPN28nprg2fP2XBTwUZlZOezDvB8R8pH8BadZJW8reQnHkjGucY6nEJYTxqU7BKDDxKrPGWfI=
Message-ID: <dfad5c650710100137i74f444d8t221f1f195cc90e1@mail.gmail.com>
Date: Wed, 10 Oct 2007 10:37:57 +0200
From: "Santiago Font Arquer" <sfa.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: skb_clone SMP race?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
    I'm studying the implementation of sk_buff and I think there's a
possible race condition in skb_clone (2.6.22.9)
    The code is:


struct sk_buff *skb_clone(struct sk_buff *skb, gfp_t gfp_mask)
{
 struct sk_buff *n;

 n = skb + 1;
 if (skb->fclone == SKB_FCLONE_ORIG &&
     n->fclone == SKB_FCLONE_UNAVAILABLE) {
  atomic_t *fclone_ref = (atomic_t *) (n + 1);
  n->fclone = SKB_FCLONE_CLONE;
  atomic_inc(fclone_ref);
 } else {
  n = kmem_cache_alloc(skbuff_head_cache, gfp_mask);
  if (!n)
   return NULL;
  n->fclone = SKB_FCLONE_UNAVAILABLE;
 }

    If an skb with fast clone available (first "if" true) has
references in different CPUs (skb->users>1) (I do not find explicit
checks for this to be impossible), if skb_clone is called
simultaneously over that skb, both callers can get the same clone (the
"fast" clone) and different problems follow: wrong "clone_skb->users"
(1 as expected by the caller, but it should be, to be true, 2),
fclone_ref set to 3 involving further problems, ...

   IMO, the same problem arises although the calls to skb_clone are
not simultaneous: there isn´t a memory barrier after the change of
"n->fclone" to guarantee the visibility of that change to other CPUs
(but that barrier will not solve anything; I mentioned this only to
reflect another reason I see for the race to happen).

   Is that correct? Thank you in advance.

        Santiago Font Arquer
