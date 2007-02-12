Return-Path: <linux-kernel-owner+w=401wt.eu-S964818AbXBLJco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818AbXBLJco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 04:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964821AbXBLJco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 04:32:44 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:27658
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964818AbXBLJcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 04:32:43 -0500
Message-Id: <45D0422A.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Mon, 12 Feb 2007 09:32:10 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeff Dike" <jdike@addtoit.com>, "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <patches@x86-64.org>
Subject: Re: [patches] [PATCH 2.6.21 review I] [4/25] x86: kernel-mode
	faults pollute current->thead
References: <200702101250.142420000@suse.de>
 <20070210115016.652C913DCE@wotan.suse.de>
In-Reply-To: <20070210115016.652C913DCE@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <ak@suse.de> 10.02.07 12:50 >>>
>
>From: Jeff Dike <jdike@addtoit.com>
>
>Kernel-mode traps on x86_64 can pollute the trap information for a previous
>userspace trap for which the signal has not yet been delivered to the
>process.
>
>do_trap and do_general_protection set task->thread.error_code and .trapno
>for kernel traps.  If a kernel-mode trap arrives between the arrival of a
>userspace trap and the delivery of the associated SISGEGV to the process,
>the process will get the kernel trap information in its sigcontext.
>
>This causes UML process segfaults, as the trapno that the UML kernel sees
>is 13, rather than the 14 for normal page faults.  So, the UML kernel
>passes the SIGSEGV along to its process.
>
>I don't claim to fully understand the problem.  On the one hand, a check in
>do_general_protection for a pending SIGSEGV turned up nothing.  On the
>other hand, this patch fixed the UML process segfault problem.
>
>The patch below moves the setting of error_code and trapno so that that
>only happens in the case of userspace faults.  As a side-effect, this
>should speed up kernel-mode fault handling a tiny bit.

This breaks consumers of notify_die() relying on the proper trap number being
passed, as the call to notify_die() from die() currently reads
current->thread.trap_no.

Also, you seem to leave other places where trap_no gets set untouched -
is this intentional (do_debug - probably correct here, kernel_math_error -
probably incorrect here)?

>I looked at i386, and there is a similar situation.  In this case, there is
>duplicate code setting task->thread.error_code and trapno.  I deleted one,
>leaving the copy that runs in the case of a userspace fault.

Likewise.

Jan
