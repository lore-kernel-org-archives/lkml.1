Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbZCPCfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbZCPCfu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Mar 2009 22:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759822AbZCPCfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Mar 2009 22:35:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57947 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759866AbZCPCfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Mar 2009 22:35:10 -0400
Date: Mon, 16 Mar 2009 11:34:55 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [Patch] Fix the possibility of insane return value of  hpet_calibrate() against SMI.
Cc: clemens@ladisch.de, Linux Kernel ML <linux-kernel@vger.kernel.org>,
       robert.picco@hp.com, venkatesh.pallipadi@intel.com, vojtech@suse.cz,
       mingo@redhat.com
In-Reply-To: <7d1d9c250903151256l36586764wfbd5e2578a45663c@mail.gmail.com>
References: <20090313134846.24B6.E1E9C6FF@jp.fujitsu.com> <7d1d9c250903151256l36586764wfbd5e2578a45663c@mail.gmail.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20090316111300.7CE5.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.01 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Mar 13, 2009 at 1:00 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> > Hello.
> >
> > I think there is a possibility that HPET driver will return
> > insane value due to a SMI interruption (or switching guests by hypervisor).
> > I found it by reviewing, and I would like to fix it.
> >
> > Current HPET driver calibrates the adjustment value
> > by calculation the elapse time in CPU busy loop.
> > However this way is too dangerous against SMI interruption.
> >
> > Here is the calibration code in hpet_calibrate()
> >
> > ?701 static unsigned long hpet_calibrate(struct hpets *hpetp)
> > ? ? ? ? ? ? :
> > ? ? ? ? ? ? :
> > ?728 ? ? ? ? do {
> > ?729 ? ? ? ? ? ? ? ? m = read_counter(&hpet->hpet_mc);
> > ?730 ? ? ? ? ? ? ? ? write_counter(t + m + hpetp->hp_delta, &timer->hpet_compare);
> > ?731 ? ? ? ? } while (i++, (m - start) < count);
> > ?732
> > ?733 ? ? ? ? local_irq_restore(flags);
> > ?734
> > ?735 ? ? ? ? return (m - start) / i;
> >
> > If SMI interruption occurs between 728 to 731, then return value will be
> > bigger value than correct one. (SMI is not able to be controlled by OS.)
> >
> >
> > This patch is a simple solution to fix it.
> > hpet_calibrate() is called 5 times, and one of them is expected as
> > correct value.
> 
> I've no sense of feel for how long each calibration run would take.
> Would doing it 5 times show up as a significant increase in the boot
> time for those that care about boot time being as quick as possible?

Hmm. The loop times is trade off against reliable value....
Though SMI is rare interruption, I don't know how frequent
hypervisor's switch is.

Each calibration of this has 1 milli second.
Do you think 5 msec is too long?
If yes, how is 3 msec? Is it still too long?

Thanks.

-- 
Yasunori Goto 


