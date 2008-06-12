Return-Path: <linux-kernel-owner+w=401wt.eu-S1757799AbYFLUQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbYFLUQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 16:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754553AbYFLUQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 16:16:39 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:27005 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbYFLUQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 16:16:39 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: Heikki Orsila <shdl@zakalwe.fi>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 12 Jun 2008 20:16:02 +0000
Subject: RE: [PATCH] HP iLO driver
Thread-Topic: [PATCH] HP iLO driver
Thread-Index: AcjMvyjuNWE8n8ibS1mV0mSKzWJFZgABMO4A
Message-ID: <CF70AA892F109448AEA269483B3A983903B6F79D74@G1W1215.americas.hpqcorp.net>
References: <20080612182308.GA1091@ldl.fc.hp.com>
 <20080612190405.GR31039@zakalwe.fi>
In-Reply-To: <20080612190405.GR31039@zakalwe.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heikki Orsila wrote:
> On Thu, Jun 12, 2008 at 12:23:08PM -0600, David Altobelli wrote:
>> +    volatile u64 fifobar[1];
>> +};
>
> Why do you need a volatile? What you probably want is atomic ops.
> Spinlocks will create memory barriers implicitly.

This points to a queue that is shared with hardware, and could
be modified outside of kernel control.

>> +static int fifo_enqueue(struct ilo_hwinfo *hw, char *fifobar, int
>> entry) +{ +     struct fifo *Q = FIFOBARTOHANDLE(fifobar);
>> +     int ret = 0;
>> +
>> +     spin_lock(&hw->fifo_lock);
>> +     if (!(Q->fifobar[(Q->tail + 1) & Q->imask] & ENTRY_MASK_O)) {
>> +             Q->fifobar[Q->tail & Q->imask] |=
>> +                     ((entry & ENTRY_MASK_NOSTATE) | Q->merge); +
>> Q->tail += 1; +             ret = 1;
>> +     }
>> +     spin_unlock(&hw->fifo_lock);
>> +
>> +     return ret;
>> +}
>
> Is writing to Q->fifobar (u64 *) endian-safe?

No, this is not endian-safe. Good point.  I think converting these
to readl() operations would let me remove the volatile and fix the
endian issue.
