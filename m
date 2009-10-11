Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbZJKPQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbZJKPQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 11:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbZJKPQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 11:16:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752946AbZJKPQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 11:16:23 -0400
Date: Sun, 11 Oct 2009 17:20:56 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
       mark.langsdorf@amd.com, Rusty Russell <rusty@rustcorp.com.au>,
       Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Subject: Re: use after free of struct powernow_k8_data
Message-ID: <20091011172056.387bafeb@leela>
In-Reply-To: <20090930133059.995c34b4.akpm@linux-foundation.org>
References: <20090924165125.7cf51a1f@leela>
 <20090930133059.995c34b4.akpm@linux-foundation.org>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Wed, 30 Sep 2009 13:30:59 -0700 Andrew Morton napsal:
> On Thu, 24 Sep 2009 16:51:25 +0200
> Michal Schmidt <mschmidt@redhat.com> wrote:
> 
> > Hello,
> > 
> > After resume from suspend I get:
> > 
> > =============================================================================
> > BUG kmalloc-256: Poison overwritten
> > -----------------------------------------------------------------------------
> > 
> > INFO: 0xffff880073bf1bb0-0xffff880073bf1bb7. First byte 0x12
> > instead of 0x6b INFO: Allocated in powernowk8_cpu_init+0x72/0xc27
> > [powernow_k8] age=290 cpu=0 pid=1782 INFO: Freed in
> > powernowk8_cpu_exit+0x6b/0x88 [powernow_k8] age=289 cpu=0 pid=1782
> > INFO: Slab 0xffffea0002f059e8 objects=12 used=10
> > fp=0xffff880073bf1b88 flags=0x200000000000c3 INFO: Object
> > 0xffff880073bf1b88 @offset=2952 fp=0xffff880073bf1e18
> > 
> > Bytes b4 0xffff880073bf1b78:  ec 77 fe ff 00 00 00 00 5a 5a 5a 5a
> > 5a 5a 5a 5a __w____....ZZZZZZZZ Object 0xffff880073bf1b88:  6b 6b
> > 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk Object
> > 0xffff880073bf1b98:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> > 6b kkkkkkkkkkkkkkkk Object 0xffff880073bf1ba8:  6b 6b 6b 6b 6b 6b
> > 6b 6b 12 00 00 00 0c 00 00 00 kkkkkkkk........ Object
> > 0xffff880073bf1bb8:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b
> > 6b kkkkkkkkkkkkkkkk
> > 
> > The overwritten values correspond to the currvid (0x12) and currfid
> > (0x0c) fields if struct powernow_k8_data. Earlier in dmesg these
> > exact values can be seen:
> > 
> > powernow-k8: table matched fid 0xc, giving vid 0x12
> > powernow-k8: target matches current values (fid 0xc, vid 0x12)
> > 
> > It seems that something called
> > query_current_values_with_pending_wait() while the struct was
> > already freed.
> > 
> > It is perfectly reproducible. The kernel is the latest from git
> > (94a8d5caba74211ec76dac80fc6e2d5c391530df).
> > I'm attaching the full dmesg and .config.
> > 
> 
> Do you know if this is a regression?  If so, since which kernel
> version?

It is a regression in 2.6.31. With 2.6.30 it is not reproducible.
It is still reproducible in current git
(bd381934bf13ccb1af2813ae26c6fe00ec85d254).

ftrace showed that powernowk8_get() gets called by the "kacpi_notify"
kernel thread. This gave me the idea to try booting with
"processor.ignore_ppc" parameter - this avoids the bug.

The bug also goes away if these two commits are reverted:

commit 1ff6e97f1d993dff2f9b6f4a9173687370660232
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Fri Jun 12 20:55:37 2009 +0930

    [CPUFREQ] cpumask: avoid playing with cpus_allowed in powernow-k8.c

commit e15bc4559b397a611441a135b1f5992f07d0f436
Author: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Date:   Thu Jun 11 15:26:54 2009 +0000

    [CPUFREQ] powernow-k8: get drv data for correct CPU

Michal
