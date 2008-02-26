Return-Path: <linux-kernel-owner+w=401wt.eu-S932239AbYBZV6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239AbYBZV6s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 16:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765687AbYBZV6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 16:58:33 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:56295 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764879AbYBZV6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 16:58:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=trvcMY4re05aWDD5B8AQPHd4IK6GB7/vylzSFBl4IDMFgwgyW6cJSNHiRAowOMFRjBqVTooK7yTkXsBkdNHV840G3w4yWHU1oYOcRDfeGlBJ6Msk5Zbc+yEDbJGYHZ0oaZRjHyP105CLwGm/azGSpz0WGjsfDv3QCIZdWMeazgY=
Message-ID: <ba7d8f720802261358h31e30308ob4d99e05a34cf584@mail.gmail.com>
Date: Tue, 26 Feb 2008 16:58:28 -0500
From: "Dan Upton" <upton.dan.linux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: rdmsr_safe_on_cpu hangs?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing this behavior in both 2.6.23.14 and 2.6.24.3, on x86-64 on
a Core2 Duo.  Where I'm working on temperature-based scheduling, I've
added a few places that basically duplicate the calls to rdmsr_on_cpu
from hwmon/coretemp.c to places in sched.c and sched_debug.c.  All of
the instances in sched_debug.c are of course only accessed once the
system has booted all the way, and I haven't run into any problems
reading (and getting correct values) like that.  When I saw
rdmsr_on_cpu hang, I switched to using rdmsr_safe_on_cpu.  I thought
that was supposed to fail gracefully, but it still seems to be
hanging.  I have two different problems:

-In the 2.6.23.14 kernel, I was trying to read via a function called
from sched_balance_self.  It seems to work fine until it becomes aware
of the second core (ie, rdmsr_safe_on_cpu(0, IA32_THERM_STATUS, &eax,
&edx) works fine, but rdmsr_safe_on_cpu(1, ...) never returns).
-In the 2.6.24.3 kernel, it works fine when I call it from
sched_balance_self.  I added another place to call the function from
prepare_task_switch, so I could save some relevant information before
swapping the task away, and it eventually hangs reading on core
0--obviously after "Booting the kernel", but before "Red Hat nash"
starting.

I guess the question is, am I just misunderstanding the use of
rdmsr_safe_on_cpu, or is it an issue with that particular MSR (some of
the stuff I've read indicates that rdmsr_safe was really only
implemented as a prequel to the coretemp driver), or is it something
wrong with rdmsr_safe_on_cpu?

-dan
