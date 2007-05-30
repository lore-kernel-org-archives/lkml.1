Return-Path: <linux-kernel-owner+w=401wt.eu-S1752244AbXE3LDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbXE3LDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 07:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbXE3LDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 07:03:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:54129 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbXE3LDi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 07:03:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: [Cbe-oss-dev] [RFC] Cell: shutdown method for spu_sysdev_class
Date: Wed, 30 May 2007 13:03:09 +0200
User-Agent: KMail/1.9.6
Cc: cbe-oss-dev@ozlabs.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       Geoff Levand <geoffrey.levand@am.sony.com>
References: <463D1A2F.10708@am.sony.com> <200705292023.49968.arnd@arndb.de> <20070530095821.GA24373@lst.de>
In-Reply-To: <20070530095821.GA24373@lst.de>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200705301303.09616.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/ZrigjEi92t7zAB1QTbCXxnRp1rlH/xLJaJHO
 V4yjviZbr3O7D8u85juMbW7ab6Aovo/5jezLfXCCU2aB6X30WJ
 MBbvFwFqPTnXK3IfKQcwA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 May 2007, Christoph Hellwig wrote:
> 
> > Is it documented or implied somewhere that ->shutdown must not free
> > the device? If not, the first option is probably the safer choice.
> 
> It's not documented anywhere, but implicitly assumed.  I don't know
> of any shutdown implementation that frees the device.

Right, I found the explanation now myself:

The ->shutdown method is called for system devices that are still
part of a linked linked list. Freeing the object would destroy that
list.

Geoff, please merge the patch below in your tree.

	Arnd <><
---

Subject: cell: don't free spu objects in sysdev shutdown

From: Arnd Bergmann <arnd.bergmann@de.ibm.com>
System devices are accessed after they are shut down, so
we must not free the data structures.

Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Index: linux-2.6/arch/powerpc/platforms/cell/spu_base.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spu_base.c
+++ linux-2.6/arch/powerpc/platforms/cell/spu_base.c
@@ -517,7 +517,6 @@ static int spu_shutdown(struct sys_devic
 
 	spu_free_irqs(spu);
 	spu_destroy_spu(spu);
-	kfree(spu);
 	return 0;
 }
 
