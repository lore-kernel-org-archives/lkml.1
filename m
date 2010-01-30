Return-Path: <linux-kernel-owner+w=401wt.eu-S1754633Ab0A3TuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab0A3TuY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 14:50:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754612Ab0A3TuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 14:50:20 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:58593 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab0A3TuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 14:50:17 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Radeon KMS regression still present in 2.6.33-rc6
Date: Sat, 30 Jan 2010 20:50:10 +0100
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc5-00306-g64a028a-dirty; KDE/4.3.95; x86_64; ; )
Cc: Kevin Winchester <kjwinchester@gmail.com>, Dave Airlie <airlied@linux.ie>,
       "dri-devel" <dri-devel@lists.sf.net>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Jerome Glisse <jglisse@redhat.com>
References: <1264871899.1533.6.camel@localhost.localdomain> <alpine.LFD.2.00.1001300929260.4206@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1001300929260.4206@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001302050.11897.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 30 Januar 2010 18:43:52 schrieb Linus Torvalds:
> On Sat, 30 Jan 2010, Kevin Winchester wrote:
> > I took a picture of the crash details:
> > 
> > http://picasaweb.google.ca/kjwinchester/LinuxKernelPanic#5432580230065271
> > 634
> > 
> > In case it helps, here is the gdb listing for the problem address:
> > 
> > (gdb) l *(radeon_agp_init+0x1d)
> > 0xffffffff811c1592 is in radeon_agp_init
> > (drivers/gpu/drm/radeon/radeon_agp.c:136). 131		uint32_t agp_status;
> > 132		int default_mode;
> > 133		bool is_v3;
> > 134		int ret;
> > 135
> > 136		if (rdev->ddev->agp->agp_info.aper_size < 32) {
> > 137			dev_warn(rdev->dev, "AGP aperture to small (%dM) "
> > 138				"need at least 32M, disabling AGP\n",
> > 139				rdev->ddev->agp->agp_info.aper_size);
> > 140			return -EINVAL;
> > 
> > Is there any other info I can provide?
> 
> In your crash 'rdev->ddev->agp' is NULL. The instruction decode is:
> 
>    e:	55                   	push   %rbp
>    f:	48 89 e5             	mov    %rsp,%rbp
>   12:	41 56                	push   %r14
>   14:	41 55                	push   %r13
>   16:	41 54                	push   %r12
>   18:	53                   	push   %rbx
>   19:	48 89 fb             	mov    %rdi,%rbx
>   1c:	48 83 ec 40          	sub    $0x40,%rsp
>   20:	48 8b 7f 08          	mov    0x8(%rdi),%rdi
>   24:	48 8b 87 20 03 00 00 	mov    0x320(%rdi),%rax
>   2b:*	4c 8b 60 28          	mov    0x28(%rax),%r12     <-- trapping
> instruction 2f:	49 83 fc 1f          	cmp    $0x1f,%r12
>   33:	77 2e                	ja     0x63
>   35:	48 8b 3b             	mov    (%rbx),%rdi
>   38:	48 8b 5f 10          	mov    0x10(%rdi),%rbx
> 
> so it's that lod of "agp_info.aper_size" that fails (you can see how it's
> trying to compare with 31, it comes from that "agp_info.aper_size < 32"
> thing.
> 
> Did that DRM init happen before AGP init or something?
> 
> 		Linus

This is caused by commit 42590a75019a50012f25a962246498dead42843

Fix is already posted:

http://marc.info/?l=linux-kernel&m=126428141429200&w=2
