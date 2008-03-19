Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbYCSTqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbYCSTqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbYCSTbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:31:51 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:33184 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbYCSTbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:31:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=LhqwROepd2su9UWkZYeIxdPt59DP6U7QGn7FaQmF2lAN6PgoDiuJsZ+QtIcJD9CJ4TsLawVgv8F+4umG7rKHzr3bI23V3S4ALOwihg5AZmRh0gWWQFPFPTGJBRWE/eO36/ekIduW5eO0FHkkViia9DdF20v4540svKEjjnbUqGM=
From: "Roy Lee" <roylee17@gmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] give elf_check_arch() a chance for checking endian mismatch
Date: Thu, 20 Mar 2008 03:03:30 +0800
Message-ID: <000101c889f3$ef5989e0$ce0c9da0$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AciJ8+tA8DXMgPtoSTqggwH1ilCc0w==
Content-Language: zh-tw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd like to warn for endianess mismatch, or unsupported feature( hardware
float point support) when loading an ELF file.
The problem is that if the endianess mismatches happens, the logic inside
the elf_check_arch() won't have a chance to be executed.
Because the "elf_ex.e_type" would be misinterpreted and the elf_check_arch()
will be skipped.
This patch should give elf_check_arch() more chance to do some machine
dependent checking.

Roy

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 672a3b9..2ffbe49 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -567,10 +567,10 @@ static int load_elf_binary(struct linux_binprm *bprm,
struct pt_regs *regs)
        if (memcmp(loc->elf_ex.e_ident, ELFMAG, SELFMAG) != 0)
                goto out;

-       if (loc->elf_ex.e_type != ET_EXEC && loc->elf_ex.e_type != ET_DYN)
-               goto out;
        if (!elf_check_arch(&loc->elf_ex))
                goto out;
+       if (loc->elf_ex.e_type != ET_EXEC && loc->elf_ex.e_type != ET_DYN)
+               goto out;
        if (!bprm->file->f_op||!bprm->file->f_op->mmap)
                goto out;


