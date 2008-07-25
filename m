Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbYGYSKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbYGYSKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 14:10:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYGYSKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 14:10:04 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:33621 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYGYSKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 14:10:03 -0400
Date: Fri, 25 Jul 2008 11:03:51 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@linux-foundation.org, torvalds@linux-founcation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] hugetlb: fix CONFIG_SYSCTL=n build
Message-ID: <20080725180351.GA11616@us.ibm.com>
References: <20080721.233512.128618365.anemo@mba.ocn.ne.jp> <20080721191519.GA15843@elte.hu> <20080721214258.787a67ca@lxorguk.ukuu.org.uk> <20080722072334.GA25241@elte.hu> <48865899.3030209@garzik.org> <20080723104520.GA20672@elte.hu> <20080724052603.GA8744@elte.hu> <20080725180935.5bd02bf5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080725180935.5bd02bf5@lxorguk.ukuu.org.uk>
X-Operating-System: Linux 2.6.26-rc9-00132-g9df2fe9 (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.07.2008 [18:09:35 +0100], Alan Cox wrote:
> On Thu, 24 Jul 2008 07:26:03 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > not sure it's known but despite all the fixes i still get:
> > 
> >  drivers/built-in.o: In function `ne_drv_resume':
> >  ne.c:(.text+0x146ba4): undefined reference to `NS8390_init'
> >  drivers/built-in.o: In function `ne_block_output':
> >  ne.c:(.text+0x146e00): undefined reference to `NS8390_init'
> 
> This should do the trick. I can't test it currently as that configuration
> now fails to build with mm errors in current git head..
> 
> mm/hugetlb.c: In function ???hugetlb_acct_memory???: mm/hugetlb.c:1507:
> error: implicit declaration of function ???cpuset_mems_nr???

When moving the intialization functions around, I did not remove the
dependency of some helpers on CONFIG_SYSCTL. This led to a large chunk
of code being elided even though it is needed to build hugetlb.o.

Fixes a build failure reported by Alan Cox:

mm/hugetlb.c: In function ‘hugetlb_acct_memory’: mm/hugetlb.c:1507:
error: implicit declaration of function ‘cpuset_mems_nr’

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 41341c4..3be79dc 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1026,7 +1026,6 @@ static void __init report_hugepages(void)
 	}
 }
 
-#ifdef CONFIG_SYSCTL
 #ifdef CONFIG_HIGHMEM
 static void try_to_free_low(struct hstate *h, unsigned long count)
 {
@@ -1386,6 +1385,7 @@ static unsigned int cpuset_mems_nr(unsigned int *array)
 	return nr;
 }
 
+#ifdef CONFIG_SYSCTL
 int hugetlb_sysctl_handler(struct ctl_table *table, int write,
 			   struct file *file, void __user *buffer,
 			   size_t *length, loff_t *ppos)

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
