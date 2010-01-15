Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab0AOJS2 (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 04:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757229Ab0AOJS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 04:18:26 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:45859 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab0AOJSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 04:18:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ctFd9cf2GVjpPlMwDeuv/HW5N8elanEgXW+Z9VZySp4vuXzk9zfdNKOGdkzmtGjbfV
         wIzwaXhLZ13s6jZCNfYEhkxjnJOmzbFHCHg/TZfMisoeS6MBmcv9jIizg1GxDlLVreZ9
         KrgFbVjKJyyeAx3o1r6jI0hYSTywexIikmGwQ=
Subject: Re: RFC: [PATCH V3 0/9 Integration of SmartMedia/xD into mtd
 subsystem
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>, joern <joern@logfs.org>
In-Reply-To: <507734.29595.qm@web37605.mail.mud.yahoo.com>
References: <507734.29595.qm@web37605.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jan 2010 11:18:19 +0200
Message-ID: <1263547099.3247.16.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 18:01 -0800, Alex Dubov wrote: 
> > > 
> > > Still bear in mind that FTL can destroy data,
> > especially if your flash
> > > card is worn out.
> 
> I sort of worry about this particular issue.
> 
> When I was doing my FTL, handling of bad blocks was one
> of the major (if not the primary) implementation problems.

This is more or less an disclaimer.
If I compare what windows driver does versus mine, I do much more
checking.

My FTL maybe is a bit erase happy, as it tries to erase blocks it found
errors that likely not result of wear but a cut in the power.


Here is a summary of algorithm that I do for scanning:


1. Test is block is marked as bad.
Here I don't cheat and read whole block, because data_status could be
set for a specific sector.
However this is a bit slow, because it causes oob of all sectors to be
read.

2. Read LBA of each sector. Due to mtd layering this makes me read oob
of each sector again.
If I find a sector with lba that can't be read or a sector that has a
different lba that first, I erase the block. This I might revisit.


3. Update the LBA->physical table. If I see that this LBA is taken, I
check again both candidatures, and this time I also read the sector
contents, which will fail if there are unrecoverable ECC errors.
If one of sectors turns out bad this way I pick the other one, if not I
just erase one of the sectors (this is likely a powerfalll situation
too)


Every time an erase is made, hardware will return errors if failed 
When this happens I mark block as bad.


Best regards,
Maxim Levitsky


