Return-Path: <linux-kernel-owner+w=401wt.eu-S1752154Ab0ABA1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab0ABA1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jan 2010 19:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668Ab0ABA1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jan 2010 19:27:40 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40656 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0ABA1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jan 2010 19:27:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=hf/2gxHBCk+wGewhh79z35xRgEcy28MVHJG7lhumUU4YnTlMaJX4L7r1I/X0MweTRD
         +espyinCosm0dDC/Ss1CVpUvr73wd3OInFcVfzDDkNZ5QrQrXPm2yZZeQ4laTTlZafvs
         90tXeclmI1aisCTYn7pCcGRbYNiJGbBuyrl64=
MIME-Version: 1.0
Date: Fri, 1 Jan 2010 19:27:38 -0500
Message-ID: <6041d2001001011627o5c494df4v37c0c466df3d444c@mail.gmail.com>
Subject: BUG during shutdown - bisected to commit e2912009
From: Marc Dionne <marc.c.dionne@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting a BUG with current kernels from
kernel/time/clockevents.c:263 when halting the system - a restart
behaves normally.  I don't have a good camera handy at the moment to
capture the call stack on screen, but the call sequence is:

clockevents_notify
hrtimer_cpu_notify
notifier_call_chain
raw_notifier_call_chain
_cpu_down
disable_nonboot_cpus
kernel_power_off
sys_reboot

I bisected it down to commit e2912009: sched: Ensure set_task_cpu() is
never called on blocked tasks.  There were a few commits tested along
the way where I got a freeze (with the power still on) instead of a
BUG. Reverting that commit from the current kernel doesn't look
trivial, but the commit immediately preceding this one does halt fine.

Marc
