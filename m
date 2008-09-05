Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbYIEO7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbYIEO7L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 10:59:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753265AbYIEO65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 10:58:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:53374 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbYIEO64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 10:58:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=u4/bcxcTRNQ0WAcsBdL1ucyDr7Ep89sd3+vVKw+dKBzhZXTEmaDn3nw5EzZz5VJn2Q
         qIVKZdlBanc2bFwQs9XXGaXiaMKd3q5JKyesb6b35epyzNbXLnvdccAqOm25XstvavWn
         73JRBO39AlYrnKVKCEPY83faWkyeKFuAV/YX0=
Message-ID: <b6c5339f0809050758r8ba7559k4ebe56531f5556e6@mail.gmail.com>
Date: Fri, 5 Sep 2008 10:58:55 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: __getblk infinite loop
Cc: linux-kernel@vger.kernel.org, snakebyte@gmx.de
In-Reply-To: <20080904223836.54fbabb1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080905032411.GB13208@hash.localnet>
	 <20080904223836.54fbabb1.akpm@linux-foundation.org>
X-Google-Sender-Auth: de9141a0f27bb28f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2008 at 1:38 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> That loop does lock up on people occasionally - last time was in isofs,
> because it had done an insane set_blocksize() earlier on.
>
> Yes, it's always a case of garbage in, garbage out (or nothing out, as
> the case may be).
>
> No, it's not particularly programmer-friendly behaviour.

Ok, I think I get it now - sector_t 0x1d4000004 is in the addressable
range (by one bit) since we can address 4G blocks of PAGE_SIZE and the
FS is using a block size of 2048.  grow_buffers() always returns 0
because find_or_create_page() fails adding a page with that huge
offset into the pagecache (?), so we try to free memory and try again.
 Your patch here:

    http://marc.info/?l=linux-kernel&m=117202372525279&w=2

doesn't apply to the situation since index is still technically a
valid page offset.

So, I guess the answer is to deal with it in fsck and tell people
"don't do that."
-- 
Bob Copeland %% www.bobcopeland.com
