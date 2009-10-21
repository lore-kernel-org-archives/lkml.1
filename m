Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZJUUEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZJUUEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbZJUUEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:04:41 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:31951 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZJUUEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:04:41 -0400
Date: Wed, 21 Oct 2009 13:03:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       "discuss@LessWatts.org" <discuss@LessWatts.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>, Corey Minyard <minyard@acm.org>
Subject: Re: [Discuss] [PATCH] ipmi: use round_jiffies on timers to reduce
 timer overhead/wakeups
Message-Id: <20091021130348.cd521b0c.randy.dunlap@oracle.com>
In-Reply-To: <4ADF57D7.7010808@intel.com>
References: <20091021102822.5b32b2dc.randy.dunlap@oracle.com>
	<20091021114210.4d7e1ea9@linux.intel.com>
	<4ADF57D7.7010808@intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4ADF6943.0013:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Oct 2009 11:49:59 -0700 Kok, Auke wrote:

> Arjan van de Ven wrote:
> > On Wed, 21 Oct 2009 10:28:22 -0700
> > Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > 
> >> From: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >> Use a round_jiffies() variant to reduce overhead of timer
> >> wakeups.  This causes the ipmi timers to occur at the same
> >> time as other timers (per CPU).
> >>
> >> Typical powertop for /ipmi/ (2.6.31, before patch):
> >>   11.4% (247.4)            kipmi0 : __mod_timer (process_timeout) 
> >>    0.6% ( 13.1)       <interrupt> : ipmi_si 
> >>    0.5% ( 10.0)     <kernel core> : __mod_timer (ipmi_timeout) 
> >>
> >> powertop for /ipmi/, 2.6.31, after patch:
> >>   10.8% (247.6)            kipmi0 : __mod_timer (process_timeout) 
> >>    0.3% (  6.9)       <interrupt> : ipmi_si 
> >>    0.0% (  1.0)     <kernel core> : __mod_timer (ipmi_timeout)
> > 
> > while it is nice that ipmi_si ande the timer wake up less now.... it's
> > still rather sad that the 247.6 from kipmi0 are still there..... those
> > are a much much bigger issue
> 
> obviously :)
> 
> Randy, any idea where those are coming from ?


obviously from kipmi thread :(

drivers/char/ipmi/ipmi_si_intf.c::ipmi_thread():

static int ipmi_thread(void *data)
{
	struct smi_info *smi_info = data;
	unsigned long flags;
	enum si_sm_result smi_result;

	set_user_nice(current, 19);
	while (!kthread_should_stop()) {
		spin_lock_irqsave(&(smi_info->si_lock), flags);
		smi_result = smi_event_handler(smi_info, 0);
		spin_unlock_irqrestore(&(smi_info->si_lock), flags);
		if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
			; /* do nothing */
		else if (smi_result == SI_SM_CALL_WITH_DELAY)
			schedule();
		else
			schedule_timeout_interruptible(1); <-----
	}
	return 0;
}


calls setup_timer_on_stack(), which calls process_timeout().

>From what I recall (probably 2 years ago), [older] ipmi hardware does not
generate event interrupts, so it has to be polled.

Corey, can you elaborate on this?


---
~Randy
