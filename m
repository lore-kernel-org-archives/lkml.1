Return-Path: <linux-kernel-owner+w=401wt.eu-S1760201AbXHaPOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760201AbXHaPOU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757508AbXHaPOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:14:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:11259 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbXHaPOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:14:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ncKYgLds98bLqlGIXnHsLTgCdlkWfJzzkN5Alji+g2wWVW1ZrV1HLi/192/fgNfSSNsvd8BlUqho3SyZ3CuDzZdzpV6qIfh/DwcT6CUnqeO6CrcXUKVGFta+GFnOUGQNZcjXTzkClGvSDmbL7L8NnMJG+PTMiK11VCo5BSZvGw8=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] debloat aic7xxx and aic79xx drivers
Date: Fri, 31 Aug 2007 16:13:59 +0100
User-Agent: KMail/1.9.1
Cc: Jan Engelhardt <jengelh@computergmbh.de>, Matthew Wilcox <matthew@wil.cx>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Arjan van de Ven <arjan@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708311613.59666.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 August 2007 14:42, Hannes Reinecke wrote:
> Jan Engelhardt wrote:
> > On Aug 30 2007 13:02, Matthew Wilcox wrote:
> >>> Well, you can send it to Linus/Andrew, that will usually upset people
> >>> and they start commenting on it. Or they don't, and everything is fine.
> >>> (The "default y" approach so to speak ;-)
> >>
> >> The problem is that we don't really have a maintainer for the aic7xyz
> >> drivers any more.  Volunteers welcome.  NOT IT!
> >
> > Take it before someone else does!
>
> Well, the semi-official maintainers are James B. and me.
>
> So I might as well do it officially.

Cool.

Thanks to Arjan's insistence, I also took a look at adding statics
and unexpectedly discovered yet another 50 kbytes of dead code
(I'm not kidding).

Attached are three patches which fix that:

   text    data     bss     dec     hex filename
 261433   50018    1172  312623   4c52f linux-2.6.23-rc1.org.t/drivers/scsi/aic7xxx/built-in.o
 199654   50018    1172  250844   3d3dc linux-2.6.23-rc1.aic.t/drivers/scsi/aic7xxx/built-in.o
 184014   21314    1172  206500   326a4 linux-2.6.23-rc1.aic1.t/drivers/scsi/aic7xxx/built-in.o
 202378    2850    1172  206400   32640 linux-2.6.23-rc1.aic2.t/drivers/scsi/aic7xxx/built-in.o

1-debloat.patch    deinlines a lot of functions
2-addstatic.patch  adds statics, #ifdefs out huge amount of unused code, adds consts
3-addconst.patch   adds more consts

make namespacecheck goes from 400+ functions to:
  drivers/scsi/aic7xxx/aic79xx_core.o
    ahd_inq
    ahd_inw
    ahd_outq
    ahd_outw
  drivers/scsi/aic7xxx/aic79xx_osm.o
    ahd_insb
  drivers/scsi/aic7xxx/aic7xxx_core.o
    ahc_inq
    ahc_outq
  drivers/scsi/aic7xxx/aic7xxx_osm.o
    ahc_insb

None of these patches actually touch any logic, code changes
are pretty minimal.

Compile tested and applies cleanly to 2.6.23-rc1, applies with some fuzz to 2.6.23-rc3.

Please propagate to mainline.
--
vda
