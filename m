Return-Path: <linux-kernel-owner+w=401wt.eu-S932825AbXJLQev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825AbXJLQev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 12:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761386AbXJLQOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 12:14:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:45900 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761379AbXJLQOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 12:14:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=A1XtBlp06W5ztqC2lF7pM8M+i5J02Rdh/loMvnw6nBi/pLcT1Iz+rufb7ZwyI/vanm7OVw03QkTmF4y4CSpze1EASJXjShLaih5qRGcp4KsdvrzlbWvtAUrFCvu+CaVB4OY42ECCy/HEm/IvVRMU9Qx/tOkf4Xk0MLgdW7Isqz0=
Message-ID: <d120d5000710120914n79c78e61ia3de6c8ce418eb61@mail.gmail.com>
Date: Fri, 12 Oct 2007 12:14:28 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: bryan.wu@analog.com
Subject: Re: [PATCH try #2] Input/Joystick Driver: add support AD7142 joystick driver
Cc: linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <1192204757.7089.9.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192174727.6247.20.camel@roc-laptop>
	 <d120d5000710120749o2505dd7aq42559c35298f05d0@mail.gmail.com>
	 <1192203593.7089.4.camel@roc-laptop>
	 <d120d5000710120850p64aae40ep95f98cfcee7d8d6f@mail.gmail.com>
	 <1192204757.7089.9.camel@roc-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/07, Bryan Wu <bryan.wu@analog.com> wrote:
> On Fri, 2007-10-12 at 11:50 -0400, Dmitry Torokhov wrote:
> > On 10/12/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > > On Fri, 2007-10-12 at 10:49 -0400, Dmitry Torokhov wrote:
> > > > Hi Bryan,
> > > >
> > > > On 10/12/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > > > > +
> > > [snip]
> > > > > +
> > > > > +static void ad7142_close(struct input_dev *dev)
> > > > > +{
> > > > > +       free_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX, ad7142_interrupt);
> > > > > +       kthread_stop(ad7142_task);
> > > >
> > > > Don't you need to write something over i2c to shut the devoce off?
> > > > What stops it from continuing to generate interrupts?
> > > >
> > > Actually, I am going to use "completion" to replace the whole
> > > wait_interrupt_xxx and intr_flag things which original from Aubrey. How
> > > do you think of that?
> > >
> >
> > I don't think it is a very good idea - for me completion is one-time
> > deal. You use it and then you are done. How about firing a work from
> > interrupt and either rely on the default workqueue (keventd) or create
> > your own to execute it?
> >
>
> completion is a wrapper of workqueue and simpler to use.
> my method:
> 1. In kthread:
> do {
> |_______|_______wait_for_completion(&ad7142_completion);
> |_______|_______ad7142_decode();
> |_______|_______enable_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX);
> |_______} while (!kthread_should_stop());
>
> 2. In irq handler will fire "complete(&ad7142_completion);"
>
> This is simpler and understand easier
>

You also need to re-initialize completion every time you done
processing in kthread otherwise you will be constantly doing
ad7142_decode(). Plus, how are you going to stop kthread (completion
may not be signalled for a long time if nobody touches the joystick).

-- 
Dmitry
