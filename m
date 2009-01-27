Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbZA0IG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbZA0IG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 03:06:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZA0IGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 03:06:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138AbZA0IGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 03:06:15 -0500
Date: Tue, 27 Jan 2009 00:04:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Tomas Carnecky <tom@dbservice.com>, bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12492] Re: [patch 1/2] stop_machine: introduce
 stop_machine_create/destroy.
Message-Id: <20090127000432.65042e85.akpm@linux-foundation.org>
In-Reply-To: <20081222114529.601526881@de.ibm.com>
References: <20081222113629.080104676@de.ibm.com>
	<20081222114529.601526881@de.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2008 12:36:30 +0100 Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> Introduce stop_machine_create/destroy. With this interface subsystems
> that need a non-failing stop_machine environment can create the
> stop_machine machine threads before actually calling stop_machine.
> When the threads aren't needed anymore they can be killed with
> stop_machine_destroy again.
> 
> When stop_machine gets called and the threads aren't present they
> will be created and destroyed automatically. This restores the old
> behaviour of stop_machine.
> 
> This patch also converts cpu hotplug to the new interface since it
> is special: cpu_down calls __stop_machine instead of stop_machine.
> However the kstop threads will only be created when stop_machine
> gets called.
> 
> Changing the code so that the threads would be created automatically
> on __stop_machine is currently not possible: when __stop_machine gets
> called we hold cpu_add_remove_lock, which is the same lock that
> create_rt_workqueue would take. So the workqueue needs to be created
> before the cpu hotplug code locks cpu_add_remove_lock.

In http://bugzilla.kernel.org/show_bug.cgi?id=12492, Thomas (cc'ed
here) reports

  Commit 9ea09af3bd3090e8349ca2899ca2011bd94cda85 introduced a
  regression that caused the kernel to fail to suspend.  The 'sleeping'
  LED on the laptop just keeps blinking and the laptop never shuts
  down.  I think this was eventually fixed because with 2.6.29-rc1 and
  -rc2 the laptop suspends fine, but fails to resume.  When I try to
  resume, all I see is a blinking cursor in the top left corner of the
  screen.

  I'm using acpi_sleep=s3_bios,s3_mode, suspending using a script
  that does: echo mem > /sys/power/state.


