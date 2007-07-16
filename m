Return-Path: <linux-kernel-owner+w=401wt.eu-S1762168AbXGPKxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762168AbXGPKxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 06:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756287AbXGPKxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 06:53:07 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:47258 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbXGPKxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 06:53:06 -0400
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] splice: fix wrong __splice_from_pipe() usage
References: <877ip1qj29.fsf@duaron.myhome.or.jp>
	<20070716063435.GG5328@kernel.dk>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Mon, 16 Jul 2007 19:53:01 +0900
In-Reply-To: <20070716063435.GG5328@kernel.dk> (Jens Axboe's message of "Mon\, 16 Jul 2007 08\:34\:36 +0200")
Message-ID: <87odiczkky.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> writes:

> On Mon, Jul 16 2007, OGAWA Hirofumi wrote:
>> Hi,
>> 
>> I've noticed the nfsd read corruption by recent change. And this patch
>> fixes the problem for me, is this right fix?
>> -- 
>> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>> 
>> 
>> __splice_from_pipe() is updating the sd->pos for the actor, but those
>> functions are passing the sd of reader side directory. So, splice
>> updates sd->pos twice.
>> 
>> This fixes usage of __splice_from_pipe().
>
> For sendfile() usage, or the nfsd path that uses splice to send?

nfsd_vfs_read() path.

nfsd_vfs_read()
    splice_direct_to_actor()
        while(len) {
            do_splice_to()                     [update sd->pos]
                -> generic_file_splice_read()  [read from sd->pos]
            nfsd_direct_splice_actor()
                -> __splice_from_pipe()        [update sd->pos]
        }

do_splice_to() updates sd->pos for read, and pass updated sd to
__splice_from_pipe(), and __splice_from_pipe() updates sd->pos for
write. So, next do_splice_to() read from wrong position.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
