Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYHUWYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYHUWYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 18:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760983AbYHUWX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 18:23:57 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:53905 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602AbYHUWX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 18:23:56 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Milan Broz <mbroz@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Ric Wheeler <rwheeler@redhat.com>,
       "MASON\,CHRISTOPHER" <CHRIS.MASON@oracle.com>
Subject: Re: Mount ext3 with barrier=1 doesn't send real barrier bio?
References: <48A5F5C6.2090204@redhat.com> <48ACAADD.2010104@sandeen.net>
Date: Fri, 22 Aug 2008 07:23:50 +0900
In-Reply-To: <48ACAADD.2010104@sandeen.net> (Eric Sandeen's message of "Wed,
	20 Aug 2008 18:38:05 -0500")
Message-ID: <874p5eqa6h.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen <sandeen@sandeen.net> writes:

>> --- a/fs/buffer.c
>> +++ b/fs/buffer.c
>> @@ -2926,16 +2926,16 @@ int submit_bh(int rw, struct buffer_head * bh)
>>  	BUG_ON(!buffer_mapped(bh));
>>  	BUG_ON(!bh->b_end_io);
>>  
>> -	if (buffer_ordered(bh) && (rw == WRITE))
>> -		rw = WRITE_BARRIER;
>> -
>>  	/*
>>  	 * Only clear out a write error when rewriting, should this
>>  	 * include WRITE_SYNC as well?
>>  	 */
>> -	if (test_set_buffer_req(bh) && (rw == WRITE || rw == WRITE_BARRIER))
>> +	if (test_set_buffer_req(bh) && rw == WRITE)
>>  		clear_buffer_write_io_error(bh);

This should be ((rw & RW_MASK) == WRITE) too?  Anyway, this seems change
behavior of submit_bh(WRITE_BARRIER) (maybe reiserfs only), it wouldn't
be your intent...

>> +	if (buffer_ordered(bh) && ((rw & RW_MASK) == WRITE))
>> +		rw |= (1 << BIO_RW_BARRIER);
>> +
>>  	/*
>>  	 * from here on down, it's all bio -- do the initial mapping,
>>  	 * submit_bio -> generic_make_request may further map this bio around
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
