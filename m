Return-Path: <linux-kernel-owner+w=401wt.eu-S933608AbXHGCD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933608AbXHGCD1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 22:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932503AbXHGCDS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 22:03:18 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:28571 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932492AbXHGCDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 22:03:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=fxKxQUl4QKpQE7uUBLVNv7yJYHLPvUjq3M2RTEKn8tpLVNJYBpU/q/cTMTdurx36uhSlZPs6eXa1GQlm3lThStfDaWcb2HD2ZcMCGNtx2F1h03gfj/8Dnf4FOTARMZIYvQ4rICTF8fWqlYMzCY6fmA4KVPA+JfTTDAZ/HjGlO/o=
Message-ID: <f56c1ba00708061903r29baea3dj6b57032be5820983@mail.gmail.com>
Date: Mon, 6 Aug 2007 22:03:15 -0400
From: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Andi Kleen" <andi@firstfloor.org>
Subject: [PATCH 0/2] PAT support for i386 and x86_64
Cc: loic@myri.com, brice@myri.com, cedric.augonnet@ens-lyon.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

For quite a while now, there as been numerous attempt to introduce support for
Page Attribute Table (PAT) in the Linux kernel, whereas most other OS already
have some support for this feature. Such a proposition popping up periodically,
perhaps it would be an opportunity to fix that lack for once.

  PAT actually makes life much easier for people needing to use write-combining
(WC) attribute. Indeed the only solution yet available is MTRRs, which are not
as flexible as PAT is.
  Indeed, even if they both allow to set memory types on memory regions, MTRRs
are intended to be used on a physical memory range, while PAT makes possible
to set such memory type based on a linear address mapping. The actual problem
with MTRR is that the BIOS usually covers physical RAM with write-back (WB),
and that MTRRs should not be overlapped.
  Using write-combining feature is sometimes crucial for performance of driver
for which writes operation on the bus are critical. High-speed networking
drivers such as myri10ge would take benefit of using PAT instead of MTRRs.
Video drivers using frame-buffers could also avoid using MTRRs that way.

  PAT6 can be a candidate for that purpose. Not only for backward compatibility
reasons, but also as various errata concerning PAT would end up by having the
PAT bit ignored, therefore if we use PAT6, when such an error occurs we would
have an uncached area, which means it would at worst not be effective, thus
resolving the issues raised in http://lkml.org/lkml/2004/4/13/102 .

 *******

 Back to 2.4.20, Terence Ripperda already submitted such a proposal for PAT
 support in
   - http://lkml.org/lkml/2003/5/20/131
 himself refering to
   - http://www.ussg.iu.edu/hypermail/linux/kernel/0303.1/0606.html

 In 2005, Eric W. Biederman submitted another similar patch :
   - http://lkml.org/lkml/2005/8/29/226

 More recently, there have been numerous threads dealing with MTRR issues,
 some of them suggesting that there should actually be some support for PAT.
 See for instance :
   - http://lkml.org/lkml/2007/6/6/333

 *******

 I therefore propose here a set of 2 patches to add some support for
 write-combining using PAT :

 [PATCH 1/2] - [PAT] Setting write combining on PAT6 at boot time
 [PATCH 2/2] - [PAT] Support for write combining in pci_mmap_page_range

Kind regards,
Cedric
