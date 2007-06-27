Return-Path: <linux-kernel-owner+w=401wt.eu-S1761275AbXF0SS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761275AbXF0SS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 14:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbXF0SSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 14:18:49 -0400
Received: from web30504.mail.mud.yahoo.com ([68.142.200.117]:20715 "HELO
	web30504.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754904AbXF0SSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 14:18:48 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2007 14:18:48 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=lH0ytsLtg/sfMu8wQ/cROPF4jZ/TzxRbjwwJc464kuktq/mYQgBo6cMZShmgnvdin5mPJmyT8rHDuCVLsp6Ei/DjeXeQ62w+DjpGaF1/GbuQRxTiCXxXykNUFOTpsWyXuXybC5bNz+y+e1fU5DmQE5/I0918p/41c3bRgBqZ8OM=  ;
Message-ID: <20070627181208.98426.qmail@web30504.mail.mud.yahoo.com>
X-YMail-OSG: Vu1PVrMVM1ke65AoylXliVHJyjr3jc0TG9DtZQj8d1XruD3JOyB4mVDEUup7wITjxA--
Date: Wed, 27 Jun 2007 11:12:08 -0700 (PDT)
From: Casey Leedom <casey_leedom@yahoo.com>
Subject: ZERO_PAGE() vs. loadable modules in Redhat 4.4 i386 kernels ...
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

  I'm working on a driver that does a get_user_pages() for a DMA write.  We
have a timeout on the DMA completion where we mark the pages as COW and return
to the application so it can potentially generate more data in order to
increase throughput, etc.  The problem is that when we traverse the
PGT/PUD/PMD/PTE hierarchy to mark the pages, we sometime fault out when the PUD
covering [0x80000000, 0xc0000000) comes out as zero when that entire region is
covered by a single large malloc()'ed buffer.  This happens because
get_user_pages() returns a reference to empty_zero_page without passing through
the fault path when a page is backed by anonymous memory.  I put a check this
in my driver using ZERO_PAGE() and everything is great.  Except that it doesn't
work on 32-bit i386 Redhat 4.4 kernels because the symbol for empty_zero_page
is not only not exported via EXPORT_SYMBOL() but has also somehow been stripped
from the kallsyms table.  This means that I can't check for the ZERO_PAGE() in
a module.

  Can someone suggest a better way of doing this?  Either by some subterfuge to
get empty_zero_page or perhaps by asking the kernel to instantiate the
PGT/PUD/PMD/PTE hierarchy for a page?  I'm sort of stuck here.  Thanks for any
help and/or advice you can offer.

Casey
