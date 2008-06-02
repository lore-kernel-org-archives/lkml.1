Return-Path: <linux-kernel-owner+w=401wt.eu-S1759506AbYFBM3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759506AbYFBM3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 08:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757771AbYFBM25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 08:28:57 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:15813 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbYFBM2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 08:28:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gonTScUtISDk2peZXyWN2FQfow/md7mJ8qUbKE5nEW5lqs7CM1GWv+ADAvK9Vznlhk820QPInnecI4VkhE2P/kZWSBc5r9a2PlN8q7SmBDqD3HawH4kbDRERjvt1KcRTjJs3pzn08r3aD/QmTKcX1injDB90RZuAA14Fm61cWuA=
Message-ID: <961aa3350806020528t4224f435qfb8406328c38c33f@mail.gmail.com>
Date: Mon, 2 Jun 2008 21:28:48 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Christian Borntraeger" <borntraeger@de.ibm.com>
Subject: Re: [patch -v2 06/23] s390/vmcp: use simple_read_from_buffer
Cc: linux-kernel@vger.kernel.org,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
In-Reply-To: <200806021053.34647.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080601231329.223608711@gmail.com>
	 <20080601231515.779423991@gmail.com>
	 <200806021053.34647.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/2 Christian Borntraeger <borntraeger@de.ibm.com>:
> Am Montag, 2. Juni 2008 schrieb akinobu.mita@gmail.com:
>
>> -     tocopy = min(session->resp_size - (size_t) (*ppos), count);
>> -     tocopy = min(tocopy, session->bufsize - (size_t) (*ppos));
>> +     ret = simple_read_from_buffer(buff, count, ppos,
>> +                             session->response, session->resp_size);
>>
>
> Its not that simple. The z/VM Diagnose 8 has a quite interesting return value.
>
> - session->bufsize is the size of the buffer as we allocated and know
> - session->resp_size is the size of the data - no matter if the buffer was
> large enough. z/VM is smart enough to not go beyond the buffer, but it tells
> us how many bytes it skipped. resp_size contains bufsize + skipped_bytes.
>
> Unfortunately there is no end of string delimiter and we have to use the
> response size.
>
> There are two cases:
> 1. The buffer was large enough, so we can use session->resp_size
> 2. The buffer was not large enough and output was truncated. we must now use
> session->bufsize

Thanks. I made too much simplified the original code.
So I'll change these lines to be

size_t size = min_t(size_t, session->resp_size, session->bufsize);
ret = simple_read_from_buffer(buff, count, ppos, session->response, size);
