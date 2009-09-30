Return-Path: <linux-kernel-owner+w=401wt.eu-S1753846AbZI3BLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbZI3BLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 21:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbZI3BLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 21:11:06 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:14784 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752378AbZI3BLF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 21:11:05 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: futex question
Date: Tue, 29 Sep 2009 18:10:41 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: futex question
Thread-Index: AcpBatP6+iksCfysTge7pnJd9w7SvQ==
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Folks:

We are observing something interesting regarding how task->robust_list
pointer is being handled across a sys_execve() call. If a task does a
sys_set_robust_list() with a certain head pointer and then at some point
does a execve() call to over-write it's address space, the 'robust-list'
pointer is never cleared. So in essence what happens is that during task
exit, within mm_release(), the 
if (unlikely(tsk->robust_list)) condition might still be true because
the pointer has a non-null address. However, the actual address value
may not belong to the new address space or point to something else
within the new address space. Should we not just clear the pointer (and
it's compat version) within do_execve()?

Granted, within exit_robust_list(), the fetch_robust_entry() calls will
fail and bail out of the function. So in essence, nothing bad should
happen. However, that extra code should save us from entering
exit_robust_list() in the first place.

CCing Ingo since the robust futex support was started by him.

Cheers,

Ani
 
