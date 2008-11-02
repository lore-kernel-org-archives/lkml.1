Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbYKBXmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbYKBXmY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 18:42:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbYKBXmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 18:42:15 -0500
Received: from rtr.ca ([76.10.145.34]:59880 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814AbYKBXmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 18:42:14 -0500
Message-ID: <490E3AD4.90506@rtr.ca>
Date: Sun, 02 Nov 2008 18:42:12 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
References: <20081031054949.GA10474@havoc.gtf.org>	 <87f94c370810310620u77f2b31r85b196d7261ef75f@mail.gmail.com>	 <490DA954.2070503@garzik.org> <87f94c370811021218g29ad4962ndc0a59f17733f2af@mail.gmail.com>
In-Reply-To: <87f94c370811021218g29ad4962ndc0a59f17733f2af@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Freemyer wrote:
> On Sun, Nov 2, 2008 at 8:21 AM, Jeff Garzik <jeff@garzik.org> wrote:
>> Greg Freemyer wrote:
>>> On Fri, Oct 31, 2008 at 1:49 AM, Jeff Garzik <jeff@garzik.org> wrote:
>>>> Notes:
>>>>
>>>> 1) 1.5TB drive fix from Roland
>>>>
>>>> 2) Tejun's sata_via brings a non-working via configuration thanks to a
>>>>  new facility also being used in recent (ICH9/10) ata_piix.
>>>>
>>>>  Change is longer than one might like, but it accurately describes the
>>>>  hardware now, the previous stuff wasn't working, and the newly added
>>>>  support code shouldn't touch non-broken VIA controllers.
>>>>
>>>>
>>>>
>>>> Please pull from 'upstream-linus' branch of
>>>> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
>>>> upstream-linus
>>>>
>>>> to receive the following updates:
>>>>
>>>>  drivers/ata/ata_piix.c    |    1 -
>>>>  drivers/ata/libata-core.c |   11 +++-
>>>>  drivers/ata/sata_via.c    |  155
>>>> +++++++++++++++++++++++++++++++++++++++++----
>>>>  include/linux/libata.h    |    1 +
>>>>  4 files changed, 152 insertions(+), 16 deletions(-)
>>>>
>>>> Jens Axboe (1):
>>>>     libata: add whitelist for devices with known good pata-sata bridges
>>>>
>>>> Randy Dunlap (1):
>>>>     ATA: remove excess kernel-doc notation
>>>>
>>>> Roland Dreier (1):
>>>>     libata: Avoid overflow in ata_tf_to_lba48() when tf->hba_lbal > 127
>>>>
>>>> Tejun Heo (1):
>>>>     sata_via: fix support for 5287
>>> <snip>
>>>
>>>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>>>> index 2ff633c..82af701 100644
>>>> --- a/drivers/ata/libata-core.c
>>>> +++ b/drivers/ata/libata-core.c
>>>> @@ -1268,7 +1268,7 @@ u64 ata_tf_to_lba48(const struct ata_taskfile *tf)
>>>>
>>>>       sectors |= ((u64)(tf->hob_lbah & 0xff)) << 40;
>>>>       sectors |= ((u64)(tf->hob_lbam & 0xff)) << 32;
>>>> -       sectors |= (tf->hob_lbal & 0xff) << 24;
>>>> +       sectors |= ((u64)(tf->hob_lbal & 0xff)) << 24;
>>>>       sectors |= (tf->lbah & 0xff) << 16;
>>>>       sectors |= (tf->lbam & 0xff) << 8;
>>>>       sectors |= (tf->lbal & 0xff);
>>> <snip>
>>>
>>> That looks really serious.
>>>
>>> What happens with all previous / stable kernels when connecting up a
>>> 1.5TB drive and the user tries to use the last portion of the drive?
>> tf-to-lba48 is a far less common operation, generally used for error
>> reporting (and in Host-Protected Area code as well, it appears).
>>
>>        Jeff
> 
> So are you saying it is not on any data read / write paths?
> 
> Or that it is only on rarely used data read/write paths?
> 
> Because if this is on a data read/write path at all, it looks like it
> could cause major data corruption with 1.5 TB drives (or larger).
..

It's on the initialization path for all lba48 devices which have
a configured HPA (Host Protected Area, mostly seen in brand-name
consumer-level systems).

The data it generates is then used on subsequent R/W commands.
I recommend the fix be backported for earlier kernels.

Cheers
