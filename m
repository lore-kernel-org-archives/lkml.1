Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbZF3JMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbZF3JMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 05:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbZF3JM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 05:12:28 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:46645 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZF3JM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 05:12:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=EIfo7dvtVwi/NbgU61/unDe3/jI6yt6qweqHacz9bWmMllIrsX9CwZHQMjZryAGAe7
         s+NIHzY0Dy5t/3TS27fVx0hHvcUdIGs5M8maM3TGcL7HPEOrhh0PhEx8MDH8tgcsyOZ0
         mOXICbNymlyhrszBqOJzG28UEz+2ELUjGLS+0=
MIME-Version: 1.0
Date: Tue, 30 Jun 2009 17:12:31 +0800
Message-ID: <daef60380906300212p2a461537p9730686084a9ef8d@mail.gmail.com>
Subject: [PATCH] Fix the multithread program core thread message error
From: Hui Zhu <teawater@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the multithread program core thread message error.
The thread message of core file is generated in
elf_dump_thread_status.  The register values is set by
elf_core_copy_task_regs in this function.
static inline int elf_core_copy_task_regs(struct task_struct *t,
					   elf_gregset_t* elfregs)
{

	return ELF_CORE_COPY_TASK_REGS(t, elfregs);
	return 0;
}
If a arch doesn't define ELF_CORE_COPY_TASK_REGS, This function will do
nothing.  Then the core file will not have the register message of
thread.
So add elf_core_copy_regs to set regiser values if
ELF_CORE_COPY_TASK_REGS doesn't define.
---
 elfcore.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index 7605c5e..03ec167 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -125,6 +125,8 @@ static inline int elf_core_copy_task_regs(struct
task_struct *t, elf_gregset_t*
 #ifdef ELF_CORE_COPY_TASK_REGS

        return ELF_CORE_COPY_TASK_REGS(t, elfregs);
+#else
+       elf_core_copy_regs(elfregs, task_pt_regs(t));
 #endif
        return 0;
 }
