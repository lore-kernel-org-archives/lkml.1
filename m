Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbZGPBob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbZGPBob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 21:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbZGPBoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 21:44:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:9221 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909AbZGPBo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 21:44:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,408,1243839600"; 
   d="scan'208";a="708223581"
Subject: Re: [PATCH 8/8] i8042: support device async suspend & shutdown
From: Zhang Rui <rui.zhang@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>
In-Reply-To: <87k52a6x62.fsf@basil.nowhere.org>
References: <1247643522.26272.83.camel@rzhang-dt>
	 <87k52a6x62.fsf@basil.nowhere.org>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 09:45:18 +0800
Message-Id: <1247708718.26272.138.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 18:46 +0800, Andi Kleen wrote:
> Zhang Rui <rui.zhang@intel.com> writes:
> 
> > i8042 controller support device async actions.
> >
> > If boot option "dev_async_action" is added,
> > i8042 controller and its child devices can be
> > suspended/resumed/shutdown asynchronously.
> >
> 
> From a quick look at the i8042 driver it still 
> seems to do a lot of slow actions without actually sleeping
> or worse holding locks. e.g. the delay loop in i8042_flush()
> 
> Did you measure how long that one takes?
> 
> Due to the locks even preempt kernels couldn't do
> something during that time.
> 
> The spinlocks are probably needed when the code is executed
> during interrupts, but perhaps the suspend variant
> could use a different code path.
> 
> Perhaps it only makes sense to do this when this 
> code is converted to sleep during delays too?
> 
most of the psmouse suspend/shutdown time was cost by a ps2 reset
command.
In my test, the serio2 (psmouse) total suspend time is 0.42s, while
the psmouse_reset takes 0.4s.

i.e.
drivers/input/serio/libps2.c

int ps2_command(struct ps2dev *ps2dev, unsigned char *param, int
command)
{
...
/*
 * The reset command takes a long time to execute.
 */
timeout = msecs_to_jiffies(command == PS2_CMD_RESET_BAT ? 4000 : 500);

timeout = wait_event_timeout(ps2dev->wait,
			!(ps2dev->flags & PS2_FLAG_CMD1), timeout);
...
}

so the patch could save suepend/shutdown time a lot, without any other
changes in psmouse driver.

thanks,
rui


