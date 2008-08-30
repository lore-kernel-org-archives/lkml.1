Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbYH3SBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbYH3SBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 14:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753305AbYH3SBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 14:01:11 -0400
Received: from h155.mvista.com ([63.81.120.155]:33691 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753265AbYH3SBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 14:01:10 -0400
Message-ID: <48B98AFF.1040301@ru.mvista.com>
Date: Sat, 30 Aug 2008 22:01:35 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] Introduce ata_id_has_unload()
References: <87wshzplvk.fsf@denkblock.local>	<20080829211345.4355.63012.stgit@denkblock.local>	<48B9357A.3040508@ru.mvista.com> <87sksmmmx4.fsf@denkblock.local>
In-Reply-To: <87sksmmmx4.fsf@denkblock.local>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:

>>>diff --git a/include/linux/ata.h b/include/linux/ata.h
>>>index 80364b6..d9a94bd 100644
>>>--- a/include/linux/ata.h
>>>+++ b/include/linux/ata.h
>>>@@ -707,6 +707,23 @@ static inline int ata_id_has_dword_io(const u16 *id)
>>> 	return 0;
>>> }
>>> +static inline int ata_id_has_unload(const u16 *id)
>>>+{
>>>+	/*
>>>+	 * ATA-7 specifies two places to indicate unload feature
>>>+	 * support. Since I don't really understand the difference,
>>>+	 * I'll just check both and only return zero if none of them
>>>+	 * indicates otherwise.

>>  If you read the comments to the words 82:84 and 85:87, they say that
>>the former indicate the supported features, and the latter indicate
>>the enabed features AND in case a feature can't be disabled, the
>>latter words will have the corresponding bit set. So it should be
>>sufficient to check only one word.

> Yes, I tend to agree with you and, in fact, I have been leaning in this
> direction myself. However, there is something that really bothers me.
> Both entries describing bit 13 of word 87 and 84 are worded alike. In
> particular, it says *supported* in both places, whereas in the case of the
> other features it would say enabled in one and supported in the other
> place.

    I think it says "supported" where the feature can't be disabled and 
"enabled" where it can. Otherwise, this would make a little sense indeed.
Hm, I even found a quote in ATA/PI-7 rev. 4b backing this claim (should've 
pasted it into previous mail):

6.17.43 Words (87:85): Features/command sets enabled

Words (87:85) shall indicate features/command sets enabled. If a defined bit 
is cleared to zero, the indicated features/command set is not enabled. If a 
supported features/command set is supported and cannot be disabled, it is 
defined as supported and the bit shall be set to one.

>>>+	 */
>>>+	if (ata_id_major_version(id) >= 7
>>>+	    && (((id[ATA_ID_CFSSE] & 0xC000) == 0x4000
>>>+		 && id[ATA_ID_CFSSE] & (1 << 13))
>>>+		|| ((id[ATA_ID_CSF_DEFAULT] & 0xC000) == 0x4000
>>>+		    && (id[ATA_ID_CSF_DEFAULT] & (1 << 13)))))
>>>  

>>  I think that it's preferrable to leave the operator on the same line
>>with the first operand...

> Not having too strong an opinion about it, I just thought that an
> operator at the beginning of the line was another indication (apart from
> indentation) that this still belongs to the condition. Still, I can

   Do we need *another* indication? :-)

> change it for the next series round.

> Regards,

> Elias

MBR, Sergei
