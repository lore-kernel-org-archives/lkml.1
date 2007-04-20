Return-Path: <linux-kernel-owner+w=401wt.eu-S1766807AbXDTJBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766807AbXDTJBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 05:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766927AbXDTJBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 05:01:13 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:33316 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1766807AbXDTJBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 05:01:11 -0400
Message-ID: <46288155.7060701@gmail.com>
Date: Fri, 20 Apr 2007 11:01:09 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, johann deneux <johann.deneux@gmail.com>,
       Dmitry Torokhov <dtor@insightbb.com>, stenyak@gmail.com,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [RFC 2/2] Input: phantom, add a new driver
References: <210731960111436322@karneval.cz>	<258431179037841809@karneval.cz> <20070419230719.a118a132.akpm@linux-foundation.org>
In-Reply-To: <20070419230719.a118a132.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napsal(a):
> On Tue, 17 Apr 2007 22:02:10 +0200 (CEST) Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> phantom, add a new driver
[...]
>> +#define PHANTOM_VERSION		"n0.9.4"
> 
> That's an impressive version number ;)

fork of 0.8 or so 2.4 linux driver -> the n in the meaning of new :)

>> +#define PHM_MAX_TORQUES		3
>> +
>> +#define PHN_CONTROL		0x6
>> +#define PHN_CTL_AMP		0x1
>> +#define PHN_CTL_BUT		0x2
>> +#define PHN_CTL_IRQ		0x10
>> +
>> +#define PHN_IRQCTL		0x4c
>> +
>> +#define PHN_ZERO_FORCE		2048
> 
> <wonders what all those do>

I have no clue too, cut&paste from sensable 2.4 driver. But I'll document as
much as possible.

>> +#define PCI_ENCODER(dev, axis) ((0 - (int)ioread32((dev)->iaddr + (axis))) & \
>> +									0xffff)
> 
> Is there any reason why this cannot be a lower-cased inline C function? 
> Nicer to read, typesafe, etc.

yes, I'll switch it.

>> +#define PHB_RUNNING		1
>> +#define PHB_RESET		2
>> +
>> +static struct PH_CLASSTYPE *phantom_class;
> 
> I guess that PH_CLASSTYPE is some protect-me-from-gregkh compatibility
> thing.  But there isn't such a macro in the tree.  I switched this to plain
> old `class'.

Yes, my bad.

>> +
>> +static irqreturn_t phantom_isr(int irq, void *data)
>> +{
>> +	struct phantom_device *dev = data;
>> +	struct input_dev *idev = dev->idev;
>> +	unsigned int a, hw_status;
>> +
>> +	hw_status = ioread32(dev->iaddr + PHN_CONTROL);
>> +	if (!(hw_status & PHN_CTL_IRQ))
>> +		return IRQ_NONE;
>> +
>> +	iowrite32(0, dev->iaddr);
>> +	wmb();
>> +	iowrite32(0xc0, dev->iaddr);
> 
> there too.

Seems reasonable, it can't be reordered. (I hope this holds on all archs.)

>> +	if (unlikely(idev == NULL))
>> +		return IRQ_HANDLED;
> 
> Can this happen?  If so, a comment explaining why would be nice.

In the case of DEBUG_SHIRQ=y. Comment will be added or better -- devinit code
reordered.

thanks for notes,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
