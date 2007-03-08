Return-Path: <linux-kernel-owner+w=401wt.eu-S1750760AbXCHCMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750760AbXCHCMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 21:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbXCHCMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 21:12:43 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:51502 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbXCHCMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 21:12:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=B/pBXXOPbuOzppO105/pttPPFy1q+CnvScn1K7td9nd1U6M942MMT+JIvC9kvqgovrDuGotMdAsyE6GZyc18GozJMe5xhcE1mGwE5/bJYg2RDutNETYxolwu0Qvg4iR+cUCkZYurYY5lTg+8OgbEhkA6pIctcHwhg/zE1rj4rjE=
Message-ID: <f2b55d220703071812l52ef7241h9f2729a9b48ab60d@mail.gmail.com>
Date: Wed, 7 Mar 2007 18:12:40 -0800
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: f_owner.lock and file->pos updates
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <f2b55d220703071750h1a47c432ife7f39c575a4303c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f2b55d220703071117n474f02f7rcc630f0415530aed@mail.gmail.com>
	 <20070308004853.4f5a090c@lxorguk.ukuu.org.uk>
	 <f2b55d220703071750h1a47c432ife7f39c575a4303c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> I didn't see any clean way to intersperse overwrites and appends to a
> record-structured file without using vfs_llseek, which steps on f_pos.

The context, of course, is an attempt to fix -ENOPATCH with regard to
the netlink-based AIO submission scheme I outlined a couple of days
ago.  :-)

Maybe f_pos should be advanced atomically by the number of bytes
expected to be read/written, before entering the vfs_(read|write)(|v)
call?  And then if the read/write doesn't complete normally, f_pos
should be decremented by the number of bytes we failed to read/write?
Or do we have to make absolutely, positively sure that sampling f_pos
from another thread never returns any value outside (before)..(before
+ bytes read/written)?  If so, the only way to cure the worst symptom
of the append race appears to be to hold a per-fd lock for the
duration of the sys_(read|write).

Cheers,
- Michael
