Return-Path: <linux-kernel-owner+w=401wt.eu-S1752029AbXCYSy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbXCYSy3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 14:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbXCYSy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 14:54:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:29910 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbXCYSyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 14:54:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=NU6o/Pa345ay950UaB9UYPGLuSoHHUySv6iXz0opopHMtdDgZIoYc8DJHEDe8XYNPzIADBzAmVenGfoVOiMcxzAtInp+9vX2cz8RDArQtZggzZ2424Ml6W4KAgzA5fJjgU4ApJ6FUzHPoWdyBRsSWLI4Oydq3OPTPumDvZGHfyA=
Date: Sun, 25 Mar 2007 23:53:46 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mchehab@infradead.org, video4linux-list@redhat.com
Subject: Interesting locking in vivi driver
Message-ID: <20070325195346.GB5308@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have some question: what's going on? How can it work?

Local spinlock _on_stack_, initialized, acquired and dropped.

drivers/media/video/vivi.c:
   271	static void gen_line(struct sg_to_addr to_addr[],int inipos,int pages,int wmax,
   272			     int hmax, int line, char *timestr)
   273	#else
   274	static void gen_line(char *basep,int inipos,int wmax,
   275			     int hmax, int line, char *timestr)
   276	#endif
   277	{
   278		int  w,i,j,pos=inipos,y;
   279		char *p,*s;
   280		u8   chr,r,g,b,color;
   281	#ifdef CONFIG_VIVI_SCATTER
   282		int pgpos,oldpg;
   283		char *basep;
   284		struct page *pg;
   285
   286		unsigned long flags;
   287	===>	spinlock_t spinlock;			<===
   288
   289	===>	spin_lock_init(&spinlock);		<===
   290
   291		/* Get first addr pointed to pixel position */
   292		oldpg=get_addr_pos(pos,pages,to_addr);
   293		pg=pfn_to_page(sg_dma_address(to_addr[oldpg].sg) >> PAGE_SHIFT);
   294	===>	spin_lock_irqsave(&spinlock,flags);	<===
   295		basep = kmap_atomic(pg, KM_BOUNCE_READ)+to_addr[oldpg].sg->offset;
   296	#endif

