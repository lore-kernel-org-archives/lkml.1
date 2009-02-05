Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbZBEOmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbZBEOmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 09:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbZBEOly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 09:41:54 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:5000 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbZBEOly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 09:41:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=IinTXqYaCVKrkl5UgZWgXF6A+cVhxr/7VM/sD45N7WlAXNlE2+mwrdLUYixKxiVaKw
         8XfsfpI3iKUZxgz++A/c6aSdpLTuQ/ir3WpI3t5NUGXG2HBpa26zTAAiC79aUdqRSadJ
         sD7lSwCKsL6dVLQpr8dKGmkorGmu6H55T18cI=
MIME-Version: 1.0
Date: Thu, 5 Feb 2009 22:41:52 +0800
Message-ID: <b6a2187b0902050641h7943816ds26275a320e724440@mail.gmail.com>
Subject: commit 64ff3b938ec6782e6585a83d5459b98b0c3f6eb8 breaks rlogin
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: herbert@gondor.apana.org.au, David Miller <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit breaks "rlogin". Symptom is the terminal just
hangs before login to the remote machine. No error, just the cursor
never come back. "~." or type "exit" will exit from remote session.
Only happens "sometimes". Happens more often if you try many times.

I've reverted the commit, and rlogin works now.

Thanks,
Jeff.



commit 64ff3b938ec6782e6585a83d5459b98b0c3f6eb8
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Dec 25 17:12:58 2008 -0800

    tcp: Always set urgent pointer if it's beyond snd_nxt

    Our TCP stack does not set the urgent flag if the urgent pointer
    does not fit in 16 bits, i.e., if it is more than 64K from the
    sequence number of a packet.

    This behaviour is different from the BSDs, and clearly contradicts
    the purpose of urgent mode, which is to send the notification
    (though not necessarily the associated data) as soon as possible.
    Our current behaviour may in fact delay the urgent notification
    indefinitely if the receiver window does not open up.

    Simply matching BSD however may break legacy applications which
    incorrectly rely on the out-of-band delivery of urgent data, and
    conversely the in-band delivery of non-urgent data.
