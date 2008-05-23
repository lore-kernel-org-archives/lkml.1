Return-Path: <linux-kernel-owner+w=401wt.eu-S1757104AbYEWROT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757104AbYEWROT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 13:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYEWROE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 13:14:04 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:48268 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbYEWROB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 13:14:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DShCHC+AYAWCNJvZzjXYeMF4xBd6k1ch8NfWGv7L7T1SqwFn9/h5V0bclzg8oSIlGFW/V0z97IU38baGAfjs0zYyZHhk7EZf4o4VGD3H11pHVvevaFCG35RWaK9lXdwHkPuzmhrya64OXfOGjbiPw0UdOz/QoNq4SX52bxldbgY=
Message-ID: <524f69650805231013u6d3e26f5lee7d475022623ee3@mail.gmail.com>
Date: Fri, 23 May 2008 12:13:58 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>
Subject: Re: pagevecs of more than PAGEVEC_SIZE pages
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080523092938.GA16915@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <524f69650805221213i62488a4fk5a906b2726b9b96a@mail.gmail.com>
	 <20080522225459.5a6f7acc.akpm@linux-foundation.org>
	 <20080523092938.GA16915@2ka.mipt.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sounds interesting - looks like the only user at the moment is NFS's
SunRPC right (so no other examples to look at)?

How much better is this than send_msg?

For the write path (coming from writepage and writepages) - we have a
small header followed by a list of sequential pages (the servers
either support 4 pages (old windows), 15 pages (some windows and
NetApp etc. filers), or 31 pages (older Samba and other Windows) or
2048 pages (current Samba supports up to 8MB writes, and this may be
very useful now that Samba can call splice/receivefile and not have to
do the extra copy)

On Fri, May 23, 2008 at 4:29 AM, Evgeniy Polyakov <johnpol@2ka.mipt.ru> wrote:
> Hi.
>
> On Thu, May 22, 2008 at 10:54:59PM -0700, Andrew Morton (akpm@linux-foundation.org) wrote:
>> > Now that various servers support processing larger than 64K file
>> > writes, it would be helpful to have pagevecs that are larger than 14
>> > pages (PAGEVEC_SIZE).so an array of more pages could be passed to
>> > kernel_sendmsg (thus allowing writes larger than 56K, depending on
>> > wsize - the server limit is currently 8MB)
>>
>> You can pass multiple pagevecs into kernel_sendmsg?
>
> kernel_sendmsg() requires iovecs, so each page will have to be mapped,
> which can end up having too many slots in kmap table. I can reproduce
> deadlock we talked about in POHMELFS thread with 100 highmem pages per
> transaction on 32bit x86, so increasing pagevec noticebly can deadlock
> CIFS too.
>
> It could be great if CIFS moved to kernel_sendpage() instead, Steve?
>
> --
>        Evgeniy Polyakov
>



-- 
Thanks,

Steve
