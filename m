Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbYBNAlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbYBNAlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 19:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYBNAlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 19:41:03 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:1212 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbYBNAlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 19:41:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tz8D0kJSnzrb/A8nRarAhBa6L1Q9re/PkLTrbKtcY3QLiH/cxRK3qRqXrZKqDTTjomiGBeDWQDpvbaixLJDKUHZP4WnSTisziTreMi4/NfcbvomBqo0iXoQIbmyvDAR5aT/iHwZlrwpHxH7QD+Bc+PYGvqqxwkjUHQzOIhLiYpc=
Message-ID: <47B38E13.1060503@gmail.com>
Date: Thu, 14 Feb 2008 09:40:51 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jeff@garzik.org, linux-ide@vger.kernel.org, jengelh@computergmbh.de,
       matthew@wil.cx, randy.dunlap@oracle.com, daniel.ritz-ml@swissonline.ch,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk,
 take #3
References: <12028937731333-git-send-email-htejun@gmail.com> <20080213155701.48871761.akpm@linux-foundation.org>
In-Reply-To: <20080213155701.48871761.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> And mprintk the following.
>>
>>  code:
>>   DEFINE_MPRINTK(mp, 2 * 80);
>>
>>   mprintk_set_header(&mp, KERN_INFO "ata%u.%2u: ", 1, 0);
>>   mprintk_push(&mp, "ATA %d", 7);
>>   mprintk_push(&mp, ", %u sectors\n", 1024);
>>   mprintk(&mp, "everything seems dandy\n");
>>
>>  output:
>>   <6>ata1.00: ATA 7, 1024 sectors
>>   <6>ata1.00  everything seems dandy
> 
> And that looks like an awful lot of fuss.  Is it really worth doing?

In the above example, s/mprintk(/mprintk_flush(/ and
s/mprintk_push(/mprintk(/

Can you please take a look at ata_eh_link_report() in
drivers/ata/libata-eh.c?  Currently, it has some problems.

* All that it wants to do is printing some messages but it's awfully
complex with temp bufs and super-long printk calls containing optional %s's.

* status / error decode print outs are printed separately from cmd/res
making it difficult to tell how they are grouped.  Putting them together
would require allocating another temp buf(s) and adding extra %s's to
cmd/res printout.

* For timeouts, result TF isn't available and thus res printout is
misleading.  res shouldn't be printed after timeouts.  This would
require allocating yest another temp buf and separating out res printing
into separate snprintf.

I was trying to do this and got fed up with all the tricks in the
function.  The only sane way out is to build messages piece-by-piece
into a buffer and print it at once.  The eh message is gigantic and I
needed to allocate the buffer elsewhere than stack.
ata_eh_link_report() fortunately has fixed place for that -
ap->sector_buf - but let's assume there was no such buffer for the
discussion.  I'm still not too sure whether it's wise to use sector_buf
for message building anyway.

The only way is to malloc the buffer.  Once the buffer is available,
building message using snprintf is a bit cumbersome but is okay.  The
problem is that malloc can fail.  To handle that case, we basically need
to do

  if (buf)
     printed += snprintf(buf + printed, len - printed, ...);
  else
     printk(...);

which is very cumbersome, so we need a wrapper around the above.  As the
wrapper needs to control when the message goes out, a flush function is
necessary too.  Combine those with overflow handling - mprintk.

Similar problem exists for ata_dev_configure() in
drivers/ata/libata-core.c although it's a bit better there.  Please take
a look at the fifth patch.  It doesn't remove a lot of lines but it
streamlines both functions significantly.  For ata_dev_configure(),
message reporting becomes what the function does secondarily while
configuring the device, not something it's structured around.

Thanks.

-- 
tejun
