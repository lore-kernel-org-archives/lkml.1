Return-Path: <linux-kernel-owner+w=401wt.eu-S964968AbXBYPsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968AbXBYPsk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 10:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964972AbXBYPsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 10:48:40 -0500
Received: from mba.ocn.ne.jp ([210.190.142.172]:52271 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964968AbXBYPsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 10:48:39 -0500
Date: Mon, 26 Feb 2007 00:48:38 +0900 (JST)
Message-Id: <20070226.004838.126574842.anemo@mba.ocn.ne.jp>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Detecting section mismatches in vmlinux
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20070224232527.GA10768@uranus.ravnborg.org>
References: <20070222.005728.126762028.anemo@mba.ocn.ne.jp>
	<20070225.035315.25909736.anemo@mba.ocn.ne.jp>
	<20070224232527.GA10768@uranus.ravnborg.org>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 3.3 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Feb 2007 00:25:27 +0100, Sam Ravnborg <sam@ravnborg.org> wrote:
> Attached patch does:
> 1) Do not check vmlinux but check all .o files that is used to create vmlinux
> 2) Teach modpost to skip non-elf files (.a files and empty .o files etc)
> 
> With this change we get proper check of vmlinux (or files used to create vmlinux)

Thanks!  It works fine for me too.

> This gives following errors in a x86_64 defconfig build:
> 
> WARNING: init/built-in.o - Section mismatch: reference to .init.text:init from .text between 'rest_init' (at offset 0xe) and 'run_init_process'

This is because rest_init() (non __init) references 'init' (__init) as
an argument of kernel_thread().  No idea how to avoid this warning...

> WARNING: mm/built-in.o - Section mismatch: reference to .init.data:initkmem_list3 from .text between 'set_up_list3s' (at offset 0x1e6fb) and 'slab_get_obj'
> WARNING: mm/built-in.o - Section mismatch: reference to .init.data:initkmem_list3 from .text between 'set_up_list3s' (at offset 0x1e71c) and 'slab_get_obj'

This is because set_up_list3s() (non __init) references
initkmem_list3[] (__initdata).  The set_up_list3s() is only used on
early stage so can be __init, but it cause an another mismatch ---
setup_cpu_cache() (non __init) calls __init function.  Some trick
using a function pointer might solve this issue, but I wonder it is a
right thing to do...

Or we need another whitelist for vmlinux?

---
Atsushi Nemoto
