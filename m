Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbZJBQli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbZJBQli (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 12:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbZJBQlh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 12:41:37 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:50689 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756663AbZJBQlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 12:41:37 -0400
Date: Fri, 2 Oct 2009 09:40:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 2: percpu compile warnings (i386)
Message-Id: <20091002094030.ffbde6ca.randy.dunlap@oracle.com>
In-Reply-To: <20091002134718.f577be51.sfr@canb.auug.org.au>
References: <20091002134718.f577be51.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4AC62D00.007A:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm/percpu.c:1873: warning: comparison of distinct pointer types lacks a cast
mm/percpu.c:1879: warning: format '%lx' expects type 'long unsigned int', but argument 2 has type 'size_t'

The second one is easily fixed (s/%lx/%zu/), but is that the correct fix?

The first one is a max(size_t, unsigned long).
The C99 spec says that the max value of a size_t is:
	limit of size_t
	SIZE_MAX 65535
(from 7.8.13(2)), but max_distance (the size_t here) is being compared to
unsigned long base_offset, which isn't limited to 65535 AFAICT.

In fact, this test:
	if (max_distance > (VMALLOC_END - VMALLOC_START) * 3 / 4) {
checks max_distance > 0x000017ff_ffffffff (on x86_64).

And it looks to me like there is some potential for some value truncation
in the max() operation, even if size_t is not limited to SIZE_MAX.

So maybe the size_t(s) should be changed to unsigned long and the
printk format doesn't need to be fixed... ?

---
~Randy
