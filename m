Return-Path: <linux-kernel-owner+w=401wt.eu-S1751691AbZLHJGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751691AbZLHJGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 04:06:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbZLHJGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 04:06:04 -0500
Received: from mail.mellanox.co.il ([194.90.237.43]:54171 "EHLO mellanox.co.il"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751516AbZLHJGA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 04:06:00 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: SR-IOV enabling process failed in kernel 2.6.32
Date: Tue, 8 Dec 2009 11:07:57 +0200
Message-ID: <2ED289D4E09FBD4D92D911E869B97FDD01E6E555@mtlexch01.mtl.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: SR-IOV enabling process failed in kernel 2.6.32
Thread-Index: Acp35SdNS7HeSI+bSIGIbTbL743lAQAAIr+w
From: "Erez Shitrit" <erezsh@mellanox.co.il>
To: <gregkh@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@atrey.karlin.mff.cuni.cz>,
       "Erez Shitrit" <erezsh@mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
 
We are working on InfiniBand device that supports SR-IOV.
and lately (from version 2.6.32 ) we faced a problem:
When the driver tried to enable SR-IOV it failed to allocate resources
for the 2 BARS the device needs.
The situation is when there are 2 BARS, the first asks for little amount
of memory and the second asks for much larger memory requirements.
I saw in the code (drivers/pci/iov.c) that the order of the allocation
starts from the first BAR to the last.

The code:
for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
  res = iov->res + i;
  if (!res->flags)
      continue;
  rc = pci_assign_resource(dev, i + PCI_IOV_RESOURCES);

This process failed for the second BAR (The big one). (in the log: "not
enough MMIO resources for SR-IOV")
 
I think (IMHO) it because the allocation of the first BAR (the little)
one was from the allocated slot of the big one (the allocation from the
sriov_init function)
and when the kernel tries to allocate the slot for he second BAR (the
big one) in the place of the little one it failed.
 
when I changed the code to start the allocation from the last to the
first: for (i = PCI_SRIOV_NUM_BARS; i >= 0; i--) 
It works fine.
 
Is it a bug ? 
 
Thanks, Erez
