Return-Path: <linux-kernel-owner+w=401wt.eu-S1759264AbXJLP7o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264AbXJLP7o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 11:59:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754741AbXJLP7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 11:59:36 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:44995 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbXJLP7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 11:59:35 -0400
X-IronPort-AV: i="4.21,267,1188792000"; 
   d="scan'208"; a="41632786:sNHT10277677501"
Subject: Re: [PATCH try #2] Input/Joystick Driver: add support AD7142
	joystick driver
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: bryan.wu@analog.com, linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <d120d5000710120850p64aae40ep95f98cfcee7d8d6f@mail.gmail.com>
References: <1192174727.6247.20.camel@roc-laptop>
	 <d120d5000710120749o2505dd7aq42559c35298f05d0@mail.gmail.com>
	 <1192203593.7089.4.camel@roc-laptop>
	 <d120d5000710120850p64aae40ep95f98cfcee7d8d6f@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Fri, 12 Oct 2007 23:59:17 +0800
Message-Id: <1192204757.7089.9.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 12 Oct 2007 15:59:22.0170 (UTC) FILETIME=[DABB19A0:01C80CE8]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-12 at 11:50 -0400, Dmitry Torokhov wrote:
> On 10/12/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > On Fri, 2007-10-12 at 10:49 -0400, Dmitry Torokhov wrote:
> > > Hi Bryan,
> > >
> > > On 10/12/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > > > +
> > [snip]
> > > > +
> > > > +static void ad7142_close(struct input_dev *dev)
> > > > +{
> > > > +       free_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX, ad7142_interrupt);
> > > > +       kthread_stop(ad7142_task);
> > >
> > > Don't you need to write something over i2c to shut the devoce off?
> > > What stops it from continuing to generate interrupts?
> > >
> > Actually, I am going to use "completion" to replace the whole
> > wait_interrupt_xxx and intr_flag things which original from Aubrey. How
> > do you think of that?
> >
> 
> I don't think it is a very good idea - for me completion is one-time
> deal. You use it and then you are done. How about firing a work from
> interrupt and either rely on the default workqueue (keventd) or create
> your own to execute it?
> 

completion is a wrapper of workqueue and simpler to use.
my method:
1. In kthread:
do {
|_______|_______wait_for_completion(&ad7142_completion);
|_______|_______ad7142_decode();
|_______|_______enable_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX);
|_______} while (!kthread_should_stop());

2. In irq handler will fire "complete(&ad7142_completion);"

This is simpler and understand easier

Thanks
-Bryan
