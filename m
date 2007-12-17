Return-Path: <linux-kernel-owner+w=401wt.eu-S1760441AbXLQTDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441AbXLQTDa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbXLQTDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:03:22 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3011 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671AbXLQTDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:03:21 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Matt Mackall <mpm@selenic.com>
Subject: Re: 2.6.24-rc5-mm1: problems with cat /proc/kpageflags
Date: Mon, 17 Dec 2007 20:05:37 +0100
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, davem@davemloft.net
References: <20071213024050.7d6e5f3e.akpm@linux-foundation.org> <200712162010.11028.m.kozlowski@tuxland.pl> <20071217021149.GC19691@waste.org>
In-Reply-To: <20071217021149.GC19691@waste.org>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200712172005.38483.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> > cat /proc/kpagecount on the other hand - with the change in line 710
> > - locks the box. Sysrq works, changing consoles works, but there is
> > no "BUG: soft lockup ..." message. After a while the box becomes
> > totaly unresponsive - even caps lock doesn't work, no responses to
> > ping.
> 
> Well I'm baffled. There's basically two things in that function that
> do anything interesting: pfn_to_page and put_user. access_ok is
> "return 1" on Sparc64. atomic_read is a simple read.
>
> My usual approach at this point would be to litter it with printks and
> see where its hanging.

Ok. Maybe this will help. Don't know how to compare that to the results from yesterday
(test with ppage = NULL) - maybe I f.... something up. This time I added a bunch
of printks and got these results:

This is from 'cat /proc/kpageflags' (after this the box is locked):

    01
    pfn:0, src:0, KPMSIZE:8
    23458
    ppage:0000000200000000, pfn:1

and the relevant code:

static ssize_t kpageflags_read(struct file *file, char __user *buf,
			     size_t count, loff_t *ppos)
{

	u64 __user *out = (u64 __user *)buf;
	struct page *ppage;
	unsigned long src = *ppos;
	unsigned long pfn;
	ssize_t ret = 0;
	u64 kflags, uflags;

printk("0");

	if (!access_ok(VERIFY_WRITE, buf, count))
		return -EFAULT;

printk("1");
	pfn = src / KPMSIZE;
printk("\npfn:%u, src:%u, KPMSIZE:%d\n", pfn, src, KPMSIZE);
	count = min_t(unsigned long, count, (max_pfn * KPMSIZE) - src);

printk("2");
	if (src & KPMMASK || count & KPMMASK)
		return -EIO;

printk("3");
	while (count > 0) {
printk("4");
	ppage = pfn_to_page(pfn++);
printk("5");
		if (!ppage) {
printk("6");
			kflags = 0;
printk("7");
		} else {
printk("8");
printk("\nppage:%p, pfn:%u\n", ppage, pfn);
			kflags = ppage->flags; // <---------------- something bad happens
printk("9");
		}

printk("a");



This is from 'cat /proc/kpagecount' (after this the box is locked)

    01
    pfn:0, src:0, KPMSIZE:8
    23567a
    ppage:0000000200000000, pfn:1

and this is the relevant code:

static ssize_t kpagecount_read(struct file *file, char __user *buf,
			     size_t count, loff_t *ppos)
{

	u64 __user *out = (u64 __user *)buf;
	struct page *ppage;
	unsigned long src = *ppos;
	unsigned long pfn;
	ssize_t ret = 0;
	u64 pcount;
printk("0");
	if (!access_ok(VERIFY_WRITE, buf, count))
		return -EFAULT;

printk("1");
	pfn = src / KPMSIZE;
printk("\npfn:%u, src:%u, KPMSIZE:%d\n", pfn, src, KPMSIZE);

printk("2");
	count = min_t(size_t, count, (max_pfn * KPMSIZE) - src);
printk("3");
	if (src & KPMMASK || count & KPMMASK) {

printk("4");
		return -EIO;
	}
printk("5");
	while (count > 0) {
printk("6");
		ppage = pfn_to_page(pfn++);
printk("7");
		if (!ppage) {
printk("8");
			pcount = 0;
		} else {
printk("a");
printk("\nppage:%p, pfn:%u\n", ppage, pfn);
			pcount = atomic_read(&ppage->_count); // <---------------- something bad happens
printk("b");
		}


Regards,

	Mariusz
