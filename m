Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbYJGVx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbYJGVx3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYJGVxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:53:18 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:5378 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbYJGVxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=XNpQnKa/pQyPRUe6SsI3PYbcC/fzZZlLSBSZquQTeGKP4gfKkvxXbPt5oPzRnQd0rs
         5XlaSSP23cdbFohXzhV8BFjS8xVkiiAVXmKZDqZVI0pQOdRQBzZtBbk70W1xIXO8FcnR
         eCKLSXHN+p/vyDl6NIeCQt+kRI3F3XyagHzmw=
Subject: [RFC] Normalizing byteorder/unaligned access API
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 14:53:11 -0700
Message-Id: <1223416391.8195.22.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[related question regarding the SCSI-private endian helper needs at the end]

Currently on the read side, we have (le16 as an example endianness)

le16_to_cpup(__le16 *)
get_unaligned_le16(void *)

And on the write side:

*(__le16)ptr = cpu_to_le16(u16)
put_unaligned_le16(u16, void *);

On the read side, Al said he would have preferred the unaligned version
take the same types as the aligned, rather than void *.  AKPM didn't think
the use of get_ was that great as get/put generally implies some kind of reference
taking in the kernel.

As the le16_to_cpup has been around for so long and is more recognizable, let's
make it the same for the unaligned case and typesafe:

le16_to_cpup(__le16 *)
unaligned_le16_to_cpup(__le16 *)

On the write side, the above get/put and type issues are still there, in addition AKPM felt
that the ordering of the put_unaligned parameters was opposite what was intuitive and that
the pointer should come first.

In this case, as there is currently no aligned helper (other than in some drivers defining macros)
define the api thusly:

Aligned:
write_le16(__le16 *ptr, u16 val)

Unaligned:
unaligned_write_le16(__le16 *ptr, u16 val)

The existing get/put_unaligned macros do not necessarily need to be modified.  It would
present one oddity that the parameter order was different, but that's not a huge issue.

These could be phased in as they do not collide with the current API and the old api converted
over fairly quickly as not many places use the get/put_unaligned_{endian} helpers yet.

In addition, there are some subsystems (scsi) that are looking into some differently sized
endian helpers (be24) and it may be worthwhile to have some agreement whether it is worth
making them common infrastructure and whether they should present a similar API to the
common byteorder/unaligned API.

Is this a worthwhile direction to take?

Cheers,

Harvey

