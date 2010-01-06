Return-Path: <linux-kernel-owner+w=401wt.eu-S932898Ab0AFVnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898Ab0AFVnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932879Ab0AFVno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:43:44 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:50042 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932883Ab0AFVnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:43:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=EzdlOwONA8HIHUYEomOv/xXd8uCKn6etBzPsAs+Hm2547Ut/QkAAIWwCr7iQYTWOuJ
         +eA5ExoQQ34U4hSJOqoFnQLniNnothOzlCgROgh+/cO/gbnOv8892gxmvgwdzzDRn0D5
         IZ2QS4bw61f80cPUyCTZc9zh6FMnold5RafvU=
Subject: RFC: [PATCH 0/9 Integration of SmartMedia/xD into mtd subsystem
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>,
       joern <joern@logfs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 23:43:36 +0200
Message-ID: <1262814216.14552.22.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the result of my work of supporting an xD card reader that I
have on my notebook.

I had to fix few problems in mtd translation layer, add few workarounds.
This is by no way a final version of the patches, there is still lot of
cleanup to do.
The patches weren't tested with checkpatch.pl for example.

I can now read and write an xD card, and I have no crashes.
Still following issues remain:

1 - Write speed IS very SLOW, just about 200 Kbytes/s
In fact a reader in my printer gives me about 330 Kbytes/s, thus
partially card is to blame.
Also, hardware doesn't support interrupts to test when card is ready,
thus writes consume 100% of one cpu.

2 - I rely on mtd driver to have empty oob layout so I can read both oob
and data using ->read_oob  with MTD_OOB_PLACE.
I thinking to add new mode to allow to read whole oob + data and check
ecc, or I will have to do pointless copying of data from 'censored' oob
to normal structure. (This applies to FTL driver I also include in this
patchset)

3 - Using the mtd device directly with anything but supplied FTL or
SSFDC, on 'modern' xD cards just doesn't. These cards implement a fake
nand command set, thus don't have a real oob.
It was disappointing for me too.
I suspect that all 'Type M' cards are of this fake type, but older cards
are OK.


4 - Suspend/resume support works, but relies on all mtd users not to
suspend in middle of card access, bacause in this case its very
difficult/impossible to know card state.
Driver will refuse suspend in that case.
Access via all block devices is safe.


5 - And of course there are bugs, thus I warn you now that this driver
has high probability to erase data from your card.
Thus DON'T USE THIS DRIVER IF ANYTHING IMPORTANT IS STORED ON THE CARD.


6 - driver only detects PCI ID of my notebook, so it might not load on
compatable chips with different ID.


7 - patches developed against stable 2.6.32, and won't compile against
latest git due to changes in kfifo api.


Feedback is welcome, flames too :-)


Best regards,
Maxim Levitsky


