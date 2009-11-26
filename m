Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbZKZJMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbZKZJMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760122AbZKZJMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:12:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:43783 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760120AbZKZJMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:12:40 -0500
Message-ID: <4B0E467A.8080201@kernel.org>
Date: Thu, 26 Nov 2009 18:12:26 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; ko-KR; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-3.6 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Ujfalusi <peter.ujfalusi@nokia.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Takashi Iwai <tiwai@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: linux-next: workqueues tree build failure
References: <20091126190050.3f9d7fef.sfr@canb.auug.org.au> <4B0E3677.6000603@kernel.org> <200911261016.58810.peter.ujfalusi@nokia.com>
In-Reply-To: <200911261016.58810.peter.ujfalusi@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

11/26/2009 05:16 PM, Peter Ujfalusi wrote:
>> Takashi, RT workqueue is going away.  Do you really need it?
> 
> What can be used instead of RT workqueue?
> The tlv320dac33 needs RT workqueue because I need to send the I2C
> command with minimum delay to the codec. If this can not be done
> (the workqueue is delayed), and the codec does not receive the
> command in time, it will literally die.  What are the options to
> replace the RT workqueue?

The problem with RT workqueue is that RT and queue don't really mix
well.  To act in real time, it requires all the resource pre-allocated
and dedicated to it making queueing or pooling meaningless.  The
original workqueue code created dedicated pool of threads for each
workqueue so it could be used for RT but new implementation uses
shared worker pool, so it can't be used as an interface to dedicated
threads.

I haven't read the code but,

* If you need to respond fast, wouldn't you be doing that from IRQ
  handler or softirq?  Do you need task context?

* Or is it that it's not triggered by IRQ but once the transfer
  started it can't be interrupted?  But in this case preempt_disable()
  or local_irq_disable() should suffice.

Thanks.

-- 
tejun
