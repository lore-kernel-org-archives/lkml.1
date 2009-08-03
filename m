Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZHCLoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZHCLoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 07:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZHCLo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 07:44:29 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:26709 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbZHCLo2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 07:44:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m1Ropjs042ioxEFmJhZrbduv4Umr7GZvjbnoNH7wUo4SlsB4d7tHYbZ8gYQ13sdN72
         qYsq1OT4SyJFrmFXTHaiSThzQqkdsjREpsPHmEB54qDeJYNTOvNXy6Np0NuRrsUEWVXT
         JKWzy2jven8Etsr5IFwOj5AuTihd7HFRSeN2I=
MIME-Version: 1.0
In-Reply-To: <4A76ABD5.9020808@vlnb.net>
References: <4A3CD62B.1020407@vlnb.net> <4A641AAC.9030300@vlnb.net>
	 <a0272b440907220144i159baca4u1a1f1f2d0c36193a@mail.gmail.com>
	 <4A6DA77B.7080600@vlnb.net>
	 <a0272b440907280251g2dd38df6ja1bf10f3fa38d333@mail.gmail.com>
	 <4A6F4C81.10600@vlnb.net>
	 <a0272b440907290548k266a975br8c6bdf4d5d992d20@mail.gmail.com>
	 <4A7338AF.8010407@vlnb.net>
	 <a0272b440908030215t66309c1fo9a0894bdae4dec17@mail.gmail.com>
	 <4A76ABD5.9020808@vlnb.net>
Date: Mon, 3 Aug 2009 13:44:28 +0200
Message-ID: <a0272b440908030444g4808ddf4o35eb587b91717cb4@mail.gmail.com>
Subject: Re: [RESEND] [PATCH] readahead:add blk_run_backing_dev
From: Ronald Moesbergen <intercommit@gmail.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: fengguang.wu@intel.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
       Alan.Brunelle@hp.com, linux-fsdevel@vger.kernel.org,
       jens.axboe@oracle.com, randy.dunlap@oracle.com,
       Bart Van Assche <bart.vanassche@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/3 Vladislav Bolkhovitin <vst@vlnb.net>:
> Ronald Moesbergen, on 08/03/2009 01:15 PM wrote:
>>
>> 2009/7/31 Vladislav Bolkhovitin <vst@vlnb.net>:
>>>
>>> OK, as I expected, on the SCST level everything is clear and the forced
>>> ordering change didn't change anything.
>>>
>>> But still, a single read stream must be the fastest from single thread.
>>> Otherwise, there's something wrong somewhere in the I/O path: block
>>> layer,
>>> RA, I/O scheduler. And, apparently, this is what we have and should find
>>> out
>>> the cause.
>>>
>>> Can you check if noop on the target and/or initiator makes any
>>> difference?
>>> Case 5 with 1 and 2 threads will be sufficient.
>>
>> That doesn't seem to help:
>>
>> client kernel: 2.6.26-15lenny3 (debian)
>> server kernel: 2.6.29.5 with readahead-context, blk_run_backing_dev
>> and io_context, forced_order
>>
>> With one IO thread:
>> 5) client: default, server: default (server noop, client noop)
>> blocksize       R        R        R   R(avg,    R(std        R
>>  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>  67108864  17.612   21.113   21.355   51.532    4.680    0.805
>>  33554432  18.329   18.523   19.049   54.969    0.891    1.718
>>  16777216  18.497   18.219   17.042   57.217    2.059    3.576
>>
>> With two threads:
>> 5) client: default, server: default (server noop, client noop)
>> blocksize       R        R        R   R(avg,    R(std        R
>>  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
>>  67108864  17.436   18.376   20.493   54.807    3.634    0.856
>>  33554432  17.466   16.980   18.261   58.337    1.740    1.823
>>  16777216  18.222   17.567   18.077   57.045    0.901    3.565
>
> And with client cfq, server noop?

client kernel: 2.6.26-15lenny3 (debian)
server kernel: 2.6.29.5 with readahead-context, blk_run_backing_dev
and io_context, forced_order

With one IO thread:
5) client: default, server: default (server noop, client cfq)
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  16.019   16.434   15.730   63.777    1.144    0.997
 33554432  16.020   16.624   15.936   63.258    1.183    1.977
 16777216  15.966   15.465   16.115   64.630    1.145    4.039

With two threads:
5) client: default, server: default (server noop, client cfq)
blocksize       R        R        R   R(avg,    R(std        R
  (bytes)     (s)      (s)      (s)    MB/s)   ,MB/s)   (IOPS)
 67108864  16.504   15.762   14.842   65.335    2.848    1.021
 33554432  16.080   16.627   15.766   63.406    1.386    1.981
 16777216  15.489   16.627   16.043   63.842    1.846    3.990

Ronald.
