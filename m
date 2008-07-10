Return-Path: <linux-kernel-owner+w=401wt.eu-S1758432AbYGJPrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758432AbYGJPrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbYGJPrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:47:35 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:39260 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbYGJPre convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:47:34 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "Camuso, Tony (ZKO3/4W27)" <Tony.Camuso@hp.com>
Date: Thu, 10 Jul 2008 15:46:43 +0000
Subject: RE: [PATCH][v5] HP iLO driver
Thread-Topic: [PATCH][v5] HP iLO driver
Thread-Index: AcjiK8WfJI2caXVLQoSEZsx62XUK6gAZniGQ
Message-ID: <CF70AA892F109448AEA269483B3A983903BBB04EDF@G1W1215.americas.hpqcorp.net>
References: <20080702153853.GA18049@ldl.fc.hp.com>
 <20080709181857.4a38b920.akpm@linux-foundation.org>
In-Reply-To: <20080709181857.4a38b920.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 2 Jul 2008 09:38:53 -0600 David Altobelli
> <david.altobelli@hp.com> wrote:
>
>>
>> +static ssize_t ilo_write(struct file *fp, const char __user *buf,
>> +                      size_t len, loff_t *off)
>> +{
>> +     int err, pkt_id, pkt_len;
>> +     struct ccb_data *data;
>> +     struct ccb *driver_ccb;
>> +     struct ilo_hwinfo *hw;
>> +     void *pkt;
>> +
>> +     data = fp->private_data;
>> +     driver_ccb = &data->driver_ccb;
>> +     hw = data->ilo_hw;
>> +
>> +     if (is_device_reset(hw) || is_channel_reset(driver_ccb)) { +
>> /* +              * If the device has been reset, applications
>> +              * need to close and reopen all ccbs. +              */
>> +             ilo_reset(hw);
>> +             return -ENODEV;
>> +     }
>
> Can multiple processes open and write to this "device"?  If so, the
> above looks awfully racy.  Perhaps vfs-level i_mutex coverage will
> save us on the write-versus-write side, but not on write-versus-read.

Yes, the channels can be shared.

I'm probably missing the race you are seeing, but is_device_reset()
checks a hardware bit, and this hw bit is only cleared after the flag
checked in is_channel_reset() is set.  Multiple processes could get into
ilo_reset(), but that function rechecks the hardware bit after taking a
lock (and I don't believe it could happen, but there is no real downside
to multiple setters of the reset flag).  Also, this bit of code is only
there to tell the applications that they need to close and reopen channels,
by returning -ENODEV.  Reading/writing from a reset channel will not cause
problems, the read or write will simply not succeed.
