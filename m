Return-Path: <linux-kernel-owner+w=401wt.eu-S1764400AbXGVUcD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764400AbXGVUcD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 16:32:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762782AbXGVUbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 16:31:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:57216 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762779AbXGVUbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 16:31:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=DLbcy5sdeF/lDUEndpIWkQSRZmmj8LcmSEIlAFgPKMvG/RmR10ly8ywX34+HoLGEex1gkGBaL4vU6qPMveWESr38GEO9l4VALlKnJkr8Vv3LTxdDpzEMHnGxwHqCVQyHlzVszHM3+ioZryKABceC1j4jF5gcSW673JXpLv/Dncg=
Message-ID: <46A3BE29.50501@googlemail.com>
Date: Sun, 22 Jul 2007 22:29:29 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: drivers/mtd/devices/doc2000.c - address of 'eccbuf' will always
 evaluate as 'true' , warnings
References: <46A349E6.3030207@googlemail.com> <20070722193449.GA11479@lazybastard.org>
In-Reply-To: <20070722193449.GA11479@lazybastard.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> On Sun, 22 July 2007 14:13:26 +0200, Gabriel C wrote:
>> I noticed this warnings on current git with gcc 4.2.1
>>
>> ....
>>
>> drivers/mtd/devices/doc2000.c: In function 'doc_read':
>> drivers/mtd/devices/doc2000.c:635: warning: the address of 'eccbuf' will always evaluate as 'true'
>> drivers/mtd/devices/doc2000.c: In function 'doc_write':
>> drivers/mtd/devices/doc2000.c:899: warning: the address of 'eccbuf' will always evaluate as 'true'
>>
>> ....
>>
>> This patch fixes it but maybe there is a better way to do it.
>>
>>
>> Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>
>> ---
>>
>>
>> diff --git a/drivers/mtd/devices/doc2000.c b/drivers/mtd/devices/doc2000.c
>> index c73e96b..ce8fbf5 100644
>> --- a/drivers/mtd/devices/doc2000.c
>> +++ b/drivers/mtd/devices/doc2000.c
>> @@ -632,7 +632,7 @@ static int doc_read(struct mtd_info *mtd, loff_t from, size_t len,
>>  			len = ((from | 0x1ff) + 1) - from;
>>  
>>  		/* The ECC will not be calculated correctly if less than 512 is read */
>> -		if (len != 0x200 && eccbuf)
>> +		if (len != 0x200 && eccbuf != NULL)
>>  			printk(KERN_WARNING
>>  			       "ECC needs a full sector read (adr: %lx size %lx)\n",
>>  			       (long) from, (long) len);
>> @@ -896,7 +896,7 @@ static int doc_write(struct mtd_info *mtd, loff_t to, size_t len,
>>  		/* Let the caller know we completed it */
>>  		*retlen += len;
>>  
>> -		if (eccbuf) {
>> +		if (eccbuf != NULL) {
>>  			unsigned char x[8];
>>  			size_t dummy;
>>  			int ret;
> 
> The patches doesn't fix anything.  If you take a look at git history for
> the file, you may find this:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7f8a894066b826a4baea49c2a3adbba0a56a192f
> 
> And if I read the patch correctly, Thomas merely forgot to remove these
> two checks on eccbuf.  So the correct patch would remove '&& eccbuf'
> from one conditional and nuke the other completely.
> 
> Care to send such a patch?

Yes. I noticed doc2001plus.c has an leftover too.

...

drivers/mtd/devices/doc2001plus.c:751: warning: the address of 'eccbuf' will always evaluate as 'true'

...


> 
> Jörn
> 


Gabriel

diff --git a/drivers/mtd/devices/doc2000.c b/drivers/mtd/devices/doc2000.c
index c73e96b..d0e6ee8 100644
--- a/drivers/mtd/devices/doc2000.c
+++ b/drivers/mtd/devices/doc2000.c
@@ -632,7 +632,7 @@ static int doc_read(struct mtd_info *mtd, loff_t from, size_t len,
 			len = ((from | 0x1ff) + 1) - from;
 
 		/* The ECC will not be calculated correctly if less than 512 is read */
-		if (len != 0x200 && eccbuf)
+		if (len != 0x200)
 			printk(KERN_WARNING
 			       "ECC needs a full sector read (adr: %lx size %lx)\n",
 			       (long) from, (long) len);
@@ -896,25 +896,6 @@ static int doc_write(struct mtd_info *mtd, loff_t to, size_t len,
 		/* Let the caller know we completed it */
 		*retlen += len;
 
-		if (eccbuf) {
-			unsigned char x[8];
-			size_t dummy;
-			int ret;
-
-			/* Write the ECC data to flash */
-			for (di=0; di<6; di++)
-				x[di] = eccbuf[di];
-
-			x[6]=0x55;
-			x[7]=0x55;
-
-			ret = doc_write_oob_nolock(mtd, to, 8, &dummy, x);
-			if (ret) {
-				mutex_unlock(&this->lock);
-				return ret;
-			}
-		}
-
 		to += len;
 		left -= len;
 		buf += len;
diff --git a/drivers/mtd/devices/doc2001plus.c b/drivers/mtd/devices/doc2001plus.c
index 2b30b58..83be346 100644
--- a/drivers/mtd/devices/doc2001plus.c
+++ b/drivers/mtd/devices/doc2001plus.c
@@ -748,7 +748,7 @@ static int doc_write(struct mtd_info *mtd, loff_t to, size_t len,
 	WriteDOC(DoC_GetDataOffset(mtd, &fto), docptr, Mplus_FlashCmd);
 
 	/* On interleaved devices the flags for 2nd half 512 are before data */
-	if (eccbuf && before)
+	if (before)
 		fto -= 2;
 
 	/* issue the Serial Data In command to initial the Page Program process */

