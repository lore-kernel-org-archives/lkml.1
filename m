Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254Ab0CEECp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 23:02:45 -0500
Received: from mail.digidescorp.com ([66.244.163.200]:22936 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab0CEECo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 23:02:44 -0500
X-Spam-Processed: digidescorp.com, Thu, 04 Mar 2010 22:02:43 -0600
X-Authenticated-Sender: steve@digidescorp.com
X-MDRemoteIP: 99.142.47.99
X-Return-Path: prvs=16809811db=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: [BUG?][NOMMU] microblaze: scheduling with interrupts disabled
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: microblaze-uclinux@itee.uq.edu.au, monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Thu, 04 Mar 2010 22:02:40 -0600
Message-Id: <1267761760.11837.7.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I ran across the following code in kernel/entry-nommu.S:

work_pending:
	andi	r11, r19, _TIF_NEED_RESCHED
	beqi	r11, 1f
	bralid	r15, schedule
	nop
1:	andi	r11, r19, _TIF_SIGPENDING
	beqi	r11, no_work_pending
	addk	r5, r1, r0
	addik	r7, r0, 1
	bralid	r15, do_signal
	addk	r6, r0, r0
	bri	no_work_pending

ENTRY(ret_to_user)
	disable_irq

	swi	r4, r1, PT_R4		/* return val */
	swi	r3, r1, PT_R3		/* return val */

	lwi	r6, r31, TS_THREAD_INFO /* get thread info */
	lwi	r19, r6, TI_FLAGS /* get flags in thread info */
	bnei	r19, work_pending
no_work_pending:
	disable_irq

If I am reading this correctly, it looks like schedule() and do_signal()
can get called with interrupts disabled. This looks like a bug to me. I
would propose to fix it by putting an enable_irq at work_pending.

Comments?
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>





