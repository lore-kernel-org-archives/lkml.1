Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbZFRXtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbZFRXtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 19:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZFRXtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 19:49:45 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39938 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbZFRXtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 19:49:45 -0400
In-Reply-To: <8916.1245303178@jrobl>
References: <8916.1245303178@jrobl>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org, safford@watson.ibm.com
MIME-Version: 1.0
Subject: Re: IMA and ETXTBSY
X-KeepSent: B9B7AF8E:87B0E629-852575D9:0080E2A1;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OFB9B7AF8E.87B0E629-ON852575D9.0080E2A1-852575D9.0082E67A@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Thu, 18 Jun 2009 19:49:46 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.5|December 05, 2008) at
 06/18/2009 19:49:46,
	Serialize complete at 06/18/2009 19:49:46
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hooanon05@yahoo.co.jp wrote on 06/18/2009 01:32:58 AM:

> After the failure of open(2) with ETXTBSY, IMA produces wrong messages.
> Here is a simple test script.
> 
> dir=/tmp
> cp /bin/sleep $dir
> ls -l $dir/sleep
> stat -f $dir
> $dir/sleep 3 & sleep 1
> echo | /bin/dd of=$dir/sleep conv=notrunc && false
> wait
> rm $dir/sleep
> 
> 
> The result.
> + cp /bin/sleep /tmp
> + ls -l /tmp/sleep
> -rwxr-xr-x 1 jro jro 23504 Jun 18 14:26 /tmp/sleep
> + stat -f /tmp
>   File: "/tmp"
>     ID: 4e22c34ea8177d80 Namelen: 255     Type: ext2/ext3
> Block size: 1024       Fundamental block size: 1024
> Blocks: Total: 918322     Free: 918281     Available: 869285
> Inodes: Total: 490560     Free: 490545
> + /tmp/sleep 3
> + sleep 1
> + echo
> + /bin/dd of=/tmp/sleep conv=notrunc
> /bin/dd: opening `/tmp/sleep': Text file busy
> + wait
> + rm /tmp/sleep
> $ iint_free: writecount: 1
> iint_free: opencount: 1
> 
> 
> J. R. Okajima

The problem is that IMA measures the file and increments the 
open/read/write counters before the file is actually opened,
but if the open fails it doesn't decrement the counters.  I'll
post a patch. Thanks for bringing this to my attention.

Mimi
