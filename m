Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094Ab0BRA5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:57:17 -0500
Received: from mail-gx0-f227.google.com ([209.85.217.227]:50721 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab0BRA5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:57:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=x6NRTDIRzLFk0t8kYkVfZ77pobClDeUMlASwf2noxymLCJiJpyeKn8IgB4FgnQznml
         hAmLqrAObpK5HqmGiBcBi3IXWnk69eWlLNDi5GtjZ0Vo+tfLJH8pwtSYKoXUKF3mVifq
         gE4ALp8DD4r5wayoaJp5jie2/+Ip4k5jShx/Y=
Message-ID: <4B7C9066.6010107@gmail.com>
Date: Wed, 17 Feb 2010 18:57:10 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: "Patrick J. LoPresti" <lopresti@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: sendfile() expert advice sought
References: <23986fd91002161153y516bb5e3i9e85f11469b9160e@mail.gmail.com>
In-Reply-To: <23986fd91002161153y516bb5e3i9e85f11469b9160e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2010 01:53 PM, Patrick J. LoPresti wrote:
> Executive summary:  Can I get the benefits of sendfile() for anonymous pages?
>
> I have an application that generates hundreds of gigabytes of data per
> hour.  I want to push that data out over a TCP socket.  (The network
> connection will be fast; multiple bonded GigE lines or 10GigE.)
>
> I gather that sendfile() is pretty efficient, so I would like to use
> it.  But I do not want to write all of my data to disk first.  So I am
> considering an approach like this:
>
>    int fd = shm_open("/foo", O_RDWR|O_TRUNC);
>    ftruncate(fd, length);
>    void *p = mmap (0, length, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
>    // (fill memory block at p with some data)
>    sendfile(fd, sock, 0, length);
>
> Questions:
>
> 1) Will this work at all?  (Some on-line sources suggest sendfile()
> does not work with tmpfs files.  But I think this was fixed at some
> point...)
>
> 2) Will it provide zero-copy behavior, or does the fact that the pages
> are mapped in my process cause sendfile() to copy them?
>
> 3) If it is zero-copy, what happens if I overwrite the memory block
> after sendfile() returns?  Do I risk corrupting my data?  (In
> particular, suppose I have TCP_CORK set on the socket.  Will
> sendfile() return before all of the data has actually been sent,
> giving me a window to corrupt my data?  If so, how do I know when it
> is "safe" to re-use the memory?)
>
> 4) If sendfile() is not zero-copy in this example, would I expect a
> performance boost anyway, because sendfile() does not need to crawl
> page tables or something?
>
> Any responses or references will be appreciated.

I can't really answer definitively, but as far as I know you wouldn't 
get any magic performance benefits from playing games with sendfile, 
splice, etc. as long as the pages were mapped into userspace already, 
they only really help when the data being written out is coming from 
another file, pipe, etc. not when your application is generating the 
data internally.
