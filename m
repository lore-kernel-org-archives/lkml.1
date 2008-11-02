Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbYKBUSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbYKBUSw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 15:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbYKBUSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 15:18:42 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:15955 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029AbYKBUSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 15:18:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=s5i8yUsIldl2XCSzkyvwkJAzIPWTNo7jWaTIQo7NStEtCKmKzux5ewuBgdOeUVXam4
         dowa65OXlKftSjR7snCMO2Oa+7brtqbvCdUUv05n0ssfPjwFBDxTe5ZZpYc2HQOHwa2t
         7/xGfOE1TPc/gWl1jtckkSkWyXVRO1VjGEtZs=
Message-ID: <87f94c370811021218g29ad4962ndc0a59f17733f2af@mail.gmail.com>
Date: Sun, 2 Nov 2008 15:18:09 -0500
From: "Greg Freemyer" <greg.freemyer@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: [git patches] libata fixes
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <490DA954.2070503@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081031054949.GA10474@havoc.gtf.org>
	 <87f94c370810310620u77f2b31r85b196d7261ef75f@mail.gmail.com>
	 <490DA954.2070503@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 2, 2008 at 8:21 AM, Jeff Garzik <jeff@garzik.org> wrote:
> Greg Freemyer wrote:
>>
>> On Fri, Oct 31, 2008 at 1:49 AM, Jeff Garzik <jeff@garzik.org> wrote:
>>>
>>> Notes:
>>>
>>> 1) 1.5TB drive fix from Roland
>>>
>>> 2) Tejun's sata_via brings a non-working via configuration thanks to a
>>>  new facility also being used in recent (ICH9/10) ata_piix.
>>>
>>>  Change is longer than one might like, but it accurately describes the
>>>  hardware now, the previous stuff wasn't working, and the newly added
>>>  support code shouldn't touch non-broken VIA controllers.
>>>
>>>
>>>
>>> Please pull from 'upstream-linus' branch of
>>> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
>>> upstream-linus
>>>
>>> to receive the following updates:
>>>
>>>  drivers/ata/ata_piix.c    |    1 -
>>>  drivers/ata/libata-core.c |   11 +++-
>>>  drivers/ata/sata_via.c    |  155
>>> +++++++++++++++++++++++++++++++++++++++++----
>>>  include/linux/libata.h    |    1 +
>>>  4 files changed, 152 insertions(+), 16 deletions(-)
>>>
>>> Jens Axboe (1):
>>>     libata: add whitelist for devices with known good pata-sata bridges
>>>
>>> Randy Dunlap (1):
>>>     ATA: remove excess kernel-doc notation
>>>
>>> Roland Dreier (1):
>>>     libata: Avoid overflow in ata_tf_to_lba48() when tf->hba_lbal > 127
>>>
>>> Tejun Heo (1):
>>>     sata_via: fix support for 5287
>>
>> <snip>
>>
>>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>>> index 2ff633c..82af701 100644
>>> --- a/drivers/ata/libata-core.c
>>> +++ b/drivers/ata/libata-core.c
>>> @@ -1268,7 +1268,7 @@ u64 ata_tf_to_lba48(const struct ata_taskfile *tf)
>>>
>>>       sectors |= ((u64)(tf->hob_lbah & 0xff)) << 40;
>>>       sectors |= ((u64)(tf->hob_lbam & 0xff)) << 32;
>>> -       sectors |= (tf->hob_lbal & 0xff) << 24;
>>> +       sectors |= ((u64)(tf->hob_lbal & 0xff)) << 24;
>>>       sectors |= (tf->lbah & 0xff) << 16;
>>>       sectors |= (tf->lbam & 0xff) << 8;
>>>       sectors |= (tf->lbal & 0xff);
>>
>> <snip>
>>
>> That looks really serious.
>>
>> What happens with all previous / stable kernels when connecting up a
>> 1.5TB drive and the user tries to use the last portion of the drive?
>
> tf-to-lba48 is a far less common operation, generally used for error
> reporting (and in Host-Protected Area code as well, it appears).
>
>        Jeff

So are you saying it is not on any data read / write paths?

Or that it is only on rarely used data read/write paths?

Because if this is on a data read/write path at all, it looks like it
could cause major data corruption with 1.5 TB drives (or larger).

Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
