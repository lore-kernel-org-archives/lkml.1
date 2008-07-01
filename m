Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbYGAOB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbYGAOB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 10:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755859AbYGAOBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 10:01:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:57088 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045AbYGAOBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 10:01:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Maynard Johnson <maynardj@us.ibm.com>
Subject: Re: [PATCH] oprofile: vma_map: fix test on overlay_tbl_offset
Date: Tue, 1 Jul 2008 16:01:20 +0200
User-Agent: KMail/1.9.9
Cc: Roel Kluin <12o3l@tiscali.nl>, phil.el@wanadoo.fr,
       oprofile-list@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>, Carl Love <cel@us.ibm.com>,
       Bob Nelson <rrnelson@linux.vnet.ibm.com>
References: <48074F18.7050802@tiscali.nl> <480F3BB0.9080507@us.ibm.com>
In-Reply-To: <480F3BB0.9080507@us.ibm.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807011601.21540.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18jSv3tcldQWD4Nxb35mFb/KhlilKAitZE6W9m
 kSZ4/d2D4a7o8kOamTbM/fTRqtRtBITR+81pB4IYk0mnSwQW/E
 cRRov27nj/EoYonVhZATA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 April 2008, Maynard Johnson wrote:
> Roel Kluin wrote:
> > Offset is unsigned and when an address isn't found in the vma map
> > vma_map_lookup() returns the vma physical address + 0x10000000.
> >
> > Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> >   
> Patch looks correct.  vma_map_lookup used to return 0xffffffff on a 
> failed lookup, but a change was recently made to return the vma physical 
> address + 0x10000000 (as Roel notes above).  There are two callers of 
> vam_map_lookup: one of them correctly deals with this new return value, 
> but the other (below) did not.  Roel's patch fixes that hole.  Thanks!
> 
> Arnd, can you put this into the Cell tree for pushing upstream?  Thanks.

Sorry for not having looked at this earlier. I'm now queuing up patches
for 2.6.27, but this one looks incorrect:

> > diff --git a/arch/powerpc/oprofile/cell/vma_map.c b/arch/powerpc/oprofile/cell/vma_map.c
> > index 9a93217..1c28e2e 100644
> > --- a/arch/powerpc/oprofile/cell/vma_map.c
> > +++ b/arch/powerpc/oprofile/cell/vma_map.c
> > @@ -229,7 +229,7 @@ struct vma_to_fileoffset_map *create_vma_map(const struct spu *aSpu,
> >  	 */
> >  	overlay_tbl_offset = vma_map_lookup(map, ovly_table_sym,
> >  					    aSpu, &grd_val);
> > -	if (overlay_tbl_offset < 0) {
> > +	if (overlay_tbl_offset >= 0x10000000) {
> >  		printk(KERN_ERR "SPU_PROF: "
> >  		       "%s, line %d: Error finding SPU overlay table\n",
> >  		       __FUNCTION__, __LINE__);
> >

You mention that the kernel can handle the return code correctly, but
this code still prints an error message in that case, which does not
make sense then.

Also, where does the 0x10000000 number come from? Is that the maximum
size that all overlays can consume in one binary?

	Arnd <><
