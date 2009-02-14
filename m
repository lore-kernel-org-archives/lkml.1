Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbZBNSEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbZBNSEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 13:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751568AbZBNSDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 13:03:50 -0500
Received: from mail-gx0-f222.google.com ([209.85.217.222]:64838 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbZBNSDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 13:03:49 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Feb 2009 13:03:48 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Z3VnobYx2UxOSMAe7VCyZHRnF0j9kbdzefL76MPK8BkUq0qPRkgKKiVBtgKGL7Nss8
         NXeZTaGuUTCiGt3dFr9Q427o3wdyKCt25jQ/zfc/yUCEHSSMj7EK/EH9JN8yQv0acY75
         VI9myr3jZ8tUNqjp9qf2inwduZFxZVq11Uf60=
Message-ID: <49970652.7030101@gmail.com>
Date: Sat, 14 Feb 2009 11:58:42 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Mark Lord <liml@rtr.ca>, Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       =?ISO-8859-1?Q?Hanno_B=F6ck?= <hanno@hboeck.de>,
       linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
Subject: Re: Very old IDE hard drive (240 MB) detected as 1.1 TB
References: <200902131428.40212.hanno@hboeck.de> <499584FC.2050104@gmail.com> <200902141352.24277.hanno@hboeck.de> <4996C563.9090900@ru.mvista.com> <4996D443.4060103@rtr.ca> <alpine.LFD.1.10.0902141526310.651@ftp.linux-mips.org>
In-Reply-To: <alpine.LFD.1.10.0902141526310.651@ftp.linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki wrote:
> On Sat, 14 Feb 2009, Mark Lord wrote:
> 
>>>   It has the current capacity in words 57-58 swapped:
>>>
>>> /dev/sdb:
>>> 0c5a 037f 0000 000a 8723 0275 0037 0030
>>> 000a 0000 2020 2020 2020 2020 2020 424d
>>> 3948 4d31 5020 2020 0003 0040 0004 302e
>>> 3336 2020 2020 436f 6e6e 6572 2050 6572
>>> 6970 6865 7261 6c73 2032 3430 4d42 202d
>>> 2043 5033 3032 3534 2020 2020 2020 8010
>>> 0000 0001 0000 0200 0202 0001 037f 000a
>>> 0037 0007 82da 0000 0000 0000 0000 0000
>>>
>>>
>>>   It must be 82da 0007, not 0007 82da.
>>>   IIRC, the IDE core doesn't trust the value reported in these words 
>> ..
>>
>> That's right.  I wrote the IDE code that way
>> *specifically* due to a (different) Conner drive
>> I had here at the time.
> 
>  It happened for some Maxtor drives too.  The reason is the ATA-1 spec was 
> not explicit about how words 57 and 58 were meant to be ordered and some 
> manufacturers interpreted it one and some the other way.  It looks like 
> libata needs to be fixed.

Here's the relevant code, it appears (drivers/ata/libata-core.c at line 
1321):

static u64 ata_id_n_sectors(const u16 *id)
{
	if (ata_id_has_lba(id)) {
		if (ata_id_has_lba48(id))
			return ata_id_u64(id, 100);
		else
			return ata_id_u32(id, 60);
	} else {
		if (ata_id_current_chs_valid(id))
			return ata_id_u32(id, 57);
		else
			return id[1] * id[3] * id[6];
	}
}

It looks like it's getting into the ata_id_current_chs_valid(id) path, 
since all the values that function checks are indeed valid, but the 
values in words 57-58 are not. There seems to be no real reason to use 
those values since the same can be calculated from the reported CHS, so 
you could change that code to:

		if (ata_id_current_chs_valid(id))
			return id[54] * id[55] * id[56];
		else
			return id[1] * id[3] * id[6];

Hanno, would you be able to try building a kernel with a modified 
drivers/ata/libata-core.c as above (in current -git it would be changing 
line 1330) and see if that resolves the problem?
