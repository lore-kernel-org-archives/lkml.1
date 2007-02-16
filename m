Return-Path: <linux-kernel-owner+w=401wt.eu-S932392AbXBPPGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbXBPPGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:06:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932394AbXBPPGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:06:06 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932392AbXBPPGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:06:05 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <45D5B483.3020502@hitachi.com> 
References: <45D5B483.3020502@hitachi.com>  <45D5B2E3.3030607@hitachi.com> 
To: "Kawai, Hidehiro" <hidehiro.kawai.ez@hitachi.com>
Cc: Andrew Morton <akpm@osdl.org>, kernel list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>, Robin Holt <holt@sgi.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <soshima@redhat.com>,
       "Hideo AOKI@redhat" <haoki@redhat.com>
Subject: Re: [PATCH 3/4] coredump: ELF-FDPIC: enable to omit anonymous shared memory 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Fri, 16 Feb 2007 15:05:35 +0000
Message-ID: <20368.1171638335@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kawai, Hidehiro <hidehiro.kawai.ez@hitachi.com> wrote:

>  static int elf_fdpic_dump_segments(struct file *file, struct mm_struct *mm,
> -				   size_t *size, unsigned long *limit)
> +				   size_t *size, unsigned long *limit,
> +				   unsigned int omit_anon_shared)

Why are you passing it as an extra argument when you could just use
mm->coredump_omit_anon_shared here:

> +		if (!maydump(vma, omit_anon_shared))

And here:

> +		phdr.p_filesz = maydump(vma, omit_anon_shared) ? sz : 0;

Actually, I think I would just pass the mm pointer you have into maydump() and
let that dereference it here:

> +		if (omit_anon_shared) {

which would then be:

		if (mm->coredump_omit_anon_shared) {

Then the calls to maydump() would be:

		if (!maydump(vma, mm))

and:

		phdr.p_filesz = maydump(vma, current->mm) ? sz : 0;

I wouldn't worry, were I you, about the setting changing whilst it's being
used.  If you are worried about that, you can probably do some locking against
that.

David
