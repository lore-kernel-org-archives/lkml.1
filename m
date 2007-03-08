Return-Path: <linux-kernel-owner+w=401wt.eu-S933280AbXCHUTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280AbXCHUTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933293AbXCHUTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:19:54 -0500
Received: from mga09.intel.com ([134.134.136.24]:48855 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933280AbXCHUTw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:19:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,264,1170662400"; 
   d="scan'208"; a="55233866:sNHT20951145"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/3] aio: fix oops because of extra IO control block freeing.
Date: Thu, 8 Mar 2007 23:19:47 +0300
Message-ID: <B41635854730A14CA71C92B36EC22AAC8CA971@mssmsx411>
In-Reply-To: <A5667440-009D-4ACB-9EA9-7462341DD704@zabbo.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/3] aio: fix oops because of extra IO control block freeing.
Thread-Index: AcdhCrnFWMCNYFNiR1akxLTJvqXiZwAo6ypg
From: "Ananiev, Leonid I" <leonid.i.ananiev@intel.com>
To: "Zach Brown" <zab@zabbo.net>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Leonid Ananiev" <leonid.i.ananiev@linux.intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "linux-aio" <linux-aio@kvack.org>,
       "Chris Mason" <chris.mason@oracle.com>
X-OriginalArrivalTime: 08 Mar 2007 20:19:50.0095 (UTC) FILETIME=[1FA5B5F0:01C761BF]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ZB>If we really decide to remove EIOCBRETRY support we'd get rid of all
ZB>the retry infrastructure and remove the EIOCBRETRY errno so their
ZB>builds failed.

Originally EIOCBRETRY was used in fs/read_write.c for vector IO.
And EIOCBRETRY was deleted from it after.
Now EIOCBRETRY is used in drivers/usb/gadget/inode.c only. And the patch
2/3 proposes to set iocb flag instead of EIOCBRETRY errno in inode.c.
Agree that the name kiocbSetPgBusy() could be better chosen if
kiocbSetPgBusy() is just instead for vector IO. But why other than DIO
developers must continue using EIOCBRETRY? Thay could use the same way
as fs/read_write.c uses?

ZB> I was waiting for them to arrive before responding.
Sorry. I've listed "linux-kernel@vger.kernel.org;
stern@rowland.harvard.edu" in a single (that is incorrect) thunderbird
'To' line; I have got response from Stern; and thought that mailing was
OK.

ZB>- ext3_releasepage() returns failure if it races with kjournald
ZB>holding a reference while it waits for a transaction to commit.

The patch proposes iterative synchronization way to solve this problem.

ZB>- generic_file_direct_IO() causes an oops if it clobbers -EIOCBQUEUED
ZB>with the return code from invalidate_inode_pages2_range()..-
ZB>releasepage().

After patching invalidate_inode_pages2_range() does not change return
value.

ZB>This fix makes the incorrect assertion that *any* failure from
ZB>invalidate_inode_pages2_range(), which might not have anything to do
ZB>with this race you're currently seeing, is transitory and should
ZB>trigger a retry.  That's wrong, it should be returning the error.

Just patch makes to retry iocb if page is transitory busy for any
reason.
If busy -> do retry IO operation later.
We will get correct errno if mapping was deleted or retry success if
page is dirty or committed.

Leonid
