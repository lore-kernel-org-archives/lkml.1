Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZBRAxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZBRAxL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:53:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755875AbZBRAws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:52:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33501 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbZBRAwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:52:46 -0500
Message-ID: <499B5BCA.8000905@zytor.com>
Date: Tue, 17 Feb 2009 16:52:26 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Engelhardt <jengelh@medozas.de>, Alain Knaff <alain@knaff.lu>,
       the arch/x86 maintainers <x86@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: tip: bzip2/lzma now in tip:x86/setup-lzma
References: <200901042146.n04LkHgP005837@hitchhiker.hitchhiker.org.lu.hitchhiker.org.lu> <4961415C.1050708@zytor.com> <49614243.70102@knaff.lu> <496142E4.8040308@zytor.com> <49614491.7020903@knaff.lu> <49614D1F.8020900@zytor.com> <alpine.LSU.2.00.0902172202230.5620@fbirervta.pbzchgretzou.qr> <499B267E.2090509@zytor.com> <20090217220825.GA24337@elte.hu> <20090217233708.GA10756@elte.hu>
In-Reply-To: <20090217233708.GA10756@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> still fails:
> 
> [    3.196037] initcall inet_init+0x0/0x1e9 returned 0 after 101777 usecs           
> [    3.202886] calling  af_unix_init+0x0/0x55 @ 1                                   
> [    3.207461] NET: Registered protocol family 1                                    
> [    3.211950] initcall af_unix_init+0x0/0x55 returned 0 after 4394 usecs           
> [    3.218624] calling  populate_rootfs+0x0/0xd2 @ 1                                
> [    3.223460] Kernel panic - not syncing: compression method gzip not configured   
> 
> config attached.
> 

Okay, I think I've tracked down the problem.

The issue is that usr/Makefile doesn't correctly filter compression 
methods which we don't support.  This particular case will happen when 
you're building with Ingo's attached configuration *and no bzip2 tool 
installed on the system*.

Basically, the algorithm used in usr/Makefile is simply wrong.

The claim is:

+# Find out "preferred" ramdisk compressor. Order of preference is
+#  1. bzip2 efficient, and likely to be present
+#  2. gzip former default
+#  3. lzma
+#  4. none
+
+# None of the above
+suffix_y                   =
+
+# Lzma, but no gzip nor bzip2
+suffix_$(CONFIG_RD_LZMA)   = .lzma
+
+# Gzip, but no bzip2
+suffix_$(CONFIG_RD_GZIP)   = .gz
+
+# Bzip2
+suffix_$(CONFIG_RD_BZIP2)  = .bz2

This doesn't end up make any sense.  The sanest thing to do is to 
compress with all the compressors that are configured into the kernel, 
and then use the smallest image of the ones that can be produced, 
*including the uncompressed image*.  Including the uncompressed image 
will guarantee that we always have a working option.

	-hpa
