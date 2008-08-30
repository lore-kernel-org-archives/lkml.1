Return-Path: <linux-kernel-owner+w=401wt.eu-S1755033AbYH3RaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033AbYH3RaT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 13:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbYH3RaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 13:30:05 -0400
Received: from nebensachen.de ([195.34.83.29]:41011 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbYH3RaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 13:30:03 -0400
X-Hashcash: 1:20:080830:sshtylyov@ru.mvista.com::0vdVNMXOSw9h8uVJ:000000000000000000000000000000000000002Py5
X-Hashcash: 1:20:080830:alan@lxorguk.ukuu.org.uk::LxOaVAv+UYNGk45k:00000000000000000000000000000000000000gxi
X-Hashcash: 1:20:080830:akpm@linux-foundation.org::doZ99hQgVWMmz5Pa:0000000000000000000000000000000000001Tqh
X-Hashcash: 1:20:080830:bzolnier@gmail.com::qmTM/W12xN0lixAp:00000000000000000000000000000000000000000002rxb
X-Hashcash: 1:20:080830:jeff@garzik.org::VcyBuLE4JGdW8e1d:003XiV
X-Hashcash: 1:20:080830:randy.dunlap@oracle.com::LdK0KlfkZIH+qy1y:000000000000000000000000000000000000005baA
X-Hashcash: 1:20:080830:htejun@gmail.com::1zcDQW3zMfskqfSK:03JR9
X-Hashcash: 1:20:080830:linux-ide@vger.kernel.org::8qtBz0qxacWSxaeW:00000000000000000000000000000000000023rd
X-Hashcash: 1:20:080830:linux-kernel@vger.kernel.org::i6ai/qmqGZuI2yHr:0000000000000000000000000000000001R53
From: Elias Oltmanns <eo@nebensachen.de>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Introduce ata_id_has_unload()
References: <87wshzplvk.fsf@denkblock.local>
	<20080829211345.4355.63012.stgit@denkblock.local>
	<48B9357A.3040508@ru.mvista.com>
Date: Sat, 30 Aug 2008 19:29:27 +0200
In-Reply-To: <48B9357A.3040508@ru.mvista.com> (Sergei Shtylyov's message of
	"Sat, 30 Aug 2008 15:56:42 +0400")
Message-ID: <87sksmmmx4.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:
> Hello.
>
> Elias Oltmanns wrote:
>
>> Add a function to check an ATA device's id for head unload support as
>> specified in ATA-7.
>>
>> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
>>   
> [...]
>> diff --git a/include/linux/ata.h b/include/linux/ata.h
>> index 80364b6..d9a94bd 100644
>> --- a/include/linux/ata.h
>> +++ b/include/linux/ata.h
>> @@ -707,6 +707,23 @@ static inline int ata_id_has_dword_io(const u16 *id)
>>  	return 0;
>>  }
>>  +static inline int ata_id_has_unload(const u16 *id)
>> +{
>> +	/*
>> +	 * ATA-7 specifies two places to indicate unload feature
>> +	 * support. Since I don't really understand the difference,
>> +	 * I'll just check both and only return zero if none of them
>> +	 * indicates otherwise.
>>   
>
>   If you read the comments to the words 82:84 and 85:87, they say that
> the former indicate the supported features, and the latter indicate
> the enabed features AND in case a feature can't be disabled, the
> latter words will have the corresponding bit set. So it should be
> sufficient to check only one word.

Yes, I tend to agree with you and, in fact, I have been leaning in this
direction myself. However, there is something that really bothers me.
Both entries describing bit 13 of word 87 and 84 are worded alike. In
particular, it says *supported* in both places, whereas in the case of the
other features it would say enabled in one and supported in the other
place.

Well, I'm willing to drop the check for word 87 since I don't like it
myself. Due to my lack of personal experience with inexplicable
implemenations of ATA standards in hardware though, I have to take your
word that this is safe.

>
>> +	 */
>> +	if (ata_id_major_version(id) >= 7
>> +	    && (((id[ATA_ID_CFSSE] & 0xC000) == 0x4000
>> +		 && id[ATA_ID_CFSSE] & (1 << 13))
>> +		|| ((id[ATA_ID_CSF_DEFAULT] & 0xC000) == 0x4000
>> +		    && (id[ATA_ID_CSF_DEFAULT] & (1 << 13)))))
>>   
>
>
>   I think that it's preferrable to leave the operator on the same line
> with the first operand...

Not having too strong an opinion about it, I just thought that an
operator at the beginning of the line was another indication (apart from
indentation) that this still belongs to the condition. Still, I can
change it for the next series round.

Regards,

Elias
