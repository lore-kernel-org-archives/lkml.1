Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbZKZJc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbZKZJc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752960AbZKZJc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:32:27 -0500
Received: from smtp.nokia.com ([192.100.122.233]:46693 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbZKZJcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:32:25 -0500
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
To: ext Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: workqueues tree build failure
Date: Thu, 26 Nov 2009 11:31:15 +0200
User-Agent: KMail/1.12.3 (Linux/2.6.31-gentoo-r4; KDE/4.3.3; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <20091126190050.3f9d7fef.sfr@canb.auug.org.au> <200911261016.58810.peter.ujfalusi@nokia.com> <4B0E467A.8080201@kernel.org>
In-Reply-To: <4B0E467A.8080201@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200911261131.15155.peter.ujfalusi@nokia.com>
X-OriginalArrivalTime: 26 Nov 2009 09:31:19.0676 (UTC) FILETIME=[35D673C0:01CA6E7B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 November 2009 11:12:26 ext Tejun Heo wrote:
> Hello,
> 
> 11/26/2009 05:16 PM, Peter Ujfalusi wrote:
> >> Takashi, RT workqueue is going away.  Do you really need it?
> >
> > What can be used instead of RT workqueue?
> > The tlv320dac33 needs RT workqueue because I need to send the I2C
> > command with minimum delay to the codec. If this can not be done
> > (the workqueue is delayed), and the codec does not receive the
> > command in time, it will literally die.  What are the options to
> > replace the RT workqueue?
> 
> The problem with RT workqueue is that RT and queue don't really mix
> well.  To act in real time, it requires all the resource pre-allocated
> and dedicated to it making queueing or pooling meaningless.  The
> original workqueue code created dedicated pool of threads for each
> workqueue so it could be used for RT but new implementation uses
> shared worker pool, so it can't be used as an interface to dedicated
> threads.
> 
> I haven't read the code but,
> 
> * If you need to respond fast, wouldn't you be doing that from IRQ
>   handler or softirq?  Do you need task context?

I2C communication can not be done in interrupt context.
I'll take a look at the threaded IRQ, but AFAIK it is just a wrapper to use the 
global workqueue (I'm not sure, I have not actually checked it).
For a quick fix, I can convert the tlv320dac33 driver to use this, and revisit 
later, if it does not fulfill the timing requirements for the HW.

> 
> * Or is it that it's not triggered by IRQ but once the transfer
>   started it can't be interrupted?  But in this case preempt_disable()
>   or local_irq_disable() should suffice.

As Takashi already commented, it is used as a BH.

> 
> Thanks.
> 

-- 
Péter
