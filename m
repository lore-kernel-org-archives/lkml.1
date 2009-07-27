Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084AbZG0ObV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbZG0ObV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 10:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752087AbZG0ObT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 10:31:19 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:29126 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZG0ObR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 10:31:17 -0400
X-SpamScore: 4
X-BigFish: VPS4(zz4015La1ffmzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KNG2ZD-04-HYB-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 0/7 v5] KVM: support for 1gb pages
Date: Mon, 27 Jul 2009 16:30:41 +0200
Message-ID: <1248705048-22607-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 27 Jul 2009 14:30:50.0739 (UTC) FILETIME=[D7078C30:01CA0EC6]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this is the latest version of the changes to KVM MMU code to support 1gb
pages.  Pages with a size of 1gb are a feature of all Fam10h AMD CPUs
and this patch set makes them available for guests and allows to map the
nested page table with 1gb pages.

Changes to the previous version of this patch set:

	* fixed a bug in the pte reserved bit checking code which
	  disallowed 1gb ptes (thanks Marcelo)
	* included a working version of 1gb page support for shadow
	  paging (again, thanks to Marcelo who found the bug in the
	  original patch)
	* rebased patches to the latest avi/master branch

I also gathered some new performance data for this code. The following
table contains the data. The configrations are all named as
<1gb pages enabled in guest>-<host backing size>. The numbers below are
the average of the elapsed time of 3 kernel compiles in a guest with 3GB
memory and 4 vpcus on an Istanbul based machine. The make jobs ran with
-j8. All measurements were done with nested paging enabled.

Configuration		Elapsed Time		Percent
------------------------------------------------------------
no1gbpages-4kb		139.81			100%
no1gbpages-1gb		129.89			92.9%
  1gbpages-4kb		137.09			98.0%
  1gbpages-1gb		129.42			92.6%

the biggest benefit is gained using 1gb pages for the nested page table.
The performance improvement compared to 4kb backing size with nested
paging is between 7% and 7.5%. Using 1gb pages in a guest with a 4kb
backing size on the host gives around 2% performance improvement.

Please review and/or consider to apply these patches.

Thanks,

	Joerg

Diffstat:


 arch/x86/include/asm/kvm_host.h |    5 +-
 arch/x86/kvm/mmu.c              |  242 ++++++++++++++++++++++++---------------
 arch/x86/kvm/paging_tmpl.h      |   97 ++++++++--------
 arch/x86/kvm/svm.c              |    6 +
 arch/x86/kvm/vmx.c              |    6 +
 arch/x86/kvm/x86.c              |    3 +-
 6 files changed, 214 insertions(+), 145 deletions(-)

Shortlog:


Joerg Roedel (7):
      kvm/mmu: make rmap code aware of mapping levels
      kvm/mmu: rename is_largepage_backed to mapping_level
      kvm/mmu: make direct mapping paths aware of mapping levels
      kvm/mmu: make page walker aware of mapping levels
      kvm/mmu: shadow support for 1gb pages
      kvm/mmu: enable gbpages by increasing nr of pagesizes
      kvm x86: report 1GB page support to userspace


