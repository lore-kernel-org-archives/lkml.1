Return-Path: <linux-kernel-owner+w=401wt.eu-S933214AbXCRW6j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214AbXCRW6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 18:58:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933368AbXCRW6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 18:58:39 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:9142 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214AbXCRW6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 18:58:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=MSjdjpWTDLiBZZLw4fHMIIkxV5WscYhaFb2128nOid4O9rGvygdLlgBh4JcPdDFqItQGx0637nX/yKZ1YHpVpfJmBv2vD/RbFCQrJn/MiMpHeeafzMEaIhILVkMaui3PWKugQD6BujGfMsa9o9hJwrKJyTNfunnqwr+OTa+cfhY=
Date: Mon, 19 Mar 2007 00:58:31 +0200
To: linux-kernel@vger.kernel.org
Subject: i386: Why putting __USER_DS in kernel threads stack initialization?
Message-ID: <20070318225831.GB3802@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

Reading the kernel threads initialization code I see:

int kernel_thread(...) {

	struct pt_regs regs;
	memset(&regs, 0, sizeof(regs));
	[...]
**	regs.xds = __USER_DS;
**	regs.xes = __USER_DS;
	[...]
	/* Ok, create the new process.. */
	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, \
	       	       0, NULL, NULL);

Continuing with the code, the threads stack (beginning from %esp) is
initialized with the passed *regs from do_fork:

int copy_thread(..., struct task_struct *p, struct pt_regs *regs) {

	struct pt_regs * childregs;
	struct task_struct *tsk;
 	childregs = task_pt_regs(p);
**	*childregs = *regs;
	[...]
** 	p->thread.esp = (unsigned long) childregs;


So the question is what will a _kernel_ thread do with the Usermode Segment
address ?

Thanks,

P.S. I've tried commenting out both lines which led to a non functional init,
Also setting them to __USER_DS made init start but stopped issuing the error:
`Panic: Segment violation at 0x8049798 - Sleeping for 30 seconds'

-- 
Ahmed S. Darwish
http://darwish.07.googlepages.com

