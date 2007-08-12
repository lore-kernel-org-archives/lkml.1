Return-Path: <linux-kernel-owner+w=401wt.eu-S1763858AbXHLAbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763858AbXHLAbA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 20:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758018AbXHLAas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 20:30:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:64278 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbXHLAaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 20:30:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=rQWvV1xlrjBUXidNejgzPNSsv/A3EFC/PRFFVS7PPqzrN3e3KsvFIcL+Z9Co44Zdt3MNC0O8Shn4EdPgjSoCrPgfq4fmriGfqBDU7dD4gv3xXpCJj1JrT//a8qs7sn67wRyqaCNtFd895p26eIPeabNrrF+hoH1whG/99vDOWts=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-scsi@vger.kernel.org
Subject: cciss: warning: right shift count >= width of type
Date: Sun, 12 Aug 2007 02:28:26 +0200
User-Agent: KMail/1.9.7
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708120228.26234.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been building some randconfig kernels lately and I've noticed 
this in a few builds : 

drivers/block/cciss.c:2614: warning: right shift count >= width of type
drivers/block/cciss.c:2615: warning: right shift count >= width of type
drivers/block/cciss.c:2616: warning: right shift count >= width of type

The code in question is this : 

static void do_cciss_request(struct request_queue *q)
{
...
        sector_t start_blk;
...
                        c->Request.CDB[2]= (start_blk >> 56) & 0xff;    //MSB
                        c->Request.CDB[3]= (start_blk >> 48) & 0xff;
                        c->Request.CDB[4]= (start_blk >> 40) & 0xff;
...
}


The problem stems from these lines in include/linux/types.h : 
...
#ifdef CONFIG_LBD
typedef u64 sector_t;
#else
typedef unsigned long sector_t;
#endif
...

So on a 32bit arch without CONFIG_LBD, sector_t is going to be 32 bits wide.
Thus it seems gcc is absolutely right in complaining about those 
56, 48 & 40 bit shifts, since they are indeed wider than the type 
in the "!CONFIG_LBD on a 32bit arch" case.


I must admit that I have no idear what the proper way to deal with 
that is, so I'll just report it so hopefully someone else can fix it.

By the way; I'm building current Linus git tree, head at commit 
ac07860264bd2b18834d3fa3be47032115524cea


Kind regards,
  Jesper Juhl


